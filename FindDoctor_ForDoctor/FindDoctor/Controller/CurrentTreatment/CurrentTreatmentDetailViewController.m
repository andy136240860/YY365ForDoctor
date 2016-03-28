//
//  CurrentTreatmentDetailViewController.m
//  FindDoctor
//
//  Created by Guo on 15/11/2.
//  Copyright © 2015年 li na. All rights reserved.
//

#import "CurrentTreatmentDetailViewController.h"
#import "CurrentTreatmentDetailsManager.h"

#import "CURecipeController.h"

#import "YYFaceView.h"
#import "YYTextView.h"
#import "YYPhotoView.h"
#import "TitleView.h"
#import "MBProgressHUD.h"
#import "TipHandler.h"

#import "CurrentTreatmentDetailHeaderView.h"
#import "CUHerbSelect.h"

#import "TreatmentOrderManager.h"
#import "TreatmentListAndDetailManager.h"
//#import "YueZhenDanViewController.h"
#import "ZhenLiaoDetailViewController.h"


#define commitViewHeight 50
#define intervalLeft 15
#define imageFrameWidth (kScreenWidth - intervalLeft*2)
#define intervalY 7

@interface CurrentTreatmentDetailViewController ()<UIAlertViewDelegate,MBProgressHUDDelegate,UITextFieldDelegate> {

    UIButton        *commitButton;

    UITextView      *zhenduanTextView;
    
    NSMutableArray  *chuFangArray;
    UIButton        *addChufangButton;
    CURecipeController *recipeController;
    
    UIImageView     *chufangImageView;
    UIButton        *addChuFangPhotoButton;

    TitleView       *bingZhengTitle;
    CGFloat         buttomY;
    UIButton        *addBingZhengButton;
    
    NSMutableArray  *bingZhengImageViewArray;
    NSMutableArray  *bingZhengImageViewDeleteButtonArry;
    
    MBProgressHUD   *HUD;
    
    int scrollViewY;
}

@property (nonatomic, strong) YYTextView *medicineNumberView;


@end

@implementation CurrentTreatmentDetailViewController
@synthesize prescriptionView;
@synthesize contentScrollView;



- (void)viewDidAppear:(BOOL)animated{
    self.isPanValid = NO;
}

- (void)viewDidLoad
{
    
    [super viewDidLoad];
    self.isPanValid = NO;
    scrollViewY = 0;
    //导航栏标题
    self.title = [NSString stringWithFormat:@"%@ 诊疗单", self.data.UserName];
    
    //导航栏按钮
    
    [self loadContentScrollView];
    [self loadContent];
    [self loadCommitView];
//    [self resetFrames];
}

-(void)loadContentScrollView{
    contentScrollView = [[UIScrollView alloc]initWithFrame:CGRectMake(0, 0, kScreenWidth, (self.contentView.frame.size.height - commitViewHeight))];
    contentScrollView.backgroundColor = UIColorFromHex(Color_Hex_ImageDefault);
    UITapGestureRecognizer *endEditTap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(endEdit)];
    [contentScrollView addGestureRecognizer:endEditTap];
    [self.contentView addSubview:contentScrollView];
}

