//
//  CUUser CUUserManager.m
//  CollegeUnion
//
//  Created by li na on 15/2/18.
//  Copyright (c) 2015年 li na. All rights reserved.
//

#import "CUUserManager.h"
#import "CUServerAPIConstant.h"
#import "AppCore.h"
#import "CUUserParser.h"
#import "SNPlatFormManager.h"
#import "CUPlatFormManager.h"
#import "SNNetworkClient.h"
#import "JSONKit.h"
#import "TipHandler.h"

@implementation CUUserManager

SINGLETON_IMPLENTATION(CUUserManager);

- (BOOL)isLogin
{
    return (self.user.token != nil) ? YES:NO;
}

- (instancetype)init
{
    if (self = [super init])
    {
        self.user = [[CUUser alloc] init];
    }
    return self;
}

- (void)load
{
    CUUser * user = [[AppCore sharedInstance].fileAccessManager loadObjectForKey:Plist_User error:nil];
//    if (user != nil && user.cellPhone.length > 0)
    if (user != nil)
    {
        self.user = user;
    }
}

- (void)save
{
    [[AppCore sharedInstance].fileAccessManager saveObject:self.user forKey:Plist_User error:nil];
}

- (void)clear
{
    self.user.token = nil;
    self.user.profile = nil;
    self.user.nickName = nil;
    self.user.cellPhone = nil;
    self.user.userId = -1;
    self.user.hiddenCellPhone = nil;
    self.user.points = 0;
    self.user.doctorId = -1;
    [[AppCore sharedInstance].fileAccessManager removeObjectForKey:Plist_User error:nil];
}

@end

@implementation CUUserManager (Network)

// 获取手机验证码
- (void)requireVerifyCodeWithCellPhone:(NSString *)cellPhone resultBlock:(SNServerAPIResultBlock)resultBlock pageName:(NSString *)pageName
{
    // param
    NSMutableDictionary * param = [NSMutableDictionary dictionary];
    [param setObjectSafely:kPlatformFrom forKey:@"from"];
    [param setObjectSafely:@"0" forKey:@"token"];
    [param setObjectSafely:@"PhoneVerify" forKey:@"require"];
    [param setObjectSafely:@(10000) forKey:@"interfaceID"];
    [param setObjectSafely:@((NSInteger)[NSDate timeIntervalSince1970]) forKey:@"timestamp"];
    
    NSMutableDictionary * dataParam = [NSMutableDictionary dictionary];
    [dataParam setObjectSafely:@"doctor" forKey:@"appType"];
    [dataParam setObjectSafely:cellPhone forKey:@"phone"];
    [dataParam setObjectSafely:@"0" forKey:@"phoneCode"];
    [dataParam setObjectSafely:[SNPlatformManager deviceString] forKey:@"clientType"];
    [dataParam setObjectSafely:@"1.0.1" forKey:@"clientVer"];
    [dataParam setObjectSafely:[SNPlatformManager deviceId] forKey:@"device"];
    [dataParam setObjectSafely:[SNPlatformManager deviceIPAdress] forKey:@"ip"];
    
    [param setObjectSafely:[dataParam JSONString] forKey:@"data"];
    
    NSLog(@"%@",param);

    [[AppCore sharedInstance].apiManager POST:URL_AfterBase parameters:param callbackRunInGlobalQueue:YES parser:nil parseMethod:nil resultBlock:resultBlock forKey:URL_AfterBase forPageNameGroup:pageName];
}

