#import "../Headers.h"

static NSMutableArray *delegateList;

void (*customizeCellPtr)(id, SEL, UITableView *, UITableViewCell *,NSIndexPath *);
void (*customizeHeaderPtr)(id, SEL, UITableView *,UIView *, NSInteger *);
void (*customizeFooterPtr)(id, SEL, UITableView *,UIView *, NSInteger *);

%group Applications 

/* === Hooks === */
%hook UITableView
- (void)setDelegate:(id)delegate
{
	if(delegate != nil && ![delegateList containsObject:NSStringFromClass([delegate class])]){
		if(![delegate respondsToSelector:@selector(tableView:willDisplayCell:forRowAtIndexPath:)]){
			class_addMethod([delegate class], @selector(tableView:willDisplayCell:forRowAtIndexPath:), (IMP)customizeCellPtr, "@@:@@");
		}
		else
		{
			MSHookMessageEx([delegate class], @selector(tableView:willDisplayCell:forRowAtIndexPath:), (IMP)customizeCellPtr, (IMP *)&original_UITableViewDelegate_willDisplayCell_);
		}

		if(![delegate respondsToSelector:@selector(tableView:willDisplayHeaderView:forSection:)]){
			class_addMethod([delegate class], @selector(tableView:willDisplayHeaderView:forSection:), (IMP)customizeHeaderPtr, "@@:@@");
		}
		else
		{
			MSHookMessageEx([delegate class], @selector(tableView:willDisplayHeaderView:forSection:), (IMP)customizeHeaderPtr, (IMP *)&original_UITableViewDelegate_HeaderView_);
		}

		if(![delegate respondsToSelector:@selector(tableView:willDisplayFooterView:forSection:)]){
			class_addMethod([delegate class], @selector(tableView:willDisplayFooterView:forSection:), (IMP)customizeFooterPtr, "@@:@@");
		}
		else
		{
			MSHookMessageEx([delegate class], @selector(tableView:willDisplayFooterView:forSection:), (IMP)customizeFooterPtr, (IMP *)&original_UITableViewDelegate_FooterView_);
		}
		[delegateList addObject:NSStringFromClass([delegate class])];
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

/* === === === */

%end

%ctor
{
	NSString *bundleID = [[NSBundle mainBundle] bundleIdentifier];
	if([bundleID hasPrefix:@"com.apple."]){

		if([bundleID isEqualToString:@"com.apple.springboard"]){
			// TODO
		}else{

			%init(Applications); 

			if([bundleID isEqualToString:@"com.apple.Preferences"]){

				customizeFooterPtr = &nocturnePreferencesUITableViewFooterModification;
			}

			if(!customizeCellPtr){
				customizeCellPtr = &notcurneCommonUITableViewCellModifications;
			}
			if(!customizeHeaderPtr){
				customizeHeaderPtr = &nocturneCommonUITableViewHeaderFooterModification;
			}
			if(!customizeFooterPtr){
				customizeFooterPtr = &nocturneCommonUITableViewHeaderFooterModification;
			}

			delegateList = [[[NSMutableArray alloc] init] autorelease];

			/* Common modifications */
			[UINavigationBar appearance].barStyle = UIBarStyleBlackTranslucent;
			[UINavigationBar appearance].tintColor = OrangeColor;

			[UITableView appearance].backgroundColor = TableViewBackgroundColor;
			[UITableViewCell appearance].tintColor = BlueColor;
					
			[UISwitch appearance].tintColor = ColorWithWhite(0.50);
			[UISwitch appearance].onTintColor = GreenColor;
			[UISwitch appearance].thumbTintColor = ColorWithRGB(214,219,223);

			[UISearchBar appearance].translucent = YES;
			[UISearchBar appearance].barTintColor = ColorWithRGB(33,47,61);

			[UISegmentedControl appearance].tintColor = BlueColor;

			[UIActivityIndicatorView appearance].color = ColorWithWhite(0.70);

			[UITextField appearance].keyboardAppearance = UIKeyboardAppearanceDark;
		}
	}	
}
