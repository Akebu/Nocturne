#define OrangeColor ColorWithRGB(230, 126, 34);
#define GreenColor ColorWithRGB(29, 131, 72);
#define ColorWithWhite(w) [UIColor colorWithWhite:w alpha:1];
#define ColorWithRGB(r,g,b) [UIColor colorWithRed:r/255.0f green:g/255.0f blue:b/255.0f alpha:1];

%group NocturneHookMethod

	%hook TableViewDelegate
	- (void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath
	{
		cell.backgroundColor = ColorWithRGB(33,47,61)
		//cell.textLabel.textColor = ColorWithWhite(0.90)
		//cell.detailTextLabel.textColor = ColorWithWhite(0.80)
	}
	%end
%end

void nocturneAddTableViewDelegateMethod(id self, SEL _cmd, UITableView *tableView, UITableViewCell *cell, NSIndexPath *indexPath)
{
}


%hook UITableView
- (void)setDelegate:(id)delegate
{
	if(![delegate respondsToSelector:@selector(tableView:willDisplayCell:forRowAtIndexPath:)]){
		class_addMethod([delegate class], @selector(tableView:willDisplayCell:forRowAtIndexPath:), (IMP)nocturneAddTableViewDelegateMethod, "@@:@@");
	}
	%init(NocturneHookMethod, TableViewDelegate = [delegate class]);
	%orig;
}

- (void)setBackgroundColor:(UIColor *)color
{
	UIColor *tableViewBackgroundColor = ColorWithRGB(28,40,51);
	%orig(tableViewBackgroundColor);
}

%end

%hook UITabBar

- (void)setBarTintColor:(UIColor *)color
{
	 %orig([UIColor orangeColor]);
}

%end

%hook UITableViewCell

- (void)_setupSelectedBackgroundView
{
	UIView *selectionColor = [[UIView alloc] init];
	selectionColor.backgroundColor = ColorWithRGB(93,109,126);
	self.selectedBackgroundView = selectionColor;
	[selectionColor release];
}

%end

%hook UINavigationBar

-(UINavigationBar *) initWithFrame:(CGRect)frame
{
	UINavigationBar *UINavBar = %orig;
	UINavBar.barStyle = UIBarStyleBlackTranslucent;
	[[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleLightContent];
	UINavBar.tintColor = OrangeColor;
	return UINavBar;
}

%end

/*s
%hook UILabel

-(void)setTextColor:(UIColor *)color
{
	/* http://stackoverflow.com/questions/2509443/check-if-uicolor-is-dark-or-bright */
	/* http://www.w3.org/WAI/ER/WD-AERT/#color-contrast */
	/*bool isEqualToOrange = [color isEqual:[UIColor orangeColor]];
	bool isEqualToGrey = [UIColor colorWithRed:142.0f/255.0f green:142.0f/255.0f blue:147.0f/255.0f alpha:1];

	if(!isEqualToOrange || !isEqualToGrey){
		UIColor *backgroundColor = [UIColor colorWithRed:13.0f/255.0f green:13.0f/255.0f blue:13.0f/255.0f alpha:1];
		size_t numberOfComponents = CGColorGetNumberOfComponents(backgroundColor.CGColor);
		const CGFloat *componentColors = CGColorGetComponents(backgroundColor.CGColor);

		CGFloat darknessScore = 0;
		if (numberOfComponents == 2) {
			darknessScore = (((componentColors[0]*255) * 299) + ((componentColors[0]*255) * 587) + ((componentColors[0]*255) * 114)) / 1000;
		} else if (numberOfComponents == 4) {
			darknessScore = (((componentColors[0]*255) * 299) + ((componentColors[1]*255) * 587) + ((componentColors[2]*255) * 114)) / 1000;
		}
		if (darknessScore >= 125) {
			color = [UIColor blackColor];
		}else{
			color = [UIColor whiteColor];
		}
	}
	%orig;
}

%end*/

%ctor
{
	%init;
	[UISwitch appearance].tintColor = ColorWithWhite(0.50);
	[UISwitch appearance].onTintColor = GreenColor;
	[UISwitch appearance].thumbTintColor = ColorWithRGB(214,219,223);

	[UISearchBar appearance].translucent = YES;
	[UISearchBar appearance].barTintColor = ColorWithRGB(33,47,61);
}
