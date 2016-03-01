////
////  CurrentTreatmentViewController.m
////  
////
////  Created by Guo on 15/10/7.
////
////
//
//#import "CurrentTreatmentViewController.h"
//#import "PrescriptionConfirmListViewController.h"
//#import "PrescriptionConfirmListModel.h"
//#import "CurrentTreatmentListViewController.h"
//#import "CurrentTreatmentListModel.h"
//
//#import "TreatmentListAndDetailManager.h"
//#import "MBProgressHUD.h"
//#import "TipHandler+HUD.h"
//#import "UIImageView+WebCache.h"
//
//
//@interface CurrentTreatmentViewController ()<UIScrollViewDelegate>{
//    CurrentTreatmentListModel *currentTreatmentListModel;
//    PrescriptionConfirmListModel *prescriptionConfirmListMode1;
//}
//
//@property (strong,nonatomic) PrescriptionConfirmListViewController *prescriptionConfirmListVC;
//@property (strong,nonatomic) CurrentTreatmentListViewController *currentTreatmentListVC;
//
//@end
//
//@implementation CurrentTreatmentViewController
//
//@synthesize segment;
//@synthesize contentScrollView;
//@synthesize prescriptionConfirmListVC;
//@synthesize currentTreatmentListVC;
//
//- (void)viewDidAppear:(BOOL)animated{
//    prescriptionConfirmListVC.slideNavigationController = self.slideNavigationController;
//    currentTreatmentListVC.slideNavigationController = self.slideNavigationController;
//}
//
//- (void)viewDidLoad {
//    [super viewDidLoad];
//
//    _PageNumber = 0;
//    
//    NSArray *arr = [NSArray arrayWithObjects:@" 当前诊疗 ",@" 处方确认 ",nil,nil];
//    segment = [[UISegmentedControl alloc]initWithItems:arr];
//    segment.selectedSegmentIndex = _PageNumber;
//    segment.momentary = NO;
//    self.navigationItem.titleView = segment;//设置navigation上的titleview
//    segment.tintColor = [UIColor whiteColor];
//    [segment addTarget:self action:@selector(changeView) forControlEvents:UIControlEventValueChanged];
//    
//    [self loadScrollView];
//
//    
//}
//
//- (void)loadScrollView{
//    contentScrollView = [[UIScrollView alloc]initWithFrame:CGRectMake(0, 0, kScreenWidth,self.contentView.frame.size.height-49)];
//    contentScrollView.contentSize = CGSizeMake(kScreenWidth*2, contentScrollView.frame.size.height);
//    contentScrollView.pagingEnabled = YES;
//    contentScrollView.bounces = NO;
//    contentScrollView.showsHorizontalScrollIndicator = NO;
//    contentScrollView.directionalLockEnabled = YES;
//    contentScrollView.delegate = self;
//    [self.contentView addSubview:contentScrollView];
//
//    currentTreatmentListModel = [[CurrentTreatmentListModel alloc] initWithSortType:CurrentTreatmentSortTypetime];
//    currentTreatmentListVC = [[CurrentTreatmentListViewController alloc]initWithPageName:@"CurrentTreatmentListViewController" listModel:currentTreatmentListModel];
//    [self addChildViewController:currentTreatmentListVC];
//    currentTreatmentListVC.slideNavigationController = self.slideNavigationController;
//    currentTreatmentListVC.view.frame = CGRectMake(0, 0, kScreenWidth, kScreenHeight-49);
//
//    
//    
//    prescriptionConfirmListMode1 = [[PrescriptionConfirmListModel alloc] initWithSortType:PrescriptionConfirmSortTypetime];
//    prescriptionConfirmListVC = [[PrescriptionConfirmListViewController alloc]initWithPageName:@"prescriptionConfirmListViewController" listModel:prescriptionConfirmListMode1];
//    prescriptionConfirmListVC.slideNavigationController = self.slideNavigationController;
//    [self addChildViewController:prescriptionConfirmListVC];
//    prescriptionConfirmListVC.view.frame = CGRectMake(kScreenWidth, 0, kScreenWidth, kScreenHeight-49);
//    
//    
//    [contentScrollView addSubview:currentTreatmentListVC.view];
//    [contentScrollView addSubview:prescriptionConfirmListVC.view];
//}
//
//-(void)changeView{
//    switch ([self.segment selectedSegmentIndex]) {
//        case 0:
//        {
//            [contentScrollView setContentOffset:CGPointMake(0, 0) animated:YES];
//        }
//            break;
//        case 1:
//        {
//            [contentScrollView setContentOffset:CGPointMake(kScreenWidth, 0) animated:YES];
//        }
//            break;
//            
//        default:
//            break;
//    }
//}
//
//- (void)scrollViewDidScroll:(UIScrollView *)scrollView;
//{
//    //    NSLog(@" scrollViewDidScroll");
//    NSLog(@"ContentOffset  x is  %f,yis %f",scrollView.contentOffset.x,scrollView.contentOffset.y);
//    int page = floor((scrollView.contentOffset.x - kScreenWidth/2)/kScreenWidth) + 1;
//    NSLog(@"%D",page);
//    if (_PageNumber != page) {
//        _PageNumber = page;
//        segment.selectedSegmentIndex = _PageNumber;
//    }
//}
//
//
//- (void)didReceiveMemoryWarning {
//    [super didReceiveMemoryWarning];
//    // Dispose of any resources that can be recreated.
//}
//
///*
//#pragma mark - Navigation
//
//// In a storyboard-based application, you will often want to do a little preparation before navigation
//- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
//    // Get the new view controller using [segue destinationViewController].
//    // Pass the selected object to the new view controller.
//}
//*/
//
//@end
