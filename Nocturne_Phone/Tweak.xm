#import "../Headers.h"

@interface PHVoicemailSlider : UISlider
@end

@interface TPNumberPadButton : UIButton
@end

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
@property(retain, nonatomic) UIColor *fillColor;
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

%hook TPNumberPadButton
+ (id)imageForCharacter:(unsigned int)character highlighted:(bool)isHighlighted whiteVersion:(bool)isWhiteVersion
{
	UIImage *buttonImage = %orig;

	if(isWhiteVersion)
		return [buttonImage setTintColor:VeryLightTextColor];
	else
		return [buttonImage setTintColor:VeryLightTextColor];
}

- (id)initForCharacter:(unsigned int)arg1
{
	TPNumberPadButton *padButton = %orig;
	padButton.backgroundColor = PhoneButtonColor;
	return padButton;
}

%end

%hook PHVoicemailSlider
- (void)willMoveToSuperview:(UIView *)newSuperview
{
	%orig;
	self.backgroundColor = [UIColor clearColor];
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
	UIView *cellContentView = self.contentView;
	HBLogInfo(@"%@", [cellContentView subviews]);
	for(UIView *view in [cellContentView subviews])
		view.backgroundColor = [UIColor clearColor];

	UIButton *speakerButton = MSHookIvar<UIButton *>(self, "_speakerButton");
	speakerButton.tintColor = BlueColor;

	UIButton *callBackButton = MSHookIvar<UIButton *>(self, "_callBackButton");
	callBackButton.tintColor = BlueColor;

	UIButton *deleteButton = MSHookIvar<UIButton *>(self, "_deleteButton");
	deleteButton.tintColor = RedColor;

	UILabel *longDateLabel = MSHookIvar<UILabel *>(self, "_longDateLabel");
	longDateLabel.backgroundColor = [UIColor clearColor];
	longDateLabel.textColor = LightTextColor;
}

+ (id)pauseImage
{
	UIImage *pauseImage = %orig;
	return [pauseImage setTintColor:BlueColor];
}
+ (id)playImage
{
	UIImage *pauseImage = %orig;
	return [pauseImage setTintColor:BlueColor];
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
	%orig(TableViewBackgroundColor);
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