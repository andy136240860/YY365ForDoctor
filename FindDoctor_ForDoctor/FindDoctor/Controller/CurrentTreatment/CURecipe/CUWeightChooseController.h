//
//  CUWeightChooseController.h
//  FindDoctor
//
//  Created by chai on 15/11/26.
//  Copyright © 2015年 li na. All rights reserved.
//

#import "CUViewController.h"
#import "CUHerb.h"

@interface CUWeightChooseController : CUViewController

@property (nonatomic, weak) CUHerb *herb;

@property (nonatomic, assign) int selectweight;

@property (nonatomic, copy) void(^selectBock)(CUHerb *operaherb, int weight);

@end
