//
//  CURecipeController.m
//  FindDoctor
//
//  Created by chai on 15/11/25.
//  Copyright © 2015年 li na. All rights reserved.
//

#import "CURecipeController.h"
#import "CUHerbChooseController.h"
#import "CUHerbSelectController.h"

@interface CURecipeController () <UIScrollViewDelegate>
{
    
}

@property(strong,nonatomic) UISegmentedControl *segment;
@property(strong,nonatomic) UIScrollView *contentScrollView;

@property NSInteger PageNumber;

@property (nonatomic, strong) CUHerbChooseController *herbchooseController;
@property (nonatomic, strong) CUHerbSelectController *herbselectController;

@end

@implementation CURecipeController
- (void)viewWillAppear:(BOOL)animated{
    if (self.selectHerbs == nil || self.selectHerbs.count == 0) {
        _contentScrollView.contentOffset = CGPointMake(0, 0);
    }
    else{
        _contentScrollView.contentOffset = CGPointMake(kScreenWidth, 0);
    }
    [super viewWillAppear:animated];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    if (_selectHerbs == nil) {
        _selectHerbs = [NSMutableArray new];
    }
    
    _PageNumber = 0;
    
    NSArray *arr = [NSArray arrayWithObjects:@" 开药 ",@" 已开药 ",nil,nil];
    _segment = [[UISegmentedControl alloc]initWithItems:arr];
    _segment.selectedSegmentIndex = _PageNumber;
    _segment.momentary = NO;
    self.navigationItem.titleView = _segment;//设置navigation上的titleview
    _segment.tintColor = [UIColor whiteColor];
    [_segment addTarget:self action:@selector(changeView) forControlEvents:UIControlEventValueChanged];
    
    [self loadScrollView];
}

- (void)loadScrollView{
    __weak __block CURecipeController * blockSelf = self;
    _contentScrollView = [[UIScrollView alloc]initWithFrame:CGRectMake(0, 0, kScreenWidth,self.contentView.frame.size.height)];
    _contentScrollView.contentSize = CGSizeMake(kScreenWidth*2, 0);
    _contentScrollView.pagingEnabled = YES;
    _contentScrollView.bounces = NO;
    _contentScrollView.showsHorizontalScrollIndicator = NO;
    _contentScrollView.directionalLockEnabled = YES;
    _contentScrollView.delegate = self;
    [self.contentView addSubview:_contentScrollView];
    
    _herbchooseController = [[CUHerbChooseController alloc] initWithPageName:@"CUHerbChooseController"];
    [self addChildViewController:_herbchooseController];
    
    _herbchooseController.view.frame = (CGRect){0,0,kScreenWidth,kScreenHeight};
    _herbchooseController.slideNavigationController = self.slideNavigationController;
    _herbchooseController.selectHerbs = _selectHerbs;
    

    _herbselectController = [[CUHerbSelectController alloc] initWithPageName:@"CUHerbSelectController"];
    _herbselectController.selectHerbs = _selectHerbs;
    _herbselectController.orderno = _orderno;
    _herbselectController.selectHerbsBlock = ^{
        blockSelf.herbsBlock(blockSelf.selectHerbs);
    };
    _herbselectController.addHerbsBlock = ^{
        [blockSelf.contentScrollView setContentOffset:CGPointMake(0, 0) animated:YES];
        [blockSelf.herbchooseController cleanupLetterTextFeild];
    };
    _herbselectController.superViewController = self.superViewController;
    [self addChildViewController:_herbselectController];
    
    _herbselectController.view.frame = (CGRect){kScreenWidth,0,kScreenWidth,kScreenHeight};
    _herbselectController.slideNavigationController = self.slideNavigationController;
        
    [_contentScrollView addSubview:_herbchooseController.view];
    [_contentScrollView addSubview:_herbselectController.view];
}

- (void)loadNavigationBar
{
    [super loadNavigationBar];
    [self addLeftBackButtonItemWithImage];
}

- (void)changeView
{
    switch ([self.segment selectedSegmentIndex]) {
        case 0:
        {
            [_herbchooseController.contentTableView reloadData];
            [_contentScrollView setContentOffset:CGPointMake(0, 0) animated:YES];
        }
            break;
        case 1:
        {
            [_herbselectController reloadContentTable];
            [_contentScrollView setContentOffset:CGPointMake(kScreenWidth, 0) animated:YES];
        }
            break;
            
        default:
            break;
    }
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView;
{
    //    NSLog(@" scrollViewDidScroll");
    NSLog(@"ContentOffset  x is  %f,yis %f",scrollView.contentOffset.x,scrollView.contentOffset.y);
    int page = floor((scrollView.contentOffset.x - kScreenWidth/2)/kScreenWidth) + 1;
    NSLog(@"%D",page);
    if (page == 1) {
        [_herbselectController reloadContentTable];
    }
    if (_PageNumber != page) {
        _PageNumber = page;
        _segment.selectedSegmentIndex = _PageNumber;
    }
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}



@end
