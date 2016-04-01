//
//  HomeViewController.m
//  EShiJia
//
//  Created by zhouzhenhua on 15-4-19.
//  Copyright (c) 2015年 li na. All rights reserved.
//

#import "HomeViewController.h"
#import "UIConstants.h"
#import "CUUIContant.h"
#import "UIImage+Color.h"
#import "HomeTipView.h"

#import "OfferOrderViewController2.h"

#import "TreatmentListAndDetailManager.h"
#import "WeatherManager.h"

#import "CUUserManager.h"
#import "AppDelegate.h"

#import "TipHandler+HUD.h"

#import "TreatmentOrderButtonView.h"

#define HomeValue(x)   AdaptedValue(x)

#define kHomeHeaderViewHeight   HomeValue(200.0)

@interface HomeViewController (){
    NSMutableArray *dataArray;
    NSMutableArray *tipDataArray;
    NSInteger   tipLineNum;
}

@end

@implementation HomeViewController
@synthesize tipTableView;

- (void)addNotifications
{}

- (id)initWithPageName:(NSString *)pageName
{
    self = [super initWithPageName:pageName];
    
    if (self) {
        _hasNavigationBar = NO;
    }
    
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self addNotifications];
}

- (void)viewWillAppear:(BOOL)animated
{
    [[TreatmentListAndDetailManager sharedInstance] getHomeTipListWithResultBlock:^(SNHTTPRequestOperation *request, SNServerAPIResultData *result) {
        if (dataArray == nil){
            dataArray = [NSMutableArray new];
        }
        if (!result.hasError) {
            NSInteger err_code = [result.responseObject integerForKeySafely:@"errorCode"];
            if (err_code == 0) {
                dataArray = result.parsedModelObject;
                tipDataArray = [NSMutableArray new];
                for (int i = 0 ; i < (dataArray.count < tipLineNum + 1 ? dataArray.count : tipLineNum + 1); i++) {
                    [tipDataArray addObject:[dataArray objectAtIndex:i]];
                }
                [tipTableView reloadData];
                [NSObject cancelPreviousPerformRequestsWithTarget:self selector:@selector(scroll) object:nil];
                [self performSelector:@selector(scroll) withObject:nil afterDelay:3.f];
            }
            else{
                [TipHandler showHUDText:[result.responseObject valueForKeySafely:@"data"]  inView:self.view];
            }
        }
        else{
            [TipHandler showHUDText:@"连接服务器失败，请检查网络" inView:self.view];
        }
        
    } pageName:@"HomeViewController"];
    
    //天气
    [[WeatherManager sharedInstance] getWeatherWithResultBlock:^(SNHTTPRequestOperation *request, SNServerAPIResultData *result) {
        if (!result.hasError) {
            
        }
    } pageName:@"HomeViewController"];
    
    [super viewWillAppear:animated];
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)setShouldHaveTab
{
    self.hasTab = YES;
}

- (void)loadNavigationBar
{
    
}

- (void)loadContentView
{
    UIImageView *backgroundImageView = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"background"]];
    backgroundImageView.frame = self.contentView.frame;
    backgroundImageView.contentMode = 0;
    [self.contentView addSubview:backgroundImageView];
    [self initButton];
//    [self initSearchEntrance];
//    [self initCollectionButton];
}

- (void)initButton
{
    UIImage *findDoctor = [UIImage imageNamed:@"button_release_num"];

    TreatmentOrderButtonView *treatmentOrderButton = [[TreatmentOrderButtonView alloc]initWithFrame:CGRectMake((kScreenWidth-findDoctor.size.width)/2.0f, 40, findDoctor.size.width, findDoctor.size.height)];
    treatmentOrderButton.clickButtonBlock = ^{
        [self offerOrderAction];
    };
    [self.contentView addSubview:treatmentOrderButton];
    

    if (tipTableView == nil) {
        tipTableView = [[UITableView alloc]init];
    }
    tipTableView.frame = CGRectMake(kScreenWidth *0.05, CGRectGetMaxY(treatmentOrderButton.frame) + 40, kScreenWidth*0.9,  floor((([self.contentView frameHeight]-CGRectGetMaxY(treatmentOrderButton.frame) )/ 40))*40 - 40);
    tipLineNum = tipTableView.frameHeight/40;
    tipTableView.backgroundColor = [UIColor clearColor];
    tipTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    tipTableView.scrollEnabled = NO;
    tipTableView.delegate = self;
    tipTableView.dataSource = self;
//    tipTableView.userInteractionEnabled =NO;
    [self.contentView addSubview:tipTableView];

}

