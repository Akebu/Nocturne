#import <objc/runtime.h>

// MAIN THEME
#define CellBackgroundColor ColorWithRGB(13, 27, 40)
#define TableViewBackgroundColor ColorWithRGB(7,18,29)
#define TextFieldBackgroundView ColorWithWhite(1)
#define CellTextColor ColorWithWhite(0.80)
#define CellDetailTextColor ColorWithWhite(0.75)
#define CellSelectedColor ColorWithRGB(83,99,116)

#define TableViewHeaderTextColor ColorWithWhite(0.65)
#define TableViewFooterTextColor ColorWithWhite(0.65)

#define RedColor ColorWithRGB(169, 50, 38)
#define OrangeColor ColorWithRGB(211, 84, 0)
#define GreenColor ColorWithRGB(29, 131, 72)
#define BlueColor ColorWithRGB(27, 79, 114)
#define LightBlueColor ColorWithRGB(33, 97, 140)

#define TextColor ColorWithWhite(0.90)
#define LightTextColor ColorWithWhite(0.72)
#define VeryLightTextColor ColorWithWhite(0.70)
// ---

// CALLS
#define kCellDelegateCall [NSNumber numberWithInt:1]
#define kHeaderDelegateCall [NSNumber numberWithInt:2]
#define kFooterDelegateCall [NSNumber numberWithInt:3]
// ---

#define ColorWithRGB(r,g,b) [UIColor colorWithRed:r/255.0f green:g/255.0f blue:b/255.0f alpha:1]
#define ColorWithWhite(w) [UIColor colorWithWhite:w alpha:1]


void notcurneCommonUITableViewCellModifications(id self, SEL _cmd, UITableView *tableView, UITableViewCell *cell, NSIndexPath *indexPath);
void nocturneCommonUITableViewHeaderFooterModification(id self, SEL _cmd, UITableView *tableView, UIView *view, NSInteger *index);
void nocturneCommonUITableViewDidDeselectRow(id self, SEL _cmd, UITableView *tableView, NSIndexPath *indexPath);

void nocturnePreferencesUITableViewHeaderModification(id self, SEL _cmd, UITableView *tableView, UIView *view, NSInteger *index);
void nocturnePreferencesUITableViewFooterModification(id self, SEL _cmd, UITableView *tableView, UIView *view, NSInteger *index);
void notcurnePreferencesUITableViewCellModifications(id self, SEL _cmd, UITableView *tableView, UITableViewCell *cell, NSIndexPath *indexPath);

void notcurnePhoneUITableViewCellModifications(id self, SEL _cmd, UITableView *tableView, UITableViewCell *cell, NSIndexPath *indexPath);


@interface NocturneController : NSObject
@property (nonatomic, assign, getter=isInTweakPref) BOOL tweakPref;
+ (id)sharedInstance;
- (void)addPointerList:(NSPointerArray *)pointerArray forDelegate:(id)delegateClass;
- (BOOL)classExists:(id)delegateClass;
- (void *)getPointerAtIndex:(int)index forDelegate:(id)delegateClass;
- (id)init;
-(void)dealloc;
@end

@interface _UIBackdropView : UIView
-(NSArray *)allBackdropViews;
- (void)transitionToColor:(id)arg1;
- (id)darkeningTintView;
@end

@interface DevicePINKeypad : UIView
@end

@interface UIImage (inverseColors)
- (UIImage *)inverseColors;
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

@interface PHRecentsCell : UITableViewCell
{
	UILabel *_callerNameLabel;
}
@end