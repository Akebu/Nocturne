#import "../Headers.h"

/* === Common modifications === */

void notcurneCommonUITableViewCellModifications(id self, SEL _cmd, UITableView *tableView, UITableViewCell *cell, NSIndexPath *indexPath)
{
	cell.backgroundColor = CellBackgroundColor;
	cell.textLabel.textColor = CellTextColor;
	cell.detailTextLabel.textColor = CellDetailTextColor;
}

void nocturneCommonUITableViewHeaderFooterModification(id self, SEL _cmd, UITableView *tableView, UIView *view, NSInteger *index)
{
	if ([view respondsToSelector:@selector(textLabel)]){
		((UITableViewHeaderFooterView *) view).textLabel.textColor = TableViewHeaderTextColor;
		[((UITableViewHeaderFooterView *) view) backgroundView].backgroundColor = TableViewBackgroundColor;
	}
}

/* === === === */

/* === Preferences.app === */

void nocturnePreferencesUITableViewFooterModification(id self, SEL _cmd, UITableView *tableView, UIView *view, NSInteger *index)
{
	nocturneCommonUITableViewHeaderFooterModification(self, _cmd, tableView, view, index);
	UITextView *possibleUITextView = [[view subviews] firstObject];
	if([possibleUITextView class] == [UITextView class]){

		NSAttributedString *oldFooterAttributedString = [possibleUITextView attributedText];
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

		possibleUITextView.attributedText = footerAttributedString;
		possibleUITextView.tintColor = BlueColor;
		[footerAttributedString release];
	}
}

/* === === === */