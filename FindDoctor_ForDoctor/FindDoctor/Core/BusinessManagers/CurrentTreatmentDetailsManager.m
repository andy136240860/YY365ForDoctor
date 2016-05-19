//
//  CurrentTreatmentDetailsManager.m
//  FindDoctor
//
//  Created by Guo on 15/11/21.
//  Copyright © 2015年 li na. All rights reserved.
//
#import "TreatmentListAndDetailManager.h"
#import "CUServerAPIConstant.h"
#import "SNPlatFormManager.h"
#import "JSONKit.h"
#import "SNNetworkClient.h"
#import "AppCore.h"
#import "NSDate+SNExtension.h"
#import "SNBaseListModel.h"

#import "SNHTTPRequestOperationWrapper.h"

#import "CurrentTreatmentDetailsManager.h"
#import "CUUserManager.h"

@implementation CurrentTreatmentDetailsManager

SINGLETON_IMPLENTATION(CurrentTreatmentDetailsManager);

@end

@implementation CurrentTreatmentDetailsManager (Network)


- (void)uploadChuFang:(NSMutableArray *)array resultBlock:(SNServerAPIResultBlock)resultBlock pageName:(NSString *)pageName progressBlock:(SNServerAPIProgressBlock)progressBlock
{
    NSMutableDictionary * param = [NSMutableDictionary dictionary];
    [param setObjectSafely:[NSString stringWithFormat:@"%ld",(long)[CUUserManager sharedInstance].user.userId] forKey:@"imgofwho"];
    [param setObjectSafely:@"pup" forKey:@"imgtype"];
    [param setObjectSafely:[CUUserManager sharedInstance].user.cellPhone forKey:@"phone"];

    SNNetworkClient *httpClient = [[SNNetworkClient alloc] initWithBaseURL:[NSURL URLWithString:@"http://123.56.251.146:8080"]];

    NSMutableURLRequest *request = [httpClient multipartFormRequestWithMethod:@"POST" path:URL_ImageUpload parameters:param constructingBodyWithBlock: ^(id <AFMultipartFormData>formData) {
        for (int i = 0; i < array.count; i++) {
            UIImage *image = (UIImage *)[array objectAtIndex:i];
            [formData appendPartWithFileData:UIImageJPEGRepresentation(image, 0.3) name:@"file" fileName:[NSString stringWithFormat:@"ChuFangImage%d.jpg",i] mimeType:@"image/png"];
        }
    }];

    SNHTTPRequestOperationWrapper *wrapper = [[SNHTTPRequestOperationWrapper alloc] initWithRequest:request successBlock:^(SNHTTPRequestOperationWrapper *operationWrapper, id responseObject) {
        
    }
    failureBlock:^(SNHTTPRequestOperationWrapper *operationWrapper, NSError *error) {
                                                                                           
    }];
    wrapper.uploadProgressBlock = ^(double progress, long long totalBytes, long long uploadedBytes){
        NSLog(@"%0.1f", progress);
        if (progressBlock) {
            progressBlock(progress);
        }
    };
    
    AFHTTPRequestOperation *operation = [[SNNetworkClient alloc] HTTPRequestOperationWithRequest:request wrapper:wrapper];
    [operation setCompletionBlockWithSuccess:^(AFHTTPRequestOperation *operation, id responseObject) {
        NSString *string = [[NSString alloc] initWithData:responseObject encoding:NSUTF8StringEncoding];
        NSDictionary *dic = [string objectFromJSONString];

        SNServerAPIResultData * result = [[SNServerAPIResultData alloc] init];
        result.responseObject = dic;
        resultBlock(nil, result);

        NSLog(@"传图片成功 %@",dic);
    } failure:^(AFHTTPRequestOperation *operation, NSError *error){
        NSLog(@"传图片失败 %@",error);
    }];
    [operation start];
}

- (void)uploadBingZheng:(NSMutableArray *)array resultBlock:(SNServerAPIResultBlock)resultBlock pageName:(NSString *)pageName progressBlock:(SNServerAPIProgressBlock)progressBlock
{
    NSMutableDictionary * param = [NSMutableDictionary dictionary];
    [param setObjectSafely:[NSString stringWithFormat:@"%ld",(long)[CUUserManager sharedInstance].user.userId] forKey:@"imgofwho"];
    [param setObjectSafely:@"pud" forKey:@"imgtype"];
    [param setObjectSafely:[CUUserManager sharedInstance].user.cellPhone forKey:@"phone"];
    
    SNNetworkClient *httpClient = [[SNNetworkClient alloc] initWithBaseURL:[NSURL URLWithString:@"http://123.56.251.146:8080"]];
    
    NSMutableURLRequest *request = [httpClient multipartFormRequestWithMethod:@"POST" path:@"/baseFrame/base/FileUpload.jmv" parameters:param constructingBodyWithBlock: ^(id <AFMultipartFormData>formData) {
        for (int i = 0; i < array.count; i++) {
            UIImage *image = (UIImage *)[array objectAtIndex:i];
            [formData appendPartWithFileData:UIImagePNGRepresentation(image) name:@"file" fileName:[NSString stringWithFormat:@"bingZhengImage%d.png",i] mimeType:@"image/png"];
        }
    }];
    
    SNHTTPRequestOperationWrapper *wrapper = [[SNHTTPRequestOperationWrapper alloc] initWithRequest:request successBlock:^(SNHTTPRequestOperationWrapper *operationWrapper, id responseObject) {
        
    }
    failureBlock:^(SNHTTPRequestOperationWrapper *operationWrapper, NSError *error) {
                                                                                           
    }];
    wrapper.uploadProgressBlock = ^(double progress, long long totalBytes, long long uploadedBytes){
        if (progressBlock) {
            progressBlock(progress);
        }
    };
    
    AFHTTPRequestOperation *operation = [[SNNetworkClient alloc] HTTPRequestOperationWithRequest:request wrapper:wrapper];

    [operation setCompletionBlockWithSuccess:^(AFHTTPRequestOperation *operation, id responseObject) {
        NSString *string = [[NSString alloc] initWithData:responseObject encoding:NSUTF8StringEncoding];
        NSDictionary *dic = [string objectFromJSONString];
        SNServerAPIResultData * result = [[SNServerAPIResultData alloc] init];
        resultBlock(nil, result);
        NSLog(@"传图片成功 %@",dic);
    } failure:^(AFHTTPRequestOperation *operation, NSError *error){
        NSLog(@"传图片失败 %@",error);
    }];
    [operation start];
}

@end
