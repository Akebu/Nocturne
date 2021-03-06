#import "../Headers.h"

void (*customizeCellPtr)(id, SEL, UITableView *, UITableViewCell *,NSIndexPath *);
void (*customizeHeaderPtr)(id, SEL, UITableView *,UIView *, NSInteger *);
void (*customizeFooterPtr)(id, SEL, UITableView *, UIView *, NSInteger *);

%group Global

%hook UIKBRenderConfig

- (BOOL)lightKeyboard
{
	/* Dark keyboard only ! */
	return NO;
}

%end

/*%hook _UIBackdropView
- (void)willMoveToSuperview:(UIView *)newSuperview
{
	%orig;
	UIColor *blurColor = [UIColor colorWithRed:1/255.0f green:11/255.0f blue:22/255.0f alpha:0.9f];
	[self transitionToColor:blurColor];
}
%end*/

%end

%group Applications

/* === Hooks === */
%hook UITableView
- (void)setDelegate:(id)delegate
{
	if(![[NocturneController sharedInstance] classExists:[delegate class]] && delegate != nil){

		IMP *original_UITableViewDelegate_willDisplayCell_;
		IMP *original_UITableViewDelegate_HeaderView_;
		IMP *original_UITableViewDelegate_FooterView_;

		NSPointerArray *pointerList = [[NSPointerArray alloc] initWithOptions:NSPointerFunctionsOpaqueMemory];

		BOOL addClassForCell = class_addMethod([delegate class], @selector(tableView:willDisplayCell:forRowAtIndexPath:), (IMP)customizeCellPtr, "@@:@@@");
		class_addMethod([delegate class], @selector(nocturneCommonModificationForCell:), (IMP)notcurneCommonUITableViewCellModifications, "@@:@");

		if(!addClassForCell){
			MSHookMessageEx([delegate class], @selector(tableView:willDisplayCell:forRowAtIndexPath:), (IMP)customizeCellPtr, (IMP *)&original_UITableViewDelegate_willDisplayCell_);
			[pointerList addPointer:original_UITableViewDelegate_willDisplayCell_];
		}else{
			[pointerList addPointer:nil];
		}

		BOOL addClassForHeaderView = class_addMethod([delegate class], @selector(tableView:willDisplayHeaderView:forSection:), (IMP)customizeHeaderPtr, "@@:@@@");
		if(!addClassForHeaderView && customizeHeaderPtr){
			MSHookMessageEx([delegate class], @selector(tableView:willDisplayHeaderView:forSection:), (IMP)customizeHeaderPtr, (IMP *)&original_UITableViewDelegate_HeaderView_);
			[pointerList addPointer:original_UITableViewDelegate_HeaderView_];
		}else{
			[pointerList addPointer:nil];
		}

		BOOL addClassForFooterView = class_addMethod([delegate class], @selector(tableView:willDisplayFooterView:forSection:), (IMP)customizeFooterPtr, "@@:@@@");
		if(!addClassForFooterView && customizeFooterPtr){
			MSHookMessageEx([delegate class], @selector(tableView:willDisplayFooterView:forSection:), (IMP)customizeFooterPtr, (IMP *)&original_UITableViewDelegate_FooterView_);
			[pointerList addPointer:original_UITableViewDelegate_FooterView_];
		}else{
			[pointerList addPointer:nil];
		}

		[[NocturneController sharedInstance] addPointerList:pointerList forDelegate:[delegate class]];
		[pointerList release];
	}

	%orig;
}

- (void)willMoveToSuperview:(UIView *)newSuperview
{
	%orig;
	[self setIndicatorStyle:UIScrollViewIndicatorStyleWhite];
	self.backgroundView = [[[UIView alloc] initWithFrame:self.frame] autorelease];
}

- (void)setBackgroundView:(UIView *)view
{
	view.backgroundColor = TableViewBackgroundColor;
	%orig;
}

- (UIView *)_defaultBackgroundView
{
	UIView *defaultView = [[[UIView alloc] initWithFrame:self.frame] autorelease];
	[self setBackgroundView:defaultView];
	return defaultView;
}

%end

%hook UITableViewCell

- (void)_setupSelectedBackgroundView
{
	%orig;
	UIView *selectionColor = [[UIView alloc] initWithFrame:self.frame];
	selectionColor.backgroundColor = CellSelectedColor;
	self.selectedBackgroundView = selectionColor;
	[selectionColor release];
}

%end

%hook UITextField

- (void)setTextColor:(UIColor *)color
{
	if([self backgroundColor] == [UIColor clearColor]){
		color = VeryLightTextColor;
	}
	%orig;
}

- (UIImage *)_clearButtonImageForState:(unsigned int)arg1
{
	/* Allow button image to be tinted */
	UIImage *clearButtonImage = %orig;
	clearButtonImage = [clearButtonImage imageWithRenderingMode:UIImageRenderingModeAlwaysTemplate];
	return clearButtonImage;
}

- (void)setBackgroundColor:(UIColor *)color
{
	if(color == [UIColor clearColor]){
		self.tintColor = ColorWithWhite(1);
	}
	%orig;
}

