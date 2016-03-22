//
//  CUDiagnoseController.m
//  FindDoctor
//
//  Created by chai on 15/11/27.
//  Copyright © 2015年 li na. All rights reserved.
//

#import "CUDiagnoseController.h"
#import "CUTextField.h"
#import "CYAlertView.h"
#import "CUHerbSelect.h"
#import "TreatmentOrderManager.h"

@interface CUDiagnoseController () <UITextFieldDelegate,UIPickerViewDataSource,UIPickerViewDelegate>
{
    CUTextField *_courseField;
    CUTextField *_chinessRecipeField;
    CUTextField *_dialecticsField;
    CUTextField *_westernRecipeField;
    CUTextField *_medicineStyleField;
    CUTextField *_medicineNumberField;

    
    UIView *_submitView;

    CYAlertView *_alertview;
    
    UIView *_courseView;
    
    UIPickerView *_coursePicker;
    
    NSMutableArray *_courses;

}
@end

@implementation CUDiagnoseController

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.title = @"输入诊断信息";
}

- (void)loadContentView
{
    [super loadContentView];
    
    _courses = [NSMutableArray arrayWithArray:@[@"儿科",@"男科",@"外科",@"内科"]];
    
    self.contentView.backgroundColor = UIColorFromRGB(244, 244, 244);
    
    float padding_left = 20*kScreenRatio;
    
    float padding_top = 20.f;
    
    float interval_y = 20.f;
    
    float field_height = 35.f*kScreenRatio;
    
    _courseField = [[CUTextField alloc] initWithFrame:(CGRect){padding_left,padding_top,kScreenWidth-padding_left*2,field_height}];
    _courseField.font = SystemFont_14;
    _courseField.fieldTitle = @"科目";
    _courseField.canEdit = NO;
    _courseField.delegate = self;
    _courseField.backgroundColor = [UIColor whiteColor];
    [self.contentView addSubview:_courseField];
    
    _chinessRecipeField = [[CUTextField alloc] initWithFrame:(CGRect){padding_left,CGRectGetMaxY(_courseField.frame)+interval_y,kScreenWidth-padding_left*2,field_height}];
    _chinessRecipeField.font = SystemFont_14;
    _chinessRecipeField.fieldTitle = @"中医诊断";
    _chinessRecipeField.canEdit = YES;
    _chinessRecipeField.delegate = self;
    _chinessRecipeField.backgroundColor = [UIColor whiteColor];
    [self.contentView addSubview:_chinessRecipeField];
    
    _dialecticsField = [[CUTextField alloc] initWithFrame:(CGRect){padding_left,CGRectGetMaxY(_chinessRecipeField.frame)+interval_y,kScreenWidth-padding_left*2,field_height}];
    _dialecticsField.font = SystemFont_14;
    _dialecticsField.fieldTitle = @"辩证";
    _dialecticsField.canEdit = YES;
    _dialecticsField.delegate = self;
    _dialecticsField.backgroundColor = [UIColor whiteColor];
    [self.contentView addSubview:_dialecticsField];
    
    _westernRecipeField = [[CUTextField alloc] initWithFrame:(CGRect){padding_left,CGRectGetMaxY(_dialecticsField.frame)+interval_y,kScreenWidth-padding_left*2,field_height}];
    _westernRecipeField.font = SystemFont_14;
    _westernRecipeField.fieldTitle = @"西医诊断";
    _westernRecipeField.canEdit = YES;
    _westernRecipeField.delegate = self;
    _westernRecipeField.backgroundColor = [UIColor whiteColor];
    [self.contentView addSubview:_westernRecipeField];
    
    _medicineStyleField = [[CUTextField alloc] initWithFrame:(CGRect){padding_left,CGRectGetMaxY(_westernRecipeField.frame)+interval_y,kScreenWidth-padding_left*2,field_height}];
    _medicineStyleField.font = SystemFont_14;
    _medicineStyleField.fieldTitle = @"中药类型";
    _medicineStyleField.canEdit = YES;
    _medicineStyleField.delegate = self;
    _medicineStyleField.backgroundColor = [UIColor whiteColor];
    [self.contentView addSubview:_medicineStyleField];
    
    _medicineNumberField = [[CUTextField alloc] initWithFrame:(CGRect){padding_left,CGRectGetMaxY(_medicineStyleField.frame)+interval_y,kScreenWidth-padding_left*2,field_height}];
    _medicineNumberField.font = SystemFont_14;
    _medicineNumberField.fieldTitle = @"开方数量";
    _medicineNumberField.canEdit = YES;
    _medicineNumberField.delegate = self;
    _medicineNumberField.backgroundColor = [UIColor whiteColor];
    _medicineNumberField.keyboardType = UIKeyboardTypeNumberPad;
    [self.contentView addSubview:_medicineNumberField];

    float submit_height = 44.f;
    
    _submitView = [[UIView alloc] init];
    _submitView.frame = (CGRect){0,kScreenHeight-submit_height-kNavigationHeight,kScreenWidth,submit_height};
    _submitView.backgroundColor = UIColorFromRGB(244, 244, 244);
    [self.contentView addSubview:_submitView];
    
    UIView *lineView = [[UIView alloc] init];
    lineView.frame = (CGRect){0,0,kScreenWidth,1.f};
    lineView.backgroundColor = UIColorFromRGB(224, 224, 224);
    [_submitView addSubview:lineView];
    
    float button_padding_left = 45.f*kScreenRatio;
    
    UIButton *submitbutton = [UIButton buttonWithType:UIButtonTypeCustom];
    submitbutton.frame = (CGRect){button_padding_left,5,kScreenWidth-button_padding_left*2,submit_height-10};
    submitbutton.backgroundColor = UIColorFromRGB(89, 180, 25);
    submitbutton.layer.cornerRadius = 4;
    submitbutton.layer.masksToBounds = YES;
    [submitbutton setTitle:@"提交" forState:UIControlStateNormal];
    submitbutton.titleLabel.font = [UIFont systemFontOfSize:16];
    [_submitView addSubview:submitbutton];
    
    [submitbutton addTarget:self action:@selector(submitAction) forControlEvents:UIControlEventTouchUpInside];
}

