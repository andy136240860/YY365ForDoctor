//
//  LoginView.m
//  FindDoctor
//
//  Created by Guo on 15/9/18.
//  Copyright (c) 2015年 li na. All rights reserved.
//

#import "LoginView.h"
#import "UserViewController.h"

@implementation LoginView

#define kTopY (21/72.0)*kScreenWidth

{
    UIScrollView *_contentScrollView;
    
}


- (instancetype)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = UIColorFromHex(Color_Hex_ImageDefault);
        [self initContentView];
        [self loadTopImage];
        [self loadMainView];

    }
    return self;
}

- (void)initContentView
{
    _contentScrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, self.frame.size.height)];
    _contentScrollView.backgroundColor = UIColorFromHex(Color_Hex_ImageDefault);
    [self addSubview:_contentScrollView];
    
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


-(void)loadTopImage{
    UIImageView *topImageView = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, kScreenWidth,kTopY)];
    topImageView.image = [UIImage imageNamed:@"BG_4"];
    topImageView.contentMode = 0;
    [_contentScrollView addSubview:topImageView];
}

-(void)loadMainView{
    UIImage *logoImage = [UIImage imageNamed:@"Logo"];
    
    //设定基础间距
    CGFloat baseIntervalY = (self.frame.size.height - kTopY - logoImage.size.height - 42*3)/6.0;
                             
    UIImageView *logoImageView = [[UIImageView alloc]initWithImage:logoImage];
    logoImageView.frame = CGRectMake((kScreenWidth-logoImage.size.width)/2, baseIntervalY/2+kTopY, logoImage.size.width, logoImage.size.width);
    
    [_contentScrollView addSubview:logoImageView];
    
    
    UIImageView *userNameBackground = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"userNameTextFieldBackground"]];
    userNameBackground.frame = CGRectMake((kScreenWidth-300)/2, kTopY+baseIntervalY+logoImage.size.height, 300, 42);
    UITextField *userName = [[UITextField alloc]init];
    userName.frame = CGRectMake((kScreenWidth-300)/2 + 50, kTopY+baseIntervalY+logoImage.size.height, 240, 42);
    userName.backgroundColor = [UIColor clearColor];
    userName.placeholder = @"请输入手机号/邮箱";
    userName.tintColor = UIColorFromHex(0xaaaaaa);
    userName.delegate = self;
    userName.clearButtonMode = UITextFieldViewModeUnlessEditing;
    [_contentScrollView addSubview:userNameBackground];
    [_contentScrollView addSubview:userName];
    
    UIImageView *passwordBackground = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"passwordTextFieldBackground"]];
    passwordBackground.frame = CGRectMake((kScreenWidth-300)/2, kTopY+baseIntervalY*2+42+logoImage.size.height, 300, 42);
    UITextField *password = [[UITextField alloc]init];
    password.frame = CGRectMake((kScreenWidth-300)/2 + 50, kTopY+baseIntervalY*2+42+logoImage.size.height, 240, 42);
    password.backgroundColor = [UIColor clearColor];
    password.placeholder = @"请输入密码";
    password.tintColor = UIColorFromHex(0xaaaaaa);
    password.delegate = self;
    password.clearButtonMode = UITextFieldViewModeUnlessEditing;
    password.secureTextEntry = YES;
    [_contentScrollView addSubview:passwordBackground];
    [_contentScrollView addSubview:password];
    
    UIButton *loginButton = [[UIButton alloc]initWithFrame:CGRectMake((kScreenWidth-300)/2,  kTopY+baseIntervalY*3+42*2+logoImage.size.height, 300, 42)];
    loginButton.backgroundColor  = [UIColor colorWithPatternImage:[UIImage imageNamed:@"LoginButtonBackground"]];
    [loginButton addTarget:self action:@selector(judgeIfLogin) forControlEvents:UIControlEventTouchUpInside];
    [_contentScrollView addSubview:loginButton];
}

- (BOOL)textFieldShouldBeginEditing:(UITextField *)textField{
    [_contentScrollView setContentOffset:CGPointMake(0,(textField.frame.origin.y - (self.frame.size.height - 253 -textField.frame.size.height) )) animated:YES];
    return YES;
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField{
    [textField resignFirstResponder];
    [_contentScrollView setContentOffset:CGPointMake(0, 0) animated:YES];
    return YES;
}



- (void)endEdit
{
    [self endEditing:YES];
    [_contentScrollView setContentOffset:CGPointMake(0, 0) animated:YES];
}

-(void)judgeIfLogin{
    [self removeFromSuperview];
}
@end
