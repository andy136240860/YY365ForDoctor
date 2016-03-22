//
//  LoginViewController.m
//  FindDoctor
//
//  Created by Guo on 15/10/1.
//  Copyright (c) 2015年 li na. All rights reserved.
//

#import "LoginViewController.h"
#import "SNTabViewController.h"

#import "HomeViewController.h"
#import "UserViewController.h"

#import "SNTabBarItem.h"
#import "UIConstants.h"


#import "CUWebController.h"
#import "CUServerAPIConstant.h"
#import "CUUIContant.h"
#import "CUUserManager.h"
#import "MBProgressHUD.h"
#import "TipHandler+HUD.h"
#import "UIImage+Color.h"

@interface LoginViewController ()<UITextFieldDelegate>

{
    int timerCount;
    UIScrollView *_contentScrollView;
    UILabel *_codeLabel;
    UIButton *_codeButton;
    NSString *codetoken;
}

@property (nonatomic,strong) UITextField *userName;
@property (nonatomic,strong) UITextField *password;
@property (nonatomic,strong) MBProgressHUD *hud;
@property (nonatomic,strong) NSTimer *timer;


#define kTopY (21/72.0)*kScreenWidth
#define kCodeButtonWith         80

@end

@implementation LoginViewController

@synthesize userName;
@synthesize password;

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = UIColorFromHex(Color_Hex_ImageDefault);
    [self initContentView];
    [self loadMainView];
    // Do any additional setup after loading the view.
}

- (void)initContentView
{
    _contentScrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, self.view.frame.size.height)];
    _contentScrollView.layer.contents = (id)[UIImage imageNamed:@"loginBackgroundImage"].CGImage;
    [self.view addSubview:_contentScrollView];
    
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(endEdit)];
    [_contentScrollView addGestureRecognizer:tap];
    
    
    _contentScrollView.contentSize = CGSizeMake(kScreenWidth    , kScreenHeight*2);
    _contentScrollView.showsVerticalScrollIndicator = NO; //取消垂直方向滚动条
    _contentScrollView.bounces = NO;   //禁止到底部弹回动画
    _contentScrollView.scrollEnabled = NO;  //禁止手动滚动scrollView
    
    /*
     float whiteOriginY = kHeadHeight;
     CGRect whiteRect = CGRectMake(0, whiteOriginY, viewWidth, originY - whiteOriginY);
     _whiteView = [[UIView alloc] initWithFrame:whiteRect];
     _whiteView.backgroundColor = [UIColor whiteColor];
     [_contentScrollView insertSubview:_whiteView atIndex:0];*/
}

-(void)loadMainView{
    int paadingTop = 50;
    int intervalY = 60;
    
    UIImage *logoImage = [UIImage imageNamed:@"Logo"];
    
    //设定基础间距
    UIView *view = [[UIView alloc]initWithFrame:CGRectMake((kScreenWidth - logoImage.size.width)/2, paadingTop, logoImage.size.width, logoImage.size.height)];
    view.layer.contents = (id)logoImage.CGImage;
    
    [_contentScrollView addSubview:view];
    
    
    UIImageView *userNameBackground = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"userNameTextFieldBackground"]];
    userNameBackground.frame = CGRectMake((kScreenWidth-userNameBackground.frameWidth)/2,CGRectGetMaxY(view.frame), userNameBackground.frameWidth, userNameBackground.frameHeight);
    userName = [[UITextField alloc]init];
    userName.frame = CGRectMake((kScreenWidth-userNameBackground.frameWidth)/2 + 50, CGRectGetMaxY(view.frame)-3, userNameBackground.frameWidth - 50, userNameBackground.frameHeight);
    userName.backgroundColor = [UIColor clearColor];
    userName.placeholder = @"请输入手机号";
    userName.tintColor = [UIColor whiteColor];
    userName.delegate = self;
    userName.clearButtonMode = UITextFieldViewModeUnlessEditing;
    userName.secureTextEntry = NO;
    userName.keyboardType = UIKeyboardTypeNumberPad;
    userName.textColor = [UIColor whiteColor];
    [userName setValue:[UIColor colorWithRed:1 green:1 blue:1 alpha:0.3] forKeyPath:@"_placeholderLabel.textColor"];
    [_contentScrollView addSubview:userNameBackground];
    [_contentScrollView addSubview:userName];
    
    UIImageView *passwordBackground = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"passwordTextFieldBackground"]];
    passwordBackground.frame = CGRectMake((kScreenWidth-passwordBackground.frameWidth)/2, CGRectGetMaxY(view.frame)+intervalY, passwordBackground.frameWidth, passwordBackground.frameHeight);
    password = [[UITextField alloc]init];
    password.frame = CGRectMake((kScreenWidth-passwordBackground.frameWidth)/2 + 50, CGRectGetMaxY(view.frame)+intervalY-3, passwordBackground.frameWidth - 50, passwordBackground.frameHeight);
    password.backgroundColor = [UIColor clearColor];
    password.placeholder = @"请输入验证码";
    password.tintColor = [UIColor whiteColor];
    password.delegate = self;
    password.clearButtonMode = UITextFieldViewModeUnlessEditing;
