//
//  MyAccountMainViewController.m
//  FindDoctor
//
//  Created by Guo on 15/11/1.
//  Copyright © 2015年 li na. All rights reserved.
//

#import "MyAccountMainViewController.h"
#import "TotalMoneyView.h"
#import "ListMoneyView.h"

@interface MyAccountMainViewController ()
{
    UITableView *contentTableView;
    TotalMoneyView *incomeView;
    TotalMoneyView *costView;
    
    ListMoneyView *listMoneyView;
}

@end

@implementation MyAccountMainViewController

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    costView.fee = [NSString stringWithFormat:@"%.2lf",_data.totalCost];
    incomeView.fee = [NSString stringWithFormat:@"%.2lf",_data.totalIncome];
    [incomeView show];
    [costView show];
}

- (void)viewDidLoad {
    self.title = @"我的账户";
    [self loadContentView];
    [super viewDidLoad];
}

- (void)loadContentView{
    [self initTotalIncomeCostView];
    [self initListMoneyView];
    
//    [self loadContentTableView];
}

- (void)initTotalIncomeCostView{
    int diamater = 100;
    costView = [[TotalMoneyView alloc]initWithFrame:CGRectMake((kScreenWidth - 2*diamater)/3, 15, diamater, diamater) title:@"现金收入(元)" color:UIColorFromHex(Color_Hex_Text_Highlighted)];
    costView.userInteractionEnabled = YES;
    UITapGestureRecognizer *costViewTap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(costViewAction)];
    costViewTap.numberOfTapsRequired = 1;
    [costView addGestureRecognizer:costViewTap];
    [self.contentView addSubview:costView];
    
    incomeView = [[TotalMoneyView alloc]initWithFrame:CGRectMake(2*(kScreenWidth - 2*diamater)/3 + diamater, 15, diamater, diamater) title:@"诊金券收入(元)" color:UIColorFromHex(Color_Hex_NavBackground)];
    UITapGestureRecognizer *incomeViewTap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(incomeViewAction)];
    incomeViewTap.numberOfTapsRequired = 1;
    [incomeView addGestureRecognizer:incomeViewTap];
    [self.contentView addSubview:incomeView];

}

- (void)initListMoneyView{
    listMoneyView = [[ListMoneyView alloc]initWithFrame:CGRectMake(15, CGRectGetMaxY(incomeView.frame) + 15, kScreenWidth - 30, self.contentView.frameHeight - CGRectGetMaxY(incomeView.frame) - 15)];
    listMoneyView.data = self.data;
    [self.contentView addSubview:listMoneyView];
}

- (void)setData:(MyAccount *)data{
    _data = data;
}

- (void)costViewAction{
    [listMoneyView costButtonAction];
    [costView show];
}

- (void)incomeViewAction{
    [listMoneyView incomeButtonAction];
    [incomeView show];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}



- (void)loadNavigationBar
{
    [self addLeftBackButtonItemWithImage];
}




@end
