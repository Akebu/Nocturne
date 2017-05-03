#import "../Headers.h"

@interface NotificationsExplanationView : NSObject
-(NSArray *)_accessibilityLabels;
@end

@interface AlertStyleView
-(UIImageView *)selectionImage;
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
		selectionImage.tintColor = NotificationSelectionColor;
		return styleView;
	}
	%end

%end

%hook PSListController
- (void)_loadBundleControllers
{
	%orig;

	if([self class] == objc_getClass("WirelessModemController")){
		static dispatch_once_t a = 0;
		dispatch_once(&a, ^{
			%init(WirelessModemSettings, TetheringSwitchFooterView = objc_getClass("TetheringSwitchFooterView"));
			%init(WirelessModemSetupInstructions, SetupView = objc_getClass("SetupView"));
		});
	}
	if([self class] == objc_getClass("APNetworksController")){
		static dispatch_once_t b = 0;
		dispatch_once(&b, ^{
			%init(AirPortSettingsAPTableCell, APTableCell = objc_getClass("APTableCell"));
			%init(AirPortSettingsGroupHeader, APNetworksGroupHeader = objc_getClass("APNetworksGroupHeader"));
		});
	}
	if([self class] == objc_getClass("BulletinBoardAppDetailController")){
		static dispatch_once_t c = 0;
		dispatch_once(&c, ^{
			%init(NotificationsExplanationFooterView, NotificationsExplanationView = objc_getClass("NotificationsExplanationView"));
			%init(AlertStyleView, AlertStyleView = objc_getClass("AlertStyleView"));
		});
	}
}
%end

%ctor
{
	%init;
}