- (void)loadContent{
    CurrentTreatmentDetailHeaderView *headerView = [[CurrentTreatmentDetailHeaderView alloc]initWithFrame:CGRectMake(0,7, kScreenWidth, 105)];
    [headerView setDataWithName:_data.UserName sex:(_data.UserSex == 0 ? @"女":@"男") cellPhone:_data.UserCellPhone age:_data.UserAge orderNo:[_data.diagnosisID longLongValue]];
    headerView.yueZhenDanBlock = ^{
        ZhenLiaoDetailViewController *detailVC = [[ZhenLiaoDetailViewController alloc]initWithPageName:@"YueZhenDanViewController"];
        detailVC.data = _data;
        [self.slideNavigationController pushViewController:detailVC animated:YES];
    };
    [contentScrollView addSubview:headerView];
    
    //诊断View
    UIView *zhenduanBackground = [[UIView alloc] initWithFrame:CGRectMake(0, CGRectGetMaxY(headerView.frame)+7, kScreenHeight, 100)];
    zhenduanBackground.backgroundColor = [UIColor whiteColor];
    [contentScrollView addSubview:zhenduanBackground];
    
    TitleView *zhenduanTitle = [[TitleView alloc]initWithFrame:CGRectMake(0, CGRectGetMinX(zhenduanBackground.frame), kScreenWidth, 30) title:@"诊断"];
    [zhenduanBackground addSubview:zhenduanTitle];
    
    UIView *zhenduanTextBackground = [[UIView alloc]initWithFrame:CGRectMake(15, 30, kScreenWidth - 30, 60)];
    zhenduanTextBackground.layer.backgroundColor = [UIColor whiteColor].CGColor;
    zhenduanTextBackground.layer.borderColor = UIColorFromHex(0xd8d8d8).CGColor;
    zhenduanTextBackground.layer.borderWidth = 1;
    [zhenduanBackground addSubview:zhenduanTextBackground];
    
    zhenduanTextView = [[UITextView alloc]initWithFrame:CGRectMake(20, 31, kScreenWidth - 40, 58)];
    zhenduanTextView.delegate = self;
    zhenduanTextView.editable = YES;
    zhenduanTextView.returnKeyType = UIReturnKeyDone;
    zhenduanTextView.textAlignment = NSTextAlignmentLeft;
    zhenduanTextView.keyboardType = UIKeyboardTypeDefault;
    zhenduanTextView.font = [UIFont systemFontOfSize:14];
    [zhenduanBackground addSubview:zhenduanTextView];
    
    __weak __block CurrentTreatmentDetailViewController * blockSelf = self;
    prescriptionView = [[PrescriptionView alloc] initWithFrame:CGRectMake(0, CGRectGetMaxY(zhenduanBackground.frame) + 7, kScreenWidth, 300)];
    prescriptionView.addPrescriptionCodeBlock = ^{[blockSelf addChuFangAction];};
    prescriptionView.addPrescriptionImageBlock = ^{[blockSelf openMenu];};
    prescriptionView.deletePrescriptionImageBlock = ^{
//        blockSelf.contentScrollView.contentSize = CGSizeMake(kScreenWidth,blockSelf.prescriptionView.frame.size.height + CGRectGetMinY(prescriptionView.frame));
        [blockSelf resetFrame];
    };
    prescriptionView.showPrescriptionImageBlock = ^{ [blockSelf showPrescriptionImageAction]; };
    [contentScrollView addSubview:prescriptionView];

    _medicineNumberView = [[YYTextView alloc]initWithFrame:CGRectMake(15, CGRectGetMaxY(prescriptionView.frame) + 7, kScreenWidth - 30, 40) canEdit:YES];
    [_medicineNumberView setTitleText:@"开方数量"];
    _medicineNumberView.contentTextField.keyboardType = UIKeyboardTypeNumberPad;
    _medicineNumberView.contentTextField.delegate = self;
    _medicineNumberView.clickBlock = ^{
        [blockSelf.medicineNumberView.contentTextField becomeFirstResponder];
    };
    [contentScrollView addSubview:_medicineNumberView];
    
    [contentScrollView setContentSize:CGSizeMake(kScreenWidth, CGRectGetMaxY(_medicineNumberView.frame) + 7)];
}

- (void)loadCommitView{
    UIView *commitBackgroundView = [[UIView alloc]init];
    commitBackgroundView.frame = CGRectMake(0, kScreenHeight - commitViewHeight, kScreenWidth, commitViewHeight);
    commitBackgroundView.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:commitBackgroundView];
    
    UIView *lineView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, kScreenWidth, 1)];
    lineView.backgroundColor = UIColorFromHex(0xeeeeee);
    [commitBackgroundView addSubview:lineView];
    
    commitButton = [[UIButton alloc]initWithFrame:CGRectMake(intervalLeft, intervalY, kScreenWidth - 2*intervalLeft, commitViewHeight - 2*intervalY)];
    [commitButton setTitle:@"提          交" forState:UIControlStateNormal];
    [commitButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    commitButton.layer.cornerRadius = 5.0;
    commitButton.layer.backgroundColor = [UIColor colorWithRed:114/255.0 green:196/255.0 blue:58/255.0 alpha:1].CGColor;
    [commitButton addTarget:self action:@selector(checkDataAndCommit) forControlEvents:UIControlEventTouchUpInside];
    
    [commitBackgroundView addSubview:commitButton];
    
}

