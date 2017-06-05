#import "../Headers.h"

void (*customizeCellPtr)(id, SEL, UITableView *, UITableViewCell *,NSIndexPath *);
void (*customizeHeaderPtr)(id, SEL, UITableView *,UIView *, NSInteger *);
void (*customizeFooterPtr)(id, SEL, UITableView *, UIView *, NSInteger *);
void (*customizeCellForDeselect)(id, SEL, UITableView *, NSIndexPath *);

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
		IMP *original_UITableViewDelegate_didDeselect_;

		NSPointerArray *pointerList = [[NSPointerArray alloc] initWithOptions:NSPointerFunctionsOpaqueMemory];

		if([delegate respondsToSelector:@selector(tableView:willDisplayCell:forRowAtIndexPath:)]){
			MSHookMessageEx([delegate class], @selector(tableView:willDisplayCell:forRowAtIndexPath:), (IMP)customizeCellPtr, (IMP *)&original_UITableViewDelegate_willDisplayCell_);
			[pointerList addPointer:original_UITableViewDelegate_willDisplayCell_];
		}else{
			class_addMethod([delegate class], @selector(tableView:willDisplayCell:forRowAtIndexPath:), (IMP)customizeCellPtr, "@@:@@@");
			[pointerList addPointer:nil];
		}

		if([delegate respondsToSelector:@selector(tableView:willDisplayHeaderView:forSection:)]){
			MSHookMessageEx([delegate class], @selector(tableView:willDisplayHeaderView:forSection:), (IMP)customizeHeaderPtr, (IMP *)&original_UITableViewDelegate_HeaderView_);
			[pointerList addPointer:original_UITableViewDelegate_HeaderView_];
		}else{
			class_addMethod([delegate class], @selector(tableView:willDisplayHeaderView:forSection:), (IMP)customizeHeaderPtr, "@@:@@@");
			[pointerList addPointer:nil];
		}

		if([delegate respondsToSelector:@selector(tableView:willDisplayFooterView:forSection:)]){
			MSHookMessageEx([delegate class], @selector(tableView:willDisplayFooterView:forSection:), (IMP)customizeFooterPtr, (IMP *)&original_UITableViewDelegate_FooterView_);
			[pointerList addPointer:original_UITableViewDelegate_FooterView_];
		}else{
			class_addMethod([delegate class], @selector(tableView:willDisplayFooterView:forSection:), (IMP)customizeFooterPtr, "@@:@@@");
			[pointerList addPointer:nil];
		}

		if([delegate respondsToSelector:@selector(tableView:didDeselectRowAtIndexPath:)]){
			MSHookMessageEx([delegate class], @selector(tableView:didDeselectRowAtIndexPath:), (IMP)customizeCellForDeselect, (IMP *)&original_UITableViewDelegate_didDeselect_);
			[pointerList addPointer:original_UITableViewDelegate_didDeselect_];
			HBLogInfo(@"Hooked !");
		}else{
			class_addMethod([delegate class], @selector(tableView:didDeselectRowAtIndexPath:), (IMP)customizeCellForDeselect, "@@:@@");
			[pointerList addPointer:nil];
			HBLogInfo(@"Added!");
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
- (void)setBarTintColor:(UIColor *)color
{
	 %orig(TableViewBackgroundColor);
}

- (void)setSelectedImageTintColor:(UIColor *)color
{
	%orig(BlueColor);
}

%end

/* === === === */

%end

void setDefaultColors()
{
	/* Use appearance, I don't want to block other tweak for theses objects*/
	[UITabBar appearance].selectedImageTintColor = BlueColor;

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
	%init(Global);
	if([bundleID hasPrefix:@"com.apple."]){

		if([bundleID isEqualToString:@"com.apple.springboard"]){
		}else{
			%init(Applications);
			customizeCellForDeselect = &nocturneCommonUITableViewDidDeselectRow;

			if([bundleID isEqualToString:@"com.apple.Preferences"]){
				customizeCellPtr = &notcurnePreferencesUITableViewCellModifications;
				customizeHeaderPtr = &nocturnePreferencesUITableViewHeaderModification;
				customizeFooterPtr = &nocturnePreferencesUITableViewFooterModification;
			}
			if([bundleID isEqualToString:@"com.apple.mobilephone"])
			{
				customizeCellPtr = &notcurnePhoneUITableViewCellModifications;
				customizeHeaderPtr = &nocturneCommonUITableViewHeaderFooterModification;
				customizeFooterPtr = &nocturneCommonUITableViewHeaderFooterModification;
			}
			setDefaultColors();
		}
	}	
}
