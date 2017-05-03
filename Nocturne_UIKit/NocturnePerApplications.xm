#import "../Headers.h"

/* === Common modifications === */

void notcurneCommonUITableViewCellModifications(id self, SEL _cmd, UITableView *tableView, UITableViewCell *cell, NSIndexPath *indexPath)
{
	cell.backgroundColor = CellBackgroundColor;
	cell.textLabel.textColor = CellTextColor;
	cell.detailTextLabel.textColor = CellDetailTextColor;
}

void nocturneCommonUITableViewHeaderModification(id self, SEL _cmd, UITableView *tableView, UIView *view, NSInteger *index)
{
	if ([view respondsToSelector:@selector(textLabel)]){
		((UITableViewHeaderFooterView *) view).textLabel.textColor = TableViewHeaderTextColor;
		[((UITableViewHeaderFooterView *) view) backgroundView].backgroundColor = TableViewBackgroundColor;
	}
}

void nocturneCommonUITableViewFooterModification(id self, SEL _cmd, UITableView *tableView, UIView *view, NSInteger *index)
{
	if ([view respondsToSelector:@selector(textLabel)]){
		((UITableViewHeaderFooterView *) view).textLabel.textColor = TableViewFooterTextColor;
		[((UITableViewHeaderFooterView *) view) backgroundView].backgroundColor = TableViewBackgroundColor;
	}
}

/* === === === */