//
//  TreatmentOrderManager.m
//  FindDoctor
//
//  Created by Guo on 15/11/16.
//  Copyright © 2015年 li na. All rights reserved.
//

#import "TreatmentOrderManager.h"
#import "CUServerAPIConstant.h"
#import "SNPlatFormManager.h"
#import "JSONKit.h"
#import "SNNetworkClient.h"
#import "AppCore.h"
#import "CUUserManager.h"
#import "NSDate+SNExtension.h"
#import "SNBaseListModel.h"
#import "Clinic.h"
#import "NSDate+SNExtension.h"
#import "AppDelegate.h"
#import "CUHerbSelect.h"

@implementation TreatmentOrderManager

SINGLETON_IMPLENTATION(TreatmentOrderManager);

@end

@implementation TreatmentOrderManager (Network)

// 通过timestamp 获取clinic
- (void)FangHaoForGetClinicWithResultBlock:(SNServerAPIResultBlock)resultBlock pageName:(NSString *)pageName
{
#if !LOCAL
    NSMutableDictionary * param = [NSMutableDictionary dictionary];
    [param setObjectSafely:@"ios" forKey:@"from"];
    [param setObjectSafely:[CUUserManager sharedInstance].user.token forKey:@"token"];
    [param setObjectSafely:@"ClinicListName" forKey:@"require"];
    [param setObjectSafely:@(21101) forKey:@"interfaceID"];
    [param setObjectSafely:@((NSInteger)[NSDate timeIntervalSince1970]) forKey:@"timestamp"];
    
    NSMutableDictionary * dataParam = [NSMutableDictionary dictionary];
    [dataParam setObjectSafely:@([CUUserManager sharedInstance].user.userId) forKey:@"accID"];
    [dataParam setObjectSafely:@(510000) forKey:@"regionID"];
    [param setObjectSafely:[dataParam JSONString] forKey:@"data"];
    
    NSLog(@"%@",param);
    
    [[AppCore sharedInstance].apiManager POST:URL_AfterBase parameters:param callbackRunInGlobalQueue:YES parser:nil parseMethod:nil resultBlock:^(SNHTTPRequestOperation *request, SNServerAPIResultData *result){
        if (!result.hasError){

            NSArray *array = [result.responseObject valueForKeySafely:@"data"];
            NSMutableArray *clinicArray = [NSMutableArray new];
            for (int i = 0; i < array.count; i++) {
                NSDictionary *dic = [array objectAtIndexSafely:i];
                Clinic *clinic = [[Clinic alloc]init];
                clinic.ID = [[dic valueForKeySafely:@"dataID"] integerValue];
                clinic.name = [dic valueForKeySafely:@"name"];
                [clinicArray addObjectSafely:clinic];
                result.parsedModelObject = clinicArray;
            }
        }
        resultBlock(nil, result);

    } forKey:@"FangHaoForGetClinic" forPageNameGroup:pageName];
#else
    SNServerAPIResultData *result = [[SNServerAPIResultData alloc]init];
    result.hasError = NO;
    NSMutableArray *clinicArray = [NSMutableArray new];
    for (int i = 0; i < 5; i++) {
        Clinic *clinic = [[Clinic alloc]init];
        clinic.ID = i;
        clinic.name = [NSString stringWithFormat:@"诊疗室%d",i];
        [clinicArray addObject:clinic];
    }
    result.parsedModelObject = clinicArray;
    resultBlock(nil,result);
#endif
}


