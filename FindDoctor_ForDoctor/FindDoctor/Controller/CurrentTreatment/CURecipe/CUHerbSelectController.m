//
//  CUHerbSelectController.m
//  FindDoctor
//
//  Created by chai on 15/11/25.
//  Copyright © 2015年 li na. All rights reserved.
//

#import "CUHerbSelectController.h"
#import "CUHerbSelectCell.h"
#import "CUDiagnoseController.h"
#import "CUWeightChooseController.h"

@interface CUHerbSelectController () <UITableViewDataSource,UITableViewDelegate>
{
    UIView *_submitView;
    
    UILabel *_firstLetterLabel;
}

@property (nonatomic, strong) UITableView *contentTableView;

@end

@implementation CUHerbSelectController

- (instancetype)initWithPageName:(NSString *)pageName
{
    self = [super init];
    if (self) {
        self.hasNavigationBar = NO;
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];

//    if (_selectHerbs == nil) {
//        _selectHerbs = [NSMutableArray new];
//    }
//    
//    [_selectHerbs removeAllObjects];
//    
//    for (int i=0; i<20; i++) {
//        CUHerbSelect *herbselect = [[CUHerbSelect alloc] init];
//        [herbselect herbModel:i];
//        
//        [_selectHerbs addObject:herbselect];
//    }
    
    NSString *showText = [NSString stringWithFormat:@"    已开%ld种药",_selectHerbs.count];
    
    NSMutableAttributedString *attributeStr = [[NSMutableAttributedString alloc] initWithString:showText];
    
    NSString *pattern = @"[0-9]{1,}";
    
    NSRegularExpression *regular = [NSRegularExpression regularExpressionWithPattern:pattern options:0 error:nil];
    
    NSArray *results = [regular matchesInString:showText options:0 range:NSMakeRange(0, showText.length)];
    
    for (int i=0; i<results.count; i++) {
        NSTextCheckingResult *expression = results[i];
        [attributeStr addAttributes:@{NSForegroundColorAttributeName:kOrangeColor,NSFontAttributeName:[UIFont systemFontOfSize:16]} range:expression.range];
    }
    
    _firstLetterLabel = [[UILabel alloc] init];
    _firstLetterLabel.frame = (CGRect){0,0,kScreenWidth,35};
    _firstLetterLabel.textColor = kDarkGrayColor;
    _firstLetterLabel.numberOfLines = 0;
    _firstLetterLabel.font = SystemFont_14;
    _firstLetterLabel.backgroundColor = UIColorFromRGB(244, 244, 244);
    [self.contentView addSubview:_firstLetterLabel];
    
    _firstLetterLabel.attributedText = attributeStr;
    
    float submit_height = 44.f;
    
    UITableView *tableview = [[UITableView alloc] init];
    tableview.frame = (CGRect){0,CGRectGetMaxY(_firstLetterLabel.frame),kScreenWidth,kScreenHeight-CGRectGetMaxY(_firstLetterLabel.frame)-submit_height-kNavigationHeight};
    tableview.delegate = self;
    tableview.dataSource = self;
    [self.contentView addSubview:tableview];
    
    tableview.separatorStyle = UITableViewCellSeparatorStyleNone;
    
    _contentTableView = tableview;
    
    _submitView = [[UIView alloc] init];
    _submitView.frame = (CGRect){0,CGRectGetMaxY(_contentTableView.frame),kScreenWidth,submit_height};
    _submitView.backgroundColor = UIColorFromRGB(244, 244, 244);
    [self.contentView addSubview:_submitView];
    
    UIView *lineView = [[UIView alloc] init];
    lineView.frame = (CGRect){0,0,kScreenWidth,1.f};
    lineView.backgroundColor = UIColorFromRGB(224, 224, 224);
    [_submitView addSubview:lineView];
    
    float padding_left = 45.f*kScreenRatio;
    
    UIButton *addbutton = [UIButton buttonWithType:UIButtonTypeCustom];
    addbutton.frame = (CGRect){padding_left,5,(kScreenWidth-padding_left*3)/2,submit_height-10};
    addbutton.backgroundColor = UIColorFromRGB(89, 180, 25);
    addbutton.layer.cornerRadius = 4;
    addbutton.layer.masksToBounds = YES;
    [addbutton setTitle:@"添加" forState:UIControlStateNormal];
    addbutton.titleLabel.font = [UIFont systemFontOfSize:16];
    [_submitView addSubview:addbutton];
    
    [addbutton addTarget:self action:@selector(addAction) forControlEvents:UIControlEventTouchUpInside];
    
    UIButton *submitbutton = [UIButton buttonWithType:UIButtonTypeCustom];
    submitbutton.frame = (CGRect){CGRectGetMaxX(addbutton.frame) + padding_left,5,(kScreenWidth-padding_left*3)/2,submit_height-10};
    submitbutton.backgroundColor = UIColorFromRGB(89, 180, 25);
    submitbutton.layer.cornerRadius = 4;
    submitbutton.layer.masksToBounds = YES;
    [submitbutton setTitle:@"确定" forState:UIControlStateNormal];
    submitbutton.titleLabel.font = [UIFont systemFontOfSize:16];
    [_submitView addSubview:submitbutton];
    
    [submitbutton addTarget:self action:@selector(submitAction) forControlEvents:UIControlEventTouchUpInside];
}

