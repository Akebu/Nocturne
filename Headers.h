#import <objc/runtime.h>

// MAIN THEME
#define CellBackgroundColor ColorWithRGB(13, 27, 40)
#define TableViewBackgroundColor ColorWithRGB(7,18,29)
#define TextFieldBackgroundView ColorWithWhite(1)
#define CellTextColor ColorWithWhite(0.80)
#define CellDetailTextColor ColorWithWhite(0.75)
#define CellSelectedColor ColorWithRGB(83,99,116)

#define TableViewHeaderTextColor OrangeColor//ColorWithWhite(0.65)
#define TableViewFooterTextColor OrangeColor//ColorWithWhite(0.65)

#define OrangeColor ColorWithRGB(211, 84, 0)
#define GreenColor ColorWithRGB(29, 131, 72)
#define BlueColor ColorWithRGB(27, 79, 114)
#define LightBlueColor ColorWithRGB(33, 97, 140)

#define TextColor ColorWithWhite(0.90)
#define LightTextColor ColorWithWhite(0.72)
#define VeryLightTextColor ColorWithWhite(0.70)
// ---

#define ColorWithRGB(r,g,b) [UIColor colorWithRed:r/255.0f green:g/255.0f blue:b/255.0f alpha:1]
#define ColorWithWhite(w) [UIColor colorWithWhite:w alpha:1]

static IMP original_UITableViewDelegate_willDisplayCell_;
static IMP original_UITableViewDelegate_HeaderView_;
static IMP original_UITableViewDelegate_FooterView_;

void notcurneCommonUITableViewCellModifications(id self, SEL _cmd, UITableView *tableView, UITableViewCell *cell, NSIndexPath *indexPath);
void nocturneCommonUITableViewHeaderFooterModification(id self, SEL _cmd, UITableView *tableView, UIView *view, NSInteger *index);

void nocturnePreferencesUITableViewHeaderModification(id self, SEL _cmd, UITableView *tableView, UIView *view, NSInteger *index);
void nocturnePreferencesUITableViewFooterModification(id self, SEL _cmd, UITableView *tableView, UIView *view, NSInteger *index);
void notcurnePreferencesUITableViewCellModifications(id self, SEL _cmd, UITableView *tableView, UITableViewCell *cell, NSIndexPath *indexPath);

@interface NocturneController : NSObject
+ (void)isInTweakPref:(BOOL)state;
@end

@interface UIImage (invertColors)
- (UIImage *)invertColors;
- (BOOL) isDark;
@end

@interface PSListController : NSObject
- (id)specifiers;
- (NSBundle *)bundle;
- (BOOL)shouldReplaceIcons;
@end

@interface PUAlbumListCellContentView : UIView
- (id)_subtitleLabel;
- (id)_titleTextField;
@end