- (void)FangHaoForGetTimeUsedStateWithTiemstamp:(NSInteger)timeStamp
                                         clinic:(Clinic *)clinic
                                    resultBlock:(SNServerAPIResultBlock)resultBlock pageName:(NSString *)pageName;
{
    NSMutableDictionary * param = [NSMutableDictionary dictionary];
    [param setObjectSafely:@"ios" forKey:@"from"];
    [param setObjectSafely:[CUUserManager sharedInstance].user.token forKey:@"token"];
    [param setObjectSafely:@"ClinicDiagnosisTime" forKey:@"require"];
    [param setObjectSafely:@(21102) forKey:@"interfaceID"];
    [param setObjectSafely:@((NSInteger)[NSDate timeIntervalSince1970]) forKey:@"timestamp"];
    
    NSMutableDictionary * dataParam = [NSMutableDictionary dictionary];
    
    [dataParam setObjectSafely:@([CUUserManager sharedInstance].user.userId) forKey:@"accID"];
    [dataParam setObjectSafely:@(timeStamp) forKey:@"date"];
    [dataParam setObjectSafely:@(clinic.ID) forKey:@"clinicID"];
    [param setObjectSafely:[dataParam JSONString] forKey:@"data"];
    
    NSLog(@"%@",param);
    
    [[AppCore sharedInstance].apiManager POST:URL_AfterBase parameters:param callbackRunInGlobalQueue:YES parser:nil parseMethod:nil resultBlock:^(SNHTTPRequestOperation *request, SNServerAPIResultData *result){
        if (!result.hasError){
            NSInteger err_code = [[result.responseObject valueForKeySafely:@"err_code"] integerValue];
            if (err_code == 0) {
                NSMutableArray *array = [[result.responseObject valueForKeySafely:@"data"] valueForKeySafely:@"usedTime"];
                clinic.timeUesdArray = [NSMutableArray new];
                for (int i = 0; i < array.count; i++) {
                    NSMutableDictionary *dic = [array objectAtIndex:i];
                    TimeUesd *timeused = [[TimeUesd alloc]init];
                    timeused.startTime = [[dic valueForKeySafely:@"startTime"] longLongValue];
                    timeused.endTime = [[dic valueForKeySafely:@"endTime"] longLongValue];
                    [clinic.timeUesdArray addObject:timeused];
                }
                result.parsedModelObject = clinic;
            }
        }

        resultBlock(nil, result);
        
    } forKey:@"FangHaoForGetTimeSeg" forPageNameGroup:pageName];
}

- (void)FangHaoWithDate:(NSInteger)date
              clinic_id:(NSInteger)clinic_id
                    num:(NSInteger)num
                    fee:(NSInteger)fee
                orderNo:(long long)orderNo
              startTime:(NSTimeInterval)startTime
                endTime:(NSTimeInterval)endTime
            resultBlock:(SNServerAPIResultBlock)resultBlock pageName:(NSString *)pageName
{
    NSMutableDictionary * param = [NSMutableDictionary dictionary];
    [param setObjectSafely:@"ios" forKey:@"from"];
    [param setObjectSafely:[CUUserManager sharedInstance].user.token forKey:@"token"];
    [param setObjectSafely:@"ReleaseDiagnosis" forKey:@"require"];
    [param setObjectSafely:@(21103) forKey:@"interfaceID"];
    [param setObjectSafely:@((NSInteger)[NSDate timeIntervalSince1970]) forKey:@"timestamp"];
    
    NSMutableDictionary * dataParam = [NSMutableDictionary dictionary];
    [dataParam setObjectSafely:@(date) forKey:@"date"];
    [dataParam setObjectSafely:@(orderNo) forKey:@"releaseID"];
    [dataParam setObjectSafely:@([CUUserManager sharedInstance].user.userId) forKey:@"accID"];
    [dataParam setObjectSafely:@(clinic_id) forKey:@"clinicID"];
    [dataParam setObjectSafely:@(num)  forKey:@"num"];
    [dataParam setObjectSafely:@(fee) forKey:@"fee"];
    [dataParam setObjectSafely:@(startTime)  forKey:@"timeStart"];
    [dataParam setObjectSafely:@(endTime) forKey:@"timeEnd"];
    

    [param setObjectSafely:[dataParam JSONString] forKey:@"data"];
    
    NSLog(@"%@",param);
    
    [[AppCore sharedInstance].apiManager POST:URL_AfterBase parameters:param callbackRunInGlobalQueue:YES parser:nil parseMethod:nil resultBlock:^(SNHTTPRequestOperation *request, SNServerAPIResultData *result){
        if (!result.hasError){

        }
        resultBlock(nil, result);
    } forKey:@"FangHaoForFirstTime" forPageNameGroup:pageName];
}

