//
//  TimeSegButtonsView.m
//  FindDoctor
//
//  Created by 晓炜 郭 on 15/12/15.
//  Copyright © 2015年 li na. All rights reserved.
//

#import "TimeSegButtonsView.h"
#import "TimeSegButton.h"
#import "NSDate+SNExtension.h"

@implementation TimeSegButtonsView{
    NSMutableArray *timeSegButtonArray;
}



- (instancetype)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    if (self) {
        [self initSubView];
    }
    return self;
}

- (void)initTitle{
    UILabel *title = [[UILabel alloc]initWithFrame:CGRectMake(0, 0, self.frame.size.width, 16)];
    title.text = @"预约时间";
    title.font = [UIFont systemFontOfSize:12];
    title.textColor = UIColorFromHex(0xa9a9a9);
    title.textAlignment = NSTextAlignmentLeft;
    [self addSubview:title];
}

- (void)initSubView{
    [self initTitle];
    int buttonViewPaddingY = 25;
    int intervalY = 55;
    
    UIView *view1 = [[UIView alloc]initWithFrame:CGRectMake(0, buttonViewPaddingY, [self frameWidth], 30)];
    view1.clipsToBounds = YES;
    view1.layer.cornerRadius = 3;
    view1.layer.borderColor = UIColorFromHex(0xa9a9a9).CGColor;
    view1.layer.borderWidth = 0.5;
    [self addSubview:view1];
    
    UIView *view2 = [[UIView alloc]initWithFrame:CGRectMake(0, buttonViewPaddingY + intervalY, [self frameWidth], 30)];
    view2.clipsToBounds = YES;
    view2.layer.cornerRadius = 3;
    view2.layer.borderColor = UIColorFromHex(0xa9a9a9).CGColor;
    view2.layer.borderWidth = 0.5;
    [self addSubview:view2];
    
    UIView *view3 = [[UIView alloc]initWithFrame:CGRectMake(0, buttonViewPaddingY + 2 * intervalY, [self frameWidth], 30)];
    view3.clipsToBounds = YES;
    view3.layer.cornerRadius = 3;
    view3.layer.borderColor = UIColorFromHex(0xa9a9a9).CGColor;
    view3.layer.borderWidth = 0.5;
    [self addSubview:view3];
    
    timeSegButtonArray = [NSMutableArray new];
    for (int i = 0; i < 15; i++) {
        if ( i < 6 ) {
            TimeSegButton *button = [[TimeSegButton alloc]initWithFrame:CGRectMake(( [self frameWidth] / 6 ) * i, 0, [self frameWidth]/6 + 0.5, 30)];
            button.ID = i;
            [view1 addSubview:button];
            [timeSegButtonArray addObject:button];
        }
        if ( i >= 6 && i < 12 ) {
            TimeSegButton *button = [[TimeSegButton alloc]initWithFrame:CGRectMake(( [self frameWidth] / 6 ) * (i-6), 0, [self frameWidth]/6 + 0.5, 30)];
            button.ID = i;
            [view2 addSubview:button];
            [timeSegButtonArray addObject:button];
        }
        if ( i >= 12 && i <15 ) {
            TimeSegButton *button = [[TimeSegButton alloc]initWithFrame:CGRectMake(( [self frameWidth] / 3 ) * (i-12), 0, [self frameWidth]/3 + 0.5, 30)];
            button.ID = i;
            [view3 addSubview:button];
            [timeSegButtonArray addObject:button];
        }
    }
    
    [self loadButtonTitle];
}

