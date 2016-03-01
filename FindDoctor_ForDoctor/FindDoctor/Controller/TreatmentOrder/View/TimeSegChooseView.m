//
//  TimeSegChooseView.m
//  FindDoctor
//
//  Created by 晓炜 郭 on 16/1/13.
//  Copyright © 2016年 li na. All rights reserved.
//

#import "TimeSegChooseView.h"
#import "NSDate+SNExtension.h"

#import "CYAlertView.h"

@interface TimeSegChooseView(){
    UIView *devidingView;
    NSMutableArray *usedViewArray;
    NSMutableArray *usedLabelArray;
    
    CYAlertView *_alertview;
    UIView *_courseView;
    UIDatePicker *dayTimePicker;
}

@end

@implementation TimeSegChooseView
@synthesize startTimeTextView;
@synthesize endTimeTextView;

- (instancetype)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    if (self) {
        usedViewArray = [NSMutableArray new];
        usedLabelArray = [NSMutableArray new];
        [self initSubView];
    }
    return self;
}

- (void)initSubView{
    int intervalXForTitle = 5;
    int fontSizeForTitle = 12;
    
    int intervalY = 5;
    int fontSize = 12;
    
    UIView *squareUsed = [[UIView alloc]init];
    squareUsed.layer.backgroundColor = UIColorFromHex(0xa9a9a9).CGColor;
    squareUsed.layer.borderColor = UIColorFromHex(0xa9a9a9).CGColor;
    squareUsed.layer.borderWidth = 0.5f;
    [self addSubview:squareUsed];
    
    UILabel *usedTitleLable = [[UILabel alloc]init];
    usedTitleLable.text = @"不可用时间";
    usedTitleLable.font = [UIFont systemFontOfSize:fontSizeForTitle];
    usedTitleLable.textColor = UIColorFromHex(Color_Hex_Text_Normal);
    [self addSubview:usedTitleLable];
    
    CGSize usedTitleLableSize = [usedTitleLable.text sizeWithAttributes:@{NSFontAttributeName: [UIFont systemFontOfSize:fontSizeForTitle]}];
    
    UIView *squareAvailable = [[UIView alloc]init];
    squareAvailable.layer.backgroundColor = [UIColor whiteColor].CGColor;
    squareAvailable.layer.borderColor = UIColorFromHex(0xa9a9a9).CGColor;
    squareAvailable.layer.borderWidth = 0.5f;
    [self addSubview:squareAvailable];
    
    UILabel *availableTitleLable = [[UILabel alloc]init];
    availableTitleLable.text = @"可用时间";
    availableTitleLable.font = [UIFont systemFontOfSize:fontSizeForTitle];
    availableTitleLable.textColor = UIColorFromHex(Color_Hex_Text_Normal);
    [self addSubview:availableTitleLable];
    
    CGSize availableTitleLableSize = [availableTitleLable.text sizeWithAttributes:@{NSFontAttributeName: [UIFont systemFontOfSize:fontSizeForTitle]}];
    
    availableTitleLable.frame = CGRectMake([self frameWidth] - availableTitleLableSize.width, 0, availableTitleLableSize.width, availableTitleLableSize.height);
    squareAvailable.frame = CGRectMake(availableTitleLable.frameX - intervalXForTitle - fontSizeForTitle * 0.8f, fontSizeForTitle * 0.2f , fontSizeForTitle * 0.8f, fontSizeForTitle * 0.8f);
    usedTitleLable.frame = CGRectMake(squareAvailable.frameX - usedTitleLableSize.width - 2 * intervalXForTitle, 0, usedTitleLableSize.width, usedTitleLableSize.height);
    squareUsed.frame = CGRectMake(usedTitleLable.frameX - intervalXForTitle - fontSizeForTitle * 0.8f, fontSizeForTitle * 0.2f , fontSizeForTitle * 0.8f, fontSizeForTitle * 0.8f);
    
    [self initDevidingView];
    
    startTimeTextView = [[YYTextView alloc]initWithFrame:CGRectMake(0, CGRectGetMaxY(devidingView.frame) +  3*intervalY + (intervalY + fontSize)*_data.timeUesdArray.count, [self frameWidth], 40) canEdit:NO];
    [self addSubview:startTimeTextView];
    
    endTimeTextView = [[YYTextView alloc]initWithFrame:CGRectMake(0, CGRectGetMaxY(startTimeTextView.frame) + 15, [self frameWidth], 40) canEdit:NO];
    [endTimeTextView setTitleText:@"结束时间"];
}

