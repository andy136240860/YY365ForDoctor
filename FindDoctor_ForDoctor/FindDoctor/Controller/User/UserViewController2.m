//
//  UserViewController2.m
//  FindDoctor
//
//  Created by 晓炜 郭 on 15/12/21.
//  Copyright © 2015年 li na. All rights reserved.
//

#import "UserViewController2.h"
#import "UserHeaderView.h"
#import "BigButtonsInUser.h"

#import "YueZhenRecordViewController.h"
#import "YueZhenRecordListModel.h"

#import "TreatmentOrderListModel.h"
#import "TreatmentOrderListViewController.h"

#import "ZhenLiaoRecordViewController.h"
#import "ZhenLiaoRecordListModel.h"

#import "MyAccountMainViewController.h"

#import "TreatmentListAndDetailManager.h"

#import "AppDelegate.h"
#import "CUUserManager.h"

@interface UserViewController2 ()<UIAlertViewDelegate>

@end

@implementation UserViewController2

- (void)viewDidLoad {
    [super viewDidLoad];
    [self initSubView];
}

- (void)initSubView{
    _contentScrollView = [[UIScrollView alloc]initWithFrame:CGRectMake(0, 0, kScreenWidth, [self.contentView frameHeight] - 49)];
    _contentScrollView.backgroundColor = UIColorFromHex(Color_Hex_ImageDefault);
    [self.contentView addSubview:_contentScrollView];
    
    UserHeaderView *userHeaderView = [[UserHeaderView alloc]initWithFrame:CGRectMake(0, 9, kScreenWidth, 95)];
    [_contentScrollView addSubview:userHeaderView];
    
    BigButtonsInUser *myOrderButton = [[BigButtonsInUser alloc]initWithFrame:CGRectMake(0, CGRectGetMaxY(userHeaderView.frame) + 23, kScreenWidth/2 - 0.5, kScreenWidth/2 - 0.5)  image:[UIImage imageNamed:@"myOrder"] title:@"我的放号"];
    [myOrderButton addTarget:self action:@selector(myOrderAction) forControlEvents:UIControlEventTouchUpInside  ];

    BigButtonsInUser *yueZhenButton = [[BigButtonsInUser alloc]initWithFrame:CGRectMake(kScreenWidth/2+0.5, CGRectGetMaxY(userHeaderView.frame) + 23, kScreenWidth/2 - 0.5, kScreenWidth /2- 0.5)  image:[UIImage imageNamed:@"yueZhen"] title:@"约诊记录"];
    [yueZhenButton addTarget:self action:@selector(yueZhenRecordAction) forControlEvents:UIControlEventTouchUpInside  ];
    
    BigButtonsInUser *zhenLiaoButton = [[BigButtonsInUser alloc]initWithFrame:CGRectMake(0, CGRectGetMaxY(myOrderButton.frame) + 1, kScreenWidth/2 - 0.5, kScreenWidth/2 - 0.5)  image:[UIImage imageNamed:@"zhenLiao"] title:@"诊疗记录"];
    [zhenLiaoButton addTarget:self action:@selector(zhenLiaoRecordAction) forControlEvents:UIControlEventTouchUpInside  ];
    
    BigButtonsInUser *myAccoutButton = [[BigButtonsInUser alloc]initWithFrame:CGRectMake(kScreenWidth/2+0.5, CGRectGetMaxY(myOrderButton.frame) + 1, kScreenWidth/2 - 0.5, kScreenWidth/2 - 0.5)  image:[UIImage imageNamed:@"myAccount"] title:@"我的账户"];
    [myAccoutButton addTarget:self action:@selector(myAccountAction) forControlEvents:UIControlEventTouchUpInside  ];
    
    [_contentScrollView addSubview:myAccoutButton];
    [_contentScrollView addSubview:myOrderButton];
    [_contentScrollView addSubview:zhenLiaoButton];
    [_contentScrollView addSubview:yueZhenButton];
    

    
    UIButton *resignButton = [[UIButton alloc]initWithFrame:CGRectMake(26, CGRectGetMaxY(myAccoutButton.frame)+24, kScreenWidth-52, 40)];
    resignButton.layer.cornerRadius = 20;
    resignButton.clipsToBounds = YES;
    resignButton.layer.backgroundColor = UIColorFromHex(0xe15f31).CGColor;
    [resignButton setTitle:@"退出当前账号" forState:UIControlStateNormal];
    [resignButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [resignButton addTarget:self action:@selector(resignAction) forControlEvents:UIControlEventTouchUpInside];
    [_contentScrollView addSubview:resignButton];
    [_contentScrollView setContentSize:CGSizeMake(kScreenWidth,CGRectGetMaxY(resignButton.frame) + 15)];
}

- (void)myOrderAction{
    TreatmentOrderListModel *treatmentOrderListModel = [[TreatmentOrderListModel alloc] initWithSortType:TreatmentOrderSortTypetime];
    TreatmentOrderListViewController *TreatmentOrderListVC = [[TreatmentOrderListViewController alloc]initWithPageName:@"TreatmentOrderListViewController" listModel:treatmentOrderListModel];
    [self.slideNavigationController pushViewController:TreatmentOrderListVC animated:YES];
}

- (void)yueZhenRecordAction{
    YueZhenRecordListModel *YueZhenRecordListMode1 = [[YueZhenRecordListModel alloc] initWithSortType:YueZhenRecordSortTypetime];
    YueZhenRecordViewController *yueZhenRecordVC = [[YueZhenRecordViewController alloc]initWithPageName:@"YueZhenRecordViewController" listModel:YueZhenRecordListMode1];
    [self.slideNavigationController pushViewController:yueZhenRecordVC animated:YES];
}

- (void)zhenLiaoRecordAction{
    ZhenLiaoRecordListModel *ZhenLiaoRecordListMode1 = [[ZhenLiaoRecordListModel alloc] initWithSortType:ZhenLiaoRecordSortTypetime];
    ZhenLiaoRecordViewController *zhenLiaoRecordVC = [[ZhenLiaoRecordViewController alloc]initWithPageName:@"ZhenLiaoRecordViewController" listModel:ZhenLiaoRecordListMode1];
    [self.slideNavigationController pushViewController:zhenLiaoRecordVC animated:YES];
}

- (void)myAccountAction{
    MyAccountMainViewController   *myAccountVC = [[MyAccountMainViewController alloc]initWithPageName:@"MyAccountMainViewController"];
    [self.slideNavigationController pushViewController:myAccountVC animated:YES];
}

- (void)resignAction{
    UIAlertView *alert = [[UIAlertView alloc]initWithTitle:nil message:@"确认退出？" delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"确认", nil];
    alert.tag = 1;
    [alert show];

}

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex{
    if(alertView.tag == 1){
        if (buttonIndex == 0) {
            return;
        }
        if (buttonIndex == 1) {
            [[CUUserManager sharedInstance] clear];
            [[AppDelegate app] launchMainView];
        }
    }
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
