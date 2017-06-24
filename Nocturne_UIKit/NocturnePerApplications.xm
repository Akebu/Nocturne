#import "../Headers.h"
#import "substrate.h"

/* === %orig === */

void notcurneUITableViewCellOriginalCall(id self, SEL _cmd, UITableView *tableView, UITableViewCell *cell, NSIndexPath *indexPath)
{
	IMP original_UITableViewDelegate_willDisplayCell_ = (IMP)[[NocturneController sharedInstance] getPointerAtIndex:0 forDelegate:[tableView.delegate class]];
	if(original_UITableViewDelegate_willDisplayCell_)
		((void(*)(id, SEL, UITableView *, UITableViewCell *, NSIndexPath *))original_UITableViewDelegate_willDisplayCell_)(self, _cmd, tableView, cell, indexPath);
}

void notcurneUITableViewHeaderOriginalCall(id self, SEL _cmd, UITableView *tableView, UIView *view, NSInteger *index)
{
	IMP original_UITableViewDelegate_HeaderView_ = (IMP)[[NocturneController sharedInstance] getPointerAtIndex:1 forDelegate:[tableView.delegate class]];
	if(original_UITableViewDelegate_HeaderView_)
		((void(*)(id, SEL, UITableView *, UIView *, NSInteger *))original_UITableViewDelegate_HeaderView_)(self, _cmd, tableView, view, index);
}

void notcurneUITableViewFooterOriginalCall(id self, SEL _cmd, UITableView *tableView, UIView *view, NSInteger *index)
{
	IMP original_UITableViewDelegate_FooterView_ = (IMP)[[NocturneController sharedInstance] getPointerAtIndex:2 forDelegate:[tableView.delegate class]];
	if(original_UITableViewDelegate_FooterView_)
		((void(*)(id, SEL, UITableView *, UIView *, NSInteger *))original_UITableViewDelegate_FooterView_)(self, _cmd, tableView, view, index);
}

/* === === === */

/* === Common modifications === */

void notcurneCommonUITableViewCellModifications(id self, SEL _cmd, UITableViewCell *cell)
{
	cell.backgroundColor = CellBackgroundColor;
	cell.contentView.backgroundColor = CellBackgroundColor;
	cell.textLabel.textColor = CellTextColor;
	cell.detailTextLabel.textColor = CellDetailTextColor;
	cell.imageView.tintColor = ColorWithWhite(0.90);
}


void nocturneCommonUITableViewHeaderFooterModification(id self, SEL _cmd, UIView *view)
{
	if([view respondsToSelector:@selector(textLabel)]){
		((UITableViewHeaderFooterView *) view).textLabel.textColor = TableViewHeaderTextColor;
		[((UITableViewHeaderFooterView *) view) backgroundView].backgroundColor = TableViewBackgroundColor;
	}
	else
	{
		for(id label in [view subviews]){
			if([label respondsToSelector:@selector(setTextColor:)])
				((UILabel *)label).textColor = TableViewFooterTextColor;
		}
	}
}

void nocturneCommonUITableViewHeaderFooterModificationMethod(id self, SEL _cmd, UITableView *tableView, UIView *view, NSInteger *indexPath)
{
	nocturneCommonUITableViewHeaderFooterModification(self, _cmd, view);
}

/* === === === */

/* === Preferences.app === */

void notcurnePreferencesUITableViewCellModifications(id self, SEL _cmd, UITableView *tableView, UITableViewCell *cell, NSIndexPath *indexPath)
{
	notcurneUITableViewCellOriginalCall(self, _cmd, tableView, cell, indexPath);
	notcurneCommonUITableViewCellModifications(self, _cmd, cell);

	if([[NocturneController sharedInstance] isInTweakPref]){
		UIImage *icon = cell.imageView.image;
		if([icon isDark]){
			cell.imageView.image = [icon setTintColor:ColorWithWhite(0.80)];
		}
	}
	if([cell class] == objc_getClass("PUAlbumListTableViewCell")){
		PUAlbumListCellContentView *cellView = cell.contentView.subviews[0];
		UILabel *label = [cellView _subtitleLabel];
		label.backgroundColor = [UIColor clearColor];
		label.textColor = LightTextColor;

		UITextField *textField = [cellView _titleTextField];
		textField.backgroundColor = [UIColor clearColor];
		textField.textColor = CellTextColor;
	}
	if((([cell class] == objc_getClass("PLBatteryUIDisplayTableCell"))) || ([cell class] == objc_getClass("ACUIAccountSummaryCell"))){
		for(id label in [cell subviews]){
			if([label respondsToSelector:@selector(setTextColor:)])
				((UILabel *)label).textColor = VeryLightTextColor;
		}
	}
}

void nocturnePreferencesUITableViewHeaderModification(id self, SEL _cmd, UITableView *tableView, UIView *view, NSInteger *index)
{
	notcurneUITableViewHeaderOriginalCall(self, _cmd, tableView, view, index);
	nocturneCommonUITableViewHeaderFooterModification(self, _cmd, view);

	if([[NocturneController sharedInstance] isInTweakPref]){
		if(view.frame.size.height > 55){
			for(id label in [view subviews]){
				if([label class] == [UILabel class])
					((UILabel *)label).textColor = TableViewHeaderTextColor;
			}
		}
	}
}

