#import "../Headers.h"

@interface CNContactListBannerView : UIView
@property (nonatomic,readonly) UILabel * titleLabel;
@property (nonatomic,readonly) UILabel * footnoteLabel;
@end

@interface CNContactListTableViewCell : UITableViewCell
@property (nonatomic) bool isMeCard;
@end

@interface CNContactListViewController : UITableViewController
- (id)tableView:(id)arg1 cellForRowAtIndexPath:(id)arg2;
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

%hook CNContactListTableViewCell

- (void)setHighlighted:(bool)isHighlighted animated:(bool)arg2
{
	if(isHighlighted)
		self.backgroundColor = CellSelectedColor;
	else
		%orig;
}

%end

%hook CNContactListViewController

- (void)tableView:(UITableView *)tableView willDisplayCell:(CNContactListTableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath
{
	%orig;
	[self nocturneCommonModificationForCell:cell];
	if([cell isMeCard]){
		cell.subviews[0].backgroundColor = [UIColor clearColor];
	}
}

%end