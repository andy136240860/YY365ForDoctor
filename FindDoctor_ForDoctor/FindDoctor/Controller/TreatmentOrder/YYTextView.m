//
//  YYTextFieldView.m
//  FindDoctor
//
//  Created by 晓炜 郭 on 15/12/16.
//  Copyright © 2015年 li na. All rights reserved.
//

#import "YYTextView.h"

@implementation YYTextView

int textFontSize = 14;

- (instancetype)initWithFrame:(CGRect)frame canEdit:(BOOL)canEdit{
    self = [super initWithFrame:frame];
    if (self) {
        [self initBackground];
        [self addTap];
        [self initContentTextField];
        self.contentTextField.userInteractionEnabled = canEdit;
    }
    return self;
}

-(void)initBackground{
    self.layer.backgroundColor = [UIColor whiteColor].CGColor;
    self.layer.borderColor = UIColorFromHex(0xa9a9a9).CGColor;
    self.layer.borderWidth = 0.5f;
    self.clipsToBounds = YES;
    self.layer.cornerRadius = 3.f;

    _title = [[UILabel alloc]initWithFrame:CGRectMake(7, ([self frameHeight]-textFontSize) * 0.5 , 70, textFontSize)];
    _title.font = [UIFont systemFontOfSize:textFontSize];
    _title.textColor = UIColorFromHex(0xa9a9a9);
    _title.textAlignment = NSTextAlignmentNatural;
//    _title.backgroundColor = [UIColor yellowColor];
    [self addSubview:_title];
}


- (void)initContentTextField{
    _contentTextField = [[UITextField alloc]initWithFrame:CGRectMake(CGRectGetMaxX(_title.frame) + 14, ([self frameHeight]-textFontSize) * 0.5 , [self frameWidth] - CGRectGetMaxX(_title.frame) - 21, textFontSize)];
    _contentTextField.font = [UIFont systemFontOfSize:textFontSize];
    _contentTextField.textColor = [UIColor blackColor];
    _contentTextField.textAlignment = NSTextAlignmentRight;
    _contentTextField.returnKeyType = UIReturnKeyDone;
    [self addSubview:_contentTextField];
}

- (void)setTitleText:(NSString *)titleText{
    _title.text = [NSString stringWithFormat:@"%@",titleText];
}

- (void)addTap{
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(clickBlockAction)];
    [self addGestureRecognizer:tap];
}

- (void)clickBlockAction{
    if (_clickBlock) {
        _clickBlock();
    }
}

@end
