//
//  OfferOrderViewController2.m
//  FindDoctor
//
//  Created by 晓炜 郭 on 15/12/15.
//  Copyright © 2015年 li na. All rights reserved.
//

#import "OfferOrderViewController2.h"
#import "TimeSegButtonsView.h"
#import "SZCalendarPicker.h"
#import "YYTextView.h"
#import "NSDate+SNExtension.h"
#import "Clinic.h"
#import "TreatmentOrderManager.h"
#import "CYAlertView.h"
#import "TipHandler.h"
#import "TimeSegChooseView.h"
#import "MBProgressHUD.h"

@interface OfferOrderViewController2 ()<UITextFieldDelegate, UIPickerViewDataSource, UIPickerViewDelegate,MBProgressHUDDelegate,UIAlertViewDelegate>{
    UIScrollView *contentScrollView;
    
    YYTextView *calendarTextView;
    SZCalendarPicker *calendarPicker;
    TimeSegButtonsView *timeSegButtonsView;
    TimeSegChooseView *timeSegChooseView;
    YYTextView *clinicTexView;
    YYTextView *numberTexView;
    YYTextView *feeTexView;

    NSMutableArray *clinicArray;
    UIPickerView *clinicPicker;
    
    CYAlertView *_alertview;
    UIView *_courseView;
    
    BOOL modify;
    long long orderNo;
    MBProgressHUD   *_hud;
}

@property (nonatomic, strong) YYTextView *calendarTextView;

@end

@implementation OfferOrderViewController2
@synthesize calendarTextView;



- (void)viewWillAppear:(BOOL)animated{
    [self showProgressView];
    
    __weak __block OfferOrderViewController2 *blockSelf = self;
    [[TreatmentOrderManager sharedInstance] FangHaoForGetClinicWithResultBlock:^(SNHTTPRequestOperation *request, SNServerAPIResultData *result) {
        [blockSelf hideProgressView];
        if (!result.hasError) {
            clinicArray = result.parsedModelObject;
            if (clinicArray.count) {
                clinicTexView.contentTextField.text = [clinicArray[0] name];
            }
            else{
                UIAlertView *alert = [[UIAlertView alloc] initWithTitle:nil message:@"当前城市无诊疗点可用" delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
                alert.tag = 100;
                [alert show];
            }
        }
    } pageName:@"OfferOrderViewController2"];
    
    if (self.data == nil) {
        self.data = [[TreatmentOrder alloc]init];
        _data.orderno = 0;
        orderNo = 0;
        NSDate *date = [[NSDate date] dateByAddingDays:1];
        calendarTextView.contentTextField.text = [date stringWithDateFormat:@"yyyy-MM-dd"];

    }
    else {
        orderNo = _data.orderno;
        calendarTextView.contentTextField.text = [[NSDate dateWithTimeIntervalSince1970:_data.timestamp] stringWithDateFormat:@"yyyy-MM-dd"];
        timeSegChooseView.startTimeTextView.contentTextField.text =  [[NSDate dateWithTimeIntervalSince1970:_data.startTime] stringWithDateFormat:@"HH:mm"];
        timeSegChooseView.endTimeTextView.contentTextField.text =  [[NSDate dateWithTimeIntervalSince1970:_data.endTime] stringWithDateFormat:@"HH:mm"];
        clinicTexView.contentTextField.text = _data.clinic.name;
        feeTexView.contentTextField.text = [NSString stringWithFormat:@"%.2lf",_data.fee/100.f];
        numberTexView.contentTextField.text = [NSString stringWithFormat:@"%ld",_data.num];
        
    }
    [super viewWillAppear:animated];
}

int scrollViewY = 0;

- (void)viewDidLoad {
    [super viewDidLoad];
    self.isPanValid = NO;
    self.title = @"放号";
    self.contentView.backgroundColor = UIColorFromHex(Color_Hex_ImageDefault);
    // Do any additional setup after loading the view.
}

- (void)loadContentView{
    contentScrollView = [[UIScrollView alloc]initWithFrame:CGRectMake(0, 0, kScreenWidth, [self.contentView frameHeight] - 50)];
    contentScrollView.backgroundColor = UIColorFromHex(Color_Hex_ImageDefault);
    UITapGestureRecognizer *endEditTap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(endEdit)];
    [contentScrollView addGestureRecognizer:endEditTap];
    [self.contentView addSubview:contentScrollView];
    
    [self initSubView];
    [self loadCommitView];
}

