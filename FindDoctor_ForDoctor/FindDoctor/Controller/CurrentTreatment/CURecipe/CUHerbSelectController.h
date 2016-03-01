//
//  CUHerbSelectController.h
//  FindDoctor
//
//  Created by chai on 15/11/25.
//  Copyright © 2015年 li na. All rights reserved.
//

#import "CUViewController.h"

typedef void (^SelectHerbsBlock)(void);
typedef void (^AddHerbsBlock)(void);
@interface CUHerbSelectController : CUViewController

@property (nonatomic, weak) id superViewController;
@property (nonatomic, weak) NSMutableArray *selectHerbs;

@property long long orderno;

@property (nonatomic, copy) SelectHerbsBlock selectHerbsBlock;
@property (nonatomic, copy) AddHerbsBlock addHerbsBlock;
- (void)reloadContentTable;

@end
