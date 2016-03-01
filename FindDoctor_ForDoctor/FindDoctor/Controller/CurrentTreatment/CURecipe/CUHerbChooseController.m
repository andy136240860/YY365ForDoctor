//
//  CUHerbChooseController.m
//  FindDoctor
//
//  Created by chai on 15/11/25.
//  Copyright © 2015年 li na. All rights reserved.
//

#import "CUHerbChooseController.h"
#import "CUHerbChooseCell.h"
#import "CUHerb.h"
#import "CUWeightChooseController.h"
#import "CUHerbSelect.h"

@interface CUHerbChooseController () <UITableViewDataSource,UITableViewDelegate>
{
    NSMutableArray *_herbLists;
    
    NSMutableArray *_herbResults;
    
    NSString *_searchText;
    
    UIView *_keyboardView;
    
    UILabel *_firstLetterLabel;
}



@end

@implementation CUHerbChooseController

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
    
    _herbLists = [NSMutableArray new];
    _herbResults = [NSMutableArray new];

    NSError *error = nil;
    
    NSString *herbStr = [NSString stringWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"prescriptionData" ofType:@"json"] encoding:NSUTF8StringEncoding error:&error];
    
    NSDictionary *herbDic = [NSJSONSerialization JSONObjectWithData:[herbStr dataUsingEncoding:NSUTF8StringEncoding] options:NSJSONReadingAllowFragments error:&error];
    
    NSArray *tempHerb = herbDic[@"items"];
    
    for (int i=0; i<tempHerb.count; i++) {
        NSDictionary *conDic = tempHerb[i];
        CUHerb *herb = [[CUHerb alloc] init];
        [herb herbDic:conDic];
//        [herb herbModel:i];
        [_herbLists addObject:herb];
    }
    
    [_contentTableView reloadData];

}

- (void)loadContentView
{
    [super loadContentView];
    [self createKeyboard];
}

- (void)createKeyboard
{
    CGRect contentFrame = self.contentView.frame;
    contentFrame.size.height = kScreenHeight-kNavigationHeight;
    self.contentView.frame = contentFrame;
    
    int asciiCode = 65;

    float line_width = 1.f;

    float item_width = (kScreenWidth-line_width*6)/7.f;
    
    float height = self.contentView.frame.size.height;
    float item_height = 55.f;
    
    _keyboardView = [[UIView alloc] init];
    _keyboardView.frame = (CGRect){0,height-item_height*4-line_width*4,kScreenWidth,item_height*4+line_width*4};
    _keyboardView.backgroundColor = UIColorFromRGB(244, 244, 244);
    [self.contentView addSubview:_keyboardView];
    
    for (int i=0; i<4; i++) {
        UIView *lineView = [[UIView alloc] init];
        lineView.frame = (CGRect){0,(item_height+line_width)*i,kScreenWidth,line_width};
        lineView.backgroundColor = UIColorFromRGB(227, 227, 227);
        [_keyboardView addSubview:lineView];
    }
    
    for (int i=1; i<7; i++) {
        UIView *lineView = [[UIView alloc] init];
        lineView.frame = (CGRect){item_width*i+line_width*(i-1),0,line_width,i==6?(item_height*3+line_width*3):(item_height*4+line_width*4)};
        lineView.backgroundColor = UIColorFromRGB(227, 227, 227);
        [_keyboardView addSubview:lineView];
    }
    
    for (int i=0; i<27; i++) {
        UIButton *letterbutton = [UIButton buttonWithType:UIButtonTypeCustom];
        letterbutton.frame = (CGRect){(item_width+line_width)*(i%7),(item_height+line_width)*(i/7)+line_width,item_width,item_height};
        [letterbutton setTitle:[NSString stringWithFormat:@"%c", asciiCode+i] forState:UIControlStateNormal];
        if (i==26) {
            letterbutton.frame = (CGRect){(item_width+line_width)*(i%7),(item_height+line_width)*(i/7)+line_width,(item_width*2+line_width),item_height};
            [letterbutton setTitle:@"重输" forState:UIControlStateNormal];
        }
        letterbutton.tag = asciiCode+i;
        [letterbutton setTitleColor:kDarkGrayColor forState:UIControlStateNormal];
        [letterbutton addTarget:self action:@selector(letterAction:) forControlEvents:UIControlEventTouchUpInside];
        [_keyboardView addSubview:letterbutton];
    }
    
    NSMutableAttributedString *attributeStr = [[NSMutableAttributedString alloc] initWithString:@"    药品拼音首字母："];
    
    [attributeStr addAttributes:@{NSForegroundColorAttributeName:UIColorFromRGB(248, 178, 14)} range:NSMakeRange(12, attributeStr.length-12)];
    
    _firstLetterLabel = [[UILabel alloc] init];
    _firstLetterLabel.frame = (CGRect){0,0,kScreenWidth,35};
    _firstLetterLabel.textColor = kDarkGrayColor;
    _firstLetterLabel.numberOfLines = 0;
    _firstLetterLabel.font = SystemFont_14;
    _firstLetterLabel.backgroundColor = UIColorFromRGB(244, 244, 244);
    [self.contentView addSubview:_firstLetterLabel];
    
    _firstLetterLabel.attributedText = attributeStr;
    
    UITableView *tableview = [[UITableView alloc] init];
    tableview.frame = (CGRect){0,CGRectGetMaxY(_firstLetterLabel.frame),kScreenWidth,CGRectGetMinY(_keyboardView.frame)-CGRectGetMaxY(_firstLetterLabel.frame)};
    tableview.delegate = self;
    tableview.dataSource = self;
    [self.contentView addSubview:tableview];
    
    tableview.separatorStyle = UITableViewCellSeparatorStyleNone;
    
    _contentTableView = tableview;
}

