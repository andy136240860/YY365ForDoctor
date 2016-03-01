//
//  massageTextFieldView.h
//  FindDoctor
//
//  Created by Guo on 15/9/11.
//  Copyright (c) 2015年 li na. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface massageTextFieldView : UIView<UITextFieldDelegate, UITextViewDelegate>

@property (strong,nonatomic) UIImageView *textFieldBackgroundImageView;
@property (strong,nonatomic) UILabel *textFieldLabel;
@property (strong,nonatomic) UITextField *textField;

- (instancetype)initTextFieldWithPointY:(CGFloat)y Title:(NSString *)lableTitle;

@end
