//
//  YYTextView.h
//  FindDoctor
//
//  Created by 晓炜 郭 on 15/12/16.
//  Copyright © 2015年 li na. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void (^ClickBlock)(void);

@interface YYTextView : UIView

@property (nonatomic, strong) UILabel *title;
@property (nonatomic, strong) UITextField *contentTextField;

- (instancetype)initWithFrame:(CGRect)frame canEdit:(BOOL)canEdit;
- (void)setTitleText:(NSString *)titleText;

@property (nonatomic, copy)ClickBlock clickBlock;
@end
