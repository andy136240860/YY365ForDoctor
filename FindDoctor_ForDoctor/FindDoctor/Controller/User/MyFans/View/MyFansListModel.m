//
//  MyFansListModel.m
//  FindDoctor
//
//  Created by Guo on 15/10/1.
//  Copyright (c) 2015年 li na. All rights reserved.
//

#import "MyFansListModel.h"

@implementation MyFansListModel

- (instancetype)initWithSortType:(FansSortType)type
{
    FansFilter *filter = [[FansFilter alloc] init];
    filter.sortType = type;
    
    return [self initWithFilter:filter];
}

- (instancetype)initWithFilter:(FansFilter *)filter
{
    self = [super init];
    
    if (self) {
        _filter = filter;
    }
    
    return self;
}



@end