#pragma mark - tableViewDelegate

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return tipDataArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{

    UITableViewCell *cell = [[UITableViewCell alloc]init];
    
    //数据倒入
    TipMessageData *data = [tipDataArray objectAtIndex:indexPath.row];
    //画图
    [cell setFrameWidth:kScreenWidth*0.9];
    cell.backgroundColor = [UIColor clearColor];
    
    UIImageView *backgroundView0 = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, cell.frame.size.width, cell.frame.size.height - 4)];
    backgroundView0.image = [UIImage imageNamed:@"tipTableViewCellBackground"];
    backgroundView0.contentMode = UIViewContentModeScaleToFill;
    backgroundView0.clipsToBounds = YES;
    [cell addSubview:backgroundView0];
    
    UIImageView *backgroundView = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, cell.frame.size.width, cell.frame.size.height - 4)];
    backgroundView.image = [UIImage imageNamed:@"tipTableViewCellBackground"];
    backgroundView.contentMode = UIViewContentModeScaleToFill;
    backgroundView.clipsToBounds = YES;
    
    cell.selectedBackgroundView = backgroundView;
    
    UILabel *label = [[UILabel alloc]initWithFrame:CGRectMake(30, -2, [cell frameWidth]-60, [cell frameHeight])];
    label.textAlignment = NSTextAlignmentLeft;
    label.font = [UIFont systemFontOfSize:13];
    label.lineBreakMode = 1;
    label.text = data.title;
    label.textColor = [UIColor whiteColor];
    [cell addSubview:label];
    
    UIImageView *separatorLine = [[UIImageView alloc]initWithFrame:CGRectMake(30, [cell frameHeight]-5, [label frameWidth],2)];
    separatorLine.image = [UIImage imageNamed:@"HomeTipViewInterval"];
    separatorLine.contentMode = 0;
    [cell addSubview:separatorLine];

    
    return cell;
}


- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 40;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    [self performSelector:@selector(deselect) withObject:nil afterDelay:0.5f];
}

- (void)deselect{
    [self.tipTableView deselectRowAtIndexPath:[self.tipTableView indexPathForSelectedRow] animated:YES];
}

- (void)scrollViewDidEndScrollingAnimation:(UIScrollView *)scrollView{
    [self.tipTableView scrollToRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:0] atScrollPosition:UITableViewScrollPositionTop animated:NO];
    [self resetData];
    [self.tipTableView reloadData];
    [self performSelector:@selector(scroll) withObject:nil afterDelay:3.f];
}

- (void)resetData{
    NSInteger index = [dataArray indexOfObject:[tipDataArray objectAtIndex:1]];
    tipDataArray = [NSMutableArray new];
    for (int i = 0; i < tipLineNum + 1; i++) {
        [tipDataArray addObject:[dataArray objectAtIndex:index]];
        if (index == dataArray.count - 1) {
            index = -1;
        }
        index++;
    }
}

- (void)scroll{
    if (tipDataArray.count > 1){
        [self.tipTableView scrollToRowAtIndexPath:[NSIndexPath indexPathForRow:1 inSection:0] atScrollPosition:UITableViewScrollPositionTop animated:YES];
    }
}
#pragma mark - 其他

//临时创建搜索入口
- (void)initSearchEntrance
{
    UIButton *searchbutton = [UIButton buttonWithType:UIButtonTypeCustom];
    searchbutton.frame = (CGRect){50,100,100,80};
    [searchbutton setTitle:@"搜索" forState:UIControlStateNormal];
    searchbutton.backgroundColor = [UIColor redColor];
    [searchbutton addTarget:self action:@selector(searchAction) forControlEvents:UIControlEventTouchUpInside];
    [self.contentView addSubview:searchbutton];
}

//临时创建我的收藏
- (void)initCollectionButton
{
    UIButton *searchbutton = [UIButton buttonWithType:UIButtonTypeCustom];
    searchbutton.frame = (CGRect){200,100,100,80};
    [searchbutton setTitle:@"我的收藏" forState:UIControlStateNormal];
    searchbutton.backgroundColor = [UIColor redColor];
    [searchbutton addTarget:self action:@selector(showMyCollection) forControlEvents:UIControlEventTouchUpInside];
    [self.contentView addSubview:searchbutton];
}

- (void)offerOrderAction{
    OfferOrderViewController2 *offerorderVC = [[OfferOrderViewController2 alloc] init];
    [self.slideNavigationController pushViewController:offerorderVC animated:YES];

}



#pragma mark - Private Func

- (void)loginAction
{}

@end
