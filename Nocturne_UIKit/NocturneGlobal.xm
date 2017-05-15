#import "../Headers.h"

static NSMutableArray *delegateList;

void (*customizeCellPtr)(id, SEL, UITableView *, UITableViewCell *,NSIndexPath *);
void (*customizeHeaderPtr)(id, SEL, UITableView *,UIView *, NSInteger *);
void (*customizeFooterPtr)(id, SEL, UITableView *,UIView *, NSInteger *);

%group Global

%hook UIKBRenderConfig

- (BOOL)lightKeyboard
{
	/* Dark keyboard only ! */
	return NO;
}

%end

%hook _UIBackdropView
- (void)willMoveToSuperview:(UIView *)newSuperview
{
	%orig;
	UIColor *blurColor = [UIColor colorWithRed:1/255.0f green:11/255.0f blue:22/255.0f alpha:0.9f];
	[self transitionToColor:blurColor];
}
%end

%end

%group Applications
/* === Hooks === */
%hook UITableView
- (void)setDelegate:(id)delegate
{
	/* Check the current delegate, call MSHookMessageEx twice will crash the program */
	if(![delegateList containsObject:[delegate class]] && delegate != nil){

		IMP *original_UITableViewDelegate_willDisplayCell_;
		IMP *original_UITableViewDelegate_HeaderView_;
		IMP *original_UITableViewDelegate_FooterView_;

		NSMutableArray *pointerList = [[NSMutableArray alloc] init];

		/* Add delegate class always in first position */
		[pointerList addObject:[delegate class]];

		/* Try to add tableView:willDisplayCell:forRowAtIndexPath:*/
		BOOL addWillDisplayCellMethod = class_addMethod([delegate class], @selector(tableView:willDisplayCell:forRowAtIndexPath:), (IMP)customizeCellPtr, "@@:@@");
		if(!addWillDisplayCellMethod){
			/* tableView:willDisplayCell:forRowAtIndexPath: already exist, so it can be Hooked */
			MSHookMessageEx([delegate class], @selector(tableView:willDisplayCell:forRowAtIndexPath:), (IMP)customizeCellPtr, (IMP *)&original_UITableViewDelegate_willDisplayCell_);
			/* Store the value of the original call, so it can be called later */
			[pointerList addObject:[NSValue valueWithPointer:original_UITableViewDelegate_willDisplayCell_]];
		}else{
			/* tableView:willDisplayCell:forRowAtIndexPath: does not exist, the method have been created and call the correct function. */
			[pointerList addObject:[NSNull null]];
		}

		/* Try to add tableView:willDisplayHeaderView:forSection:*/
		BOOL addwillDisplayHeaderViewMethod = class_addMethod([delegate class], @selector(tableView:willDisplayHeaderView:forSection:), (IMP)customizeHeaderPtr, "@@:@@");
		if(!addwillDisplayHeaderViewMethod){
			MSHookMessageEx([delegate class], @selector(tableView:willDisplayHeaderView:forSection:), (IMP)customizeHeaderPtr, (IMP *)&original_UITableViewDelegate_HeaderView_);
			[pointerList addObject:[NSValue valueWithPointer:original_UITableViewDelegate_HeaderView_]];
		}else{
			[pointerList addObject:[NSNull null]];
		}

		/* Try to add tableView:willDisplayFooterView:forSection:*/
		BOOL addWillDisplayFooterViewMethod = class_addMethod([delegate class], @selector(tableView:willDisplayFooterView:forSection:), (IMP)customizeFooterPtr, "@@:@@");
		if(!addWillDisplayFooterViewMethod){
			MSHookMessageEx([delegate class], @selector(tableView:willDisplayFooterView:forSection:), (IMP)customizeFooterPtr, (IMP *)&original_UITableViewDelegate_FooterView_);
			[pointerList addObject:[NSValue valueWithPointer:original_UITableViewDelegate_FooterView_]];
		}else{
			[pointerList addObject:[NSNull null]];
		}

		/* Add the pointer array to the NocturneController */
		[[NocturneController sharedInstance] addOriginalCalls:pointerList];
		[pointerList release];
		/* Add the current delegate, call MSHookMessageEx twice will crash the program */
		[delegateList addObject:[delegate class]];
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
	 %orig([UIColor orangeColor]);
}
%end

/* === === === */

%end

void setDefaultColors()
{
	/* Use appearance, I don't want to block other tweak for theses objects*/
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
	if([bundleID hasPrefix:@"com.apple."]){
		%init(Global);
		if([bundleID isEqualToString:@"com.apple.springboard"]){
		}else{
			%init(Applications);
			if([bundleID isEqualToString:@"com.apple.Preferences"]){
				customizeCellPtr = &notcurnePreferencesUITableViewCellModifications;
				customizeHeaderPtr = &nocturnePreferencesUITableViewHeaderModification;
				customizeFooterPtr = &nocturnePreferencesUITableViewFooterModification;
			}
			if([bundleID isEqualToString:@"com.apple.Music"]){
				customizeCellPtr = &notcurneMusicUITableViewCellModifications;
			}
			setDefaultColors();
			delegateList = [[[NSMutableArray alloc] init] autorelease];
		}
	}	
}
