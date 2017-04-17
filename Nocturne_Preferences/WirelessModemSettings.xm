#import "../Headers.h"

static pthread_once_t modemHooksAreInit = PTHREAD_ONCE_INIT;
static void initModemSettingsHooks();

%group WirelessModemSettings
	%hook TetheringSwitchFooterView
	-(void)layoutSubviews
	{
		%log;
		%orig;
		NSMutableArray *allLabels = MSHookIvar<NSMutableArray *>(self, "_labels");
		for(UILabel *label in allLabels){
			label.textColor = TableViewFooterTextColor;
		}
	}
	%end
%end

%group WirelessModemSetupInstructions
	%hook SetupView
	-(void)addStep:(id)step
	{
		UILabel *titleLabel = MSHookIvar<UILabel *>(self, "_title");
		titleLabel.textColor = ColorWithWhite(0.90);

		%orig;
	}

	-(void)setIcon:(UIImage *)image
	{
		/* http://stackoverflow.com/a/22669888 */
		%orig([image invertColors]);
	}

	-(id)_preferenceLabelWithText:(id)arg1
	{
		UILabel *setupLabel = %orig;
		setupLabel.textColor = ColorWithWhite(0.72);
		return setupLabel;
	}

	%end
%end

%hook PSListController
- (void)_loadBundleControllers
{
	%orig;
	if([self class] == objc_getClass("WirelessModemController")){
		pthread_once(&modemHooksAreInit, initModemSettingsHooks);
	}
}
%end

void initModemSettingsHooks()
{
	%init(WirelessModemSettings, TetheringSwitchFooterView = objc_getClass("TetheringSwitchFooterView"));
	%init(WirelessModemSetupInstructions, SetupView = objc_getClass("SetupView"));
}

%ctor
{
	%init;
}