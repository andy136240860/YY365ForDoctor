//
//  massageTextFieldView.m
//  FindDoctor
//
//  Created by Guo on 15/9/11.
//  Copyright (c) 2015年 li na. All rights reserved.
//

#import "massageTextFieldView.h"

@implementation massageTextFieldView

- (instancetype)initTextFieldWithPointY:(CGFloat)y Title:(NSString *)lableTitle {
    self = [super init];
    if (self) {
        
        self.frame = CGRectMake((kScreenWidth-242)/2, y, 242, 67/2.0);
        _textFieldBackgroundImageView = [[UIImageView alloc]init];
        _textFieldBackgroundImageView.frame = CGRectMake(0, 0, 242, 67/2.0);
        _textFieldBackgroundImageView.image = [UIImage imageNamed:@"textFieldBackground"];
        [self addSubview:_textFieldBackgroundImageView];
        
        _textFieldLabel = [[UILabel alloc]initWithFrame:CGRectMake(0, 0, 65, 67/2.0)];
        _textFieldLabel.text = lableTitle;
        _textFieldLabel.textAlignment = UITextAlignmentCenter;
        _textFieldLabel.font = [UIFont systemFontOfSize:14];
        _textFieldLabel.textColor = UIColorFromHex(0x999999);
        
        _textField = [[UITextField alloc]initWithFrame:CGRectMake(78, 0, 151, 67/2.0)];
        _textField.font = [UIFont systemFontOfSize:14];
        _textField.textColor = UIColorFromHex(0x999999);
        _textField.textAlignment = UITextAlignmentLeft;
        _textField.placeholder = @"我爱中医"; //默认文字
        _textField.clearButtonMode = UITextFieldViewModeWhileEditing; //编辑时会出现个修改X
        _textField.delegate = self;
        
        
        [self addSubview:_textFieldLabel];
        [self addSubview:_textField];
            }
    return self;
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [textField resignFirstResponder]; return YES;
    
}

-(void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    [self resignFirstResponder];
}
@end
