//
//  UserViewController.m
//  FindDoctor
//
//  Created by Guo on 15/9/18.
//  Copyright (c) 2015年 li na. All rights reserved.
//
#import "CUUserManager.h"
#import "LoginViewController.h"
#import "AppDelegate.h"
#import "CUUser.h"

#import "UserViewController.h"
#import "LoginView.h"
#import "CUPlatFormManager.h"
#import "TitleView.h"

#import "OfferOrderViewController.h"

#import "MyFansListViewController.h"
#import "MyFansListModel.h"

#import "YueZhenRecordViewController.h"
#import "YueZhenRecordListModel.h"

#import "ZhenLiaoRecordViewController.h"
#import "ZhenLiaoRecordListModel.h"

//#import "MyAccountMain.h"
#import "MyAccountMainViewController.h"

#import "TreatmentOrderListModel.h"
#import "TreatmentOrderListViewController.h"
#import "CUUserManager.h"

#import "UIImageView+WebCache.h"
@interface UserViewController ()
{
    LoginView *loginView;
    NSArray *contentTableViewCellIcon;
    NSArray *contentTableViewCellText;
}

@end

@implementation UserViewController


- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.title = @"我的空间";

    [self loadMyCenter];

    // Do any additional setup after loading the view.
}


-(void)loadMyCenter{
    if (loginView) {
        loginView = nil;
    }
    [self initData];
    
    _contentTableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 0, kScreenWidth, self.contentView.frame.size.height-49) style:UITableViewStylePlain];
    _contentTableView.delegate = self;
    _contentTableView.dataSource = self;
    _contentTableView.separatorInset = UIEdgeInsetsMake(0, -80, 0, 0);
    _contentTableView.separatorStyle = UITableViewCellSelectionStyleNone;
    
    [self.contentView  addSubview:_contentTableView];
}

- (void)initData{
    contentTableViewCellIcon = @[@"button_fans",@"button_appointments",@"button_clinics",@"button_advise",@"button_prise",@"button_accounts"];
    contentTableViewCellText = @[@"放号管理",@"约诊记录",@"诊疗记录",@"退出登录"];
    
}

#pragma mark - didLogin == NO

-(void)loadLogView{
    loginView = [[LoginView alloc]initWithFrame:CGRectMake(0, 0, kScreenWidth, self.contentView.frame.size.height-49)];
    [self.contentView addSubview:loginView];
}



- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


