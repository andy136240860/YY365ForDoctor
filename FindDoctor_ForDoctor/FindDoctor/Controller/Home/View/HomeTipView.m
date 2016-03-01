//
//  HomeTipView.m
//  FindDoctor
//
//  Created by chai on 15/9/16.
//  Copyright (c) 2015年 li na. All rights reserved.
//

#import "HomeTipView.h"

@interface HomeTipView ()
{
    UIImageView *_footerLineView;
    UILabel *_contentLabel;
}
@end

@implementation HomeTipView

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self createSubViews];
    }
    return self;
}

- (void)createSubViews
{
    
    _footerLineView = [[UIImageView alloc] init];
    [self addSubview:_footerLineView];
    
    _contentLabel = [[UILabel alloc] init];
    _contentLabel.font = SystemFont_14;
    _contentLabel.textColor = [UIColor whiteColor];
    [self addSubview:_contentLabel];
}

- (void)setContentTitle:(NSString *)title
{
    UIImage *homeTipViewIntervalImage = [UIImage imageNamed:@"HomeTipViewInterval"];
    
    float margin_left = (kScreenWidth-homeTipViewIntervalImage.size.width)/2.f;
    float interval_x = 30;
    float sign_width = 30.f;
//    _signView.frame = (CGRect){margin_left,0,sign_width,sign_width};
//    _signView.image = [UIImage imageNamed:@"home_tip_sign"];
    

    _footerLineView.frame = (CGRect){margin_left,30,homeTipViewIntervalImage.size.width,homeTipViewIntervalImage.size.height};
    _footerLineView.image = homeTipViewIntervalImage;
    
    _contentLabel.frame = (CGRect){margin_left+interval_x,0,_footerLineView.frame.size.width,sign_width};
    _contentLabel.text = title;
}

@end
