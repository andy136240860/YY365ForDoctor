//
//  PersonalViewController.m
//  FindDoctor
//
//  Created by Guo on 15/8/18.
//  Copyright (c) 2015年 li na. All rights reserved.
//

#import "PersonalViewController.h"
#import "TitleView.h"
#import "PersonalDoctorView.h"
#import "PersonalOrderView.h"
#import "PersonalDoctorView.h"
#import "ConsultationListController.h"
#import "CUUserManager+FamilyMember.h"
#import "TipHandler+HUD.h"
#import "SettingViewController.h"


@interface PersonalViewController ()

//@property (nonatomic, strong) NSMutableArray *memberArray;
//@property NSInteger selectedMemberIndex;
//
//@property (nonatomic, strong) FamilyMemberListView *memberListView;

@end

@implementation PersonalViewController

- (id)initWithPageName:(NSString *)pageName
{
    self = [super initWithPageName:pageName];

    
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.title = @"个人中心";
    
    UIBarButtonItem *settingButtom = [[UIBarButtonItem alloc]initWithImage:[UIImage imageNamed:@"settingButtom"] style:UIBarButtonItemStyleBordered target:self action:@selector(turnToSettingView)];
    self.navigationItem.rightBarButtonItem = settingButtom;
    
    [self loadViewLoginInformation];
    [self loadViewMyDoctor];
    [self loadMyOrder];
    [self loadmine];


}


- (BOOL)hasTab
{
    return YES;
}

- (void)loadViewLoginInformation
{
    //创建个人信息区域，设置背景
    UIView *loginInformationView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, kScreenWidth, 60)];
    loginInformationView.backgroundColor = UIColorFromHex(0xf7fcf4);
    
    //创建圆形头像区域
    UIImageView *personalFaceView = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"DoctorPortrait"]];
    personalFaceView.frame = CGRectMake(25,10,40,40);
    personalFaceView.layer.cornerRadius = personalFaceView.frame.size.width / 2;
    personalFaceView.clipsToBounds = YES;
    [loginInformationView addSubview:personalFaceView];
    
    //创建信息区域
    UILabel *line1 = [[UILabel alloc]initWithFrame:CGRectMake(90, 12, kScreenWidth-130, 14)];
    line1.text = @"昵称:XiXi      等级:1级";
    line1.font = [UIFont systemFontOfSize:12];
    line1.textColor = UIColorFromHex(0x999999);
    UILabel *line2 = [[UILabel alloc]initWithFrame:CGRectMake(90, 32, kScreenWidth-130, 14)];
    line2.text = @"账号:13588888888";
    line2.font = [UIFont systemFontOfSize:12];
    line2.textColor = UIColorFromHex(0x999999);
    [loginInformationView addSubview:line1];
    [loginInformationView addSubview:line2];
    
    [self.contentView addSubview:loginInformationView];
    
//    UIButton *consultationbutton = [UIButton buttonWithType:UIButtonTypeCustom];
//    consultationbutton.frame = CGRectMake(100, 400, kScreenWidth-200, 40);
//    consultationbutton.backgroundColor = [UIColor redColor];
//    [consultationbutton addTarget:self action:@selector(consultationShowAction) forControlEvents:UIControlEventTouchUpInside];
//    [self.contentView addSubview:consultationbutton];
}

#pragma mark - temp Action
- (void)consultationShowAction
{
    ConsultationListController *consultationLC = [[ConsultationListController alloc] init];
    [self.slideNavigationController pushViewController:consultationLC animated:YES];
}



-(void)loadViewMyDoctor{
    //设置我的医生View区域大小
    UIView *myDoctorView = [[UIView alloc]initWithFrame:CGRectMake(0,60, kScreenWidth,100)];
    
    //添加我的医生标题
    TitleView *myDoctorTitleView = [[TitleView alloc]initWithFrame:CGRectMake(0, 0, kScreenWidth, 30) title:@"我的医生"];
    
    //添加我的医生头像View
    PersonalDoctorView *myDoctorFaceView = [[PersonalDoctorView alloc]init];
    
    //添加更多医生向右箭头按钮
    UIButton *moreMyDoctorButton = [[UIButton alloc]initWithFrame:CGRectMake(kScreenWidth-25, 55, 7, 12.5)];
    moreMyDoctorButton.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"moreDoctor"]];
    [moreMyDoctorButton addTarget:self action:@selector(turnToMoreMyDoctor) forControlEvents:UIControlEventTouchUpInside];

    [myDoctorView addSubview:myDoctorTitleView];
    [myDoctorView addSubview:myDoctorFaceView];
    [myDoctorView addSubview:moreMyDoctorButton];
    [self.contentView addSubview:myDoctorView];
}