- (void)loadCommitView{
    
    UIView *commitBackgroundView = [[UIView alloc]init];
    commitBackgroundView.frame = CGRectMake(0, [self.contentView frameHeight] - 50, [self.contentView frameHeight], 50);
    commitBackgroundView.backgroundColor = [UIColor whiteColor];
    [self.contentView addSubview:commitBackgroundView];
    
    UIView *lineView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, kScreenWidth, 1)];
    lineView.backgroundColor = UIColorFromHex(0xeeeeee);
    [commitBackgroundView addSubview:lineView];
    
    
    UIButton   *commitButton = [[UIButton alloc]initWithFrame:CGRectMake(7, 7, kScreenWidth - 2*7, 50 - 2*7)];
    [commitButton setTitle:@"提          交" forState:UIControlStateNormal];
    [commitButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    commitButton.layer.cornerRadius = 5.0;
    commitButton.layer.backgroundColor = [UIColor colorWithRed:114/255.0 green:196/255.0 blue:58/255.0 alpha:1].CGColor;
    [commitButton addTarget:self action:@selector(checkDataAndCommit) forControlEvents:UIControlEventTouchUpInside];
    
    [commitBackgroundView addSubview:commitButton];
    
}



- (void)initSubView{
    int leftPadding = 7;
    int intervalY = 15;
    int textViewHeight = 40;
    
    __weak __block OfferOrderViewController2 * blockSelf = self;
    
    calendarTextView = [[YYTextView alloc]initWithFrame:CGRectMake(leftPadding, 15, kScreenWidth - leftPadding *2, textViewHeight) canEdit:NO];
    [calendarTextView setTitleText:@"放号日期"];
    calendarTextView.contentTextField.text = @"点击选择放号日期";
    calendarTextView.clickBlock = ^{
        NSLog(@"点击calendarTextView");
        [blockSelf showAction:@"calendarTextView"];
    };
    [contentScrollView addSubview:calendarTextView];
    
//    timeSegButtonsView = [[TimeSegButtonsView alloc]initWithFrame:CGRectMake(leftPadding,CGRectGetMaxY(calendarTextView.frame) + intervalY, kScreenWidth - leftPadding*2, 200)];
//    [contentScrollView addSubview:timeSegButtonsView];
    
    timeSegChooseView = [[TimeSegChooseView alloc]initWithFrame:CGRectMake(leftPadding,CGRectGetMaxY(calendarTextView.frame) + intervalY, kScreenWidth - leftPadding*2, 200)];
    [timeSegChooseView.startTimeTextView.contentTextField addObserver:self forKeyPath:@"text" options:NSKeyValueObservingOptionNew|NSKeyValueObservingOptionOld context:nil];
    [timeSegChooseView.endTimeTextView.contentTextField addObserver:self forKeyPath:@"text" options:NSKeyValueObservingOptionNew|NSKeyValueObservingOptionOld context:nil];
    [contentScrollView addSubview:timeSegChooseView];
    
    clinicTexView = [[YYTextView alloc]initWithFrame:CGRectMake(leftPadding, CGRectGetMaxY(timeSegChooseView.frame), kScreenWidth - 2 * leftPadding, textViewHeight) canEdit:NO];
    [clinicTexView setTitleText:@"选择诊疗点"];
    clinicTexView.clickBlock = ^{
        NSLog(@"点击clinicTexView");
        [blockSelf showAction:@"clinicTexView"];
    };
    [clinicTexView.contentTextField addObserver:self forKeyPath:@"text" options:NSKeyValueObservingOptionNew|NSKeyValueObservingOptionOld context:nil];
    [contentScrollView addSubview:clinicTexView];
    
    numberTexView = [[YYTextView alloc]initWithFrame:CGRectMake(leftPadding, CGRectGetMaxY(clinicTexView.frame)+intervalY, kScreenWidth - 2 * leftPadding, textViewHeight) canEdit:YES];
    [numberTexView setTitleText:@"放号数量"];
    numberTexView.contentTextField.delegate = self;
    numberTexView.contentTextField.keyboardType = UIKeyboardTypeNumberPad;
    numberTexView.clickBlock = ^{
        NSLog(@"点击numberTexView");
        [blockSelf showAction:@"numberTexView"];
    };
    [numberTexView.contentTextField addTarget:self action:@selector(textFieldDidChange:) forControlEvents:UIControlEventEditingChanged];
    [contentScrollView addSubview:numberTexView];
    
    feeTexView = [[YYTextView alloc]initWithFrame:CGRectMake(leftPadding, CGRectGetMaxY(numberTexView.frame)+intervalY, kScreenWidth - 2 * leftPadding, textViewHeight) canEdit:YES];
    [feeTexView setTitleText:@"就诊费"];
    feeTexView.contentTextField.delegate = self;
    feeTexView.contentTextField.keyboardType = UIKeyboardTypeNumberPad;
    feeTexView.clickBlock = ^{
        NSLog(@"点击feeTexView");
        [blockSelf showAction:@"feeTexView"];
    };
    [contentScrollView addSubview:feeTexView];
    
    [contentScrollView setContentSize:CGSizeMake(kScreenWidth, CGRectGetMaxY(feeTexView.frame) + 15)];
    
    calendarTextView.hidden = YES;
    timeSegChooseView.hidden = YES;
    clinicTexView.hidden = YES;
    numberTexView.hidden = YES;
    feeTexView.hidden = YES;
}

