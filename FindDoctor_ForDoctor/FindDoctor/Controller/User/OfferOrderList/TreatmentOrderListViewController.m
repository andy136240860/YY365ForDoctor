//
//  JiuZhenRecordViewController.m
//  
//
//  Created by Guo on 15/10/6.
//
//

#import "TreatmentOrderListViewController.h"
#import "DOPDropDownMenu.h"
#import "TreatmentOrderCell.h"
#import "TreatmentOrderManager.h"
#import "OfferOrderViewController2.h"

@interface TreatmentOrderListViewController ()<DOPDropDownMenuDataSource, DOPDropDownMenuDelegate>

@property (nonatomic,strong) DOPDropDownMenu *dropdownMenu;

@property (nonatomic,strong) NSArray *titleArray;

@property (nonatomic,strong) NSArray *timeArray;
@property (nonatomic,strong) NSArray *levelArray;

@end


@implementation TreatmentOrderListViewController

- (id)initWithPageName:(NSString *)pageName listModel:(SNBaseListModel *)listModel
{
    
    self = [super initWithPageName:pageName listModel:listModel];
    
    if (self) {
        self.titleArray = @[@"预约时间从前往后", @"等级从高到低"];
        self.timeArray = @[@"预约时间从前往后", @"预约时间从后往前"];
        self.levelArray = @[@"等级从高到低", @"等级从低到高"];
        
    }
    
    return self;
}

- (void)viewWillAppear:(BOOL)animated{
    [self triggerRefresh];
    [super viewWillAppear:animated];
}


- (void)viewDidLoad {
    self.title = @"放号管理";
    [super viewDidLoad];
    self.contentTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    self.contentTableView.backgroundColor = UIColorFromHex(Color_Hex_ImageDefault);
    //    NSString *test = @"而忘记二号 耳机昂昂昂诶他忘记二号 耳机昂昂昂诶他忘记二号 耳机昂昂昂诶他忘记二号 耳机昂昂昂诶他";
    //    NSMutableParagraphStyle *paragraph = [[NSMutableParagraphStyle alloc] init];
    //    paragraph.lineBreakMode = NSLineBreakByWordWrapping;
    //    CGSize testSize = [test boundingRectWithSize:CGSizeMake(300,  MAXFLOAT) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:14],NSParagraphStyleAttributeName:paragraph} context:nil].size;
    // Do any additional setup after loading the view.
}

- (void)loadContentView{
    [super loadContentView];
    
//    self.dropdownMenu = [[DOPDropDownMenu alloc] initWithOrigin:CGPointMake(0, 0) andHeight:40*Width_AdaptedFactor];
//    self.dropdownMenu.dataSource = self;
//    self.dropdownMenu.delegate = self;
//    [self.contentView addSubview:self.dropdownMenu];
//    
//    self.contentTableView.frame = CGRectMake(0, self.dropdownMenu.frameHeight, self.contentTableView.frameWidth, self.contentTableView.frameHeight-self.dropdownMenu.frameHeight);
//    
    self.contentTableView.frame = CGRectMake(0, 0, self.contentTableView.frameWidth, self.contentTableView.frameHeight);
    
    
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


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *cellIdentifier = @"DoctorCell";
    
    TreatmentOrderCell *cell = (TreatmentOrderCell *)[tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    
    if (cell == nil) {
        cell =  [[TreatmentOrderCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIdentifier];
    }
    cell.data = self.listModel.items[indexPath.row];
    cell.refreshDataBlock = ^{
        [self triggerRefresh];
    };
    cell.editOrderBlock = ^(TreatmentOrder *data){
        NSLog(@"Block到TableView获得orderno %lld",data.orderno);
        
        OfferOrderViewController2 *offerorderVC = [[OfferOrderViewController2 alloc]init];
        offerorderVC.data = data;
        [self.slideNavigationController pushViewController:offerorderVC animated:YES];
    };
    
    [cell setSelectionStyle:UITableViewCellSelectionStyleNone]; 
    
    return cell;
}


- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    NSMutableParagraphStyle *paragraph = [NSMutableParagraphStyle new];
    paragraph.lineBreakMode = NSLineBreakByWordWrapping;
    paragraph.lineSpacing = 3;
    TreatmentOrder *_data =  self.listModel.items[indexPath.row];
    
    CGSize size0,size1,size2,size3;
    
    size0 = [self sizeWithString:[NSString stringWithFormat:@"诊疗点：%@",_data.clinic.name] font: SystemFont_12 lableWith:ksubTextWeith NSParagraphStyleAttributeName:paragraph];
    size1 = [self sizeWithString:[NSString stringWithFormat:@"地   址：%@",_data.clinic.address] font: SystemFont_12 lableWith:ksubTextWeith NSParagraphStyleAttributeName:paragraph];
    size2 = [self sizeWithString:[NSString stringWithFormat:@"费   用：%ld",(long)_data.fee] font: SystemFont_12 lableWith:ksubTextWeith NSParagraphStyleAttributeName:paragraph];
    size3 = [self sizeWithString:[NSString stringWithFormat:@"放号数量：%ld",(long)_data.num] font:SystemFont_12 lableWith:ksubTextWeith NSParagraphStyleAttributeName:paragraph];
//    data.subject
//    data.num
    
    return size0.height+size1.height+size2.height+size3.height + 14 + 4 * ktopPadding +kHalfTableViewCellInteralY*2 +35;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
//    [tableView deselectRowAtIndexPath:indexPath animated:YES];
//    TreatmentOrder *_data =  self.listModel.items[indexPath.row];
//    [[TreatmentOrderManager sharedInstance] getOrderDetailWithOrderNumber:_data.orderno resultBlock:^(SNHTTPRequestOperation *request, SNServerAPIResultData *result) {
////        NSLog(result.responseObject);
//    } pageName:@"TreatmentOrderListViewController"];
    //
    //    DoctorDetailController *detailVC = [[DoctorDetailController alloc] initWithPageName:@"DoctorDetailController"];
    //    detailVC.doctor = [self.listModel.items objectAtIndexSafely:indexPath.row];
    //    [self.slideNavigationController pushViewController:detailVC animated:YES];
//    return nil;
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

- (CGSize)sizeWithString:(NSString *)string font:(UIFont *)font lableWith:(CGFloat)lableWith NSParagraphStyleAttributeName:(NSMutableParagraphStyle *)paragraph{
    CGRect rect = [string boundingRectWithSize:CGSizeMake(lableWith, 8000)//限制最大的宽度和高度
                                       options:NSStringDrawingTruncatesLastVisibleLine | NSStringDrawingUsesFontLeading  |NSStringDrawingUsesLineFragmentOrigin//采用换行模式
                                    attributes:@{NSFontAttributeName: font, NSParagraphStyleAttributeName:paragraph}//传人的字体字典
                                       context:nil];
    
    return rect.size;
}

@end
