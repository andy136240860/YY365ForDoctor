//
//  CUHerbSelect.m
//  FindDoctor
//
//  Created by chai on 15/11/25.
//  Copyright © 2015年 li na. All rights reserved.
//

#import "CUHerbSelect.h"

@implementation CUHerbSelect

- (void)herbModel:(int)index
{
    [super herbModel:index];
    self.weight = (index+1)*10;
}


@end