//放号列表
- (void)getListWithresultBlock:(SNServerAPIResultBlock)resultBlock pageName:(NSString *)pageName{
    NSMutableDictionary * param = [NSMutableDictionary dictionary];
    [param setObjectSafely:@"ios" forKey:@"from"];
    [param setObjectSafely:[CUUserManager sharedInstance].user.token forKey:@"token"];
    [param setObjectSafely:@"ReleaseDiagnosisRecords" forKey:@"require"];
    [param setObjectSafely:@(23001) forKey:@"interfaceID"];
    [param setObjectSafely:@((NSInteger)[NSDate timeIntervalSince1970]) forKey:@"timestamp"];
    
    NSMutableDictionary * dataParam = [NSMutableDictionary dictionary];
    
    [dataParam setObjectSafely:@([CUUserManager sharedInstance].user.userId) forKey:@"accID"];
    [param setObjectSafely:[dataParam JSONString] forKey:@"data"];
    
    [[AppCore sharedInstance].apiManager POST:URL_AfterBase parameters:param callbackRunInGlobalQueue:YES parser:nil parseMethod:nil resultBlock:^(SNHTTPRequestOperation *request, SNServerAPIResultData *result){
        if (!result.hasError){
            SNBaseListModel *listModel = [[SNBaseListModel alloc] init];
            NSInteger errorCode = [[result.responseObject valueForKeySafely:@"errorCode"] integerValue];
            if (errorCode == 0){
                NSMutableArray *dataArray = [result.responseObject valueForKeySafely:@"data"];
                for (int i = 0; i < dataArray.count ; i++) {
                    NSMutableDictionary *dic = [dataArray objectAtIndex:i];
                    TreatmentOrder *treatmentOrder = [[TreatmentOrder alloc]init];
                    treatmentOrder.clinic = [[Clinic alloc]init];
                    treatmentOrder.subject = [dic valueForKeyPathSafely:@"DiagnosisSubject"];
                    treatmentOrder.clinic.address = [dic valueForKeyPathSafely:@"address"];
                    treatmentOrder.clinic.name = [dic valueForKeyPathSafely:@"name"];
                    treatmentOrder.fee = [[dic valueForKeyPathSafely:@"fee"] integerValue];
                    treatmentOrder.num = [[dic valueForKeyPathSafely:@"num"] integerValue];
                    treatmentOrder.orderno = [[dic valueForKeyPathSafely:@"releaseID"] longLongValue];
                    treatmentOrder.startTime = [[dic valueForKeyPathSafely:@"startTime"] longLongValue];
                    treatmentOrder.endTime = [[dic valueForKeyPathSafely:@"endTime"] longLongValue];
                    treatmentOrder.editState = [[dic valueForKeyPathSafely:@"state"] integerValue];
                    
                    long long inttime = [[dic valueForKeyPathSafely:@"startTime"] longLongValue];
                    NSDate *date = [NSDate dateWithTimeIntervalSince1970:inttime];
                    date = [date dateAtStartOfDay];
                    treatmentOrder.timestamp = [date timeIntervalSince1970];
                    
                    if (listModel.items.count > 0) {
                        TreatmentOrder *beforeItem = [listModel.items objectAtIndex:(listModel.items.count - 1)];
                        if (beforeItem.orderno == treatmentOrder.orderno) {
                            continue;
                        }
                    }
                    [listModel.items addObject:treatmentOrder]; // 筛选排除重复
                    
                }
                result.parsedModelObject = listModel;
            }
            resultBlock(nil, result);
        }
    } forKey:@"getList" forPageNameGroup:pageName];

}


//放号删除
- (void)deleteOrderWithOrderNumber:(long long)orderNo resultBlock:(SNServerAPIResultBlock)resultBlock pageName:(NSString *)pageName{
    NSMutableDictionary * param = [NSMutableDictionary dictionary];
    [param setObjectSafely:@"ios" forKey:@"from"];
    [param setObjectSafely:[CUUserManager sharedInstance].user.token forKey:@"token"];
    [param setObjectSafely:@"DoctorDelRelease" forKey:@"require"];
    [param setObjectSafely:@(23001) forKey:@"interfaceID"];
    [param setObjectSafely:@((NSInteger)[NSDate timeIntervalSince1970]) forKey:@"timestamp"];
    
    NSMutableDictionary * dataParam = [NSMutableDictionary dictionary];
    
    [dataParam setObjectSafely:@([CUUserManager sharedInstance].user.userId) forKey:@"accID"];
    [dataParam setObjectSafely:@(orderNo) forKey:@"releaseID"];
    [param setObjectSafely:[dataParam JSONString] forKey:@"data"];
    
    [[AppCore sharedInstance].apiManager POST:URL_AfterBase parameters:param callbackRunInGlobalQueue:YES parser:nil parseMethod:nil resultBlock:^(SNHTTPRequestOperation *request, SNServerAPIResultData *result){
        if (!result.hasError){
        
            
            
        }
        resultBlock(nil, result);
    } forKey:@"deleteOrder" forPageNameGroup:pageName];
    
}

