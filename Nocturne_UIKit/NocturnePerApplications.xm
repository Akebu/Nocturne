#import "../Headers.h"

/* === Common modifications === */

void notcurneCommonUITableViewCellModifications(id self, SEL _cmd, UITableView *tableView, UITableViewCell *cell, NSIndexPath *indexPath)
{
	NSMutableArray *callList = [[NocturneController sharedInstance] getPointerList];
	for(NSArray *callArray in callList){
		if(([callArray objectAtIndex:0] == [tableView.delegate class]) && ([callArray objectAtIndex:1] != [NSNull null])){
			/* The delegate is the same, we can call the original implementation */
			IMP original_UITableViewDelegate_willDisplayCell_ = (IMP)[[callArray objectAtIndex:1] pointerValue];
			((void(*)(id, SEL, UITableView *, UITableViewCell *, NSIndexPath *))original_UITableViewDelegate_willDisplayCell_)(self, _cmd, tableView, cell, indexPath);
		}
	}
	cell.backgroundColor = CellBackgroundColor; 
	cell.textLabel.textColor = CellTextColor;
	cell.detailTextLabel.textColor = CellDetailTextColor;
	cell.imageView.tintColor = ColorWithWhite(0.90);
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

/* === Preferences.app === */

void notcurneMusicUITableViewCellModifications(id self, SEL _cmd, UITableView *tableView, UITableViewCell *cell, NSIndexPath *indexPath)
{
	notcurneCommonUITableViewCellModifications(self, _cmd, tableView, cell, indexPath);
}

/* === === === */