- (void)addChuFangAction{
    if (recipeController == nil) {
        recipeController = [[CURecipeController alloc] init];
    }
    __weak __block CurrentTreatmentDetailViewController * blockSelf = self;
    recipeController.superViewController = blockSelf;
    recipeController.herbsBlock = ^(NSMutableArray *herbs){
        blockSelf.prescriptionView.prescriptionArray = herbs;
//        blockSelf.contentScrollView.contentSize = CGSizeMake(kScreenWidth,blockSelf.prescriptionView.frame.size.height + CGRectGetMinY(prescriptionView.frame));
        [blockSelf resetFrame];
    };
    [self.slideNavigationController pushViewController:recipeController animated:YES];
}

- (void)showPrescriptionImageAction{
    NSLog(@"showPrescriptionImageAction");
    self.hasNavigationBar = NO;
    YYPhotoView *test = [[YYPhotoView alloc]initWithPhotoArray: [NSMutableArray arrayWithObject:prescriptionView.image] numberOfClickedPhoto:0];
    [self.view addSubview:test];
}

#pragma mark - 弹出选择照片
-(void)openMenu
{
    //在这里呼出下方菜单按钮项
//    NSLog(@"sender.tag = %d",sender.tag);
    myActionSheet = [[UIActionSheet alloc]
                     initWithTitle:nil
                     delegate:self
                     cancelButtonTitle:@"取消"
                     destructiveButtonTitle:nil
                     otherButtonTitles: @"打开照相机", @"从手机相册获取",nil];
//    myActionSheet.tag = sender.tag;
    
    [myActionSheet showInView:self.contentView];
}




- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex
{
    //呼出的菜单按钮点击后的响应
    if (buttonIndex == myActionSheet.cancelButtonIndex)
    {
        NSLog(@"取消");
    }
    
    switch (buttonIndex)
    {
        case 0:  //打开照相机拍照
            [self takePhoto:actionSheet];
            break;
            
        case 1:  //打开本地相册
            [self LocalPhoto:actionSheet];
            break;
    }
}


//开始拍照
-(void)takePhoto:(UIActionSheet *)sender
{
    UIImagePickerControllerSourceType sourceType = UIImagePickerControllerSourceTypeCamera;
    if ([UIImagePickerController isSourceTypeAvailable: UIImagePickerControllerSourceTypeCamera])
    {
        UIImagePickerController *picker = [[UIImagePickerController alloc] init];
        picker.delegate = self;
        //设置拍照后的图片可被编辑
        picker.allowsEditing = YES;
        picker.sourceType = sourceType;
        picker.view.tag = sender.tag;
        [self presentModalViewController:picker animated:YES];
    }else
    {
        NSLog(@"模拟其中无法打开照相机,请在真机中使用");
    }
}

//打开本地相册
-(void)LocalPhoto:(UIActionSheet *)sender
{
    UIImagePickerController *picker = [[UIImagePickerController alloc] init];
    
    picker.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
    picker.delegate = self;
    //设置选择后的图片可被编辑
    picker.allowsEditing = YES;
//    picker.view.tag = sender.tag;
    [self presentModalViewController:picker animated:YES];
}

//当选择一张图片后进入这里
-(void)imagePickerController:(UIImagePickerController*)picker didFinishPickingMediaWithInfo:(NSDictionary *)info

{
    
    NSString *type = [info objectForKey:UIImagePickerControllerMediaType];
    
//    NSLog(@"info:%@\ntag = %d",info,picker.view.tag);
    
    //当选择的类型是图片
    if ([type isEqualToString:@"public.image"])
    {
        //先把图片转成NSData
        UIImage* image = [info objectForKey:@"UIImagePickerControllerOriginalImage"];
        NSData *data;
        if (UIImagePNGRepresentation(image) == nil)
        {
            data = UIImageJPEGRepresentation(image, 1.0);
        }
        else
        {
            data = UIImagePNGRepresentation(image);
        }

        [picker dismissViewControllerAnimated:YES completion:nil];
        [picker removeFromParentViewController];
        
        prescriptionView.image = image;
        [self resetFrame];
    }
    
}

- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker
{
    NSLog(@"您取消了选择图片");
    [picker dismissViewControllerAnimated:YES completion:nil];
}

- (void)resetFrame{
    _medicineNumberView.frame = CGRectMake(_medicineNumberView.frameX,self.prescriptionView.frame.size.height+CGRectGetMinY(prescriptionView.frame) + 7, _medicineNumberView.frameWidth, 40);
    [contentScrollView setContentSize:CGSizeMake(kScreenWidth, CGRectGetMaxY(_medicineNumberView.frame) + 7)];
}

#pragma mark - 提交
- (void)checkDataAndCommit{
    if ([_medicineNumberView.contentTextField.text isEqualToString:@""] || [_medicineNumberView.contentTextField.text integerValue] <= 0){
        UIAlertView *alert = [[UIAlertView alloc]initWithTitle:nil message:@"请输入处方数量" delegate:nil cancelButtonTitle:@"关闭" otherButtonTitles:nil];
        [alert show];
    }
    else
    {
        if (prescriptionView.image == nil) {
            [self commitWithMedicineCode];
        }
        else{
            [self commitWithMedicineImage];
        }
    }
}

- (void)commitWithMedicineCode{
    NSString *temPrecipe_sentence = [NSString stringWithFormat:@""];
    for (int i = 0; i < self.prescriptionView.prescriptionArray.count; i++) {
        CUHerbSelect *tempherb = (CUHerbSelect *)[self.prescriptionView.prescriptionArray objectAtIndex:i];
        temPrecipe_sentence = [temPrecipe_sentence stringByAppendingFormat:@",%@  %d  %@",tempherb.name,tempherb.weight,tempherb.unit];
    }
    if (temPrecipe_sentence.length > 0) {
        temPrecipe_sentence = [temPrecipe_sentence substringFromIndex:1];
        [[TreatmentOrderManager sharedInstance] medicineWithOrderNumber:[_data.diagnosisID longLongValue] recipeData:self.prescriptionView.prescriptionArray number:[_medicineNumberView.contentTextField.text integerValue] diagnose:zhenduanTextView.text resultBlock:^(SNHTTPRequestOperation *request, SNServerAPIResultData *result) {
            if (!result.hasError) {
                NSInteger err_code = [result.responseObject integerForKeySafely:@"errorCode"];
                if (err_code == 0){
                    [TipHandler showTipOnlyTextWithNsstring:@"提交成功"];
                    [self performSelector:@selector(backToRootView) withObject:nil afterDelay:1.0f];
                }
                else{
                    [TipHandler showTipOnlyTextWithNsstring:@"服务器错误，提交失败"];
                    [self performSelector:@selector(backToRootView) withObject:nil afterDelay:1.0f];
                }
            }
            else{
                if(result.errorType == SNServerAPIErrorType_NetWorkFailure){
                    [TipHandler showTipOnlyTextWithNsstring:@"网络错误， 请检查网络连接"];
                }
                else{
                    [TipHandler showTipOnlyTextWithNsstring:@"服务器内部错误"];
                }
            }
        } pageName:@"CurrentTreatmentDetailViewController"];
    }
    else {
        UIAlertView *alert = [[UIAlertView alloc]initWithTitle:nil message:@"请选择电子开方或者拍照输入处方" delegate:nil cancelButtonTitle:nil otherButtonTitles:@"确定", nil];
        [alert show];
    }
}