// 弹出日历
- (void)showAction:(NSString *)ViewName
{
    if ([ViewName isEqualToString:@"calendarTextView"]) {
        __weak __block OfferOrderViewController2 *blockSelf = self;
        calendarPicker = [SZCalendarPicker showOnView:self.view];
        calendarPicker.today = [NSDate date];
        calendarPicker.date = calendarPicker.today;
//        calendarPicker.selectedDate = [[NSDate date] dateByAddingDays:1];
        calendarPicker.selectedDate = [NSDate date];
        calendarPicker.frame = CGRectMake(0, 100, self.view.frame.size.width, 352);
        calendarPicker.calendarBlock = ^(NSInteger day, NSInteger month, NSInteger year){
            NSString *string = [NSString stringWithFormat:@"%i-%i-%i", year,month,day];
            
            NSDateFormatter *inputFormatter = [[NSDateFormatter alloc]init];
            [inputFormatter setDateFormat:@"yyyy-MM-dd"];
            NSDate *date = [inputFormatter dateFromString:string];

            blockSelf.calendarTextView.contentTextField.text = [date stringWithDateFormat:@"yyyy-MM-dd"];
            [blockSelf reSetTimeChooseViewData];
        };
    }
    if ([ViewName isEqualToString:@"clinicTexView"]) {
        [self showCourseView];
    }
    if ([ViewName isEqualToString:@"numberTexView"]) {
        [numberTexView.contentTextField becomeFirstResponder];
    }
    if ([ViewName isEqualToString:@"feeTexView"]) {
        [feeTexView.contentTextField becomeFirstResponder];
    }
    
}

- (void)showCourseView
{
    if (_alertview == nil) {
        _alertview = [[CYAlertView alloc] init];
    }
    
    _alertview.backgroundColor = [UIColor colorWithWhite:0 alpha:0.4f];
    
    
    if (_courseView == nil) {
        _courseView = [[UIView alloc] initWithFrame:(CGRect){0,0,300*kScreenRatio,250}];
        clinicPicker = [[UIPickerView alloc] initWithFrame:(CGRect){0,0,300*kScreenRatio,216}];
        [_courseView addSubview:clinicPicker];
        
        UIButton *surebutton = [UIButton buttonWithType:UIButtonTypeCustom];
        surebutton.frame = (CGRect){0,216,300*kScreenRatio,34};
        [surebutton setTitle:@"确定" forState:UIControlStateNormal];
        [surebutton setTitleColor:kDarkGrayColor forState:UIControlStateNormal];
        [surebutton addTarget:self action:@selector(sureAction) forControlEvents:UIControlEventTouchUpInside];
        [_courseView addSubview:surebutton];
    }
    
    clinicPicker.delegate = self;
    clinicPicker.dataSource = self;
    
    _alertview.contentView = _courseView;
    _alertview.isHaveAnimation = YES;
    [_alertview show];
    
}

