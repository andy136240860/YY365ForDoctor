//
//  CUWeightChooseController.m
//  FindDoctor
//
//  Created by chai on 15/11/26.
//  Copyright © 2015年 li na. All rights reserved.
//

#import "CUWeightChooseController.h"
#import "CUWeightCell.h"

@interface CUWeightChooseController () <UITableViewDataSource,UITableViewDelegate>
{
    NSMutableArray *_weights;
    UITextField *_weightField;
    UIButton *_submitbutton;
}

@property (nonatomic, strong) UITableView *contentTableView;

@end

@implementation CUWeightChooseController

- (void)registerNotification
{
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardChanged:) name:UIKeyboardWillChangeFrameNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardShow:) name:UIKeyboardWillShowNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardHidden:) name:UIKeyboardWillHideNotification object:nil];
}

- (void)resignNotificaiton
{
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UIKeyboardWillShowNotification object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UIKeyboardWillHideNotification object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UIKeyboardWillChangeFrameNotification object:nil];
}

- (void)keyboardShow:(NSNotification *)notification
{
    NSDictionary *userInfo = [notification userInfo];
    NSValue *aValue = [userInfo objectForKey:UIKeyboardFrameEndUserInfoKey];
    CGRect keyboardRect = [aValue CGRectValue];
    int height = keyboardRect.size.height;
    CGRect contentFrame = self.contentView.frame;
    contentFrame.origin.y = -height+kNavigationHeight;
    self.contentView.frame = contentFrame;
}

- (void)keyboardChanged:(NSNotification *)notification
{
    NSDictionary *userInfo = [notification userInfo];
    NSValue *aValue = [userInfo objectForKey:UIKeyboardFrameEndUserInfoKey];
    CGRect keyboardRect = [aValue CGRectValue];
    int height = keyboardRect.size.height;
    CGRect contentFrame = self.contentView.frame;
    contentFrame.origin.y = -height+kNavigationHeight;
    self.contentView.frame = contentFrame;
}

- (void)keyboardHidden:(NSNotification *)notification
{
    NSDictionary *userInfo = [notification userInfo];
    NSValue *aValue = [userInfo objectForKey:UIKeyboardFrameEndUserInfoKey];
    CGRect keyboardRect = [aValue CGRectValue];
    int height = keyboardRect.size.height;
    CGRect contentFrame = self.contentView.frame;
    contentFrame.origin.y = kNavigationHeight;
    self.contentView.frame = contentFrame;
}

- (void)dealloc
{
    [self resignNotificaiton];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self registerNotification];
    self.title = @"数量设定";
}

- (void)loadContentView
{
    [super loadContentView];
    
    self.contentView.backgroundColor = UIColorFromRGB(244, 244, 244);
    
    [self createContentTable];
}

- (void)loadNavigationBar
{
    [self addLeftBackButtonItemWithImage];
}

- (void)createContentTable
{
    float footer_height = 44.f;
    
    if (_weights == nil) {
        _weights = [NSMutableArray new];
    }
    
    [_weights removeAllObjects];
    
    for (int i=0; i<20; i++) {
        [_weights addObject:[NSString stringWithFormat:@"%d",(i+1)*5]];
    }
    
    UITableView *tableview = [[UITableView alloc] init];
    tableview.frame = (CGRect){0,0,kScreenWidth,kScreenHeight-footer_height-kNavigationHeight};
    tableview.delegate = self;
    tableview.dataSource = self;
    [self.contentView addSubview:tableview];
    
    tableview.separatorStyle = UITableViewCellSeparatorStyleNone;
    
    _contentTableView = tableview;
    
    float submit_width = 80.f;
    
    float padding_top = 5.f;
    float padding_left = 10.f;
    
    _submitbutton = [UIButton buttonWithType:UIButtonTypeCustom];
    _submitbutton.frame = (CGRect){kScreenWidth-padding_left-submit_width,CGRectGetMaxY(_contentTableView.frame)+padding_top,submit_width,footer_height-padding_top*2};
    _submitbutton.backgroundColor = UIColorFromRGB(89, 180, 25);
    _submitbutton.layer.cornerRadius = 4;
    _submitbutton.layer.masksToBounds = YES;
    [_submitbutton setTitle:@"确定" forState:UIControlStateNormal];
    [_submitbutton addTarget:self action:@selector(submitAction) forControlEvents:UIControlEventTouchUpInside];
    [self.contentView addSubview:_submitbutton];
    
    UIView *leftView = [[UIView alloc] init];
    leftView.frame = (CGRect){0,0,10,footer_height-padding_top*2};
    
    _weightField = [[UITextField alloc] init];
    _weightField.font = SystemFont_14;
    _weightField.layer.cornerRadius = 3;
    _weightField.layer.masksToBounds = YES;
    _weightField.leftView = leftView;
    _weightField.leftViewMode = UITextFieldViewModeAlways;
    _weightField.frame = (CGRect){padding_left,CGRectGetMinY(_submitbutton.frame),CGRectGetMinX(_submitbutton.frame)-padding_left*2,footer_height-padding_top*2};
    _weightField.layer.borderColor = UIColorFromRGB(224, 224, 224).CGColor;
    _weightField.layer.borderWidth = 1.f;
    _weightField.backgroundColor = [UIColor whiteColor];
    _weightField.placeholder = @"请输入数量";
    _weightField.keyboardType = UIKeyboardTypeNumberPad;
    [self.contentView addSubview:_weightField];
}

- (void)submitAction
{
    [_weightField resignFirstResponder];
    if ([_weightField.text intValue]>0) {
        if (self.selectBock) {
            self.selectBock(self.herb,[_weightField.text intValue]);
        }
        [self.slideNavigationController popViewControllerAnimated:YES];
    }
}

#pragma mark ------------------ tableView Delegate --------------------

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return _weights.count;
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
    static NSString *weightIdentifier = @"WeightCell";
    CUWeightCell *weightcell = (CUWeightCell *)[tableView dequeueReusableCellWithIdentifier:weightIdentifier];
    if (weightcell == nil) {
        weightcell = [[CUWeightCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:weightIdentifier];
    }
    weightcell.indexPath = indexPath;
    weightcell.isLastCell = indexPath.row==_weights.count-1;
    weightcell.weightText = [NSString stringWithFormat:@"%@ g",_weights[indexPath.row]];
    if ([_weights[indexPath.row] intValue] == _selectweight) {
        weightcell.isChoose = YES;
    }else{
        weightcell.isChoose = NO;
    }
    return weightcell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    _selectweight = [_weights[indexPath.row] intValue];
    if (self.selectBock) {
        self.selectBock(self.herb,_selectweight);
    }
    [self.slideNavigationController popViewControllerAnimated:YES];
}

@end
