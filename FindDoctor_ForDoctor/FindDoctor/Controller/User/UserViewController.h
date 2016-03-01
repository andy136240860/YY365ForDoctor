//
//  UserViewController.h
//  FindDoctor
//
//  Created by Guo on 15/9/18.
//  Copyright (c) 2015年 li na. All rights reserved.
//

#import "CUViewController.h"

@interface UserViewController : CUViewController<UITableViewDataSource,UITableViewDelegate>

@property BOOL didLongin;
@property BOOL verifyCode;
@property (nonatomic,assign) BOOL hasVarify;
@property (nonatomic,strong) UITableView *contentTableView;


@end
