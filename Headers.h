#import <objc/runtime.h>

// MAIN THEME
#define CellBackgroundColor ColorWithRGB(13, 27, 40)
#define PhoneButtonColor ColorWithRGB(39, 57, 75)
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

#define ColorWithRGB(r,g,b) [UIColor colorWithRed:r/255.0f green:g/255.0f blue:b/255.0f alpha:1]
#define ColorWithWhite(w) [UIColor colorWithWhite:w alpha:1]

void notcurneUITableViewCellOriginalCall(id self, SEL _cmd, UITableView *tableView, UITableViewCell *cell, NSIndexPath *indexPath);
void notcurneUITableViewHeaderOriginalCall(id self, SEL _cmd, UITableView *tableView, UIView *view, NSInteger *index);
void notcurneUITableViewFooterOriginalCall(id self, SEL _cmd, UITableView *tableView, UIView *view, NSInteger *index);

void notcurneCommonUITableViewCellModifications(id self, SEL _cmd, UITableViewCell *cell);
void nocturneCommonUITableViewHeaderFooterModification(id self, SEL _cmd, UIView *view);
void nocturneCommonUITableViewHeaderFooterModificationMethod(id self, SEL _cmd, UITableView *tableView, UIView *view, NSInteger *indePath);

void nocturnePreferencesUITableViewHeaderModification(id self, SEL _cmd, UITableView *tableView, UIView *view, NSInteger *index);
void nocturnePreferencesUITableViewFooterModification(id self, SEL _cmd, UITableView *tableView, UIView *view, NSInteger *index);
void notcurnePreferencesUITableViewCellModifications(id self, SEL _cmd, UITableView *tableView, UITableViewCell *cell, NSIndexPath *indexPath);

void notcurnePhoneUITableViewCellModifications(id self, SEL _cmd, UITableView *tableView, UITableViewCell *cell, NSIndexPath *indexPath);
void nocturnePhoneUITableViewHeaderModification(id self, SEL _cmd, UITableView *tableView, UIView *view, NSInteger *index);
void nocturnePhoneUITableViewFooterModification(id self, SEL _cmd, UITableView *tableView, UIView *view, NSInteger *index);

void notcurneStoreUITableViewCellModifications(id self, SEL _cmd, UITableView *tableView, UITableViewCell *cell, NSIndexPath *indexPath);

@interface UITableViewController (nocturneExtension)
- (void)nocturneCommonModificationForCell:(UITableViewCell *)cell;
@end

@interface UITableViewCell (background)
- (void)_setupSelectedBackgroundView;
@end

@interface NocturneController : NSObject
@property (nonatomic, getter=isInTweakPref) BOOL tweakPref;
+ (NSAttributedString *)_replaceColorForAttributedString:(NSAttributedString *)oldString withColor:(UIColor *)color;
+ (id)sharedInstance;
- (void)addPointerList:(NSPointerArray *)pointerArray forDelegate:(id)delegateClass;
- (BOOL)classExists:(id)delegateClass;
- (void *)getPointerAtIndex:(int)index forDelegate:(id)delegateClass;
- (id)init;
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
- (UIImage *)setTintColor:(UIColor *)color;
+ (UIImage *)imageWithColor:(UIColor *)color;
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

@interface CHRecentCall : NSObject
@property unsigned int callStatus;
@end

@interface PHRecentsCell : UITableViewCell
@property(readonly, assign) NSDictionary* allViews;
@property(retain, nonatomic) CHRecentCall* call;
@end

@interface _UIContentUnavailableView : UIView
@end

@interface PHVoicemailCell : UITableViewCell
-(id)_nameLabel;
@end

@interface UITableViewIndex : UIView
@property (nonatomic, retain) UIColor *indexBackgroundColor;
@property (nonatomic, retain) UIColor *indexColor;
@property (nonatomic, retain) UIColor *indexTrackingBackgroundColor;
@end

@interface ASUpdateCellLayout : UIView
@end

@interface ASUpdateTableViewCell : UITableViewCell
-(ASUpdateCellLayout *)layout;
@end

@interface SKUIAccountButtonsView : UIView
@property (nonatomic, readonly) UIButton *appleIDButton;
@property (nonatomic, readonly) UIButton *giftingButton;
@property (nonatomic, readonly) UIButton *redeemButton;
@property (nonatomic, readonly) UIButton *termsAndConditionsButton;
@end

@interface UINavigationTransitionView : UIView
@property (readonly) UIView *fromView;
@end