#import "../Headers.h"

@interface TPDialerNumberPad : UIView
@end

@interface PHHandsetDialerView
@property(retain) UIView* topBlankView;
@property(retain) UIView* bottomBlankView;
@property(retain) UIView* rightBlankView;
@property(retain) UIView* leftBlankView;
@property(retain) UIView* dimmingView;
@end

@interface TPPathView : UIView
{
    UIBezierPath *_path;
    UIColor *_fillColor;
}
@property(retain, nonatomic) UIColor *fillColor; // @synthesize fillColor=_fillColor;
@end

@interface TPRevealingRingView : UIView
@property (nonatomic, retain) UIColor *colorInsideRing;
@property (nonatomic, retain) UIColor *colorOutsideRing;
@end

@interface TPSuperBottomBarButton : UIButton
@end

@interface PHHandsetDialerNumberPadButton : UIControl
@end

%hook PHVoicemailSlider
- (id)timeLabelTextColorForStyle:(int)style
{
	return VeryLightTextColor;
}

%end

%hook PHVoicemailCell
+ (id)grayColor
{
	return VeryLightTextColor;
}

- (void)layoutSubviews
{
	%orig;
	UIButton *speakerButton = MSHookIvar<UIButton *>(self, "_speakerButton");
	speakerButton.tintColor = BlueColor;
	speakerButton.backgroundColor = [UIColor clearColor];

	UIButton *callBackButton = MSHookIvar<UIButton *>(self, "_callBackButton");
	callBackButton.tintColor = BlueColor;
	callBackButton.backgroundColor = [UIColor clearColor];

	UIButton *deleteButton = MSHookIvar<UIButton *>(self, "_deleteButton");
	deleteButton.tintColor = RedColor;
	deleteButton.backgroundColor = [UIColor clearColor];

	/*UIButton *playPauseButton = MSHookIvar<UIButton *>(self, "_playPauseButton");
	UIImage *buttonImage = [playPauseButton imageForState:UIControlStateNormal];
	buttonImage = [buttonImage imageWithRenderingMode:UIImageRenderingModeAlwaysTemplate];
	[playPauseButton setImage:buttonImage forState:UIControlStateNormal]; 
	playPauseButton.tintColor = BlueColor;*/
}
%end


%hook TPSuperBottomBarButton
-(void)setBackgroundColor:(UIColor *)color
{
	%orig(GreenColor);
}
%end

%hook TPPathView
- (void)setFillColor:(UIColor *)color
{
	color = PhoneButtonColor;
	%orig;
}
%end

%hook TPRevealingRingView
- (UIColor *)colorInsideRing
{
	return TableViewBackgroundColor;
}

- (UIColor *)colorOutsideRing
{
	return TableViewBackgroundColor;
}
%end

%hook TPDialerNumberPad
- (void)willMoveToSuperview:(UIView *)newSuperview
{
	%orig;
	self.backgroundColor = CellBackgroundColor;
}
%end

%hook PHHandsetDialerLCDView
- (id)newDeleteButton
{
	UIButton *deleteButton = %orig;
	deleteButton.tintColor = OrangeColor;
	return deleteButton;
}

- (id)newAddContactButton
{
	UIButton *addContactButton = %orig;
	addContactButton.tintColor = OrangeColor;
	return addContactButton;
}

- (id)lcdColor
{
	return TableViewBackgroundColor;
}

- (id)numberLabel
{
	UILabel *label = %orig;
	label.textColor = LightTextColor;
	return label;
}
%end

%hook PHHandsetDialerView
-(UIView *)topBlankView
{
	UIView *blankView = %orig;
	blankView.backgroundColor = TableViewBackgroundColor;
	return blankView;
}

-(UIView *)bottomBlankView
{
	UIView *blankView = %orig;
	blankView.backgroundColor = TableViewBackgroundColor;
	return blankView;
}

-(UIView *)rightBlankView
{
	UIView *blankView = %orig;
	blankView.backgroundColor = TableViewBackgroundColor;
	return blankView;
}

-(UIView *)leftBlankView
{
	UIView *blankView = %orig;
	blankView.backgroundColor = TableViewBackgroundColor;
	return blankView;
}

-(UIView *)dimmingView
{
	UIView *blankView = %orig;
	blankView.backgroundColor = TableViewBackgroundColor;
	return blankView;
}

%end