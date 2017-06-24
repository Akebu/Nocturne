#import "../Headers.h"
#import <QuartzCore/QuartzCore.h>

@interface SKUISectionHeaderCollectionViewCell : UIView
@end

@interface SKUIRoundedRectButton : UIButton
- (CABasicAnimation *)_basicAnimationWithKeyPath:(NSString *)keyPath;
@end

@interface SKUISectionHeaderView : UIView
@end

@interface SKUIActivityIndicatorViewElement : NSObject
@property (nonatomic,readonly) NSAttributedString * text; 
@end

@interface SKUILoadingDocumentViewController : UIViewController
- (SKUIActivityIndicatorViewElement *)_activityIndicator;
@end

%hook SKUIViewElementText
- (id)attributedStringWithDefaultFont:(id)font foregroundColor:(id)color
{
	color = TextColor;
	return %orig;
}
- (id)attributedStringWithDefaultFont:(id)font foregroundColor:(id)color style:(id)arg3
{
	color = TextColor;
	return %orig;
}
- (id)attributedStringWithDefaultFont:(id)font foregroundColor:(id)color textAlignment:(int)alignment
{
	color = TextColor;
	return %orig;
}
- (id)attributedStringWithDefaultFont:(id)font foregroundColor:(id)color textAlignment:(int)alignment style:(id)style
{
	color = TextColor;
	return %orig;
}
%end

%hook SKUILoadingDocumentViewController
- (void)viewDidAppear:(bool)arg1
{
	%orig;
	self.view.backgroundColor = TableViewBackgroundColor;
}
%end

%hook SKUISectionHeaderView
+ (id)_attributedStringForButton:(id)arg1 context:(id)arg2
{
	return [%c(NocturneController) _replaceColorForAttributedString:%orig withColor:LightTextColor];
}
+ (NSAttributedString *)_attributedStringForLabel:(id)arg1 context:(id)arg2
{
	return [%c(NocturneController) _replaceColorForAttributedString:%orig withColor:TextColor];
}

-(void)setBackgroundColor:(UIColor *)color
{
	%orig(TableViewBackgroundColor);
}
%end

%hook SKUIVerticalLockupView
+ (id)_attributedStringForButton:(id)arg1 context:(id)arg2
{
	return [%c(NocturneController) _replaceColorForAttributedString:%orig withColor:LightTextColor];
}
+ (NSAttributedString *)_attributedStringForLabel:(id)arg1 context:(id)arg2
{
	return [%c(NocturneController) _replaceColorForAttributedString:%orig withColor:TextColor];
}
%end

%hook SKUIPageDividerCollectionViewCell
- (void)setBackgroundColor:(UIColor *)color
{
	%orig(TableViewBackgroundColor);
}
%end

%hook SKUIButtonCollectionViewCell
+ (id)_attributedStringWithButton:(id)arg1 context:(id)arg2
{
	return [%c(NocturneController) _replaceColorForAttributedString:%orig withColor:CellTextColor];
}

- (void)reloadWithViewElement:(id)arg1 width:(double)arg2 context:(id)arg3
{
	%orig;
	UIControl *button = MSHookIvar<UIControl *>(self, "_button");
	button.backgroundColor = CellBackgroundColor;
	button.superview.backgroundColor = CellBackgroundColor;
}
%end

%hook SKUIAccountButtonsView
- (void)setBackgroundColor:(UIColor *)color
{
	%orig(TableViewBackgroundColor);
}
%end

%hook SKUILinkButton
- (void)setTitleColor:(UIColor *)color forState:(unsigned long long)state
{
	%orig(CellTextColor, state);
}
%end

%hook SKUIRoundedRectButton
- (CABasicAnimation *)_basicAnimationWithKeyPath:(NSString *)keyPath
{
	if([keyPath isEqualToString:@"backgroundColor"]){
	    CABasicAnimation *basicAnimation = [CABasicAnimation animationWithKeyPath:keyPath];
	    basicAnimation.duration = 0.8;
	    basicAnimation.autoreverses = YES;
	    CAMediaTimingFunction *customTimingFunction;
		customTimingFunction=[CAMediaTimingFunction functionWithControlPoints:0.3f :1.0f :0.1f :1.0f];
		basicAnimation.timingFunction = customTimingFunction;
	    basicAnimation.fromValue = (id) CellBackgroundColor.CGColor;
	    basicAnimation.toValue = (id) CellSelectedColor.CGColor;
	    basicAnimation.delegate = self;
	    basicAnimation.fillMode = kCAFillModeForwards;
	    return basicAnimation;
	}
	else
		return %orig;
}

- (void)_reloadColors
{
	%orig;
	[self setTitleColor:CellTextColor forState:UIControlStateNormal];
	UIView *backgroundView = MSHookIvar<UIView *>(self, "_borderView");
	backgroundView.layer.borderColor = ColorWithWhite(0.90).CGColor;
	backgroundView.backgroundColor = CellBackgroundColor;
	[self sendSubviewToBack:backgroundView];
}

- (void)setHighlighted:(BOOL)shouldHightlight
{
	if(shouldHightlight)
	{
		CABasicAnimation *basicAnimation = [self _basicAnimationWithKeyPath:@"backgroundColor"];
		UIView *backgroundView = MSHookIvar<UIView *>(self, "_borderView");
		[backgroundView.layer addAnimation:basicAnimation forKey:@"backgroundColor"];
	}
	else
	{
		%orig;
	}
}
%end