//    password.secureTextEntry = YES;
    password.keyboardType = UIKeyboardTypeNumberPad;
    password.textColor = [UIColor whiteColor];
    [password setValue:[UIColor colorWithRed:1 green:1 blue:1 alpha:0.3] forKeyPath:@"_placeholderLabel.textColor"];
    [_contentScrollView addSubview:passwordBackground];
    [_contentScrollView addSubview:password];
    
    _codeButton = [UIButton buttonWithType:UIButtonTypeCustom];
    _codeButton.frame = CGRectMake(CGRectGetMaxX(password.frame) - kCodeButtonWith, CGRectGetMinY(password.frame), kCodeButtonWith, CGRectGetHeight(password.frame));
    [_codeButton setBackgroundImage:[UIImage imageNamed:@"login_code_bg"] forState:UIControlStateNormal];
    [_codeButton setBackgroundImage:[UIImage imageNamed:@"login_code_bg"] forState:UIControlStateDisabled];
    _codeButton.adjustsImageWhenHighlighted = NO;
    [_codeButton addTarget:self action:@selector(codeLableAction) forControlEvents:UIControlEventTouchUpInside];
    [_contentScrollView addSubview:_codeButton];
    
    _codeLabel = [[UILabel alloc] initWithFrame:_codeButton.frame];
    _codeLabel.backgroundColor = [UIColor clearColor];
    _codeLabel.font = [UIFont systemFontOfSize:12];
    _codeLabel.textAlignment = NSTextAlignmentCenter;
    _codeLabel.textColor = [UIColor whiteColor];
    _codeLabel.text = @"获取验证码";
    [_contentScrollView addSubview:_codeLabel];
    
    UIButton *loginButton = [[UIButton alloc]initWithFrame:CGRectMake((kScreenWidth-passwordBackground.frameWidth)/2, CGRectGetMaxY(view.frame)+intervalY*2, passwordBackground.frameWidth, 42)];
    loginButton.layer.backgroundColor = [UIColor clearColor].CGColor;
    loginButton.layer.cornerRadius = 21.f;
    loginButton.layer.borderColor = [UIColor whiteColor].CGColor;
    loginButton.layer.borderWidth = 1.f;
    [loginButton setTitle:@"登           陆" forState:UIControlStateNormal];
    [loginButton addTarget:self action:@selector(confirmButtonAction) forControlEvents:UIControlEventTouchUpInside];
    [_contentScrollView addSubview:loginButton];
}

- (void)confirmButtonAction{
    if(self.userName.text.length == 11 && self.password.text.length >1 ){
        [self Login];
    }
    else{
        UIAlertView *tempAlert = [[UIAlertView alloc]initWithTitle:nil message:@"手机号或验证码填写错误" delegate:nil cancelButtonTitle:nil otherButtonTitles:@"确定", nil];
        [tempAlert show];
    }
}