// 登录
- (void)loginWithCellPhone:(NSString *)cellPhone code:(NSString *)code codetoken:(NSString *)codetoken resultBlock:(SNServerAPIResultBlock)resultBlock pageName:(NSString *)pageName
{
    // param
    NSMutableDictionary * param = [NSMutableDictionary dictionary];
    [param setObjectSafely:kPlatformFrom forKey:@"from"];
    [param setObjectSafely:@"0" forKey:@"token"];
    [param setObjectSafely:@"DoctorLoginAccount" forKey:@"require"];
    [param setObjectSafely:@(20102) forKey:@"interfaceID"];
    [param setObjectSafely:@((NSInteger)[NSDate timeIntervalSince1970]) forKey:@"timestamp"];

    
    NSMutableDictionary * dataParam = [NSMutableDictionary dictionary];
    [dataParam setObjectSafely:@(0) forKey:@"accID"];
    [dataParam setObjectSafely:cellPhone forKey:@"account"];
    [dataParam setObjectSafely:[[@"uyi365" MD5] uppercaseString] forKey:@"code"];
    [dataParam setObjectSafely:[SNPlatformManager deviceString] forKey:@"clientType"];
    [dataParam setObjectSafely:[CUPlatFormManager currentAppVersion] forKey:@"clientVer"];
    [dataParam setObjectSafely:[SNPlatformManager deviceId] forKey:@"device"];
    [dataParam setObjectSafely:[SNPlatformManager deviceIPAdress] forKey:@"ip"];
    [dataParam setObjectSafely:@"成都市" forKey:@"region"];
    [dataParam setObjectSafely:kCurrentLat forKey:@"latitude"];
    [dataParam setObjectSafely:kCurrentLng forKey:@"longtitude"];
    
    [param setObjectSafely:[dataParam JSONString] forKey:@"data"];
    __block CUUserManager * blockSelf = self;
    
    [[AppCore sharedInstance].apiManager POST:URL_AfterBase parameters:param callbackRunInGlobalQueue:YES parser:nil parseMethod:nil resultBlock:^(SNHTTPRequestOperation *request, SNServerAPIResultData *result) {
        if (!result.hasError)
        {
            // 赋值user数据
            NSInteger err_code = [result.responseObject integerForKeySafely:@"errorCode"];
            if(err_code == 0){
                NSDictionary *data = [result.responseObject dictionaryForKeySafely:@"data"];
                
                //                    blockSelf.user.cellPhone = [data valueForKey:@"phone"];
                blockSelf.user.userId = [data integerForKeySafely:@"accID"];
                blockSelf.user.doctorId = [data integerForKeySafely:@"accID"];
                blockSelf.user.nickName = [data stringForKeySafely:@"name"];
                blockSelf.user.icon = [data stringForKeySafely:@"icon"];
                NSLog(@"cellPhone:%@",blockSelf.user.cellPhone);
                NSLog(@"userId:%d",blockSelf.user.userId );
                NSLog(@"doctorId:%d",blockSelf.user.doctorId );
                blockSelf.user.token = [data stringForKeySafely:@"token"];
                
                [blockSelf save];
            }
            else{
                [TipHandler showTipOnlyTextWithNsstring:[result.responseObject stringForKeySafely:@"data"]];
            }

        }
        resultBlock(request,result);
    } forKey:URL_AfterBase forPageNameGroup:pageName];
}
//
//- (void)loginWithAccountName:(NSString *)name password:(NSString *)password resultBlock:(SNServerAPIResultBlock)resultBlock pageName:(NSString *)pageName
//{
//    // param
//    NSMutableDictionary * param = [NSMutableDictionary dictionary];
//    [param setObjectSafely:kPlatformFrom forKey:@"from"];
//    [param setObjectSafely:@"V1.0" forKey:@"version"];
//    [param setObjectSafely:[SNPlatformManager deviceId] forKey:@"deviceinfo"];
//    [param setObjectSafely:@"0" forKey:@"token"];
//    [param setObjectSafely:@"login_my" forKey:@"require"];
//    [param setObjectSafely:@"0" forKey:@"lantitude"];
//    [param setObjectSafely:@"0" forKey:@"lontitude"];
//    [param setObjectSafely:@"phonecode" forKey:@"logintype"];
//    [param setObjectSafely:@"ture" forKey:@"ios"];
//    
//    NSMutableDictionary * dataParam = [NSMutableDictionary dictionary];
//    [dataParam setValue:name forKey:@"phone"];
//    [dataParam setValue:password forKey:@"code"];
//    [dataParam setValue:@"0" forKey:@"email"];
//    [dataParam setValue:@"0" forKey:@"account"];
//    [dataParam setValue:@"0" forKey:@"accountid"];
//    [dataParam setValue:@"phonemsg_from_doctor" forKey:@"logintype"];
//    [param setObjectSafely:[dataParam JSONString] forKey:@"data"];
//
//    
//    CUUserParser * parser = [[CUUserParser alloc] init];
//    __block CUUserManager * blockSelf = self;
//    
//    [[AppCore sharedInstance].apiManager POST:URL_AfterBase parameters:param callbackRunInGlobalQueue:YES parser:parser parseMethod:@selector(parseLoginWithDict:) resultBlock:^(SNHTTPRequestOperation *request, SNServerAPIResultData *result) {
//        NSLog(@"%@",result.responseObject);
//        
//        if (!result.hasError)
//        {
//            // 赋值user数据
//            
//            blockSelf.user.token = [result.responseObject valueForKey:@"token"];
//            
//            NSDictionary *data = [result.responseObject valueForKey:@"data"];
//    
//            blockSelf.user.cellPhone = [data valueForKey:@"phone"];
//            blockSelf.user.userId = [[data valueForKey:@"no"] intValue];
//            blockSelf.user.doctorId = [[data valueForKey:@"iddoctor"] intValue];
//            blockSelf.user.nickName = [data valueForKey:@"name"];
//            blockSelf.user.icon = [data valueForKey:@"icon"];
//            
//            NSLog(@"cellPhone:%@",blockSelf.user.cellPhone);
//            NSLog(@"userId:%d",blockSelf.user.userId );
//            NSLog(@"doctorId:%d",blockSelf.user.doctorId );
//            
//            [blockSelf save];
//        }
//        resultBlock(request,result);
//    } forKey:URL_AfterBase forPageNameGroup:pageName];
//}

