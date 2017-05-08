#import "../Headers.h"

@interface NotificationsExplanationView : NSObject
-(NSArray *)_accessibilityLabels;
@end

@interface AlertStyleView
-(UIImageView *)selectionImage;
@end

@interface PSSpecifier
- (id)propertyForKey:(id)arg1;
- (void)setProperty:(id)prop forKey:(id)key;
@end

%group WirelessModemSettings
	%hook TetheringSwitchFooterView
	-(void)layoutSubviews
	{
		%orig;
		NSMutableArray *allLabels = MSHookIvar<NSMutableArray *>(self, "_labels");
		for(UILabel *label in allLabels){
			label.textColor = TableViewFooterTextColor;
		}
	}
	%end
%end

%group WirelessModemSetupInstructions
	%hook SetupView
	-(void)addStep:(id)step
	{
		UILabel *titleLabel = MSHookIvar<UILabel *>(self, "_title");
		titleLabel.textColor = TextColor;
		%orig;
	}

	-(void)setIcon:(UIImage *)image
	{
		%orig([image invertColors]);
	}

	-(id)_preferenceLabelWithText:(id)arg1
	{
		UILabel *setupLabel = %orig;
		setupLabel.textColor = LightTextColor;
		return setupLabel;
	}

	%end
%end


%group AirPortSettingsAPTableCell
	%hook APTableCell
	- (void)updateImages
	{
		%orig;
		UIImageView *lockView = MSHookIvar<UIImageView *>(self, "_lockView");
		lockView.image = [lockView.image imageWithRenderingMode:UIImageRenderingModeAlwaysTemplate];
		lockView.tintColor = TextColor;

		lockView = MSHookIvar<UIImageView *>(self, "_barsView");
		lockView.image = [lockView.image imageWithRenderingMode:UIImageRenderingModeAlwaysTemplate];
		lockView.tintColor = TextColor;
	}
	%end
%end

%group AirPortSettingsGroupHeader

	%hook APNetworksGroupHeader
		-(void)addSubview:(id)subview
		{
			if([subview class] == [UILabel class]){
				((UILabel *)subview).textColor = TableViewHeaderTextColor;
			}
			%orig;
		}
	%end

%end

%group NotificationsExplanationFooterView

	%hook NotificationsExplanationView

	-(void)layoutSubviews
	{
		%orig;
		for(UILabel *label in [self _accessibilityLabels]){
			label.textColor = TableViewFooterTextColor;
		}
	}
	%end

%end

%group AlertStyleView

	%hook AlertStyleView

	-(id)initWithType:(id)arg1
	{	
		id styleView = %orig;
		UIImageView *selectionImage = [self selectionImage];
		selectionImage.image = [selectionImage.image imageWithRenderingMode:UIImageRenderingModeAlwaysTemplate];
		selectionImage.tintColor = LightBlueColor;
		return styleView;
	}
	%end

%end

%group WallpaperMagicTableCategoryLabel

	%hook WallpaperMagicTableCategoryLabel

	-(id)initWithFrame:(CGRect)arg1
	{
		UILabel *label = %orig;
		label.textColor = TableViewFooterTextColor;
		return label;
	}

	%end
%end

%group PSUIPrefsListController

	%hook PSUIPrefsListController

	-(NSMutableArray *) specifiers
	{
		static dispatch_once_t sp;
		NSMutableArray *specifiers = %orig;
		dispatch_once(&sp, ^{
			for(PSSpecifier *specifier in specifiers){
				NSBundle *specifierBundle = ((NSBundle *)[specifier propertyForKey:@"pl_bundle"]);
				if(specifierBundle){
					NSString *bundlePath = [specifierBundle bundlePath];
					if([bundlePath rangeOfString:@"PreferenceLoader"].location != NSNotFound){
						UIImage *iconImage = [specifier propertyForKey:@"iconImage"];
						if([iconImage isDark])
							[specifier setProperty:[iconImage invertColors] forKey:@"iconImage"];
					}
				}
			}
		});
		return specifiers;
	}

	%end

%end

%hook PSListController

- (void)viewWillAppear:(bool)arg1
{
	%orig;

	NSString *bundlePath = [[self bundle] bundlePath];
	NSString *bundlePathSource = [[bundlePath stringByDeletingLastPathComponent] lastPathComponent];

	if([bundlePathSource rangeOfString:@"Preference"].location != NSNotFound){
		[%c(NocturneController) isInTweakPref:YES];
	}else{
		[%c(NocturneController) isInTweakPref:NO];
	}
}

- (void)_loadBundleControllers
{
	%orig;
	//HBLogInfo(@"%@", [self class]);
	
	if([self class] == objc_getClass("WirelessModemController")){
		static dispatch_once_t a;
		dispatch_once(&a, ^{
			%init(WirelessModemSettings, TetheringSwitchFooterView = objc_getClass("TetheringSwitchFooterView"));
			%init(WirelessModemSetupInstructions, SetupView = objc_getClass("SetupView"));
		});
	}
	else if([self class] == objc_getClass("APNetworksController")){
		static dispatch_once_t b;
		dispatch_once(&b, ^{
			%init(AirPortSettingsAPTableCell, APTableCell = objc_getClass("APTableCell"));
			%init(AirPortSettingsGroupHeader, APNetworksGroupHeader = objc_getClass("APNetworksGroupHeader"));
		});
	}
	else if([self class] == objc_getClass("BulletinBoardAppDetailController")){
		static dispatch_once_t c;
		dispatch_once(&c, ^{
			%init(NotificationsExplanationFooterView, NotificationsExplanationView = objc_getClass("NotificationsExplanationView"));
			%init(AlertStyleView, AlertStyleView = objc_getClass("AlertStyleView"));
		});
	}
	else if([self class] == objc_getClass("PSUIPrefsListController")){
		static dispatch_once_t d;
		dispatch_once(&d, ^{
			%init(PSUIPrefsListController, PSUIPrefsListController = objc_getClass("PSUIPrefsListController"));
		});	
	}
	else if([self class] == objc_getClass("WallpaperController")){
		static dispatch_once_t e;
		dispatch_once(&e, ^{
			void *isHandled = dlopen("/Library/MobileSubstrate/DynamicLibraries/Nocturne_PhotosUI.dylib", RTLD_LAZY);
			if(isHandled){
				%init(WallpaperMagicTableCategoryLabel, WallpaperMagicTableCategoryLabel = objc_getClass("WallpaperMagicTableCategoryLabel"));
				dlclose(isHandled);
			}
		});
	}
}

/*- (void)_unloadBundleControllers
{
}*/

%end

%ctor
{
	%init;
}