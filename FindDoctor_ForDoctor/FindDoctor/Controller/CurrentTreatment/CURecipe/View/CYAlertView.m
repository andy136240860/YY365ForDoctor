//
//  CYAlertView.m
//  CYBaseProject
//
//  Created by chai on 15-6-7.
//  Copyright (c) 2015年 chai. All rights reserved.
//

#import "CYAlertView.h"

@interface CYAlertView ()
{
    
}


@end

#define kAnimationDuration 0.4f

@implementation CYAlertView

- (instancetype)init
{
    self = [super init];
    if (self) {
        self.frame = [UIScreen mainScreen].bounds;
        UITapGestureRecognizer *tapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapGestureAction:)];
        tapGesture.numberOfTapsRequired = 1;
        tapGesture.numberOfTouchesRequired = 1;
        tapGesture.cancelsTouchesInView = NO;
        [self addGestureRecognizer:tapGesture];
    }
    return self;
}

- (void)tapGestureAction:(UITapGestureRecognizer *)tapGesture
{
    CGPoint location = [tapGesture locationInView:_contentView];
    if (location.x>0 && location.y>0 && location.x<_contentView.bounds.size.width && location.y<_contentView.bounds.size.height) {
        return;
    }
    [self hidden];
}

- (void)registerNotification
{
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardChanged:) name:UIKeyboardWillChangeFrameNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardShow:) name:UIKeyboardWillShowNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardHidden:) name:UIKeyboardWillHideNotification object:nil];
}

- (void)resignNotificaiton
{
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UIKeyboardWillShowNotification object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UIKeyboardWillHideNotification object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UIKeyboardWillChangeFrameNotification object:nil];
}

- (void)keyboardShow:(NSNotification *)notification
{
    NSDictionary *userInfo = [notification userInfo];
    NSValue *aValue = [userInfo objectForKey:UIKeyboardFrameEndUserInfoKey];
    CGRect keyboardRect = [aValue CGRectValue];
    int height = keyboardRect.size.height;
    CGSize size = [UIApplication sharedApplication].keyWindow.frame.size;
    _contentView.center = CGPointMake(size.width/2.0, (size.height-height)/2.0);
}

- (void)keyboardChanged:(NSNotification *)notification
{
    NSDictionary *userInfo = [notification userInfo];
    NSValue *aValue = [userInfo objectForKey:UIKeyboardFrameEndUserInfoKey];
    CGRect keyboardRect = [aValue CGRectValue];
    int height = keyboardRect.size.height;
    CGSize size = [UIApplication sharedApplication].keyWindow.frame.size;
    _contentView.center = CGPointMake(size.width/2.0, (size.height-height)/2.0);
}

- (void)keyboardHidden:(NSNotification *)notification
{
    NSDictionary *userInfo = [notification userInfo];
    NSValue *aValue = [userInfo objectForKey:UIKeyboardFrameEndUserInfoKey];
    CGRect keyboardRect = [aValue CGRectValue];
    int height = keyboardRect.size.height;
    CGSize size = [UIApplication sharedApplication].keyWindow.frame.size;
    _contentView.center = CGPointMake(size.width/2.0, (size.height-height)/2.0);
}

- (void)setContentView:(UIView *)contentView
{
    _contentView = contentView;
    _contentView.layer.cornerRadius = 6.0f;
    _contentView.layer.borderColor = [UIColor colorWithWhite:0.9 alpha:0.9].CGColor;
    _contentView.layer.borderWidth = 1.0f;
    _contentView.center = self.center;
    _contentView.backgroundColor = [UIColor whiteColor];
    if ([self.subviews containsObject:_contentView]) {
        [_contentView removeFromSuperview];
    }
    [self addSubview:_contentView];
}

- (void)show
{
    [self resignNotificaiton];
    [self registerNotification];
    
    [[UIApplication sharedApplication].keyWindow addSubview:self];
    
    if (_isHaveAnimation) {
        CAKeyframeAnimation *popAnimation = [CAKeyframeAnimation animationWithKeyPath:@"transform"];
        popAnimation.duration = kAnimationDuration;
        popAnimation.values = @[[NSValue valueWithCATransform3D:CATransform3DMakeScale(0.01f, 0.01f, 1.0f)],
                                [NSValue valueWithCATransform3D:CATransform3DMakeScale(1.05f, 1.05f, 1.0f)],
                                [NSValue valueWithCATransform3D:CATransform3DMakeScale(0.9f, 0.9f, 1.0f)],
                                [NSValue valueWithCATransform3D:CATransform3DIdentity]];
        popAnimation.keyTimes = @[@0.2f, @0.5f, @0.75f, @1.0f];
        popAnimation.timingFunctions = @[[CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut],
                                         [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut],
                                         [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut]];
        [_contentView.layer addAnimation:popAnimation forKey:nil];
        
        self.alpha = 0;
        
        [UIView animateWithDuration:kAnimationDuration
                         animations:^{
                             self.alpha = 1;
                         }
                         completion:^(BOOL finished) {
                             
                         }];
    }
}

- (void)hidden
{
    [self resignNotificaiton];
    
    if (_isHaveAnimation) {
        CAKeyframeAnimation *hideAnimation = [CAKeyframeAnimation animationWithKeyPath:@"transform"];
        hideAnimation.duration = kAnimationDuration;
        hideAnimation.values = @[[NSValue valueWithCATransform3D:CATransform3DMakeScale(1.05f, 1.05f, 1.0f)],
                                 [NSValue valueWithCATransform3D:CATransform3DMakeScale(1.0f, 1.0f, 1.0f)],
                                 [NSValue valueWithCATransform3D:CATransform3DMakeScale(0.00f, 0.00f, 0.00f)]];
        hideAnimation.keyTimes = @[@0.2f, @0.5f, @0.75f];
        hideAnimation.timingFunctions = @[[CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut],
                                          [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut],
                                          [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut]];
        hideAnimation.delegate = self;
        [self.layer addAnimation:hideAnimation forKey:nil];

        self.alpha = 1;
        
        [UIView animateWithDuration:kAnimationDuration
                         animations:^{
                             self.alpha = 0;
                         }
                         completion:^(BOOL finished) {
                             [_contentView removeFromSuperview];
                             [self removeFromSuperview];
                         }];
        return;

    }
    
    [_contentView removeFromSuperview];
    [self removeFromSuperview];

    
    
    
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