//// 登出
//- (void)logoutWithUser:(CUUser *)user resultBlock:(SNServerAPIResultBlock)resultBlock pageName:(NSString *)pageName
//{
//    // param
//    NSMutableDictionary * param = [NSMutableDictionary dictionary];
//    [param setObjectSafely:user.token forKey:Key_Token];
//    
//    CUUserParser * parser = [[CUUserParser alloc] init];
//    __block CUUserManager * blockSelf = self;
//    
//    [[AppCore sharedInstance].apiManager POST:URL_AfterBase parameters:param callbackRunInGlobalQueue:YES parser:parser parseMethod:@selector(parseLogoutWithDict:) resultBlock:^(SNHTTPRequestOperation *request, SNServerAPIResultData *result) {
//        if (!result.hasError)
//        {
//            // 赋值user数据
//            [blockSelf clear];
//            [blockSelf save];
//        }
//        resultBlock(request,result);
//    }  forKey:URL_AfterBase forPageNameGroup:pageName];
//}

// 获取用户信息
//- (void)getUserInfo:(NSString *)token resultBlock:(SNServerAPIResultBlock)resultBlock// pageName:(NSString *)pageName
//{
//    // param
//    NSMutableDictionary * param = [NSMutableDictionary dictionary];
//    [param setObjectSafely:token forKey:Key_Token];
//    
//    CUUserParser * parser = [[CUUserParser alloc] init];
//    __block CUUserManager * blockSelf = self;
//    [[AppCore sharedInstance].apiManager POST:URL_AfterBase parameters:param callbackRunInGlobalQueue:YES parser:parser parseMethod:@selector(parseGetUserInfoWithDict:) resultBlock:^(SNHTTPRequestOperation *request, SNServerAPIResultData *result) {
//        if (!result.hasError)
//        {
////            // 赋值user数据
////            NSString * profile = ((CUUser *)result.parsedModelObject).profile;
////            NSString * nickName = ((CUUser *)result.parsedModelObject).nickName;
////            NSString * hiddenCellPhone = ((CUUser *)result.parsedModelObject).hiddenCellPhone;
////            
////            if (profile != nil)
////            {
////                blockSelf.user.profile = profile;
////            }
////            if (nickName != nil)
////            {
////                 blockSelf.user.nickName = nickName;
////            }
////            if (hiddenCellPhone != nil)
////            {
////                blockSelf.user.hiddenCellPhone = hiddenCellPhone;
////            }
////            blockSelf.user.userId = ((CUUser *)result.parsedModelObject).userId;
////            blockSelf.user.points = ((CUUser *)result.parsedModelObject).points;
////            [blockSelf save];
//        }
//        resultBlock(request,result);
//    }   forKey:URL_AfterBase];
//}

