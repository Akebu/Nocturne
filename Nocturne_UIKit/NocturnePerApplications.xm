#import "../Headers.h"
#import "substrate.h"

/* === Common modifications === */

void notcurneUITableViewOriginalCall(id self, SEL _cmd, UITableView *tableView, UITableViewCell *cell, NSIndexPath *indexPath, int index)
{
	IMP original_UITableViewDelegate_willDisplayCell_ = (IMP)[[NocturneController sharedInstance] getPointerAtIndex:index forDelegate:[tableView.delegate class]];
	if(original_UITableViewDelegate_willDisplayCell_)
		((void(*)(id, SEL, UITableView *, UITableViewCell *, NSIndexPath *))original_UITableViewDelegate_willDisplayCell_)(self, _cmd, tableView, cell, indexPath);
}

void notcurneCommonUITableViewCellModifications(id self, SEL _cmd, UITableView *tableView, UITableViewCell *cell, NSIndexPath *indexPath)
{
	cell.backgroundColor = CellBackgroundColor; 
	cell.textLabel.textColor = CellTextColor;
	cell.detailTextLabel.textColor = CellDetailTextColor;
	cell.imageView.tintColor = ColorWithWhite(0.90);
}

void nocturneCommonUITableViewDidDeselectRow(id self, SEL _cmd, UITableView *tableView, NSIndexPath *indexPath)
{
	HBLogInfo(@"Yaha");
}

void nocturneCommonUITableViewHeaderFooterModification(id self, SEL _cmd, UITableView *tableView, UIView *view, NSInteger *index)
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
	notcurneCommonUITableViewCellModifications(self, _cmd, tableView, cell, indexPath);

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
	nocturneCommonUITableViewHeaderFooterModification(self, _cmd, tableView, view, index);

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
	nocturneCommonUITableViewHeaderFooterModification(self, _cmd, tableView, view, index);

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
	notcurneUITableViewOriginalCall(self, _cmd, tableView, cell, indexPath, 0);

	if([cell class] == objc_getClass("PHRecentsCell")){
		cell.backgroundColor = CellBackgroundColor; 
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
		UILabel *titleTextLabel = MSHookIvar<UILabel *>(cell, "_titleTextLabel");
		titleTextLabel.textColor = TextColor;

		UILabel *detailTextLabel = MSHookIvar<UILabel *>(cell, "_labelTextLabel");
		detailTextLabel.textColor = LightTextColor;
	}
}