//放号详情
- (void)getOrderDetailWithOrderNumber:(NSInteger)orderno resultBlock:(SNServerAPIResultBlock)resultBlock pageName:(NSString *)pageName{
    NSMutableDictionary * param = [NSMutableDictionary dictionary];
    [param setObjectSafely:@"ios doctor" forKey:@"from"];
    [param setObjectSafely:@"V1.0" forKey:@"version"];
    [param setObjectSafely:[SNPlatformManager deviceId] forKey:@"deviceinfo"];
    [param setObjectSafely:[CUUserManager sharedInstance].user.token forKey:@"token"];
    [param setObjectSafely:@"getReleaseOrderInfo" forKey:@"require"];
    [param setObjectSafely:@"0" forKey:@"lantitude"];
    [param setObjectSafely:@"0" forKey:@"lontitude"];
    [param setObjectSafely:@"ture" forKey:@"ios"];
    
    NSMutableDictionary * dataParam = [NSMutableDictionary dictionary];
    
    [dataParam setObjectSafely:@([CUUserManager sharedInstance].user.userId) forKey:@"accountid"];
    [dataParam setObjectSafely:@([CUUserManager sharedInstance].user.doctorId) forKey:@"iddoctor"];
    [dataParam setObjectSafely:@(orderno) forKey:@"orderno"];
    [dataParam setObjectSafely:@(3) forKey:@"type"];
    [param setObjectSafely:[dataParam JSONString] forKey:@"data"];
    
    [[AppCore sharedInstance].apiManager POST:URL_AfterBase parameters:param callbackRunInGlobalQueue:YES parser:nil parseMethod:nil resultBlock:^(SNHTTPRequestOperation *request, SNServerAPIResultData *result){
        if (!result.hasError){
            SNBaseListModel *listModel = [[SNBaseListModel alloc] init];
            NSDictionary *dic = [[result.responseObject valueForKeySafely:@"data"] valueForKeyPathSafely:@"list"];
            
            TreatmentOrder *treatmentOrder = [[TreatmentOrder alloc]init];
            treatmentOrder.clinic = [[Clinic alloc]init];
            treatmentOrder.subject = [dic valueForKeyPathSafely:@"DiagnosisSubject"];
            treatmentOrder.clinic.address = [dic valueForKeyPathSafely:@"address"];
            treatmentOrder.clinic.name = [dic valueForKeyPathSafely:@"name"];
            treatmentOrder.fee = [[dic valueForKeyPathSafely:@"fee"] integerValue];
            treatmentOrder.num = [[dic valueForKeyPathSafely:@"number"] integerValue];
            
            long long inttime = [[dic valueForKeyPathSafely:@"releasestarttime"] longLongValue]/1000;
            NSDate *date = [NSDate dateWithTimeIntervalSince1970:inttime-3600*8];
            date = [date dateAtStartOfDay];
            treatmentOrder.timestamp = [date timeIntervalSince1970];
            
            [listModel.items addObject:treatmentOrder];
            

            result.parsedModelObject = listModel;
        }
        resultBlock(nil, result);
    } forKey:@"getOrderDetail" forPageNameGroup:pageName];
}