- (void)initDevidingView{
    int devidingLineHeight = 7;
    int intervalY = 5;
    int fontSize = 12;
    
    devidingView = [[UIView alloc]initWithFrame:CGRectMake(0, 20 ,[self frameWidth], 20)];
    devidingView.layer.backgroundColor = [UIColor whiteColor].CGColor;
    devidingView.layer.cornerRadius = 3;
    devidingView.clipsToBounds = YES;
    devidingView.layer.borderColor = UIColorFromHex(0xa9a9a9).CGColor;
    devidingView.layer.borderWidth = 0.5;
    [self addSubview:devidingView];
    
    UIView *devidingline1 = [[UIView alloc]initWithFrame:CGRectMake(devidingView.frameWidth*0.25f, devidingView.frameHeight - devidingLineHeight, 0.5, devidingLineHeight)];
    devidingline1.layer.backgroundColor = [UIColor grayColor].CGColor;
    [devidingView addSubview:devidingline1];
    
    UIView *devidingline2 = [[UIView alloc]initWithFrame:CGRectMake(devidingView.frameWidth*0.5f, devidingView.frameHeight - devidingLineHeight, 0.5, devidingLineHeight)];
    devidingline2.layer.backgroundColor = [UIColor grayColor].CGColor;
    [devidingView addSubview:devidingline2];
    
    UIView *devidingline3 = [[UIView alloc]initWithFrame:CGRectMake(devidingView.frameWidth*0.75f, devidingView.frameHeight - devidingLineHeight, 0.5, devidingLineHeight)];
    devidingline3.layer.backgroundColor = [UIColor grayColor].CGColor;
    [devidingView addSubview:devidingline3];
    
    UILabel *timeMarkLabel1 = [[UILabel alloc]initWithFrame:CGRectMake(devidingView.frameWidth*0.f, CGRectGetMaxY(devidingView.frame)+intervalY, 100, fontSize)];
    timeMarkLabel1.text = @"0:00";
    timeMarkLabel1.font = [UIFont systemFontOfSize:fontSize];
    timeMarkLabel1.textColor = UIColorFromHex(Color_Hex_Text_Normal);
    [self addSubview:timeMarkLabel1];
    
    UILabel *timeMarkLabel2 = [[UILabel alloc]initWithFrame:CGRectMake(devidingView.frameWidth*0.25f-50, CGRectGetMaxY(devidingView.frame)+intervalY, 100, fontSize)];
    timeMarkLabel2.text = @"6:00";
    timeMarkLabel2.font = [UIFont systemFontOfSize:fontSize];
    timeMarkLabel2.textColor = UIColorFromHex(Color_Hex_Text_Normal);
    timeMarkLabel2.textAlignment = NSTextAlignmentCenter;
    [self addSubview:timeMarkLabel2];
    
    UILabel *timeMarkLabel3 = [[UILabel alloc]initWithFrame:CGRectMake(devidingView.frameWidth*0.5f-50, CGRectGetMaxY(devidingView.frame)+intervalY, 100, fontSize)];
    timeMarkLabel3.text = @"12:00";
    timeMarkLabel3.font = [UIFont systemFontOfSize:fontSize];
    timeMarkLabel3.textColor = UIColorFromHex(Color_Hex_Text_Normal);
    timeMarkLabel3.textAlignment = NSTextAlignmentCenter;
    [self addSubview:timeMarkLabel3];
    
    UILabel *timeMarkLabel4 = [[UILabel alloc]initWithFrame:CGRectMake(devidingView.frameWidth*0.75f-50, CGRectGetMaxY(devidingView.frame)+intervalY, 100, fontSize)];
    timeMarkLabel4.text = @"18:00";
    timeMarkLabel4.font = [UIFont systemFontOfSize:fontSize];
    timeMarkLabel4.textColor = UIColorFromHex(Color_Hex_Text_Normal);
    timeMarkLabel4.textAlignment = NSTextAlignmentCenter;
    [self addSubview:timeMarkLabel4];
    
    UILabel *timeMarkLabel5 = [[UILabel alloc]initWithFrame:CGRectMake(0, CGRectGetMaxY(devidingView.frame)+intervalY, devidingView.frameWidth, fontSize)];
    timeMarkLabel5.text = @"24:00";
    timeMarkLabel5.font = [UIFont systemFontOfSize:fontSize];
    timeMarkLabel5.textColor = UIColorFromHex(Color_Hex_Text_Normal);
    timeMarkLabel5.textAlignment = NSTextAlignmentRight;
    [self addSubview:timeMarkLabel5];
}

