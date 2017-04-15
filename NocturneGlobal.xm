#import "Headers.h"

void (*customizationPtr)(id, SEL, UITableViewCell *);

%group NocturneTableViewHook

	%hook TableViewDelegate
	- (void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath
	{
		%orig;
		[self nocturneCustomizeCell:cell];
	}

	- (void)tableView:(UITableView *)tableView willDisplayHeaderView:(UIView *)view forSection:(NSInteger)section
	{
		%orig;
		if ([view respondsToSelector:@selector(textLabel)]){
			((UITableViewHeaderFooterView *) view).textLabel.textColor = ColorWithWhite(0.85);
		}
	}

	- (void)tableView:(UITableView *)tableView willDisplayFooterView:(UIView *)view forSection:(NSInteger)section
	{
		%orig;
		if ([view respondsToSelector:@selector(textLabel)]){
			((UITableViewHeaderFooterView *) view).textLabel.textColor = ColorWithWhite(0.85);
		}
	}
	%end

%end

void nocturneAddTableViewDelegateCellMethod(id self, SEL _cmd, UITableView *tableView, UITableViewCell *cell, NSIndexPath *indexPath){}
void nocturneAddTableViewDelegateHeaderMethod(id self, SEL _cmd, UITableView *tableView, UITableViewCell *cell, NSInteger *indexPath){}
void nocturneAddTableViewDelegateFooterMethod(id self, SEL _cmd, UITableView *tableView, UITableViewCell *cell, NSIndexPath *indexPath){}

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

	class_addMethod([delegate class], @selector(nocturneCustomizeCell:), (IMP)customizationPtr, "@@:@");
	%init(NocturneTableViewHook, TableViewDelegate = [delegate class]);
	%orig;
}

- (void)didMoveToSuperview
{
	%orig;
	self.backgroundColor = TableViewBackgroundColor;
}

%end

%hook UITableViewCell

- (void)_setupSelectedBackgroundView
{
	UIView *selectionColor = [[UIView alloc] init];
	selectionColor.backgroundColor = ColorWithRGB(93,109,126);
	self.selectedBackgroundView = selectionColor;
	[selectionColor release];
}

%end

%hook UITextField
- (void)setTextColor:(UIColor *)color
{
	color = ColorWithWhite(0.90);
	%orig;
}

%end


%hook UINavigationBar

-(UINavigationBar *) initWithFrame:(CGRect)frame
{
	UINavigationBar *UINavBar = %orig;
	/* Manually call setBarStyle: and setTintColor:*/
	UINavBar.barStyle = UIBarStyleBlackTranslucent;
	UINavBar.tintColor = OrangeColor;
	return UINavBar;
}

- (void)setBarStyle:(UIBarStyle)barStyle
{
	[[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleLightContent];
	%orig(UIBarStyleBlackTranslucent);
}

- (void)setTintColor:(UIColor *)tintColor
{
	tintColor = OrangeColor;
	%orig;
}

%end


%ctor
{
	NSString *bundleID = [[NSBundle mainBundle] bundleIdentifier];
	if([bundleID hasPrefix:@"com.apple."] && ![bundleID isEqualToString:@"com.apple.springboard"]){

		%init;

		if([bundleID isEqualToString:@"com.apple.Preferences"]){
			customizationPtr = &nocturneSettingsUITableViewCellModification;
		}
		else if([bundleID isEqualToString:@"com.apple.mobilephone"]){
			customizationPtr = &nocturnePhoneUITableViewCellModification;
		}

		[UISwitch appearance].tintColor = ColorWithWhite(0.50);
		[UISwitch appearance].onTintColor = GreenColor;
		[UISwitch appearance].thumbTintColor = ColorWithRGB(214,219,223);

		[UISearchBar appearance].translucent = YES;
		[UISearchBar appearance].barTintColor = ColorWithRGB(33,47,61);
	}
}