// 修改用户信息
- (void)updateUserInfo:(CUUser *)user resultBlock:(SNServerAPIResultBlock)resultBlock pageName:(NSString *)pageName
{
    // param
    NSMutableDictionary * param = [NSMutableDictionary dictionary];
    [param setObjectSafely:user.token forKey:Key_Token];
    [param setObjectSafely:user.nickName forKey:@"nickname"];
    
    NSString *baseURL = [NSString stringWithFormat:@"%@/",URL_ImageBase];
    NSString *profile = [user.profile stringByReplacingOccurrencesOfString:baseURL withString:@""];
    if (profile.length) {
        [param setObjectSafely:profile forKey:@"avatar"];
    }
    
    CUUserParser * parser = [[CUUserParser alloc] init];
    __block CUUserManager * blockSelf = self;
    [[AppCore sharedInstance].apiManager POST:URL_AfterBase parameters:param callbackRunInGlobalQueue:YES parser:parser parseMethod:@selector(parseUpdateUserInfoWithDict:) resultBlock:^(SNHTTPRequestOperation *request, SNServerAPIResultData *result) {
        if (!result.hasError)
        {
            // 赋值user数据
            NSString * profile = user.profile;
            NSString * nickName = user.nickName;
            
            if (profile != nil)
            {
                blockSelf.user.profile = profile;
            }
            if (nickName != nil)
            {
                blockSelf.user.nickName = nickName;
            }
            [blockSelf save];
        }
        resultBlock(request,result);
    } forKey:URL_AfterBase forPageNameGroup:pageName];
}

- (void)uploadAvatar:(UIImage *)image resultBlock:(SNServerAPIResultBlock)resultBlock pageName:(NSString *)pageName
{
    CUUserParser * parser = [[CUUserParser alloc] init];
    
    SNNetworkClient *httpClient = [[SNNetworkClient alloc] initWithBaseURL:[NSURL URLWithString:URL_Base]];
    
    NSMutableURLRequest *request = [httpClient multipartFormRequestWithMethod:@"POST" path:@"/baseFrame/base/server" parameters:nil constructingBodyWithBlock: ^(id <AFMultipartFormData>formData) {
        [formData appendPartWithFileData:UIImagePNGRepresentation(image) name:@"file" fileName:@"upload.png" mimeType:@"image/png"];
    }];
    
    AFHTTPRequestOperation *operation = [[AFHTTPRequestOperation alloc] initWithRequest:request];
    
    __weak CUUserManager * blockSelf = self;

    [operation setCompletionBlockWithSuccess:^(AFHTTPRequestOperation *operation, id responseObject) {
        NSString *string = [[NSString alloc] initWithData:responseObject encoding:NSUTF8StringEncoding];
        NSDictionary *dic = [string objectFromJSONString];
        
        SNServerAPIResultData * result = [[SNServerAPIResultData alloc] init];
        
        result.parsedModelObject = [parser performSelector:@selector(parseUploadAvatarWithDict:) withObject:dic];
        
        result.hasError = parser.hasError;
        
        if (!result.hasError && result.parsedModelObject) {
            blockSelf.user.profile = result.parsedModelObject;
            
            [blockSelf updateUserInfo:blockSelf.user resultBlock:^(SNHTTPRequestOperation * request,SNServerAPIResultData * result) {
                
            } pageName:@"ESJ_UpdateUserInfo"];
        }
        
        resultBlock(nil, result);
        
        NSLog(@"传图片成功 %@",dic);
    } failure:^(AFHTTPRequestOperation *operation, NSError *error){
        NSLog(@"传图片失败 %@",error);
    }];
    [operation start];
    
//    [[AppCore sharedInstance].apiManager POST:URL_ImageUpload parameters:nil callbackRunInGlobalQueue:YES parser:parser parseMethod:@selector(parseUploadAvatarWithDict:) resultBlock:resultBlock forKey:URL_ImageUpload forPageNameGroup:pageName];
}

@end
