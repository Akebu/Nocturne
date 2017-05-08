#import "../Headers.h"

@interface PUCollectionView : UICollectionView
@end

%hook PUCollectionView

- (void)reloadData
{
	%orig;
	self.backgroundColor = TableViewBackgroundColor;
}

%end

%hook PUPhotosGlobalFooterView

- (void)willMoveToSuperview:(UIView *)newSuperview
{
	%orig;
	
	UIStackView *stackView = MSHookIvar<UIStackView *>(self, " _stackView");
	HBLogInfo(@"%@", [stackView subviews]);
}

%end