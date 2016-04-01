//
//  HFRequestModel.m
//  FindDoctor
//
//  Created by 晓炜 郭 on 16/3/29.
//  Copyright © 2016年 li na. All rights reserved.
//

#import "HFRequestModel.h"
#import "JSONKit.h"
#import "CUUserManager.h"

@implementation HFRequestModel

+ (NSDictionary *)paramDicWithRequire:(NSString *)require interfaceID:(NSInteger)interfaceID data:(id)data{
    NSMutableDictionary * param = [NSMutableDictionary dictionary];
    [param setObjectSafely:kPlatformFrom forKey:@"from"];
    [param setObjectSafely:([[CUUserManager sharedInstance] isLogin] ? [CUUserManager sharedInstance].user.token : @"0" )  forKey:@"token"];
    [param setObjectSafely:require forKey:@"require"];
    [param setObjectSafely:@(interfaceID) forKey:@"interfaceID"];
    [param setObjectSafely:@((NSInteger)[NSDate timeIntervalSince1970]) forKey:@"timestamp"];
    [param setObjectSafely:[data JSONString] forKey:@"data"];
    return param;
}

@end
