//
//  CUHerb.m
//  FindDoctor
//
//  Created by chai on 15/11/25.
//  Copyright © 2015年 li na. All rights reserved.
//

#import "CUHerb.h"

@interface CUHerb ()
{
    NSMutableArray *_herbs;
}
@end

@implementation CUHerb

- (instancetype)init
{
    self = [super init];
    if (self) {
//        _herbs = [NSMutableArray arrayWithArray:@[
//                                                  @{@"name":@"三七",@"letter":@"SQ"},
//                                                  @{@"name":@"枸杞",@"letter":@"GQ"},
//                                                  @{@"name":@"当归",@"letter":@"DG"},
//                                                  @{@"name":@"麻黄",@"letter":@"MH"},
//                                                  @{@"name":@"桂枝",@"letter":@"GZ"},
//                                                  @{@"name":@"人参",@"letter":@"RS"},
//                                                  @{@"name":@"薄荷",@"letter":@"BH"},
//                                                  @{@"name":@"鹿茸",@"letter":@"LR"},
//                                                  @{@"name":@"茯苓",@"letter":@"FL"},
//                                                  @{@"name":@"葛根",@"letter":@"GG"},
//                                                  @{@"name":@"白止",@"letter":@"BZ"},
//                                                  @{@"name":@"半夏",@"letter":@"BX"},
//                                                  @{@"name":@"蝉蜕",@"letter":@"CT"}
//                                                  ]];
        _herbs = [NSMutableArray   new];
    }
    return self;
}

- (void)herbDic:(NSDictionary *)dic
{
    self.name = dic[@"name"];
    self.unit = dic[@"unit"];
    self.herbid = dic[@"ID"];
    self.herbFirstLetter = dic[@"pinyin"];
}

- (void)herbModel:(int)index
{
    NSDictionary *conDic = _herbs[index%_herbs.count];
    self.name = [NSString stringWithFormat:@"%@",conDic[@"name"]];
    self.unit = @"克";
    self.herbid = [NSString stringWithFormat:@"%d",1000000+index];
    self.herbFirstLetter = conDic[@"letter"];
}

- (void)copyFromItem:(CUHerb *)herb
{
    self.name = herb.name;
    self.unit = herb.unit;
    self.herbid = herb.herbid;
    self.herbFirstLetter = herb.herbFirstLetter;
}

@end
