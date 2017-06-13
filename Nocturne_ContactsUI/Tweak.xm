#import "../Headers.h"

@interface CNContactListBannerView : UIView
@property (nonatomic,readonly) UILabel * titleLabel;
@property (nonatomic,readonly) UILabel * footnoteLabel;
@end

@interface CNContactListTableViewCell : UITableViewCell
@property (nonatomic) bool isMeCard;
@end

@interface CNContactListViewController : UITableViewController
@end

%hook CNContactListBannerView
- (void)willMoveToSuperview:(UIView *)newSuperview
{
	%orig;
	self.backgroundColor = CellBackgroundColor;
	self.titleLabel.textColor = TextColor;
	self.footnoteLabel.textColor = LightTextColor;
}
%end

%hook CNContactListViewController

/*- (void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath
{
	%orig;
}

- (void)tableView:(UITableView *) willDisplayHeaderView:(UIView *)view forSection:(NSInteger *)index
{
	%orig;
}

- (void)tableView:(UITableView *) willDisplayFooterView:(UIView *)view forSection:(NSInteger *)index
{
	%orig;
}*/

%end