- (void)emptyViewArray:(NSMutableArray *)array{
    for (int i = 0; i<array.count; i++) {
        UIView *item = [array objectAtIndex:i];
        [item removeFromSuperview];
        item = nil;
    }
}

- (void)emptyLabelArray:(NSMutableArray *)array{
    for (int i = 0; i<array.count; i++) {
        UILabel *item = [array objectAtIndex:i];
        [item removeFromSuperview];
        item = nil;
    }
}

- (void)setData:(Clinic *)data{
    _data = data;
    if( _data.timeUesdArray.count){
        TimeUesd *timeUsedMark = _data.timeUesdArray[_data.timeUesdArray.count - 1];
        if ([self timeIntervalSinceStartOfDayWithTimeInterval:timeUsedMark.startTime] == 0) {
            for (int i = 0; i < _data.timeUesdArray.count - 1; i++) {
                TimeUesd *timeUsed = _data.timeUesdArray[i];
                if (timeUsed.endTime < timeUsedMark.endTime ) {
                    [_data.timeUesdArray removeObject:timeUsed];
                    i--;
                    continue;
                }
                if (timeUsed.startTime < timeUsedMark.endTime && timeUsed.endTime > timeUsedMark.endTime ) {
                    timeUsed.startTime = timeUsedMark.startTime;
                    [_data.timeUesdArray removeObject:timeUsedMark];
                }
            }
        }
    }
    

    
    int intervalY = 10;
    int fontSize = 12;
    
    [self emptyViewArray:usedViewArray];
    [self emptyLabelArray:usedLabelArray];//为了再次加载新的数据重新刷新一遍界面为空值
    for (int i = 0; i < _data.timeUesdArray.count; i++) {
        TimeUesd *timeUsed = _data.timeUesdArray[i];
        double X1 = ([self timeIntervalSinceStartOfDayWithTimeInterval:timeUsed.startTime])/3600/24;
        double X2 = ([self timeIntervalSinceStartOfDayWithTimeInterval:timeUsed.endTime])/3600/24;
        UIView *view = [[UIView alloc]initWithFrame:CGRectMake(X1*[devidingView frameWidth], 0, (X2 - X1)*[devidingView frameWidth], [devidingView frameHeight])];
        view.layer.backgroundColor = UIColorFromHex(0xa9a9a9).CGColor;
        [devidingView addSubview:view];
        [usedViewArray addObject:view];
        
        UILabel *lable = [[UILabel alloc]initWithFrame:CGRectMake(0, CGRectGetMaxY(devidingView.frame) + 3*intervalY + (intervalY + fontSize)*i, [self frameWidth], fontSize)];
        lable.text = [NSString stringWithFormat:@"%@ - %@  诊疗室满不可用",[[NSDate dateWithTimeIntervalSince1970:timeUsed.startTime] stringWithDateFormat:@"HH:mm"],[[NSDate dateWithTimeIntervalSince1970:timeUsed.endTime] stringWithDateFormat:@"HH:mm"]];
        [self addSubview:lable];
        lable.textColor = UIColorFromHex(Color_Hex_Text_Readed);
        lable.font = [UIFont systemFontOfSize:fontSize];
        lable.textAlignment = NSTextAlignmentRight;
        [usedLabelArray addObject:lable];
    }
    
//    startTimeTextView = [[YYTextView alloc]initWithFrame:CGRectMake(0, CGRectGetMaxY(devidingView.frame) +  3*intervalY + (intervalY + fontSize)*_data.timeUesdArray.count, [self frameWidth], 40) canEdit:NO];
//    [startTimeTextView setTitleText:@"起始时间"];
//    __weak __block TimeSegChooseView  *blockSelf = self;
//    startTimeTextView.clickBlock = ^{
//        [blockSelf showCourseView1];
//    };
//    [self addSubview:startTimeTextView];
//    
//    endTimeTextView = [[YYTextView alloc]initWithFrame:CGRectMake(0, CGRectGetMaxY(startTimeTextView.frame) + 15, [self frameWidth], 40) canEdit:NO];
//    [endTimeTextView setTitleText:@"结束时间"];
//    endTimeTextView.clickBlock = ^{
//        [blockSelf showCourseView2];
//    };
//    [self addSubview:endTimeTextView];
    
    startTimeTextView.frame = CGRectMake(0, CGRectGetMaxY(devidingView.frame) +  3*intervalY + (intervalY + fontSize)*_data.timeUesdArray.count, [self frameWidth], 40);
    [startTimeTextView setTitleText:@"起始时间"];
    __weak __block TimeSegChooseView  *blockSelf = self;
    startTimeTextView.clickBlock = ^{
        [blockSelf showCourseView1];
    };
    [self addSubview:startTimeTextView];
    
    endTimeTextView.frame = CGRectMake(0, CGRectGetMaxY(startTimeTextView.frame) + 15, [self frameWidth], 40);
    [endTimeTextView setTitleText:@"结束时间"];
    endTimeTextView.clickBlock = ^{
        [blockSelf showCourseView2];
    };
    [self addSubview:endTimeTextView];
    
    self.frame = CGRectMake(self.frameX, self.frameY,self.frameWidth, CGRectGetMaxY(endTimeTextView.frame));
}

