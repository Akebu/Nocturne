#import "../Headers.h"

%group AirPortSettingsAPTableCell
	%hook APTableCell
	- (void)updateImages
	{
		%orig;
		UIImageView *lockView = MSHookIvar<UIImageView *>(self, "_lockView");
		lockView.image = [lockView.image imageWithRenderingMode:UIImageRenderingModeAlwaysTemplate];
		lockView.tintColor = ColorWithWhite(0.90);

		lockView = MSHookIvar<UIImageView *>(self, "_barsView");
		lockView.image = [lockView.image imageWithRenderingMode:UIImageRenderingModeAlwaysTemplate];
		lockView.tintColor = ColorWithWhite(0.90);
	}
	%end
%end

%group AirPortSettingsGroupHeader

	%hook APNetworksGroupHeader
		-(void)addSubview:(id)subview
		{
			if([subview class] == [UILabel class]){
				((UILabel *)subview).textColor = TableViewHeaderTextColor
			}
			%orig;
		}
	%end

%end

%hook PSListController
- (void)_loadBundleControllers
{
	%orig;
	if([self class] == objc_getClass("APNetworksController")){
		static dispatch_once_t p = 0;
		dispatch_once(&p, ^{
			%init(AirPortSettingsAPTableCell, APTableCell = objc_getClass("APTableCell"));
			%init(AirPortSettingsGroupHeader, APNetworksGroupHeader = objc_getClass("APNetworksGroupHeader"));
		});
	}
}
%end

%ctor
{
	%init;
}