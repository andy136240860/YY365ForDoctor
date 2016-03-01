//
//  MyFansListViewController.m
//  FindDoctor
//
//  Created by Guo on 15/9/29.
//  Copyright (c) 2015年 li na. All rights reserved.
//

#import "MyFansListViewController.h"
#import "DOPDropDownMenu.h"
#import "FansCell.h"

@interface MyFansListViewController () <DOPDropDownMenuDataSource, DOPDropDownMenuDelegate>

@property (nonatomic,strong) DOPDropDownMenu *dropdownMenu;

@property (nonatomic,strong) NSArray *titleArray;

@property (nonatomic,strong) NSArray *timeArray;
@property (nonatomic,strong) NSArray *levelArray;

@end

@implementation MyFansListViewController

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
    self.title = @"我的粉丝";
    self.contentTableView.backgroundColor = UIColorFromHex(Color_Hex_ImageDefault);
    [super viewDidLoad];
//    NSString *test = @"而忘记二号 耳机昂昂昂诶他忘记二号 耳机昂昂昂诶他忘记二号 耳机昂昂昂诶他忘记二号 耳机昂昂昂诶他";
//    NSMutableParagraphStyle *paragraph = [[NSMutableParagraphStyle alloc] init];
//    paragraph.lineBreakMode = NSLineBreakByWordWrapping;
//    CGSize testSize = [test boundingRectWithSize:CGSizeMake(300,  MAXFLOAT) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:14],NSParagraphStyleAttributeName:paragraph} context:nil].size;
    // Do any additional setup after loading the view.
}

- (void)loadContentView{
    [super loadContentView];
    
    self.dropdownMenu = [[DOPDropDownMenu alloc] initWithOrigin:CGPointMake(0, 0) andHeight:40*Width_AdaptedFactor];
    self.dropdownMenu.dataSource = self;
    self.dropdownMenu.delegate = self;
    [self.contentView addSubview:self.dropdownMenu];
    

    
    self.contentTableView.frame = CGRectMake(0, self.dropdownMenu.frameHeight, self.contentTableView.frameWidth, self.contentTableView.frameHeight-self.dropdownMenu.frameHeight);
    
    [self setShouldLoadMoreControl];

}

- (void)loadNavigationBar
{
    [self addLeftBackButtonItemWithImage];
}


#pragma mark ------------------ tableView Delegate --------------------

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.listModel.items.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 74;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *cellIdentifier = @"DoctorCell";
    
    
    FansCell *cell = (FansCell *)[tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    
    if (cell == nil) {
        cell =  [[FansCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIdentifier];
    }
    cell.data = self.listModel.items[indexPath.row];
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
//    [tableView deselectRowAtIndexPath:indexPath animated:YES];
//    
//    DoctorDetailController *detailVC = [[DoctorDetailController alloc] initWithPageName:@"DoctorDetailController"];
//    detailVC.doctor = [self.listModel.items objectAtIndexSafely:indexPath.row];
//    [self.slideNavigationController pushViewController:detailVC animated:YES];
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
