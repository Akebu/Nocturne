#define CellBackgroundColor ColorWithRGB(33,47,61)
#define TableViewBackgroundColor ColorWithRGB(28,40,51);
#define OrangeColor ColorWithRGB(230, 126, 34);
#define GreenColor ColorWithRGB(29, 131, 72);
#define ColorWithRGB(r,g,b) [UIColor colorWithRed:r/255.0f green:g/255.0f blue:b/255.0f alpha:1];
#define ColorWithWhite(w) [UIColor colorWithWhite:w alpha:1];

extern void nocturneSettingsUITableViewCellModification(id self, SEL _cmd, UITableViewCell *cell);
extern void nocturnePhoneUITableViewCellModification(id self, SEL _cmd, UITableViewCell *cell);
extern void nocturneAddTableViewDelegateCellMethod(id self, SEL _cmd, UITableView *tableView, UITableViewCell *cell, NSIndexPath *indexPath);

@interface UITableViewDelegate
-(void) nocturneCustomizeCell:(UITableViewCell *)cell;
@end

@interface UITableViewCell (APTablCell)
-(void)updateImages;
@end