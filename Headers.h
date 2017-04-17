#define CellBackgroundColor ColorWithRGB(33,47,61)
#define TableViewBackgroundColor ColorWithRGB(28,40,51);
#define CellTextColor ColorWithWhite(0.90);
#define CellDetailTextColor ColorWithWhite(0.75);

#define TableViewHeaderTextColor ColorWithRGB(230, 126, 34);//ColorWithWhite(0.72);
#define TableViewFooterTextColor ColorWithRGB(230, 126, 34);//ColorWithWhite(0.72);

#define OrangeColor ColorWithRGB(230, 126, 34);
#define GreenColor ColorWithRGB(29, 131, 72);
#define BlueColor ColorWithRGB(41, 128, 185);
#define ColorWithRGB(r,g,b) [UIColor colorWithRed:r/255.0f green:g/255.0f blue:b/255.0f alpha:1];
#define ColorWithWhite(w) [UIColor colorWithWhite:w alpha:1];

@interface UITableViewDelegate
-(void) nocturneCustomizeCell:(UITableViewCell *)cell;
-(void) nocturneCustomizeHeaderView:(UIView *)view;
-(void) nocturneCustomizeFooterView:(UIView *)view;
-(void) nocturneSelectRowAtIndexPath:(NSIndexPath *)indexPath;
@end

@interface UIImage (invertColors)
- (UIImage *)invertColors;
@end