- (void)letterAction:(id)sender
{
    UIButton *letterbutton = (UIButton *)sender;
    
    NSString *showText = [NSString stringWithFormat:@"%@%@",_firstLetterLabel.text,letterbutton.titleLabel.text];
    
    int asciiCode = 65;
    
    if (_searchText==nil) {
        _searchText = @"";
    }
    
    _searchText = [NSString stringWithFormat:@"%@%@",_searchText,letterbutton.titleLabel.text];
    
    if (letterbutton.tag == asciiCode+26) {
        showText = @"    药品拼音首字母：";
        _searchText = @"";
    }
    
    NSMutableAttributedString *attributeStr = [[NSMutableAttributedString alloc] initWithString:showText];
    
    [attributeStr addAttributes:@{NSForegroundColorAttributeName:UIColorFromRGB(248, 178, 14)} range:NSMakeRange(12, attributeStr.length-12)];
    
    _firstLetterLabel.attributedText = attributeStr;
    
    [self reloadTableView];
}

- (void)cleanupLetterTextFeild{
    UIButton *button = [[UIButton alloc]init];
    button.tag = 65+26;
    [self letterAction:button];
}

- (void)reloadTableView
{
    NSMutableArray *tempResults = [NSMutableArray new];

    if (_herbResults.count>0 && _searchText.length>0) {
        for (int i=0; i<_herbResults.count; i++) {
            CUHerb *herb = _herbResults[i];
            if (_searchText.length>herb.herbFirstLetter.length) {
                continue;
            }
            NSString *tempLetter = [herb.herbFirstLetter substringWithRange:(NSRange){0,_searchText.length}];
            if ([tempLetter isEqualToString:_searchText]) {
                [tempResults addObject:herb];
            }
        }
        
        [_herbResults removeAllObjects];
        [_herbResults addObjectsFromArray:tempResults];
        
        [_contentTableView reloadData];
        
        return;
    }
    
    if (_searchText.length==0||_searchText == nil) {
        [_herbResults removeAllObjects];
        [_herbResults addObjectsFromArray:_herbLists];
        [_contentTableView reloadData];
        return;
    }
    
    for (int i=0; i<_herbLists.count; i++) {
        CUHerb *herb = _herbLists[i];
        if (_searchText.length>herb.herbFirstLetter.length) {
            continue;
        }
        NSString *tempLetter = [herb.herbFirstLetter substringWithRange:(NSRange){0,_searchText.length}];
        if ([tempLetter isEqualToString:_searchText]) {
            [tempResults addObject:herb];
        }
    }
    
    [_herbResults removeAllObjects];
    [_herbResults addObjectsFromArray:tempResults];
    
    [_contentTableView reloadData];
}

#pragma mark ------------------ tableView Delegate --------------------

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (_searchText.length > 0 && _searchText != nil) {
        return _herbResults.count;
    }
    return _herbLists.count;
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
    static NSString *chooseIdentifier = @"ChooseCell";
    CUHerbChooseCell *choosecell = (CUHerbChooseCell *)[tableView dequeueReusableCellWithIdentifier:chooseIdentifier];
    if (choosecell == nil) {
        choosecell = [[CUHerbChooseCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:chooseIdentifier];
    }
    choosecell.indexPath = indexPath;
    if (_searchText.length > 0 && _searchText != nil) {
        choosecell.isLastCell = indexPath.row==_herbResults.count-1;
        choosecell.herb = _herbResults[indexPath.row];
    }else{
        choosecell.isLastCell = indexPath.row==_herbLists.count-1;
        choosecell.herb = _herbLists[indexPath.row];
    }
    choosecell.isChoose = NO;
    
    for (int i=0; i<_selectHerbs.count; i++) {
        CUHerbSelect *selectherb = _selectHerbs[i];
        if ([selectherb.name isEqualToString:choosecell.herb.name]) {
            choosecell.isChoose = YES;
            break;
        }
    }
    return choosecell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    CUWeightChooseController *weightchooseController = [[CUWeightChooseController alloc] initWithPageName:@"CUWeightChooseController"];
    if (_searchText.length > 0 && _searchText != nil) {
        weightchooseController.herb = _herbResults[indexPath.row];
    }else{
        weightchooseController.herb = _herbLists[indexPath.row];
    }
    
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
