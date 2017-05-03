#import "../Headers.h"

static NSMutableArray *delegateList = [[NSMutableArray alloc] init];

void (*customizeCellPtr)(id, SEL, UITableView *, UITableViewCell *,NSIndexPath *);
void (*customizeHeaderPtr)(id, SEL, UITableView *,UIView *, NSInteger *);
void (*customizeFooterPtr)(id, SEL, UITableView *,UIView *, NSInteger *);

%group Applications 

void nocturneAddTableViewDelegateCellMethod(id self, SEL _cmd, UITableView *tableView, UITableViewCell *cell, NSIndexPath *indexPath){ return ; } 
void nocturneAddTableViewDelegateHeaderMethod(id self, SEL _cmd, UITableView *tableView, UIView *cell, NSInteger *indexPath){ return ; }
void nocturneAddTableViewDelegateFooterMethod(id self, SEL _cmd, UITableView *tableView, UIView *cell, NSInteger *indexPath){ return ; }

/* === Hooks === */
%hook UITableView
- (void)setDelegate:(id)delegate
{
	if(![delegate respondsToSelector:@selector(tableView:willDisplayCell:forRowAtIndexPath:)]){
		class_addMethod([delegate class], @selector(tableView:willDisplayCell:forRowAtIndexPath:), (IMP)nocturneAddTableViewDelegateCellMethod, "@@:@@");
	}
	if(![delegate respondsToSelector:@selector(tableView:willDisplayHeaderView:forSection:)]){
		class_addMethod([delegate class], @selector(tableView:willDisplayHeaderView:forSection:), (IMP)nocturneAddTableViewDelegateHeaderMethod, "@@:@@");
	}
	if(![delegate respondsToSelector:@selector(tableView:willDisplayFooterView:forSection:)]){
		class_addMethod([delegate class], @selector(tableView:willDisplayFooterView:forSection:), (IMP)nocturneAddTableViewDelegateFooterMethod, "@@:@@");
	}

	if(delegate != nil && ![delegateList containsObject:NSStringFromClass([delegate class])]){
		/* Call MSHookMessageEx twice on the same delegate class will crash the application */
		MSHookMessageEx([delegate class], @selector(tableView:willDisplayCell:forRowAtIndexPath:), (IMP)customizeCellPtr, (IMP *)&original_UITableViewDelegate_willDisplayCell_);
		MSHookMessageEx([delegate class], @selector(tableView:willDisplayHeaderView:forSection:), (IMP)customizeHeaderPtr, (IMP *)&original_UITableViewDelegate_HeaderView_);
		MSHookMessageEx([delegate class], @selector(tableView:willDisplayFooterView:forSection:), (IMP)customizeFooterPtr, (IMP *)&original_UITableViewDelegate_FooterView_);
		/* Add the delegate to the list, so it will never be executed again */
		[delegateList addObject:NSStringFromClass([delegate class])];
	}

	%orig;
}

%end

%hook UITableViewCell

- (void)_setupSelectedBackgroundView
{
	%orig;
	UIView *selectionColor = [[UIView alloc] initWithFrame:self.frame];
	selectionColor.backgroundColor = CellSelectedColor;
	self.selectedBackgroundView = selectionColor;
	[self bringSubviewToFront:selectionColor];
	[selectionColor release];
}

%end

%hook UITextField

- (void)setTextColor:(UIColor *)color
{
	if([self backgroundColor] == [UIColor clearColor]){
		color = ColorWithWhite(0.70);
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
		self.tintColor = ColorWithWhite(0.90);
	}
	%orig;
}

%end

%hook UIApplication
-(void)setStatusBarStyle:(int)style
{
	style = UIStatusBarStyleLightContent;
	%orig;
}
%end

/* === === === */

%end

%ctor
{
	NSString *bundleID = [[NSBundle mainBundle] bundleIdentifier];
	if([bundleID hasPrefix:@"com.apple."]){

		if([bundleID isEqualToString:@"com.apple.springboard"]){

		}else{

			%init(Applications); 

			customizeCellPtr = &notcurneCommonUITableViewCellModifications;
			customizeHeaderPtr = &nocturneCommonUITableViewHeaderModification;
			customizeFooterPtr = &nocturneCommonUITableViewFooterModification;

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
