//
//  UserViewController.m
//  FindDoctor
//
//  Created by Guo on 15/9/18.
//  Copyright (c) 2015年 li na. All rights reserved.
//
#import "CUUserManager.h"
#import "LoginViewController.h"

#import "UserViewController.h"
#import "LoginView.h"
#import "CUPlatFormManager.h"
#import "TitleView.h"

#import "UserHeaderView.h"
#import "BigButtonsInUser.h"

#import "YueZhenRecordViewController.h"
#import "YueZhenRecordListModel.h"

#import "TreatmentOrderListModel.h"
#import "TreatmentOrderListViewController.h"

#import "ZhenLiaoRecordViewController.h"
#import "ZhenLiaoRecordListModel.h"

#import "MyAccountMainViewController.h"

#import "CommentListViewController.h"
#import "CommentListModel.h"

#import "TreatmentListAndDetailManager.h"

#import "AppDelegate.h"
#import "CUUserManager.h"

#import "TreatmentOrderListModel.h"
#import "TreatmentOrderListViewController.h"
#import "CUUserManager.h"

#import "UIImageView+WebCache.h"
@interface UserViewController ()
{
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
    [self initData];
    
    _contentTableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 0, kScreenWidth, self.contentView.frame.size.height-49) style:UITableViewStylePlain];
    _contentTableView.delegate = self;
    _contentTableView.dataSource = self;
    _contentTableView.separatorInset = UIEdgeInsetsMake(0, -80, 0, 0);
    _contentTableView.separatorStyle = UITableViewCellSelectionStyleNone;
    _contentTableView.backgroundColor = UIColorFromHex(Color_Hex_ImageDefault);
    [self.contentView  addSubview:_contentTableView];
}

- (void)initData{
    contentTableViewCellIcon = @[@"button_fans",@"button_appointments",@"button_clinics",@"button_advise",@"button_accounts",@"button_prise"];
    contentTableViewCellText = @[@"我的放号",@"约诊记录",@"诊疗记录",@"我的点评",@"我的账户",@"退出登录"];
}

#pragma mark - didLogin == NO

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
        return 116;
    }
    if(indexPath.row == contentTableViewCellText.count){
        return 63+24;
    }
    return 63;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.row == 0) {
        UITableViewCell *cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:nil];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        cell.backgroundColor = UIColorFromHex(Color_Hex_ImageDefault);
        
        UserHeaderView *userHeaderView = [[UserHeaderView alloc]initWithFrame:CGRectMake(0, 9, kScreenWidth, 95)];
        [cell addSubview:userHeaderView];
        
        return cell;
    }
    
    if(indexPath.row == contentTableViewCellText.count){
        UITableViewCell *cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:nil];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        cell.backgroundColor = UIColorFromHex(Color_Hex_ImageDefault);
        
        UIButton *resignButton = [[UIButton alloc]initWithFrame:CGRectMake(26, 24, kScreenWidth-52, 40)];
        resignButton.layer.cornerRadius = 20;
        resignButton.clipsToBounds = YES;
        resignButton.layer.backgroundColor = UIColorFromHex(0xe15f31).CGColor;
        [resignButton setTitle:@"退出当前账号" forState:UIControlStateNormal];
        [resignButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [resignButton addTarget:self action:@selector(resignAction) forControlEvents:UIControlEventTouchUpInside];
        [cell addSubview:resignButton];
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
        //我的点评
        case 4:
        {
            CommentListModel *listModel = [[CommentListModel alloc] initWithSortType:1];
            CommentListViewController *detailVC = [[CommentListViewController alloc]initWithPageName:@"CommentListViewController" listModel:listModel];
            [self.slideNavigationController pushViewController:detailVC animated:YES];
            break;
        }
        //我的账户
        case 5:
        {
            [[TreatmentListAndDetailManager sharedInstance] getMyAccountWithResultBlock:^(SNHTTPRequestOperation *request, SNServerAPIResultData *result) {
                MyAccountMainViewController   *myAccountVC = [[MyAccountMainViewController alloc]initWithPageName:@"MyAccountMainViewController"];
                myAccountVC.data = result.parsedModelObject;
                [self.slideNavigationController pushViewController:myAccountVC animated:YES];
            } pageName:@"MyAccount"];
            break;
        }
    
        case 6 :
        {
            break;
        }
            
        default:{
            break;
        }
    }
    

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


/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