- (void)loadMyOrder{
    //设置我的约诊View区域大小
    UIView *myOrderView = [[UIView alloc]initWithFrame:CGRectMake(0,170, kScreenWidth, self.contentView.frame.size.height-60-100-110-49)];
    myOrderView.userInteractionEnabled=YES;
    
    //添加我的约诊标题
    TitleView *myOrderTitleView = [[TitleView alloc]initWithFrame:CGRectMake(0,0, kScreenWidth, 30) title:@"已约诊"];
    
    //添加约诊详情
    PersonalOrderView *myOrderContentView = [[PersonalOrderView alloc]initWithFrame:CGRectMake(0, 0, kScreenWidth, myOrderView.frame.size.height) OrderID:100];
//    myOrderContentView.backgroundColor = [UIColor redColor];
    
    NSLog(@"kH = %@",self.contentView.frame.size.height);
    [myOrderView addSubview:myOrderContentView];
    [myOrderView addSubview:myOrderTitleView];
    [self.contentView addSubview:myOrderView];

}

- (void)loadmine{
    UIView *mineView = [[UIView alloc]initWithFrame:CGRectMake(0, self.contentView.frame.size.height -110, kScreenWidth, 110)];
    
    TitleView *mineTitleView = [[TitleView alloc]initWithFrame:CGRectMake(0, 0, kScreenWidth, 30) title:@"我的"];
    
    //收藏按钮
    //收藏按钮图片
    UIButton *collectionButton = [[UIButton alloc]initWithFrame:CGRectMake((kScreenWidth - 56*4)/8, 30, 56, 56)];
    collectionButton.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"pic1"]];
    [collectionButton addTarget:self action:@selector(turnToCollectionView) forControlEvents:UIControlEventTouchUpInside];
    //收藏按钮Lable
    UILabel *collectionLable = [[UILabel alloc]initWithFrame:CGRectMake((kScreenWidth - 56*4)/8,91, 56, 14)];
    collectionLable.text = @"收藏";
    collectionLable.font = [UIFont systemFontOfSize:14];
    collectionLable.textAlignment = UITextAlignmentCenter;
    
    //记录按钮
    //记录按钮图片
    UIButton *recordButton = [[UIButton alloc]initWithFrame:CGRectMake((kScreenWidth - 56*4)/8*3+56, 30, 56, 56)];
    recordButton.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"pic2"]];
    [recordButton addTarget:self action:@selector(turnToRecordView) forControlEvents:UIControlEventTouchUpInside];
    //记录按钮Lable
    UILabel *recordLable = [[UILabel alloc]initWithFrame:CGRectMake((kScreenWidth - 56*4)/8*3+56,91, 56, 14)];
    recordLable.text = @"记录";
    recordLable.font = [UIFont systemFontOfSize:14];
    recordLable.textAlignment = UITextAlignmentCenter;
    
    //咨询按钮
    //咨询按钮图片
    UIButton *consultationButton = [[UIButton alloc]initWithFrame:CGRectMake((kScreenWidth - 56*4)/8*5+56*2, 30, 56, 56)];
    consultationButton.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"pic3"]];
    [consultationButton addTarget:self action:@selector(turnToConsultationView) forControlEvents:UIControlEventTouchUpInside];
    //咨询按钮Lable
    UILabel *consultationLable = [[UILabel alloc]initWithFrame:CGRectMake((kScreenWidth - 56*4)/8*5+56*2,91, 56, 14)];
    consultationLable.text = @"咨询";
    consultationLable.font = [UIFont systemFontOfSize:14];
    consultationLable.textAlignment = UITextAlignmentCenter;
    
    //账户按钮
    //账户按钮图片
    UIButton *myAccountButton = [[UIButton alloc]initWithFrame:CGRectMake((kScreenWidth - 56*4)/8*7+56*3, 30, 56, 56)];
    myAccountButton.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"pic4"]];
    [myAccountButton addTarget:self action:@selector(turnToMyAccountView) forControlEvents:UIControlEventTouchUpInside];
    //账户按钮Lable
    UILabel *myAccountLable = [[UILabel alloc]initWithFrame:CGRectMake((kScreenWidth - 56*4)/8*7+56*3,91, 56, 14)];
    myAccountLable.text = @"账户";
    myAccountLable.font = [UIFont systemFontOfSize:14];
    myAccountLable.textAlignment = UITextAlignmentCenter;
    
    [mineView addSubview:mineTitleView];
    
    [mineView addSubview:collectionButton];
    [mineView addSubview:collectionLable];
    [mineView addSubview:recordButton];
    [mineView addSubview:recordLable];
    [mineView addSubview:consultationButton];
    [mineView addSubview:consultationLable];
    [mineView addSubview:myAccountButton];
    [mineView addSubview:myAccountLable];
    
    [self.contentView addSubview:mineView];
}

- (void)turnToMoreMyDoctor{
    NSLog(@"跳转到更多我的医生");
}

- (void)turnToRecordView{
    NSLog(@"跳转到记录页面");
}

- (void)turnToConsultationView{
    NSLog(@"跳转到咨询页面");
    ConsultationListController *consultationLC = [[ConsultationListController alloc] init];
    [self.slideNavigationController pushViewController:consultationLC animated:YES];
}

- (void)turnToMyAccountView{
    NSLog(@"跳转到账户页面");
}

- (void)turnToCollectionView{
    NSLog(@"跳转到收藏页面");
}


- (void)didLingin {

}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)turnToSettingView{
    NSLog(@"跳转到设置页面");
    SettingViewController *settingViewController = [[SettingViewController alloc] init];
    [self.slideNavigationController pushViewController:settingViewController animated:YES];
    

}


#pragma mark - Navigation


@end
 
 
