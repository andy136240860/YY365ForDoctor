//
//  CommentListViewController.m
//  FindDoctor
//
//  Created by Guo on 15/9/29.
//  Copyright (c) 2015年 li na. All rights reserved.
//

#import "CommentListViewController.h"
#import "FlagView.h"
#import "DOPDropDownMenu.h"
#import "CommentCell.h"
#import "TipHandler+HUD.h"
#import "TitleView.h"

@interface CommentListViewController () <DOPDropDownMenuDataSource, DOPDropDownMenuDelegate>
{
    FlagView        *flagView;
    NSInteger       _cellHeight;
}
@property (nonatomic,strong) DOPDropDownMenu *dropdownMenu;

@property (nonatomic,strong) NSArray *titleArray;

@property (nonatomic,strong) NSArray *timeArray;
@property (nonatomic,strong) NSArray *levelArray;

@end

@implementation CommentListViewController
@dynamic listModel;

- (id)initWithPageName:(NSString *)pageName listModel:(SNBaseListModel *)listModel
{

    self = [super initWithPageName:pageName listModel:listModel];
    
    if (self) {
        self.titleArray = @[@"时间从前往后", @"等级从高到低"];
        self.timeArray = @[@"时间从前往后", @"时间从后往前"];
        self.levelArray = @[@"等级从高到低", @"等级从低到高"];

    }
    
    return self;
}


- (void)viewDidLoad {
    self.title = @"我的点评";
    self.contentTableView.backgroundColor = UIColorFromHex(Color_Hex_ImageDefault);
    self.hasFreshControl = NO;
    [super viewDidLoad];
}

- (void)viewWillAppear:(BOOL)animated{

}

- (void)loadContentView{
    [super loadContentView];
    
//    self.dropdownMenu = [[DOPDropDownMenu alloc] initWithOrigin:CGPointMake(0, 0) andHeight:40*Width_AdaptedFactor];
//    self.dropdownMenu.dataSource = self;
//    self.dropdownMenu.delegate = self;
//    [self.contentView addSubview:self.dropdownMenu];
    flagView = [[FlagView alloc]initWithFrame:CGRectMake(0, 0, kScreenWidth, 110)];
    [self.contentView addSubview:flagView];
    
    TitleView *title = [[TitleView alloc]initWithFrame:CGRectMake(0, flagView.maxY+5, kScreenWidth, 30) title:@"用户评价"];
    [self.contentView addSubview:title];
    
    self.contentTableView.frame = CGRectMake(0, 145, self.contentTableView.frameWidth, self.contentTableView.frameHeight-145);
    
    [self setShouldLoadMoreControl];

}

- (void)loadNavigationBar
{
    [self addLeftBackButtonItemWithImage];
}

- (void)triggerRefresh
{
    self.listModel.filter.lastID = 0;
    
    [self.freshControl beginRefreshing];
    [self.loadMoreControl endLoading];
    self.listModel.isLoading = YES;
    __block __weak CUListViewController * blockSelf = self;

    [self.listModel gotoFirstPage:^(SNHTTPRequestOperation *request, SNServerAPIResultData *result) {
        
        blockSelf.listModel.isLoading = NO;
        [blockSelf.freshControl endRefreshing];
        if (!result.hasError)
        {
            NSInteger err_code = [result.responseObject integerForKeySafely:@"errorCode"];
            if (err_code == 0){
                // height
                [self.heightDictOfCells removeAllObjects];
                
                [self.freshControl refreshLastUpdatedTime:[NSDate date]];
                [blockSelf.contentTableView reloadData];
                
                // footer
                if ([blockSelf.listModel hasNext])
                {
                    blockSelf.contentTableView.tableFooterView = self.loadMoreControl;
                }
                else
                {
                    blockSelf.contentTableView.tableFooterView = [[UIView alloc] initWithFrame:CGRectZero];
                    ;
                }
                CommentListModel *listModel = result.parsedModelObject;
                flagView.data = listModel.data;
                [flagView setMark];
            }
            else{
//                [TipHandler showHUDText:@"登陆  异常" inView:blockSelf.view];
            }
        }
        else
        {
            [TipHandler showHUDText:[result.error.userInfo valueForKey:NSLocalizedDescriptionKey] inView:blockSelf.view];
            
        }
        
        // 添加空页面
        if ([blockSelf.listModel.items count] == 0)
        {
            blockSelf.emptyView.hidden = NO;
        }
        else // 隐藏空页面
        {
            blockSelf.emptyView.hidden = YES;
        }
    }];
}