- (void)showCourseView1
{
    if (_alertview == nil) {
        _alertview = [[CYAlertView alloc] init];
    }
    
    _alertview.backgroundColor = [UIColor colorWithWhite:0 alpha:0.4f];
    
    _courseView = [[UIView alloc] initWithFrame:(CGRect){0,0,300*kScreenRatio,250}];
    dayTimePicker = [[UIDatePicker alloc]initWithFrame:(CGRect){0,0,300*kScreenRatio,216}];
    dayTimePicker.backgroundColor = [UIColor whiteColor];
    dayTimePicker.datePickerMode = UIDatePickerModeDate;
    [dayTimePicker setMinuteInterval:10];
    [dayTimePicker setCalendar:[NSCalendar currentCalendar]];
    [dayTimePicker setTimeZone:[NSTimeZone defaultTimeZone]];
    
    [dayTimePicker setDate:[NSDate date]];
    [dayTimePicker setDatePickerMode:UIDatePickerModeTime];
    if(![endTimeTextView.contentTextField.text isEmpty]){
        NSTimeInterval time = [[[NSDate date] dateAtStartOfDay] timeIntervalSince1970];
        NSInteger hour = [[endTimeTextView.contentTextField.text substringWithRange:NSMakeRange(0, 2)] integerValue];
        NSInteger min = [[endTimeTextView.contentTextField.text substringWithRange:NSMakeRange(3, 2)] integerValue];
        time += (hour*3600 + min*60);
        NSDate *date = [NSDate dateWithTimeIntervalSince1970:time];
        [dayTimePicker setMaximumDate:date];
    }
    [dayTimePicker setMinimumDate:nil];
    [_courseView addSubview:dayTimePicker];
    
    UIButton *surebutton = [UIButton buttonWithType:UIButtonTypeCustom];
    surebutton.frame = (CGRect){0,216,300*kScreenRatio,34};
    [surebutton setTitle:@"确定" forState:UIControlStateNormal];
    [surebutton setTitleColor:kDarkGrayColor forState:UIControlStateNormal];
    [surebutton addTarget:self action:@selector(sureAction1) forControlEvents:UIControlEventTouchUpInside];
    [_courseView addSubview:surebutton];
    
    _alertview.contentView = _courseView;
    _alertview.isHaveAnimation = YES;
    [_alertview show];
}

- (void)sureAction1
{
    if([self isusedWithCurrentTime:[dayTimePicker.date timeIntervalSince1970]]){
        startTimeTextView.contentTextField.text = [[NSDate dateWithTimeIntervalSince1970:[self fitTimeWithCurrentTime:[dayTimePicker.date timeIntervalSince1970]]+16*3600] stringWithDateFormat:@"HH:mm"];
    }else{
        startTimeTextView.contentTextField.text = [dayTimePicker.date stringWithDateFormat:@"HH:mm"];
    }
    [_alertview hidden];
}

