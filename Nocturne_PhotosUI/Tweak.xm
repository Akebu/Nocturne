#import "../Headers.h"

@interface PUCollectionView : UICollectionView
@end

%hook PUPhotosGlobalFooterView
- (void)willMoveToSuperview:(UIView *)newSuperview
{
	%orig;
	UIStackView *stackView = MSHookIvar<UIStackView *>(self, "_stackView");
	for(UILabel *label in [stackView subviews]){
		if([label respondsToSelector:@selector(setTextColor:)])
			((UILabel *)label).textColor = CellDetailTextColor;
	}
}
%end