- (void)commitWithMedicineImage{
    HUD = [[MBProgressHUD alloc] initWithView:self.view];
    [self.view addSubview:HUD];
    HUD.labelText = @"正在上传处方图片";
    HUD.delegate = self;
    HUD.mode = MBProgressHUDModeAnnularDeterminate;
    [HUD show:YES];
    
    [[CurrentTreatmentDetailsManager sharedInstance] uploadChuFang:[NSMutableArray arrayWithObject:prescriptionView.image] resultBlock:^(SNHTTPRequestOperation *request, SNServerAPIResultData *result)  {
        if (!result.hasError) {
            [HUD hide:YES];
            HUD.labelText = @"上传成功";
            HUD.mode = MBProgressHUDModeCustomView;
            HUD.customView = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"Checkmark"]];
            [HUD show:YES];
            [HUD hide:YES afterDelay:1];
            NSLog(@"上传完毕处方图片");
            NSMutableDictionary *dic = [result.responseObject objectForKey:@"data"];
            NSMutableArray *ftppathArray = [dic valueForKeyPathSafely:@"ftppath"];
            NSString *ftppath = ftppathArray[0];
            [[TreatmentOrderManager sharedInstance] medicineWithOrderNumber:[_data.diagnosisID longLongValue] ftppath:ftppath  number:[_medicineNumberView.contentTextField.text integerValue] diagnose:zhenduanTextView.text resultBlock:^(SNHTTPRequestOperation *request, SNServerAPIResultData *result) {
                if (!result.hasError) {
                    NSInteger errorCode = [result.responseObject integerForKeySafely:@"errorCode"];
                    if (errorCode == 0){
                        [TipHandler showTipOnlyTextWithNsstring:@"提交成功"];
                        [self performSelector:@selector(backToRootView) withObject:nil afterDelay:1.0f];
                    }
                    else {
                        [TipHandler showTipOnlyTextWithNsstring:[result.responseObject valueForKeySafely:@"data"]];
                    }

                }
                
            } pageName:@"CurrentTreatmentDetailViewController"];
        }
    } pageName:@"CurrentTreatmentDetailViewControllerchufang" progressBlock:^(float progress) {
        HUD.progress = progress;
        NSLog(@"%f",progress);
    }];
    
}

- (void)backToRootView{
    [self.slideNavigationController popToRootViewControllerAnimated:YES];
}


#pragma mark - TextViewDelegate
- (BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text{
    if ([text isEqualToString:@"\n"]){ //判断输入的字是否是回车，即按下return
        [self endEdit];
        return NO; //这里返回NO，就代表return键值失效，即页面上按下return，不会出现换行，如果为yes，则输入页面会换行
    }
    
    return YES;
}

#pragma mark - textFieldDelegate

- (void)textFieldDidBeginEditing:(UITextField *)textField{
    scrollViewY = contentScrollView.contentOffset.y;
    if (textField == _medicineNumberView.contentTextField) {
        [contentScrollView setContentOffset:CGPointMake(0,CGRectGetMinY(_medicineNumberView.frame) - ([contentScrollView frameHeight] - 330)) animated:YES];
    }
}

- (void)textFieldDidEndEditing:(UITextField *)textField{
    if (scrollViewY + [contentScrollView frameHeight] > contentScrollView.contentSize.height) {
        [contentScrollView setContentOffset:CGPointMake(0, contentScrollView.contentSize.height - [contentScrollView frameHeight]) animated:YES];
    }
    else{
        [contentScrollView setContentOffset:CGPointMake(0, scrollViewY) animated:YES];
    }
    
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField{
    [self endEdit];
    return YES;
}


- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
}


- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string{
    if (textField == _medicineNumberView.contentTextField){
        if ([string isEqualToString:@"0"]||[string isEqualToString:@"1"]||[string isEqualToString:@"2"]||[string isEqualToString:@"3"]||[string isEqualToString:@"4"]||[string isEqualToString:@"5"]||[string isEqualToString:@"6"]||[string isEqualToString:@"7"]||[string isEqualToString:@"8"]||[string isEqualToString:@"9"]||[string isEqualToString:@""]) {
            return YES;
        }
        else{
            return NO;
        }
    }
    return YES;
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

- (void)loadNavigationBar
{
    [self addLeftBackButtonItemWithImage];
}

#pragma mark - keyboard

- (void)endEdit{
    NSLog(@"检测到触摸屏幕其他地方， 释放键盘");
    [_medicineNumberView.contentTextField resignFirstResponder];
    [zhenduanTextView resignFirstResponder];
    [contentScrollView becomeFirstResponder];
}


@end