- (void)showCourseView2
{
    if (_alertview == nil) {
        _alertview = [[CYAlertView alloc] init];
    }
    
    _alertview.backgroundColor = [UIColor colorWithWhite:0 alpha:0.4f];
    
    _courseView = [[UIView alloc] initWithFrame:(CGRect){0,0,300*kScreenRatio,250}];
    dayTimePicker = [[UIDatePicker alloc]initWithFrame:(CGRect){0,0,300*kScreenRatio,216}];
    dayTimePicker.backgroundColor = [UIColor whiteColor];
    dayTimePicker.datePickerMode = UIDatePickerModeDate;
    dayTimePicker.minuteInterval = 10;
    [dayTimePicker setCalendar:[NSCalendar currentCalendar]];
    [dayTimePicker setTimeZone:[NSTimeZone defaultTimeZone]];
    
    [dayTimePicker setDate:[NSDate date]];
    [dayTimePicker setDatePickerMode:UIDatePickerModeTime];
    if(![startTimeTextView.contentTextField.text isEmpty]){
        NSTimeInterval time = [[[NSDate date] dateAtStartOfDay] timeIntervalSince1970];
        NSInteger hour = [[startTimeTextView.contentTextField.text substringWithRange:NSMakeRange(0, 2)] integerValue];
        NSInteger min = [[startTimeTextView.contentTextField.text substringWithRange:NSMakeRange(3, 2)] integerValue];
        time += (hour*3600 + min*60);
        NSDate *date = [NSDate dateWithTimeIntervalSince1970:time];
        [dayTimePicker setMinimumDate:date];
    }
    [dayTimePicker setMaximumDate:nil];
    
    [_courseView addSubview:dayTimePicker];
    
    UIButton *surebutton = [UIButton buttonWithType:UIButtonTypeCustom];
    surebutton.frame = (CGRect){0,216,300*kScreenRatio,34};
    [surebutton setTitle:@"确定" forState:UIControlStateNormal];
    [surebutton setTitleColor:kDarkGrayColor forState:UIControlStateNormal];
    [surebutton addTarget:self action:@selector(sureAction2) forControlEvents:UIControlEventTouchUpInside];
    [_courseView addSubview:surebutton];
    
    _alertview.contentView = _courseView;
    _alertview.isHaveAnimation = YES;
    [_alertview show];
}

- (void)sureAction2
{
    if([self isusedWithCurrentTime:[dayTimePicker.date timeIntervalSince1970]]){
        endTimeTextView.contentTextField.text = [[NSDate dateWithTimeIntervalSince1970:[self fitTimeWithCurrentTime:[dayTimePicker.date timeIntervalSince1970]]+16*3600] stringWithDateFormat:@"HH:mm"];
    }else{
        endTimeTextView.contentTextField.text = [dayTimePicker.date stringWithDateFormat:@"HH:mm"];
    }
    [_alertview hidden];
}

- (BOOL)isusedWithCurrentTime:(NSTimeInterval)currentTime{
    for (int i = 0 ; i < _data.timeUesdArray.count; i++) {
        NSTimeInterval startTime = [self timeIntervalSinceStartOfDayWithTimeInterval:[[_data.timeUesdArray objectAtIndex:i] startTime]];
        NSTimeInterval endTime = [self timeIntervalSinceStartOfDayWithTimeInterval:[[_data.timeUesdArray objectAtIndex:i] endTime]];
        currentTime = [self timeIntervalSinceStartOfDayWithTimeInterval:currentTime];
        if (currentTime - startTime > 0 && endTime - currentTime > 0) {
            return YES;
        }
    }
    return NO;
}

- (NSTimeInterval)fitTimeWithCurrentTime:(NSTimeInterval)currentTime{
    for (int i = 0 ; i < _data.timeUesdArray.count; i++) {
        NSTimeInterval startTime = [self timeIntervalSinceStartOfDayWithTimeInterval:[[_data.timeUesdArray objectAtIndex:i] startTime]];
        NSTimeInterval endTime = [self timeIntervalSinceStartOfDayWithTimeInterval:[[_data.timeUesdArray objectAtIndex:i] endTime]];
        currentTime = [self timeIntervalSinceStartOfDayWithTimeInterval:currentTime];
        if (currentTime - startTime > 0 && endTime - currentTime > 0) {
            if (currentTime - startTime > endTime - currentTime) {
                return endTime;
            }
            else{
                return startTime;
            }
        }
    }
    return NO;
}

- (NSTimeInterval)timeIntervalSinceStartOfDayWithTimeInterval:(NSTimeInterval)time{
    time = time - [[[NSDate dateWithTimeIntervalSince1970:time] dateAtStartOfDay] timeIntervalSince1970];
    return time;
}

@end