#pragma mark - TableView代理方法

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    NSLog(@"计算分组数");
    return 1;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    NSLog(@"计算每组(组)行数");
    return contentTableViewCellText.count+1;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if(indexPath.row == 0){
        return 112;
    }
    return 63;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.row == 0) {
        UITableViewCell *cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:nil];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        cell.backgroundColor = UIColorFromHex(0xf3facd);
        
        //创建圆形头像区域
        UIImageView *personalFaceView = [[UIImageView alloc]init];
        [personalFaceView setImageWithURL:[CUUserManager sharedInstance].user.icon placeholderImage:[UIImage imageNamed:@"DefaultHeaderImage"]];
        personalFaceView.frame = CGRectMake(25,25,60,60);
        personalFaceView.layer.cornerRadius = personalFaceView.frame.size.width / 2;
        personalFaceView.clipsToBounds = YES;
        [cell.contentView addSubview:personalFaceView];
        
        //创建信息区域
        UILabel *line0 = [[UILabel alloc]initWithFrame:CGRectMake(110, 12+15, kScreenWidth-130, 14)];
        line0.text = [NSString stringWithFormat:@"%@",[CUUserManager sharedInstance].user.nickName];
        line0.font = [UIFont systemFontOfSize:14];
        line0.textColor = UIColorFromHex(0x030303);
        UILabel *line1 = [[UILabel alloc]initWithFrame:CGRectMake(110, 12+35, kScreenWidth-130, 14)];
        line1.text = [NSString stringWithFormat:@"ID : %ld",[CUUserManager sharedInstance].user.userId];
        line1.font = [UIFont systemFontOfSize:12];
        line1.textColor = UIColorFromHex(0x454545);
        UILabel *line2 = [[UILabel alloc]initWithFrame:CGRectMake(110, 32+35, kScreenWidth-130, 14)];
        line2.text = [NSString stringWithFormat:@"手机号 : %@",[CUUserManager sharedInstance].user.cellPhone];
        line2.font = [UIFont systemFontOfSize:12];
        line2.textColor = UIColorFromHex(0x454545);
        [cell.contentView addSubview:line0];
        [cell.contentView addSubview:line1];
        [cell.contentView addSubview:line2];
        
        return cell;
    }
    
    if(indexPath.row == contentTableViewCellText.count){
        UITableViewCell *cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:nil];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        
        UIView *buttonView = [[UIView alloc]initWithFrame:CGRectMake(15, 5, kScreenWidth-30, cell.frame.size.height-10)];
        buttonView.layer.cornerRadius = 5;
        buttonView.layer.backgroundColor = [UIColor redColor].CGColor;
        [cell.contentView addSubview:buttonView];
        
        UILabel *buttonLable = [[UILabel alloc]initWithFrame:CGRectMake(0, 0, [buttonView frameWidth], [buttonView frameHeight])];
        buttonLable.text = @"退 出 登 录";
        buttonLable.textColor = [UIColor whiteColor];
        buttonLable.textAlignment = NSTextAlignmentCenter;
        [buttonView addSubview:buttonLable];
        return cell;

    }

    UITableViewCell *cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:nil];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;

    cell.imageView.image = [UIImage imageNamed:[contentTableViewCellIcon objectAtIndex:(indexPath.row -1)]];
    cell.textLabel.text = [contentTableViewCellText objectAtIndex:(indexPath.row - 1)];
    cell.textLabel.font = [UIFont systemFontOfSize:13];
    
    cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    
    UIView *lineView = [[UIView alloc]initWithFrame:CGRectMake(20, 62.5, kScreenWidth-20, 0.5)];
    lineView.backgroundColor = UIColorFromHex(0xcccccc);
    [cell.contentView addSubview:lineView];
    return cell;

}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    switch (indexPath.row) {
        case 0:
            break;
        case 1:{
            TreatmentOrderListModel *treatmentOrderListModel = [[TreatmentOrderListModel alloc] initWithSortType:TreatmentOrderSortTypetime];
            TreatmentOrderListViewController *TreatmentOrderListVC = [[TreatmentOrderListViewController alloc]initWithPageName:@"TreatmentOrderListViewController" listModel:treatmentOrderListModel];
            [self.slideNavigationController pushViewController:TreatmentOrderListVC animated:YES];
            break;
        }
        //约诊记录
        case 2:{
            YueZhenRecordListModel *YueZhenRecordListMode1 = [[YueZhenRecordListModel alloc] initWithSortType:YueZhenRecordSortTypetime];
            YueZhenRecordViewController *yueZhenRecordVC = [[YueZhenRecordViewController alloc]initWithPageName:@"YueZhenRecordViewController" listModel:YueZhenRecordListMode1];
            [self.slideNavigationController pushViewController:yueZhenRecordVC animated:YES];
            break;
        }
        //诊疗记录
        case 3:{
            ZhenLiaoRecordListModel *ZhenLiaoRecordListMode1 = [[ZhenLiaoRecordListModel alloc] initWithSortType:ZhenLiaoRecordSortTypetime];
            ZhenLiaoRecordViewController *zhenLiaoRecordVC = [[ZhenLiaoRecordViewController alloc]initWithPageName:@"ZhenLiaoRecordViewController" listModel:ZhenLiaoRecordListMode1];
            [self.slideNavigationController pushViewController:zhenLiaoRecordVC animated:YES];
            break;
        }
        //我的账户
//        case 4:
        {
            MyAccountMainViewController   *myAccountVC = [[MyAccountMainViewController alloc]initWithPageName:@"MyAccountMainViewController"];
            
//            MyAccountMain *fakeData = [[MyAccountMain alloc]init];
//            fakeData.expenditure = 315;
//            fakeData.zhenJinIncome = 100;
//            fakeData.totalPoints = 200;
//            fakeData.jinQiIncome = 300;
//            myAccountVC.data = fakeData;
            [self.slideNavigationController pushViewController:myAccountVC animated:YES];
            break;
        }
        //我的粉丝
        case 5:
//        {
//            MyFansListModel *myFansListMode1 = [[MyFansListModel alloc] initWithSortType:FansSortTypetime];
//            
//            for(int i = 0;i < 10;i++){
//                Fans *fan = [[Fans alloc] init];
//                fan.name = @"华佗";
//                fan.availableTime = @"2015-11-01 10:24";
//                if (i%2 ==0) {
//                    fan.isVIP = YES;
//                }
//                else{
//                    fan.isVIP = NO;
//                }
//                
//                [myFansListMode1.items addObject:fan];
//            }
//            
//            MyFansListViewController *MyFansVC = [[MyFansListViewController alloc]initWithPageName:@"MyFansListViewController" listModel:myFansListMode1];
//            [self.slideNavigationController pushViewController:MyFansVC animated:YES];
//            break;
//        }
            
        case 4 :
        {
            [[CUUserManager sharedInstance] clear];
            [[AppDelegate app] launchMainView];
            break;
        }
            
        default:{
//            OfferOrderViewController2  *VC = [[OfferOrderViewController2   alloc]init];
//            [self.slideNavigationController pushViewController:VC animated:YES];
            break;
        }
    }
    

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
