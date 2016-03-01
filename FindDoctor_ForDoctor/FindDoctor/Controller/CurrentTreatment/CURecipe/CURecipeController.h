//
//  CURecipeController.h
//  FindDoctor
//
//  Created by chai on 15/11/25.
//  Copyright © 2015年 li na. All rights reserved.
//

#import "CUViewController.h"

typedef void (^HerbsBlock)(NSMutableArray *herbArray);

@interface CURecipeController : CUViewController

@property (nonatomic, weak) id superViewController;
@property (nonatomic, strong) NSMutableArray *selectHerbs;

@property long long orderno;

@property (nonatomic, copy) HerbsBlock herbsBlock;

@end
