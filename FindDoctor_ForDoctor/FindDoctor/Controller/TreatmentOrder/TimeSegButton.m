//
//  TimeSegButton.m
//  FindDoctor
//
//  Created by Guo on 15/10/16.
//  Copyright © 2015年 li na. All rights reserved.
//

#import "TimeSegButton.h"

@implementation TimeSegButton

- (instancetype)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    if (self) {
        self.layer.borderWidth = 0.5;
        self.layer.borderColor = UIColorFromHex(0xa9a9a9).CGColor;
        self.layer.backgroundColor = [UIColor whiteColor].CGColor;
        [self setButtonState:Normal];
        self.layer.backgroundColor = [UIColor whiteColor].CGColor;
        [self addTarget:self action:@selector(clickAction) forControlEvents:UIControlEventTouchUpInside];
    }
    return self;
}

- (void)clickAction{
    switch (self.buttonState) {
        case -1:{
            NSLog(@"第%d个按钮不可使用",self.ID);
            break;
        }
        case 0:{
            self.layer.backgroundColor = UIColorFromHex(Color_Hex_NavBackground).CGColor;
            self.buttonState = HighLight;
            break;
        }
        case 1:{
            self.layer.backgroundColor = [UIColor whiteColor].CGColor;
            self.buttonState = Normal;
            break;
        }
        default:
            break;
    }
}

- (void)setState:(ButtonState)state{
    _buttonState = state;
    switch (self.buttonState) {
        case Forbidden:{
            self.layer.backgroundColor = UIColorFromHex(0xa9a9a9).CGColor;
            break;
        }
        case Normal:{
            self.layer.backgroundColor = [UIColor whiteColor].CGColor;
            break;
        }
        case HighLight:{
            self.layer.backgroundColor = UIColorFromHex(Color_Hex_NavBackground).CGColor;
            break;
        }
        default:
            break;
    }
}



@end