- (void)codeLableAction
{
    [self endEdit];
    if ([userName.text isEmpty])
    {
        [TipHandler showTipOnlyTextWithNsstring:@"请输入手机号"];
        return;
    }
    if(self.userName.text.length != 11){
        [TipHandler showTipOnlyTextWithNsstring:@"请检查手机号是否正确"];
        return;
    }
    
    [self showHUD];
    
    [self startTimer];
    
    [[CUUserManager sharedInstance] requireVerifyCodeWithCellPhone:[self userName].text resultBlock:^(SNHTTPRequestOperation *request, SNServerAPIResultData *result)
     {
         [self hideHUD];
         
         if (!result.hasError) {
             NSInteger errorCode = [[result.responseObject valueForKey:@"errorCode"] integerValue];
             if(errorCode == 0){
//                 codetoken = [[result.responseObject valueForKey:@"data"] valueForKey:@"codetoken"];
//                 NSLog(@"code = %@\ncodetoken = %@",[[result.responseObject valueForKey:@"data"] valueForKey:@"code"],[[result.responseObject valueForKey:@"data"] valueForKey:@"codetoken"]);
             }
             else{
                 UIAlertView *alert = [[UIAlertView alloc]initWithTitle:nil message:[NSString stringWithFormat:@"%@",[result.responseObject valueForKey:@"data"]] delegate:nil cancelButtonTitle:nil otherButtonTitles:@"确定", nil];
                 [alert show];
                 [self stopTimer];
                 [self resetButton];
             }
         }
         else {
             //提示错误
             NSString *msg = [result.error.userInfo valueForKey:NSLocalizedDescriptionKey];
             NSLog(@"===ERROR===%@",msg);
             
             [TipHandler showTipOnlyTextWithNsstring:msg];
             
             [self stopTimer];
             [self resetButton];
         }
     } pageName:@"CUUserVerifyCode"];
    
}

- (void)stopTimer
{
    if ([self.timer isValid]) {
        [self.timer invalidate];
        self.timer = nil;
    }
}

- (void)resetButton
{
    _codeLabel.text = @"获取验证码";
    _codeButton.enabled = YES;
//    _codeField.text = @"";
}

- (void)startTimer {
    [self stopTimer];
    
    timerCount = 60;
    
    _codeButton.enabled = NO;
    
    self.timer = [NSTimer scheduledTimerWithTimeInterval:1 target:self selector:@selector(updateCode) userInfo:nil repeats:YES];
    [self.timer fire];
}

- (void)updateCode
{
    if (timerCount < 0) {
        [self stopTimer];
        [self resetButton];
        return;
    }
    
    NSString *strTime = [NSString stringWithFormat:@"%.1d", timerCount];
    _codeLabel.text = [NSString stringWithFormat:@"%@s",strTime];
    
    timerCount--;
}

- (void)showHUD
{
    if (_hud == nil) {
        _hud = [[MBProgressHUD alloc] initWithFrame:CGRectMake(0, 0, 200, 200)];
        _hud.center = CGPointMake(CGRectGetWidth(self.view.bounds)/2, CGRectGetHeight(self.view.bounds)/2);
        [self.view addSubview:_hud];
        [self.view bringSubviewToFront:_hud];
    }
    
    [_hud show:YES];
}

- (void)hideHUD
{
    [_hud hide:NO];
}


- (void)Login
{
    [self endEdit];
    [self showProgressView];
    
    __weak __block LoginViewController * blockSelf = self;
    SNServerAPIResultBlock handler = ^(SNHTTPRequestOperation *request, SNServerAPIResultData *result)
    {
        [blockSelf hideProgressView];
        if (!result.hasError)
        {
            NSInteger err_code = [[result.responseObject valueForKey:@"errorCode"] integerValue];
            if (err_code == 0) {
                if ([CUUserManager sharedInstance].user.doctorId == -1){
                    [TipHandler showHUDText:@"对不起，您还并未签约，请联系客服" inView:blockSelf.view];
                }
                else {
                    [TipHandler showHUDText:@"登录成功" inView:blockSelf.view];
                    [[NSNotificationCenter defaultCenter] postNotificationName:@"loginSuccess" object:nil];
                }
            }
            else {
                [TipHandler showHUDText:[NSString stringWithFormat:@"%@",[result.responseObject valueForKey:@"data"]] inView:blockSelf.view];
            }
        }
        else
        {
            [TipHandler showHUDText:[result.error.userInfo valueForKey:NSLocalizedDescriptionKey] inView:blockSelf.contentView];
        }
    };
    
    [[CUUserManager sharedInstance] loginWithCellPhone:self.userName.text code:(NSString *)self.password.text codetoken:codetoken resultBlock:handler pageName:@"LoginViewController"];
}

