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

/* === === === */

/* === Preferences.app === */

void notcurnePreferencesUITableViewCellModifications(id self, SEL _cmd, UITableView *tableView, UITableViewCell *cell, NSIndexPath *indexPath)
{
	notcurneUITableViewCellOriginalCall(self, _cmd, tableView, cell, indexPath);
	notcurneCommonUITableViewCellModifications(self, _cmd, cell);

	if([[NocturneController sharedInstance] isInTweakPref]){
		UIImage *icon = cell.imageView.image;
		if([icon isDark]){
			cell.imageView.image = [icon imageWithRenderingMode:UIImageRenderingModeAlwaysTemplate];
			cell.imageView.tintColor = ColorWithWhite(0.80);
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
		NSAttributedString *oldFooterAttributedString = [attributedTextView attributedText];
		NSMutableAttributedString *footerAttributedString = [[NSMutableAttributedString alloc] initWithString:[oldFooterAttributedString string]];
		[oldFooterAttributedString enumerateAttributesInRange:NSMakeRange(0, [oldFooterAttributedString length])
			options:nil
			usingBlock:^(NSDictionary<NSString *,id> *attrs, NSRange range, BOOL *stop)
			{
				for(id attribute in attrs){
					if([NSStringFromClass([attrs[attribute] class]) isEqualToString:@"UICachedDeviceRGBColor"]){
						[footerAttributedString addAttribute:attribute value:TableViewHeaderTextColor range:range];
					}else{
						[footerAttributedString addAttribute:attribute value:attrs[attribute] range:range];
					}
				}
			}
		];
		attributedTextView.attributedText = footerAttributedString;
		attributedTextView.tintColor = BlueColor;
		[footerAttributedString release];
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
		UILabel *callerName = MSHookIvar<UILabel *>(cell, "_callerNameLabel");
		CGFloat red = 0.0, green = 0.0, blue = 0.0, alpha = 0.0;
		[callerName.textColor getRed:&red green:&green blue:&blue alpha:&alpha];
		UIColor *color = nil;

		if(red == 1 && green < 0.5 && blue < 0.5)
			color = RedColor;
		else
			color = TextColor;

		callerName.textColor = color;
		callerName.backgroundColor = [UIColor clearColor];

		UILabel *callerCountLabel = MSHookIvar<UILabel *>(cell, "_callerCountLabel");
		callerCountLabel.textColor = color;
		callerCountLabel.backgroundColor = [UIColor clearColor];

		UILabel *callerNameLabel = MSHookIvar<UILabel *>(cell, "_callerLabelLabel");
		callerNameLabel.textColor = LightTextColor;
		callerNameLabel.backgroundColor = [UIColor clearColor];

		UILabel *callerDateLabel = MSHookIvar<UILabel *>(cell, "_callerDateLabel");
		callerDateLabel.textColor = VeryLightTextColor;
		callerDateLabel.backgroundColor = [UIColor clearColor];

		UIImageView *callType = MSHookIvar<UIImageView *>(cell, "_callTypeIconView");
		callType.image = [callType.image imageWithRenderingMode:UIImageRenderingModeAlwaysTemplate];
		callType.tintColor = ColorWithWhite(1);
	}
	else if([cell class] == objc_getClass("PHFavoritesCell"))
	{
		cell.backgroundColor = TableViewBackgroundColor;
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