- (void)loadButtonTitle{
    for (int i = 0 ; i < 15 ; i++) {
        TimeSegButton *button = (TimeSegButton *)[timeSegButtonArray objectAtIndex:i];
        CGRect fream = button.frame;
        fream.origin.y += 50;
        if (button.ID >=6 && button.ID < 12) {
            fream.origin.y += 55;
        }
        if (button.ID >=12) {
            fream.origin.y += 110;
        }
        UILabel *title = [[UILabel alloc]initWithFrame:fream];
        title.font = [UIFont systemFontOfSize:11];
        title.textColor = UIColorFromHex(0xa9a9a9);
        [self addSubview:title];
        switch (button.ID) {
            case 0: {
                title.text = @"8:00";
                break;
            }
            case 1: {
                title.text = @"9:00";
                break;
            }
            case 2: {
                title.text = @"10:00";
                break;
            }
            case 3: {
                title.text = @"11:00";
                break;
            }
            case 4: {
                title.text = @"12:00";
                break;
            }
            case 5: {
                title.text = @"13:00";
                break;
            }
            case 6: {
                title.text = @"14:00";
                break;
            }
            case 7: {
                title.text = @"15:00";
                break;
            }
            case 8: {
                title.text = @"16:00";
                break;
            }
            case 9: {
                title.text = @"17:00";
                break;
            }
            case 10: {
                title.text = @"18:00";
                break;
            }
            case 11: {
                title.text = @"19:00";
                break;
            }
            case 12: {
                title.text = @"20:00";
                break;
            }
            case 13: {
                title.text = @"24:00";
                break;
            }
            case 14: {
                title.text = @"第二天4:00 - 8:00";
                break;
            }
        }
    }
}

- (void)setButtonsUsedWithString:(NSString *)string{
    NSArray *listItems = [string componentsSeparatedByString:@","];
    NSMutableArray *array = [NSMutableArray new];
    for (int i = 0; i < listItems.count; i++) {
        NSInteger  temp = [[listItems objectAtIndex:i] integerValue];
        temp -= 8;
        if (temp >= 0 && temp < 12) {
            temp = temp;
        }
        if (temp >= 12 && temp < 16) {
            temp = 12;
        }
        if (temp >= 16 && temp < 20) {
            temp = 13;
        }
        if (temp >= 20 && temp < 24) {
            temp = 14;
        }
        
        [array addObject:@(temp)];
    }
    listItems = [[NSSet setWithArray:array] allObjects];
    for (int i = 0; i < 15; i++) {
        TimeSegButton *button = [timeSegButtonArray objectAtIndex:i];
        for(int k = 0 ; k < listItems.count ; k++){
            NSInteger tempint = [[listItems objectAtIndex:k] integerValue];
            if ( i == tempint){
                [button setState:HighLight];
                break;
            }
        }
    }
}

- (void)setButtonsNotAvailableWithString:(NSString *)string{
    
}

- (void)setButtonsNotAvailableBecauseOfDateIsToday{
    NSDate *dateToday = [[NSDate date] dateAtStartOfDay];
    NSInteger hour = [[NSDate date] hoursAfterDate:dateToday];
    hour += 1;    //比如现在是下午3点半， 是hour为15， 应该是4点的号才能放
    if (hour <= 8) {
        return;
    }
    else {
        if (hour <= 20) {
            for (int i = 0; i < hour - 8; i++) {
                TimeSegButton *button = [timeSegButtonArray objectAtIndex:i];
                [button setState:Forbidden];
            }
        }
        else if (hour <= 24) {
            for (int i = 0; i < 13; i++) {
                TimeSegButton *button = [timeSegButtonArray objectAtIndex:i];
                [button setState:Forbidden];
            }
        }
    }
}

- (void)setButtonsAllAvailable{
    for (int i = 0; i < 15; i++) {
        TimeSegButton *button = [timeSegButtonArray objectAtIndex:i];
        if (button.buttonState == Forbidden) {
            [button setState:Normal];
        }
    }
}

- (NSString *)loadUsedButton{
    NSString *timeseg = @"";
    for (int i = 0; i < timeSegButtonArray.count; i++) {
        TimeSegButton *button = [timeSegButtonArray objectAtIndex:i];
        if (button.buttonState == HighLight) {
            if (i < 12){
                timeseg = [timeseg stringByAppendingFormat:@",%d",i+8];
            }
            if (i == 12) {
                timeseg = [timeseg stringByAppendingFormat:@",20,21,22,23"];
            }
            if (i == 13) {
                timeseg = [timeseg stringByAppendingFormat:@",24,25,26,27"];
            }
            if (i == 14) {
                timeseg = [timeseg stringByAppendingFormat:@",28,29,30,31"];
            }
        }
    }
    if (timeseg.length == 0) {
        return @"error";
    }
    return [timeseg substringFromIndex:1];
}

@end
