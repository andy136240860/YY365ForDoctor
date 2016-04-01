//
//  CUPlatFormManager.h
//  CollegeUnion
//
//  Created by li na on 15/2/27.
//  Copyright (c) 2015年 li na. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "SNBusinessMananger.h"
#import "Platform.h"

@interface CUPlatFormManager : SNBusinessMananger

@property (nonatomic ,retain)Platform *platform;
@property (nonatomic, assign)BOOL       isNewInstall;
@property (nonatomic, assign)BOOL       isCoverInstall;

SINGLETON_DECLARE(CUPlatFormManager);

#pragma mark ============= 类便利方法 =============
// 获取当前版本号 ,新版本信息.
+ (NSString *)currentAppVersion;
+ (NSInteger)appVersionNumInBundle;
+ (NSInteger)changeVersionFromStringToInt:(NSString *)version;
- (void)sychronizeVersion;

@end
