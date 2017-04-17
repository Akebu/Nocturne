#import "../Headers.h"
#include <pthread.h>
static pthread_once_t airportHooksAreInit = PTHREAD_ONCE_INIT;
static void initAirPortSettingsHooks();

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
		pthread_once(&airportHooksAreInit, initAirPortSettingsHooks);
	}
}
%end

void initAirPortSettingsHooks()
{
	%init(AirPortSettingsAPTableCell, APTableCell = objc_getClass("APTableCell"));
	%init(AirPortSettingsGroupHeader, APNetworksGroupHeader = objc_getClass("APNetworksGroupHeader"));
}

%ctor
{
	%init;
}