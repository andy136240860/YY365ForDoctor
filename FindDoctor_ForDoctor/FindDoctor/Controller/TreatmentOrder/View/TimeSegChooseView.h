//
//  TimeSegChooseView.h
//  FindDoctor
//
//  Created by 晓炜 郭 on 16/1/13.
//  Copyright © 2016年 li na. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "Clinic.h"
#import "YYTextView.h"

@interface TimeSegChooseView : UIView

- (instancetype)initWithFrame:(CGRect)frame;

@property (nonatomic, weak) Clinic *data;

@property (nonatomic, strong) YYTextView *startTimeTextView;
@property (nonatomic, strong) YYTextView *endTimeTextView;

@end