void nocturnePreferencesUITableViewFooterModification(id self, SEL _cmd, UITableView *tableView, UIView *view, NSInteger *index)
{
	notcurneUITableViewFooterOriginalCall(self, _cmd, tableView, view, index);
	nocturneCommonUITableViewHeaderFooterModification(self, _cmd, view);

	if([[[view subviews] firstObject] class] == [UITextView class]){
		UITextView *attributedTextView = [[view subviews] firstObject];
		NSAttributedString *footerAttributedString = [attributedTextView attributedText];
		attributedTextView.attributedText = [%c(NocturneController) _replaceColorForAttributedString:footerAttributedString withColor:TableViewHeaderTextColor];
		attributedTextView.tintColor = BlueColor;
	}
}

/* === === === */

/* === Store.app === */
void notcurneStoreUITableViewCellModifications(id self, SEL _cmd, UITableView *tableView, UITableViewCell *cell, NSIndexPath *indexPath)
{
	notcurneUITableViewCellOriginalCall(self, _cmd, tableView, cell, indexPath);
	notcurneCommonUITableViewCellModifications(self, _cmd, cell);
	if([cell class] == objc_getClass("ASUpdateTableViewCell"))
	{
		ASUpdateCellLayout *cellLayout = [(ASUpdateTableViewCell *)cell layout];
		MSHookIvar<UILabel *>(cellLayout, "_titleLabel").textColor = TextColor;
		MSHookIvar<UILabel *>(cellLayout, "_versionLabel").textColor = LightTextColor;
	}
}
/* === === === */

/* === Phone.app === */

void notcurnePhoneUITableViewCellModifications(id self, SEL _cmd, UITableView *tableView, UITableViewCell *cell, NSIndexPath *indexPath)
{
	notcurneUITableViewCellOriginalCall(self, _cmd, tableView, cell, indexPath);

	if([cell class] != objc_getClass("CNContactListTableViewCell"))
		notcurneCommonUITableViewCellModifications(self, _cmd, cell);

	if([cell class] == objc_getClass("PHRecentsCell")){
		NSDictionary *allViews = [(PHRecentsCell *)cell allViews];
		NSArray *allLabelKey = [allViews allKeys];
		for(NSString *key in allLabelKey){
			id view = [allViews objectForKey:key];
			UIColor *color = nil;
			if([key isEqualToString:@"Name"] || [key isEqualToString:@"Count"]){
				CHRecentCall *recentCalls = ((PHRecentsCell *)cell).call;
				if(recentCalls.callStatus == 8){
					color = RedColor;
				}else{
					color = CellTextColor;
				}
			}
			else if([key isEqualToString:@"Count"]){
				color = CellTextColor;
			}
			else if([key isEqualToString:@"Label"]){
				color = VeryLightTextColor;
			}
			else if([key isEqualToString:@"Date"]){
				color = LightTextColor;
			}
			else if([key isEqualToString:@"CallTypeIcon"]){
				((UIImageView *)view).image = [((UIImageView *)view).image setTintColor:ColorWithWhite(1)];
				return;
			}
			else
			{
				color = LightTextColor;
			}
			((UILabel *)view).textColor = color;
			((UILabel *)view).backgroundColor = [UIColor clearColor];
		}
	}
	else if([cell class] == objc_getClass("PHFavoritesCell"))
	{
		cell.backgroundColor = TableViewBackgroundColor;
		cell.contentView.backgroundColor = TableViewBackgroundColor;
		MSHookIvar<UILabel *>(cell, "_titleTextLabel").textColor = TextColor;
		MSHookIvar<UILabel *>(cell, "_labelTextLabel").textColor = LightTextColor;
	}
	else if([cell class] == objc_getClass("PHVoicemailCell"))
	{

		cell.backgroundColor = CellBackgroundColor;
		cell.contentView.subviews[0].backgroundColor = CellBackgroundColor;

		UILabel *nameLabel = ((PHVoicemailCell *)cell)._nameLabel;
		nameLabel.backgroundColor = [UIColor clearColor];
		nameLabel.textColor = CellTextColor;

		UILabel *labelLabel = MSHookIvar<UILabel *>(cell, "_labelLabel");
		labelLabel.textColor = LightTextColor;
		labelLabel.backgroundColor = [UIColor clearColor];

		UILabel *durationLabel = MSHookIvar<UILabel *>(cell, "_durationLabel");
		durationLabel.textColor = VeryLightTextColor;
		durationLabel.backgroundColor = [UIColor clearColor];

		UILabel *dateLabel = MSHookIvar<UILabel *>(cell, "_dateLabel");
		dateLabel.textColor = LightTextColor;
		dateLabel.backgroundColor = [UIColor clearColor];

		UIImageView *unreadView = MSHookIvar<UIImageView *>(cell, "_unreadIndicatorView");
		unreadView.image = [unreadView.image imageWithRenderingMode:UIImageRenderingModeAlwaysTemplate];
		unreadView.tintColor = OrangeColor;
		unreadView.backgroundColor = [UIColor clearColor];

		UIImageView *infoButton = MSHookIvar<UIImageView *>(cell, "_infoButton");
		infoButton.backgroundColor = [UIColor clearColor];

	}
	else if([cell class] == objc_getClass("PHVoicemailFolderCell"))
	{
		cell.backgroundColor = CellBackgroundColor;

		UILabel *folderLabel = MSHookIvar<UILabel *>(cell, "_folderLabel");
		folderLabel.textColor = TextColor;
		folderLabel.backgroundColor = [UIColor clearColor];

		UILabel *countLabel = MSHookIvar<UILabel *>(cell, "_countLabel");
		countLabel.textColor = LightTextColor;
		countLabel.backgroundColor = [UIColor clearColor];
	}
}

/* === === === */