//
//  CUHerb.h
//  FindDoctor
//
//  Created by chai on 15/11/25.
//  Copyright © 2015年 li na. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface CUHerb : NSObject

@property (nonatomic, copy) NSString *name;
@property (nonatomic, copy) NSString *unit;
@property (nonatomic, copy) NSString *herbid;
@property (nonatomic, copy) NSString *herbFirstLetter;

- (void)herbModel:(int)index;

- (void)herbDic:(NSDictionary *)dic;

- (void)copyFromItem:(CUHerb *)herb;

@end
