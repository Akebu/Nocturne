#import "../Headers.h"

%group Applications

static NSMutableArray *delegateList = [[NSMutableArray alloc] init];
static IMP original_UITableViewDelegate_willDisplayCell_;
static IMP original_UITableViewDelegate_HeaderView_;
static IMP original_UITableViewDelegate_FooterView_;

void (*customizeCellPtr)(id, SEL, UITableView *, UITableViewCell *,NSIndexPath *);
void (*customizeHeaderPtr)(id, SEL, UITableView *,UIView *, NSInteger *);
void (*customizeFooterPtr)(id, SEL, UITableView *,UIView *, NSInteger *);

void nocturneAddTableViewDelegateCellMethod(id self, SEL _cmd, UITableView *tableView, UITableViewCell *cell, NSIndexPath *indexPath){ return ; } 
void nocturneAddTableViewDelegateHeaderMethod(id self, SEL _cmd, UITableView *tableView, UIView *cell, NSInteger *indexPath){ return ; }
void nocturneAddTableViewDelegateFooterMethod(id self, SEL _cmd, UITableView *tableView, UIView *cell, NSInteger *indexPath){ return ; }

/* === Common modifications === */
void notcurneCommonUITableViewCellModifications(id self, SEL _cmd, UITableView *tableView, UITableViewCell *cell, NSIndexPath *indexPath)
{
	original_UITableViewDelegate_willDisplayCell_(self, _cmd, tableView, cell, indexPath);	// %orig;
	cell.backgroundColor = CellBackgroundColor;
	cell.textLabel.textColor = CellTextColor;
	cell.detailTextLabel.textColor = CellDetailTextColor;
}

void nocturneCommonUITableViewHeaderModification(id self, SEL _cmd, UITableView *tableView, UIView *view, NSInteger *index)
{
	original_UITableViewDelegate_HeaderView_(self, _cmd, tableView, view, index);			// %orig;
	if ([view respondsToSelector:@selector(textLabel)]){
		((UITableViewHeaderFooterView *) view).textLabel.textColor = TableViewHeaderTextColor
	}
}

void nocturneCommonUITableViewFooterModification(id self, SEL _cmd, UITableView *tableView, UIView *view, NSInteger *index)
{
	original_UITableViewDelegate_FooterView_(self, _cmd, tableView, view, index);			// %orig;
	if ([view respondsToSelector:@selector(textLabel)]){
		((UITableViewHeaderFooterView *) view).textLabel.textColor = TableViewFooterTextColor
	}
}
/* === === === */

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
		[delegateList addObject:NSStringFromClass ([delegate class])];
	}
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
