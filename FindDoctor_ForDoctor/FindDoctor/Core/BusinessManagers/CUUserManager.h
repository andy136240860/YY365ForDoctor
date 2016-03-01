//
//  CUUser CUUserManager.h
//  CollegeUnion
//
//  Created by li na on 15/2/18.
//  Copyright (c) 2015年 li na. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "SNBusinessMananger.h"
#import "SNServerAPIDefine.h"
#import "CUUser.h"

@interface CUUserManager : SNBusinessMananger

@property (nonatomic,strong) CUUser * user;

- (BOOL)isLogin;


SINGLETON_DECLARE(CUUserManager);

@end

@interface CUUserManager (Network)

// 获取手机验证码
- (void)requireVerifyCodeWithCellPhone:(NSString *)cellPhone resultBlock:(SNServerAPIResultBlock)resultBlock pageName:(NSString *)pageName;

// 手机号+验证码登录
- (void)loginWithCellPhone:(NSString *)cellPhone code:(NSString *)code codetoken:(NSString *)codetoken resultBlock:(SNServerAPIResultBlock)resultBlock pageName:(NSString *)pageName;

// 账号+密码登录
- (void)loginWithAccountName:(NSString *)name password:(NSString *)password resultBlock:(SNServerAPIResultBlock)resultBlock pageName:(NSString *)pageName;

// 登出
- (void)logoutWithUser:(CUUser *)user resultBlock:(SNServerAPIResultBlock)resultBlock pageName:(NSString *)pageName;

// 获取用户信息
- (void)getUserInfo:(NSString *)token resultBlock:(SNServerAPIResultBlock)resultBlock;// pageName:(NSString *)pageName;

// 修改用户信息
- (void)updateUserInfo:(CUUser *)user resultBlock:(SNServerAPIResultBlock)resultBlock pageName:(NSString *)pageName;

// 上传头像
- (void)uploadAvatar:(UIImage *)image resultBlock:(SNServerAPIResultBlock)resultBlock pageName:(NSString *)pageName;

@end