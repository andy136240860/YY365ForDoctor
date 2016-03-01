//
//  FindDoctorButtonView.m
//  FindDoctor
//
//  Created by 晓炜 郭 on 15/12/10.
//  Copyright © 2015年 li na. All rights reserved.
//

#import "TreatmentOrderButtonView.h"

@interface TreatmentOrderButtonView(){
    CGRect _frame;
}

@end

@implementation TreatmentOrderButtonView

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        _frame = frame;
        _frame.origin.x = 0;
        _frame.origin.y = 0;
        [self initSubView];
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(clickBlockAction)];
        tap.numberOfTapsRequired = 1;
        [self addGestureRecognizer:tap];
    }
    return self;
}

- (void)initSubView{
    CALayer *imageLayer = [CALayer layer];
    imageLayer.frame = _frame;
    imageLayer.contents = (id)[UIImage imageNamed:@"button_release_num"].CGImage;
    [self.layer addSublayer:imageLayer];
}

- (void)clickBlockAction{
    _clickButtonBlock();
}

@end