- (void)sureAction
{
    NSInteger selectRow = [clinicPicker selectedRowInComponent:0];
    clinicTexView.contentTextField.text = [clinicArray[selectRow] name];
    [_alertview hidden];
}

- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary<NSString *,id> *)change context:(void *)context{
    if (object == clinicTexView.contentTextField) {
        if ([keyPath isEqualToString:@"text"]) {
            [self reSetTimeChooseViewData];
        }
    }
    if (object == timeSegChooseView.startTimeTextView.contentTextField) {
        NSDateFormatter *inputFormatter = [[NSDateFormatter alloc]init];
        [inputFormatter setDateFormat:@"yyyy-MM-dd"];
        NSDate *date = [inputFormatter dateFromString:calendarTextView.contentTextField.text];
        NSInteger timestamp = [date timeIntervalSince1970];
        
        NSInteger hour1 = [[timeSegChooseView.startTimeTextView.contentTextField.text substringWithRange:NSMakeRange(0, 2)] integerValue];
        NSInteger min1 = [[timeSegChooseView.startTimeTextView.contentTextField.text substringWithRange:NSMakeRange(3, 2)] integerValue];
        self.data.startTime = timestamp + (hour1*3600 + min1*60);
    }
    if (object == timeSegChooseView.endTimeTextView.contentTextField) {
        NSDateFormatter *inputFormatter = [[NSDateFormatter alloc]init];
        [inputFormatter setDateFormat:@"yyyy-MM-dd"];
        NSDate *date = [inputFormatter dateFromString:calendarTextView.contentTextField.text];
        NSInteger timestamp = [date timeIntervalSince1970];
        
        NSInteger hour2 = [[timeSegChooseView.endTimeTextView.contentTextField.text substringWithRange:NSMakeRange(0, 2)] integerValue];
        NSInteger min2 = [[timeSegChooseView.endTimeTextView.contentTextField.text substringWithRange:NSMakeRange(3, 2)] integerValue];
        self.data.endTime = timestamp + (hour2*3600 + min2*60);
    }
}

- (void)reSetTimeChooseViewData{
    int leftPadding = 7;
    int intervalY = 15;
    int textViewHeight = 40;
    NSLog(@"调用KVO");
    NSLog(@"诊疗点是%@",clinicTexView.contentTextField.text);
    NSLog(@"时间点是%@",calendarTextView.contentTextField.text);
    
    NSDateFormatter *inputFormatter = [[NSDateFormatter alloc]init];
    [inputFormatter setDateFormat:@"yyyy-MM-dd"];
    NSDate *date = [inputFormatter dateFromString:calendarTextView.contentTextField.text];
    NSInteger timestamp = [date timeIntervalSince1970];
    
//    __weak __block OfferOrderViewController2 *blockSelf = self;
    
    for (int i = 0 ; i < clinicArray.count; i++) {
        Clinic *clinic = (Clinic *)clinicArray[i];
        if ([clinic.name isEqualToString:clinicTexView.contentTextField.text]) {
            [[TreatmentOrderManager sharedInstance] FangHaoForGetTimeUsedStateWithTiemstamp:timestamp clinic:clinic resultBlock:^(SNHTTPRequestOperation *request, SNServerAPIResultData *result) {
                if (!result.hasError) {
                    Clinic *clinic = result.parsedModelObject;
                    if ([[NSDate dateWithTimeIntervalSince1970:timestamp] isToday]) {
                        TimeUesd *timeused = [[TimeUesd alloc]init];
                        timeused.startTime = timestamp;
                        timeused.endTime = [[NSDate date] timeIntervalSince1970];
                        [clinic.timeUesdArray addObject:timeused];
                    }
                    [timeSegChooseView setData:clinic];
                    clinicTexView.frame = CGRectMake(leftPadding, CGRectGetMaxY(timeSegChooseView.frame) + intervalY, kScreenWidth - 2 * leftPadding, textViewHeight);
                    numberTexView.frame = CGRectMake(leftPadding, CGRectGetMaxY(clinicTexView.frame)+ intervalY, kScreenWidth - 2 * leftPadding, textViewHeight);
                    feeTexView.frame = CGRectMake(leftPadding, CGRectGetMaxY(numberTexView.frame)+ intervalY, kScreenWidth - 2 * leftPadding, textViewHeight);
                    [contentScrollView setContentSize:CGSizeMake(kScreenWidth, CGRectGetMaxY(feeTexView.frame) + 15)];
                    
                    if (self.data.startTime != 0) {
                        timeSegChooseView.startTimeTextView.contentTextField.text =  [[NSDate dateWithTimeIntervalSince1970:_data.startTime] stringWithDateFormat:@"HH:mm"];
                        timeSegChooseView.endTimeTextView.contentTextField.text =  [[NSDate dateWithTimeIntervalSince1970:_data.endTime] stringWithDateFormat:@"HH:mm"];
                    }
                    
                    calendarTextView.hidden = NO;
                    timeSegChooseView.hidden = NO;
                    clinicTexView.hidden = NO;
                    numberTexView.hidden = NO;
                    feeTexView.hidden = NO;
                }
            } pageName:@"OfferOrderViewController2"];
            break;
        }
    }
}