- (void)loadContentView
{
    [super loadContentView];
}

- (void)reloadContentTable
{
    NSString *showText = [NSString stringWithFormat:@"    已开%ld种药",_selectHerbs.count];
    
    NSMutableAttributedString *attributeStr = [[NSMutableAttributedString alloc] initWithString:showText];
    
    NSString *pattern = @"[0-9]{1,}";
    
    NSRegularExpression *regular = [NSRegularExpression regularExpressionWithPattern:pattern options:0 error:nil];
    
    NSArray *results = [regular matchesInString:showText options:0 range:NSMakeRange(0, showText.length)];
    
    for (int i=0; i<results.count; i++) {
        NSTextCheckingResult *expression = results[i];
        [attributeStr addAttributes:@{NSForegroundColorAttributeName:kOrangeColor,NSFontAttributeName:[UIFont systemFontOfSize:16]} range:expression.range];
    }
    
    _firstLetterLabel.attributedText = attributeStr;

    [self.contentTableView reloadData];
}

- (void)addAction{
    _addHerbsBlock();
}

- (void)submitAction
{
    _selectHerbsBlock();
    [self.slideNavigationController popToViewController:self.superViewController animated:YES];
//    CUDiagnoseController *diagnoseController = [[CUDiagnoseController alloc] initWithPageName:@"CUDiagnoseController"];
//    diagnoseController.selectHerbs = self.selectHerbs;
//    diagnoseController.orderno = _orderno;
//    [self.slideNavigationController pushViewController:diagnoseController animated:YES];
}

#pragma mark ------------------ tableView Delegate --------------------

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return _selectHerbs.count;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 46.f;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *selectIdentifier = @"SelectCell";
    CUHerbSelectCell *selectcell = (CUHerbSelectCell *)[tableView dequeueReusableCellWithIdentifier:selectIdentifier];
    if (selectcell == nil) {
        selectcell = [[CUHerbSelectCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:selectIdentifier];
    }
    selectcell.indexPath = indexPath;
    selectcell.isLastCell = indexPath.row==_selectHerbs.count-1;
    selectcell.herbselect = _selectHerbs[indexPath.row];
    __weak __block CUHerbSelectController *blockSelf = self;
    selectcell.deleteHerbBlock = ^(CUHerbSelect *herb){
        for (int i = 0; i < _selectHerbs.count; i++) {
            CUHerbSelect *selectherb = _selectHerbs[i];
            if ([selectherb.name isEqualToString:herb.name]) {
                [_selectHerbs removeObjectAtIndex:i];
                [blockSelf reloadContentTable];
                break;
            }
        }
    };
    return selectcell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    CUWeightChooseController *weightchooseController = [[CUWeightChooseController alloc] initWithPageName:@"CUWeightChooseController"];
    weightchooseController.herb = _selectHerbs[indexPath.row];
    
    for (int i=0; i<_selectHerbs.count; i++) {
        CUHerbSelect *selectherb = _selectHerbs[i];
        if ([selectherb.name isEqualToString:weightchooseController.herb.name]) {
            weightchooseController.selectweight = selectherb.weight;
            break;
        }
    }
    
    __weak typeof(self) sself = self;
    weightchooseController.selectBock = ^(CUHerb *herb, int weight){
        CUHerbSelect *herbselect = nil;
        for (int i=0; i<_selectHerbs.count; i++) {
            CUHerbSelect *tempherb = _selectHerbs[i];
            if ([tempherb.name isEqualToString:herb.name]) {
                tempherb.weight = weight;
                herbselect = tempherb;
            }
        }
        if (herbselect == nil) {
            herbselect = [[CUHerbSelect alloc] init];
            herbselect.name = herb.name;
            herbselect.unit = herb.unit;
            herbselect.herbid = herb.herbid;
            herbselect.herbFirstLetter = herb.herbFirstLetter;
            herbselect.weight = weight;
            [_selectHerbs addObject:herbselect];
        }
        
        [sself.contentTableView reloadData];
    };
    [self.slideNavigationController pushViewController:weightchooseController animated:YES];
}


@end
