#import "Headers.h"
static BOOL isInit = NO;

/* === Settings === */
%group SettingsHooks

	%hook APTableCell
	-(void)updateImages
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

void nocturneSettingsUITableViewCellModification(id self, SEL _cmd, UITableViewCell *cell)
{
	cell.backgroundColor = CellBackgroundColor;
	cell.textLabel.textColor = ColorWithWhite(0.90);
	cell.detailTextLabel.textColor = ColorWithWhite(0.80);
	if([cell class] == [%c(APTableCell) class]){
		if(!isInit){
			isInit = YES;
			%init(SettingsHooks, APTableCell = [cell class]);
		}
		[cell updateImages];
	}
}

/* === Phone === */
void nocturnePhoneUITableViewCellModification(id self, SEL _cmd, UITableViewCell *cell){
	cell.backgroundColor = OrangeColor;
}