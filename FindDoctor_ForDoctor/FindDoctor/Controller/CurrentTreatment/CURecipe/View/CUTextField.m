//
//  CUTextField.m
//  FindDoctor
//
//  Created by chai on 15/11/28.
//  Copyright © 2015年 li na. All rights reserved.
//

#import "CUTextField.h"

@interface CUTextField ()
{
    UIView *_leftView;
    UILabel *_titleLabel;
    
    UIImageView *_rightView;
}
@end

@implementation CUTextField

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.layer.masksToBounds = YES;
        self.layer.cornerRadius = 4.f;
        self.layer.borderColor = UIColorFromRGB(224, 224, 224).CGColor;
        self.layer.borderWidth = 1.f;
        
        self.textAlignment = NSTextAlignmentRight;
    }
    return self;
}

- (void)setCanEdit:(BOOL)canEdit
{
    _canEdit = canEdit;
    
    if (_canEdit) {
        
        UIView *view = [[UIView alloc] initWithFrame:(CGRect){0,0,10,self.frame.size.height}];
        
        self.rightView = view;
        self.rightViewMode = UITextFieldViewModeAlways;
        
        return;
    }
    
    if (_rightView==nil) {
        _rightView = [[UIImageView alloc] init];
    }
    _rightView.contentMode = UIViewContentModeScaleAspectFit;
    _rightView.frame = (CGRect){0,0,self.frame.size.height,self.frame.size.height};
    _rightView.image = [UIImage imageNamed:@"show_for_choose_sign"];
    self.rightView = _rightView;
    self.rightViewMode = UITextFieldViewModeAlways;
}

- (void)setFieldTitle:(NSString *)fieldTitle
{
    _fieldTitle = fieldTitle;
    
    if (_fieldTitle==nil) {
        self.leftView = nil;
        return;
    }
    
    if (_leftView == nil) {
        _leftView = [[UIView alloc] init];
        _titleLabel = [[UILabel alloc] init];
        [_leftView addSubview:_titleLabel];
    }
    
    float padding_left = 10.f;
    
    NSString *showText = [NSString stringWithFormat:@"%@  |",fieldTitle];
    
    CGSize titleSize = [self titleSize:showText];
    
    _leftView.frame = (CGRect){0,0,padding_left*2+titleSize.width,self.frame.size.height};
    
    _titleLabel.frame = (CGRect){padding_left,0,titleSize.width,self.frame.size.height};
    _titleLabel.text = showText;
    _titleLabel.textColor = kLightGrayColor;
    _titleLabel.font = self.font;
    
    self.leftView = _leftView;
    self.leftViewMode = UITextFieldViewModeAlways;
}

- (CGSize)titleSize:(NSString *)title
{
    NSMutableParagraphStyle *paragraph = [[NSMutableParagraphStyle alloc] init];
    paragraph.lineBreakMode = NSLineBreakByWordWrapping;
    
    CGSize titleSize = [title boundingRectWithSize:CGSizeMake(MAXFLOAT, self.font.lineHeight)
                                           options:NSStringDrawingUsesLineFragmentOrigin
                                        attributes:@{NSFontAttributeName:self.font,NSParagraphStyleAttributeName:paragraph}
                                           context:nil].size;
    return titleSize;
}

@end