//
//- (void)Login
//{
//    [self endEdit];
//    [self showProgressView];
//    
//    __weak LoginViewController * blockSelf = self;
//    SNServerAPIResultBlock handler = ^(SNHTTPRequestOperation *request, SNServerAPIResultData *result)
//    {
//        if (result.hasError) {
//            if (result.errorType == SNServerAPIErrorType_NetWorkFailure) {
//                [TipHandler showHUDText:@"网络错误" inView:blockSelf.view];
//            }
//            if (result.errorType == SNServerAPIErrorType_DataError) {
//                [TipHandler showHUDText:@"用户名或密码错误" inView:blockSelf.view];
//            }
//            
//        }
//        if (!result.hasError)
//        {
//            NSInteger err_code = [[result.responseObject valueForKey:@"err_code"] integerValue];
//            switch (err_code) {
//                case 1:
//                {
//                    [TipHandler showHUDText:@"用户名不存在" inView:blockSelf.view];
//                    break;
//                }
//
//                case 2:{
//                    [TipHandler showHUDText:@"密码错误" inView:blockSelf.view];
//                    break;
//                }
//
//                case 0:{
//                    [[CUUserManager sharedInstance] getUserInfo:[CUUserManager sharedInstance].user.token resultBlock:^(SNHTTPRequestOperation *request, SNServerAPIResultData *result) {
//                        
//                        [blockSelf hideProgressView];
//                        
//                        [TipHandler showHUDText:@"登录成功" inView:blockSelf.view];
//
//                        [[NSNotificationCenter defaultCenter] postNotificationName:@"loginSuccess" object:nil];
//                    }];
//                    break;
//                }
//                
//                default:{
//                    [TipHandler showHUDText:@"密码错误" inView:blockSelf.view];
//                    break;
//                }
//
//            }
//
//            //调用userInfo
//        }
//        else
//        {
//            [blockSelf hideProgressView];
//            [TipHandler showHUDText:[result.error.userInfo valueForKey:NSLocalizedDescriptionKey] inView:blockSelf.contentView];
//        }
//    };
//    
//    if (self.verifyCode) {
//        [[CUUserManager sharedInstance] loginWithCellPhone:self.userName.text varifyCode:[self.password.text integerValue] resultBlock:handler pageName:@"LoginViewController"];
//    }
//    else {
//        NSString *password = [[self.password.text MD5] uppercaseString];
//        
////        NSString *password = self.password.text;
//        [[CUUserManager sharedInstance] loginWithAccountName:self.userName.text password:password resultBlock:handler pageName:@"LoginViewController"];
//    }
//}

- (BOOL)textFieldShouldBeginEditing:(UITextField *)textField{
    if (textField.frame.origin.y - (self.view.frame.size.height - 253 -textField.frame.size.height) < 0){
        return  YES;
    }
    else {
        [_contentScrollView setContentOffset:CGPointMake(0,(textField.frame.origin.y - (self.view.frame.size.height - 253 -textField.frame.size.height) )) animated:YES];
    }

    return YES;
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField{
    [textField resignFirstResponder];
    [_contentScrollView setContentOffset:CGPointMake(0, 0) animated:YES];
    return YES;
}



- (void)endEdit
{
    [self.view endEditing:YES];
    [_contentScrollView setContentOffset:CGPointMake(0, 0) animated:YES];
}




- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
