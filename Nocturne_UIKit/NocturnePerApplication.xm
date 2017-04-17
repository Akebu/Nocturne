#import "../Headers.h"

/* Common */
void notcurneCommonUITableViewCellModifications(id self, SEL _cmd, UITableViewCell *cell)
{
	cell.backgroundColor = CellBackgroundColor;
	cell.textLabel.textColor = CellTextColor;
	cell.detailTextLabel.textColor = CellDetailTextColor;
}

void nocturneCommonUITableViewHeaderModification(id self, SEL _cmd, UIView *view)
{
	if ([view respondsToSelector:@selector(textLabel)]){
		((UITableViewHeaderFooterView *) view).textLabel.textColor = TableViewHeaderTextColor
	}
}

void nocturneCommonUITableViewFooterModification(id self, SEL _cmd, UIView *view)
{
	if ([view respondsToSelector:@selector(textLabel)]){
		((UITableViewHeaderFooterView *) view).textLabel.textColor = TableViewFooterTextColor
	}
}