- (void)triggerLoadMore
{    
    [self.freshControl endRefreshing];
    self.listModel.isLoading = YES;
    [self.loadMoreControl beginLoading];
    __block __weak CUListViewController * blockSelf = self;
    [self.listModel gotoNextPage:^(SNHTTPRequestOperation *request, SNServerAPIResultData *result) {
        blockSelf.listModel.isLoading = NO;
        [blockSelf.loadMoreControl endLoading];
        if (!result.hasError)
        {
            [blockSelf.contentTableView reloadData];
            if ([blockSelf.listModel hasNext])
            {
                blockSelf.contentTableView.tableFooterView = self.loadMoreControl;
            }
            else
            {
                blockSelf.contentTableView.tableFooterView = [[UIView alloc] initWithFrame:CGRectZero];
                ;
            }
        }
        else
        {
            [TipHandler showHUDText:[result.error.userInfo valueForKey:NSLocalizedDescriptionKey] inView:blockSelf.view];
            
        }
    }];
}

#pragma mark ------------------ tableView Delegate --------------------

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.listModel.items.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (!_cellHeight) {
        return 1;
    }
    return _cellHeight;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSString * CellID = [NSString stringWithFormat:@"Cell%d",(NSInteger)indexPath.row];
    CommentCell * cell = [[CommentCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellID];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    
    if (self.listModel.items > 0) {
        cell.data = [self.listModel.items objectAtIndexSafely:indexPath.row];
        _cellHeight = [cell CellHeight];
    }
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}

#pragma mark ------------------ dropdown menu -------------------------
// dropdown menu

- (NSInteger)numberOfColumnsInMenu:(DOPDropDownMenu *)menu
{
    return [self.titleArray count];
}

- (NSString *)menu:(DOPDropDownMenu *)menu initMenuTitleInColum:(NSInteger)column
{
    return self.titleArray[column];
}


- (NSInteger)menu:(DOPDropDownMenu *)menu numberOfRowsInColumn:(NSInteger)column
{
    NSInteger rows = 0;
    switch (column)
    {
        case 0: rows = [self.timeArray count];
            break;
        case 1: rows = [self.levelArray count];
            break;
        default:
            break;
    }
    return rows;
    
}

- (NSString *)menu:(DOPDropDownMenu *)menu titleForRowAtIndexPath:(DOPIndexPath *)indexPath
{
    NSString * title = nil;
    switch (indexPath.column)
    {
        case 0:
        {
            title = [self.timeArray objectAtIndexSafely:indexPath.row];
        }
            break;
        case 1:
        {
            title = [self.levelArray objectAtIndexSafely:indexPath.row];
        }
            break;
        default:
            break;
    }
    return title;
}

- (void)menu:(DOPDropDownMenu *)menu didSelectRowAtIndexPath:(DOPIndexPath *)indexPath
{
    // 点击第一个，即‘全部’
    if (indexPath.row == 0)
    {
        [self.dropdownMenu updateMenuTitle:self.titleArray[indexPath.column] inColumn:indexPath.column];
    }
    
    // TODO:filter设置
    [self triggerRefresh];
}


- (void)menu:(DOPDropDownMenu *)menu didTappedColumn:(NSInteger)column
{}


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