- (void)dealloc{
    [clinicTexView.contentTextField removeObserver:self forKeyPath:@"text"];
    [timeSegChooseView.startTimeTextView.contentTextField removeObserver:self forKeyPath:@"text"];
    [timeSegChooseView.endTimeTextView.contentTextField removeObserver:self forKeyPath:@"text"];
}

#pragma mark - PickerView代理方法

// pickerView 列数
- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView {
    if (pickerView == clinicPicker) {
        return 1;
    }
    return 1;
}

// pickerView 每列个数
- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component {
    if (pickerView == clinicPicker) {
        return [clinicArray count];
    }
    return 0;
}

// 每列宽度
- (CGFloat)pickerView:(UIPickerView *)pickerView widthForComponent:(NSInteger)component {

    if (pickerView == clinicPicker) {
        return 200;
    }
    return 180;
}
// 返回选中的行
- (void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component
{

}

//返回当前行的内容,此处是将数组中数值添加到滚动的那个显示栏上
-(NSString*)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component
{
    if (pickerView == clinicPicker) {
        Clinic *temp = (Clinic *)[clinicArray objectAtIndex:row];
        return temp.name;
    }
    Clinic *temp = (Clinic *)[clinicArray objectAtIndex:row];
    return temp.name;
}


#pragma mark - textFieldDelegate

- (void)textFieldDidBeginEditing:(UITextField *)textField{
    scrollViewY = contentScrollView.contentOffset.y;
    if (textField == numberTexView.contentTextField) {
        [contentScrollView setContentOffset:CGPointMake(0,CGRectGetMinY(numberTexView.frame) - ([contentScrollView frameHeight] - 330)) animated:YES];
    }
    if (textField == feeTexView.contentTextField) {
        [contentScrollView setContentOffset:CGPointMake(0,CGRectGetMinY(feeTexView.frame) - ([contentScrollView frameHeight] - 330)) animated:YES];
    }
}

- (void)textFieldDidEndEditing:(UITextField *)textField{
    if (scrollViewY + [contentScrollView frameHeight] > contentScrollView.contentSize.height) {
        [contentScrollView setContentOffset:CGPointMake(0, contentScrollView.contentSize.height - [contentScrollView frameHeight]) animated:YES];
    }
    else{
        [contentScrollView setContentOffset:CGPointMake(0, 0) animated:YES];
    }

}

- (BOOL)textFieldShouldReturn:(UITextField *)textField{
    [self endEdit];
    return YES;
}

- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string{
    if (textField == feeTexView.contentTextField){
        if ([string isEqualToString:@"0"]||[string isEqualToString:@"1"]||[string isEqualToString:@"2"]||[string isEqualToString:@"3"]||[string isEqualToString:@"4"]||[string isEqualToString:@"5"]||[string isEqualToString:@"6"]||[string isEqualToString:@"7"]||[string isEqualToString:@"8"]||[string isEqualToString:@"9"]||[string isEqualToString:@"."]||[string isEqualToString:@""]) {
            return YES;
        }
        else{
            return NO;
        }
    }
    if (textField == numberTexView.contentTextField){
        if ([string isEqualToString:@"0"]||[string isEqualToString:@"1"]||[string isEqualToString:@"2"]||[string isEqualToString:@"3"]||[string isEqualToString:@"4"]||[string isEqualToString:@"5"]||[string isEqualToString:@"6"]||[string isEqualToString:@"7"]||[string isEqualToString:@"8"]||[string isEqualToString:@"9"]||[string isEqualToString:@""]) {
            return YES;
        }
        else{
            return NO;
        }
    }
    return YES;
}

- (void)textFieldDidChange:(UITextField *) textField
{
    NSString *text = textField.text;
    if (textField == numberTexView.contentTextField){
        if ((![timeSegChooseView.startTimeTextView.contentTextField.text isEmpty]&&(![timeSegChooseView.endTimeTextView.contentTextField.text isEmpty])) ) {
            NSInteger hour1 = [[timeSegChooseView.startTimeTextView.contentTextField.text substringWithRange:NSMakeRange(0, 2)] integerValue];
            NSInteger min1 = [[timeSegChooseView.startTimeTextView.contentTextField.text substringWithRange:NSMakeRange(3, 2)] integerValue];
            NSTimeInterval startTime = (hour1*3600 + min1*60);
            
            NSInteger hour2 = [[timeSegChooseView.endTimeTextView.contentTextField.text substringWithRange:NSMakeRange(0, 2)] integerValue];
            NSInteger min2 = [[timeSegChooseView.endTimeTextView.contentTextField.text substringWithRange:NSMakeRange(3, 2)] integerValue];
            NSTimeInterval endTime = (hour2*3600 + min2*60);
            
            NSInteger maxNum = (endTime - startTime) / 300;
            
            text = [NSString stringWithFormat:@"%d", MIN(maxNum, [text integerValue])];
        }
    }
    if (textField == feeTexView.contentTextField){
//        NSUInteger index = [text rangeOfString:@"."].location;
//        if (index != NSNotFound) {
//            double amount = [[text stringByReplacingOccurrencesOfString:@"." withString:@""] doubleValue];
//            text = [NSString stringWithFormat:@"%.02f", MIN(amount, kMaxAmount)/100];
//        } else {
//            double amount = [text doubleValue];
//            text = [NSString stringWithFormat:@"%.02f", MIN(amount, kMaxAmount)/100];
//        }
    }

    textField.text = text;
}

- (void)checkDataAndCommit{
    
    if([timeSegChooseView.startTimeTextView.contentTextField.text isEmpty]){
        UIAlertView *alert = [[UIAlertView alloc]initWithTitle:nil message:@"请选择起始时间" delegate:nil cancelButtonTitle:nil otherButtonTitles:@"确定", nil];
        [alert show];
        return;
    }
    if ([timeSegChooseView.endTimeTextView.contentTextField.text isEmpty]) {
        UIAlertView *alert = [[UIAlertView alloc]initWithTitle:nil message:@"请选择结束时间" delegate:nil cancelButtonTitle:nil otherButtonTitles:@"确定", nil];
        [alert show];
        return;
    }
    if ([timeSegChooseView.startTimeTextView.contentTextField.text isEmpty]||[timeSegChooseView.endTimeTextView.contentTextField.text isEmpty]) {
        UIAlertView *alert = [[UIAlertView alloc]initWithTitle:nil message:@"请选择预约时间" delegate:nil cancelButtonTitle:nil otherButtonTitles:@"确定", nil];
        [alert show];
        return;
    }
    if (numberTexView.contentTextField.text == nil || [numberTexView.contentTextField.text isEqualToString:@""] || [numberTexView.contentTextField.text integerValue] < 1) {
        UIAlertView *alert = [[UIAlertView alloc]initWithTitle:nil message:@"请输入放号数量（每个小时放号数量建议为12个）" delegate:nil cancelButtonTitle:nil otherButtonTitles:@"确定", nil];
        [alert show];
        return;
    } //判断放号数量
    if (feeTexView.contentTextField.text == nil || [feeTexView.contentTextField.text isEqualToString:@""] || [feeTexView.contentTextField.text doubleValue] <= 0) {
        UIAlertView *alert = [[UIAlertView alloc]initWithTitle:nil message:@"请输入就诊费" delegate:nil cancelButtonTitle:nil otherButtonTitles:@"确定", nil];
        [alert show];
        return;
    }
    // ------------确认数据--------------
    NSDateFormatter *inputFormatter = [[NSDateFormatter alloc]init];
    [inputFormatter setDateFormat:@"yyyy-MM-dd"];
    NSDate *date = [inputFormatter dateFromString:calendarTextView.contentTextField.text];
    NSInteger timestamp = [date timeIntervalSince1970]; // 放号timestamp
    
    NSInteger hour1 = [[timeSegChooseView.startTimeTextView.contentTextField.text substringWithRange:NSMakeRange(0, 2)] integerValue];
    NSInteger min1 = [[timeSegChooseView.startTimeTextView.contentTextField.text substringWithRange:NSMakeRange(3, 2)] integerValue];
    NSTimeInterval startTime = timestamp + (hour1*3600 + min1*60);
    
    NSInteger hour2 = [[timeSegChooseView.endTimeTextView.contentTextField.text substringWithRange:NSMakeRange(0, 2)] integerValue];
    NSInteger min2 = [[timeSegChooseView.endTimeTextView.contentTextField.text substringWithRange:NSMakeRange(3, 2)] integerValue];
    NSTimeInterval endTime = timestamp + (hour2*3600 + min2*60);
    
    //    NSString *time_seg = [timeSegButtonsView loadUsedButton];
    
    NSInteger clinicID = 0;
    for (int i = 0; i < clinicArray.count; i ++) {
        if ([clinicTexView.contentTextField.text isEqualToString:[[clinicArray objectAtIndex:i] name]]) {
            clinicID = [[clinicArray objectAtIndex:i] ID];
            break;
        }
    }
    
    if (endTime - startTime < [numberTexView.contentTextField.text integerValue]*300) {
        int adviceNumber = (endTime - startTime)/300;
        UIAlertView *alert = [[UIAlertView alloc]initWithTitle:nil message:[NSString stringWithFormat:@"一小时至多放号数量为12个，请您重新输入放号数量，建议为%d个",adviceNumber] delegate:nil cancelButtonTitle:nil otherButtonTitles:@"确定", nil];
        [alert show];
        return;
    }
    

    
    //发起网络请求
    [self showProgressView];
    [[TreatmentOrderManager sharedInstance] FangHaoWithDate:timestamp clinic_id:clinicID num:[numberTexView.contentTextField.text integerValue] fee:(NSInteger)([feeTexView.contentTextField.text doubleValue]*100) orderNo:orderNo startTime:startTime endTime:endTime resultBlock:^(SNHTTPRequestOperation *request, SNServerAPIResultData *result) {
        [self hideProgressView];
        if (!result.hasError) {
            NSInteger err = [result.responseObject integerForKeySafely:@"errorCode"];
            if (orderNo == 0) {
                if (err == 0) {
                    [TipHandler showTipOnlyTextWithNsstring:@"放号成功"];
                    NSLog(@"放号成功");
                    [self performSelector:@selector(backToRoot) withObject:nil afterDelay:1.f];
                }
                else{
                    [TipHandler showTipOnlyTextWithNsstring:[result.responseObject objectForKey:@"data"]];
                }
            }
            else{
                if (err == 0) {
                    [TipHandler showTipOnlyTextWithNsstring:@"修改成功"];
                    NSLog(@"修改成功");
                    [self performSelector:@selector(backToRoot) withObject:nil afterDelay:1.f];
                }
                else{
                    NSLog(@"未知错误 修改失败");
                    [TipHandler showTipOnlyTextWithNsstring:[result.responseObject objectForKey:@"data"]];
                }
            }
        }
    } pageName:@"OfferOrderViewController2"];
}

- (void)backToRoot{
    [self.slideNavigationController popViewControllerAnimated:YES];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)loadNavigationBar
{
    [self addLeftBackButtonItemWithImage];
}

- (void)endEdit{
    [feeTexView.contentTextField resignFirstResponder];
    [numberTexView.contentTextField resignFirstResponder];
}

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex{
    if (alertView.tag == 100) {
        if (buttonIndex == 0) {
            [self backToRoot];
        }
    }
}

@end
