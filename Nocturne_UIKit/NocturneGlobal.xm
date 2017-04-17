#import "../Headers.h"

void (*cellPtr)(id, SEL, UITableViewCell *);
void (*headerViewPtr)(id, SEL, UIView *);
void (*footerViewPtr)(id, SEL, UIView *);

void nocturneAddTableViewDelegateCellMethod(id self, SEL _cmd, UITableView *tableView, UITableViewCell *cell, NSIndexPath *indexPath){}
void nocturneAddTableViewDelegateHeaderMethod(id self, SEL _cmd, UITableView *tableView, UITableViewCell *cell, NSInteger *indexPath){}
void nocturneAddTableViewDelegateFooterMethod(id self, SEL _cmd, UITableView *tableView, UITableViewCell *cell, NSIndexPath *indexPath){}

%group NocturneTableViewHook

	%hook TableViewDelegate
	- (void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath
	{
		[self nocturneCustomizeCell:cell];
	}

	- (void)tableView:(UITableView *)tableView willDisplayHeaderView:(UIView *)view forSection:(NSInteger)section
	{
		[self nocturneCustomizeFooterView:view];
	}

	- (void)tableView:(UITableView *)tableView willDisplayFooterView:(UIView *)view forSection:(NSInteger)section
	{
		[self nocturneCustomizeHeaderView:view];
	}
	%end

%end

%group Applications

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

	class_addMethod([delegate class], @selector(nocturneCustomizeCell:), (IMP)cellPtr, "@@:@");
	class_addMethod([delegate class], @selector(nocturneCustomizeFooterView:), (IMP)footerViewPtr, "@@:@");
	class_addMethod([delegate class], @selector(nocturneCustomizeHeaderView:), (IMP)headerViewPtr, "@@:@");

	%init(NocturneTableViewHook, TableViewDelegate = [delegate class]);
	%orig;
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

%hook UIViewController
- (void)viewDidLoad
{
	%orig;
	[[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleLightContent];

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
%end

%end


%ctor
{
	NSString *bundleID = [[NSBundle mainBundle] bundleIdentifier];
	if([bundleID hasPrefix:@"com.apple."]){

		if([bundleID isEqualToString:@"com.apple.springboard"]){

		}else{
			%init(Applications);

			/* Common modifications */
			cellPtr = &notcurneCommonUITableViewCellModifications;
			headerViewPtr = &nocturneCommonUITableViewHeaderModification;
			footerViewPtr = &nocturneCommonUITableViewFooterModification;
		}
	}	
}