- (id)_placeholderColor
{
	return ColorWithWhite(0.35);
}

%end

%hook UIApplication

-(void)setStatusBarStyle:(int)style
{
	%orig(UIStatusBarStyleLightContent);
}

%end

%hook UINavigationBar
- (void)setBarStyle:(int)style
{
	%orig(UIBarStyleBlackTranslucent);
}
- (void)setTintColor:(UIColor *)color
{
	%orig(OrangeColor);
}
- (void)setTitleTextAttributes:(NSDictionary *)attributes
{
	NSDictionary *newAttributes = [NSDictionary dictionaryWithObjectsAndKeys:[UIColor whiteColor], NSForegroundColorAttributeName, nil];
	%orig(newAttributes);
}
%end

%hook UITabBar
- (void)_setBackgroundView:(id)backgroundView
{
	return;
}

- (void)setBarStyle:(int)style
{
	%orig(UIBarStyleBlack);
}

- (void)setSelectedImageTintColor:(UIColor *)color
{
	%orig(BlueColor);
}

- (void)setTranslucent:(BOOL)arg1
{
	%orig(TRUE);
}

%end

%hook UIViewController
- (void)viewWillAppear:(BOOL)animated
{
	%orig;
	[[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleLightContent];
}
%end

%hook UITableViewIndex
- (void)setIndexBackgroundColor:(UIColor *)color
{
	%orig(CellBackgroundColor);
}
- (void)setIndexColor:(UIColor *)color
{
	%orig(LightTextColor);
}
- (void)setIndexTrackingBackgroundColor:(UIColor *)color
{
	%orig([UIColor blackColor]);
}
%end

%hook UICollectionView

- (void)setBackgroundColor:(UIColor *)color
{
	%orig(TableViewBackgroundColor);
}

- (void)reloadData
{
	%orig;
	self.backgroundColor = TableViewBackgroundColor;
}

%end

%hook UINavigationTransitionView
- (void)willMoveToSuperview:(UIView *)newSuperview
{
	%orig;
	self.backgroundColor = TableViewBackgroundColor;
}
%end

%hook UIActivityIndicatorView
- (void)setColor:(UIColor *)color
{
	%orig(ColorWithWhite(0.70));
}
%end

/* === === === */

%end

%group PhoneApp
%hook _UIContentUnavailableView
- (void)willMoveToSuperview:(UIView *)newSuperview
{
	%orig;
	self.backgroundColor = TableViewBackgroundColor;
}

- (id)_flatTextColor
{
	return TextColor;
}
%end
%end

void setDefaultColors()
{
	[UITabBar appearance].selectedImageTintColor = BlueColor;
	[UITabBar appearance].barStyle = UIBarStyleBlack;
	[UITabBar appearance].translucent = true;

	[UINavigationBar appearance].barStyle = UIBarStyleBlackTranslucent;
	[UINavigationBar appearance].tintColor = OrangeColor;

	[UITableView appearance].backgroundColor = TableViewBackgroundColor;
	[UITableViewCell appearance].tintColor = BlueColor;
			
	[UISwitch appearance].tintColor = ColorWithWhite(0.50);
	[UISwitch appearance].onTintColor = GreenColor;
	[UISwitch appearance].thumbTintColor = ColorWithRGB(214,219,223);

	[UISearchBar appearance].translucent = YES;
	[UISearchBar appearance].barTintColor = CellBackgroundColor;

	[UISegmentedControl appearance].tintColor = BlueColor;

	[UIActivityIndicatorView appearance].color = ColorWithWhite(0.70);
}

%ctor
{
	NSString *bundleID = [[NSBundle mainBundle] bundleIdentifier];
	HBLogInfo(@"Load into %@", bundleID);
	%init(Global);
	if([bundleID hasPrefix:@"com.apple."]){

		if([bundleID isEqualToString:@"com.apple.springboard"]){
		}else{
			%init(Applications);
			customizeHeaderPtr = &nocturneCommonUITableViewHeaderFooterModificationMethod;
			customizeFooterPtr = &nocturneCommonUITableViewHeaderFooterModificationMethod;

			if([bundleID isEqualToString:@"com.apple.Preferences"]){
				customizeCellPtr = &notcurnePreferencesUITableViewCellModifications;
				customizeHeaderPtr = &nocturnePreferencesUITableViewHeaderModification;
				customizeFooterPtr = &nocturnePreferencesUITableViewFooterModification;
			}
			if([bundleID isEqualToString:@"com.apple.mobilephone"])
			{
				%init(PhoneApp);
				dlopen("/Library/MobileSubstrate/DynamicLibraries/Nocturne_ContactsUI.dylib", RTLD_NOW);
				customizeCellPtr = &notcurnePhoneUITableViewCellModifications;
			}
			if([bundleID isEqualToString:@"com.apple.AppStore"])
			{
				customizeCellPtr = &notcurneStoreUITableViewCellModifications;
			}
			setDefaultColors();
		}
	}	
}
