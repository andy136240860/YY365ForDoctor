//
//  CUHerbChooseController.h
//  FindDoctor
//
//  Created by chai on 15/11/25.
//  Copyright © 2015年 li na. All rights reserved.
//

#import "CUViewController.h"

@interface CUHerbChooseController : CUViewController

@property (nonatomic, strong) NSMutableArray *selectHerbs;
@property (nonatomic, strong) UITableView *contentTableView;

- (void)cleanupLetterTextFeild;

@end
