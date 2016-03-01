//
//  MyFansListModel.h
//  FindDoctor
//
//  Created by Guo on 15/10/1.
//  Copyright (c) 2015年 li na. All rights reserved.
//

#import "SNBaseListModel.h"
#import "Fans.h"


@interface MyFansListModel : SNBaseListModel

@property (nonatomic, strong) FansFilter *filter;


- (instancetype)initWithSortType:(FansSortType)type;

@end