//开方
- (void)medicineWithOrderNumber:(long long)orderno
                recipeData:(NSMutableArray *)recipeData
                         number:(NSInteger)number
                       diagnose:(NSString *)diagnose
                    resultBlock:(SNServerAPIResultBlock)resultBlock pageName:(NSString *)pageName{
    NSMutableDictionary * param = [NSMutableDictionary dictionary];
    [param setObjectSafely:@"ios" forKey:@"from"];
    [param setObjectSafely:[CUUserManager sharedInstance].user.token forKey:@"token"];
    [param setObjectSafely:@"SubmitDiagnosisData" forKey:@"require"];
    [param setObjectSafely:@(22101) forKey:@"interfaceID"];
    [param setObjectSafely:@((NSInteger)[NSDate timeIntervalSince1970]) forKey:@"timestamp"];
    
    NSMutableDictionary * dataParam = [NSMutableDictionary dictionary];
    [dataParam setObjectSafely:@(2) forKey:@"state"];
    [dataParam setObjectSafely:@(orderno) forKey:@"diagnosisID"];
    [dataParam setObjectSafely:diagnose  forKey:@"diagnosisContent"];
    [dataParam setObjectSafely:@"" forKey:@"recipePic"];
    [dataParam setObjectSafely:@(number) forKey:@"recipeNum"];
    
    NSMutableArray * recipeDataArray = [NSMutableArray new];
    for (int i = 0 ; i < recipeData.count; i++) {
        NSMutableDictionary * recipeDataParam = [NSMutableDictionary dictionary];
        [recipeDataParam setObjectSafely:@(i+1) forKey:@"ID"];
        [recipeDataParam setObjectSafely:@([[recipeData[i] herbid]integerValue]) forKey:@"dataID"];
        [recipeDataParam setObjectSafely:[recipeData[i] name] forKey:@"name"];
        [recipeDataParam setObjectSafely:@([recipeData[i] weight]) forKey:@"num"];
        [recipeDataParam setObjectSafely:[recipeData[i] unit] forKey:@"unit"];
        [recipeDataArray addObject:recipeDataParam];
    }
    [dataParam setObjectSafely:recipeDataArray forKey:@"recipeData"];
    [param setObjectSafely:[dataParam JSONString] forKey:@"data"];
    
    [[AppCore sharedInstance].apiManager POST:URL_AfterBase parameters:param callbackRunInGlobalQueue:YES parser:nil parseMethod:nil resultBlock:^(SNHTTPRequestOperation *request, SNServerAPIResultData *result){
        if (!result.hasError){
            
        }
        resultBlock(nil, result);
    } forKey:@"medicine" forPageNameGroup:pageName];
}



//拍照开方
- (void)medicineWithOrderNumber:(long long)orderno
                        ftppath:(NSString *)ftppath
                         number:(NSInteger)number
                       diagnose:(NSString *)diagnose
                    resultBlock:(SNServerAPIResultBlock)resultBlock pageName:(NSString *)pageName{
    NSMutableDictionary * param = [NSMutableDictionary dictionary];
    [param setObjectSafely:@"ios" forKey:@"from"];
    [param setObjectSafely:[CUUserManager sharedInstance].user.token forKey:@"token"];
    [param setObjectSafely:@"SubmitDiagnosisData" forKey:@"require"];
    [param setObjectSafely:@(22101) forKey:@"interfaceID"];
    [param setObjectSafely:@((NSInteger)[NSDate timeIntervalSince1970]) forKey:@"timestamp"];
    
    NSMutableDictionary * dataParam = [NSMutableDictionary dictionary];
    [dataParam setObjectSafely:@(2) forKey:@"state"];
    [dataParam setObjectSafely:@(orderno) forKey:@"diagnosisID"];
    [dataParam setObjectSafely:diagnose  forKey:@"diagnosisContent"];
    [dataParam setObjectSafely:ftppath forKey:@"recipePic"];
    [dataParam setObjectSafely:@(number) forKey:@"recipeNum"];
    
    NSMutableArray * recipeDataArray = [NSMutableArray new];
    [dataParam setObjectSafely:recipeDataArray forKey:@"recipeData"];
    [param setObjectSafely:[dataParam JSONString] forKey:@"data"];
    
    NSLog(@"%@",param);
    
    [[AppCore sharedInstance].apiManager POST:URL_AfterBase parameters:param callbackRunInGlobalQueue:YES parser:nil parseMethod:nil resultBlock:^(SNHTTPRequestOperation *request, SNServerAPIResultData *result){
        if (!result.hasError){
            
        }
        resultBlock(nil, result);
    } forKey:@"medicine" forPageNameGroup:pageName];
}


@end