- (void)loadNavigationBar
{
    [self addLeftBackButtonItemWithImage];
}

#pragma mark ----- button action ------

- (void)submitAction
{
    
    NSString *temPrecipe_sentence = [NSString stringWithFormat:@""];
    for (int i = 0; i < _selectHerbs.count; i++) {
        CUHerbSelect *tempherb = (CUHerbSelect *)[_selectHerbs objectAtIndex:i];
        temPrecipe_sentence = [temPrecipe_sentence stringByAppendingFormat:@",%@  %d  %@",tempherb.name,tempherb.weight,tempherb.unit];
    }
    if (temPrecipe_sentence.length > 0) {
        temPrecipe_sentence = [temPrecipe_sentence substringFromIndex:1];
    }

//    NSString *tempDiagnose = [NSString stringWithFormat:@"%@,%@,%@,%@",_chinessRecipeField.text,_dialecticsField.text,_westernRecipeField.text,_medicineStyleField.text];
//    [[TreatmentOrderManager sharedInstance] medicineWithOrderNumber:_orderno recipeData:self. number:[_medicineNumberField.text integerValue] diagnose:tempDiagnose resultBlock:^(SNHTTPRequestOperation *request, SNServerAPIResultData *result) {
//        if (!result.hasError) {
//            NSInteger err_code = [[result.responseObject valueForKeySafely:@"err_code"] integerValue];
//            if (err_code == 0){
//                [self performSelector:@selector(backToRootView) withObject:nil afterDelay:0.5f];
//            }
//            else{
//                [self performSelector:@selector(backToRootView) withObject:nil afterDelay:0.5f];
//            }
//        }
//    } pageName:@"CUDiagnoseController"];
}

- (void)backToRootView{
    [self.slideNavigationController popToRootViewControllerAnimated:YES];
}

- (void)showCourseView
{
    if (_alertview == nil) {
        _alertview = [[CYAlertView alloc] init];
    }
    
    _alertview.backgroundColor = [UIColor colorWithWhite:0 alpha:0.4f];
    
    
    if (_courseView == nil) {
        _courseView = [[UIView alloc] initWithFrame:(CGRect){0,0,300*kScreenRatio,250}];
        _coursePicker = [[UIPickerView alloc] initWithFrame:(CGRect){0,0,300*kScreenRatio,216}];
        [_courseView addSubview:_coursePicker];
        
        UIButton *surebutton = [UIButton buttonWithType:UIButtonTypeCustom];
        surebutton.frame = (CGRect){0,216,300*kScreenRatio,34};
        [surebutton setTitle:@"确定" forState:UIControlStateNormal];
        [surebutton setTitleColor:kDarkGrayColor forState:UIControlStateNormal];
        [surebutton addTarget:self action:@selector(sureAction) forControlEvents:UIControlEventTouchUpInside];
        [_courseView addSubview:surebutton];
    }
    
    _coursePicker.delegate = self;
    _coursePicker.dataSource = self;
    
    _alertview.contentView = _courseView;
    _alertview.isHaveAnimation = YES;
    [_alertview show];

}

- (void)sureAction
{
    NSInteger selectRow = [_coursePicker selectedRowInComponent:0];
    _courseField.text = _courses[selectRow];
    [_alertview hidden];
}

- (void)hiddenkeyboard
{
    [_courseField resignFirstResponder];
    [_chinessRecipeField resignFirstResponder];
    [_dialecticsField resignFirstResponder];
    [_westernRecipeField resignFirstResponder];
    [_medicineStyleField resignFirstResponder];
}

#pragma mark ---- textfield delegate ----
- (BOOL)textFieldShouldBeginEditing:(UITextField *)textField
{
    if ([textField isEqual:_courseField]) {
        [self showCourseView];
        [self hiddenkeyboard];
        return NO;
    }
    
    CGRect contentFrame = self.contentView.bounds;
    
    if ([textField isEqual:_chinessRecipeField]) {
        contentFrame.origin.y = 0;
    }
    
    if ([textField isEqual:_dialecticsField]) {
        contentFrame.origin.y = -40;
    }
    
    if ([textField isEqual:_westernRecipeField]) {
        contentFrame.origin.y = -80;
    }
    
    if ([textField isEqual:_medicineStyleField]) {
        contentFrame.origin.y = -120;
    }
    
    if ([textField isEqual:_medicineNumberField]) {
        contentFrame.origin.y = -160;
    }
    
    [UIView animateWithDuration:0.5f
                     animations:^{
                         self.contentView.frame = contentFrame;
                     }];
    
    return YES;
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [textField resignFirstResponder];
    CGRect contentFrame = self.contentView.bounds;
    contentFrame.origin.y = kNavigationHeight;
    [UIView animateWithDuration:0.5f
                     animations:^{
                         self.contentView.frame = contentFrame;
                     }];
    return YES;
}

#pragma mark ----- picker view delegate --------

- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component
{
    return _courses.count;
}

- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView
{
    return 1;
}

- (NSString *)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component
{
    return _courses[row];
}

- (void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component
{
    
}

@end
