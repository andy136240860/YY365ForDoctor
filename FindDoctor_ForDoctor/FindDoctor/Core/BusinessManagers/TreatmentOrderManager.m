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

- (void)FangHaoForGetClinicWithResultBlock:(SNServerAPIResultBlock)resultBlock pageName:(NSString *)pageName
{
#if !LOCAL
    NSMutableDictionary * param = [NSMutableDictionary dictionary];
    [param setObjectSafely:kPlatformFrom forKey:@"from"];
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
            NSInteger errorCode = [result.responseObject integerForKeySafely:@"errorCode"];
            if (errorCode == 0) {
                NSArray *recvList = [result.responseObject arrayForKeySafely:@"data"];
                NSMutableArray *clinicArray = [NSMutableArray new];
                [recvList enumerateObjectsUsingBlockSafety:^(id  _Nonnull obj, NSUInteger idx, BOOL *stop) {
                    Clinic *clinic = [[Clinic alloc]init];
                    clinic.ID = [obj integerForKeySafely:@"dataID"];
                    clinic.name = [obj stringForKeySafely:@"name"];
                    [clinicArray addObjectSafely:clinic];
                }];
                result.parsedModelObject = clinicArray;
            }
            else {
            
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
    [param setObjectSafely:kPlatformFrom forKey:@"from"];
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
            NSInteger err_code = [result.responseObject integerForKeySafely:@"errorCode"];
            if (err_code == 0) {
                NSArray *array = [[result.responseObject dictionaryForKeySafely:@"data"] arrayForKeySafely:@"usedTime"];
                clinic.timeUesdArray = [NSMutableArray new];
                for (int i = 0; i < array.count; i++) {
                    NSMutableDictionary *dic = [array objectAtIndex:i];
                    TimeUesd *timeused = [[TimeUesd alloc]init];
                    timeused.startTime = [dic longlongForKeySafely:@"startTime"];
                    timeused.endTime = [dic longlongForKeySafely:@"endTime"];
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
    [param setObjectSafely:kPlatformFrom forKey:@"from"];
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
- (void)getListWithPageSize:(NSInteger)pageSize CurrentPage:(NSInteger)currentPage resultBlock:(SNServerAPIResultBlock)resultBlock pageName:(NSString *)pageName{
    NSMutableDictionary * param = [NSMutableDictionary dictionary];
    [param setObjectSafely:kPlatformFrom forKey:@"from"];
    [param setObjectSafely:[CUUserManager sharedInstance].user.token forKey:@"token"];
    [param setObjectSafely:@"ReleaseDiagnosisRecords" forKey:@"require"];
    [param setObjectSafely:@(23001) forKey:@"interfaceID"];
    [param setObjectSafely:@((NSInteger)[NSDate timeIntervalSince1970]) forKey:@"timestamp"];
    
    NSMutableDictionary * dataParam = [NSMutableDictionary dictionary];
    
    [dataParam setObjectSafely:@([CUUserManager sharedInstance].user.userId) forKey:@"accID"];
    [dataParam setObjectSafely:@(pageSize) forKey:@"pageNum"];
    [dataParam setObjectSafely:@(currentPage + 1) forKey:@"pageID"];
    
    [param setObjectSafely:[dataParam JSONString] forKey:@"data"];
    
    [[AppCore sharedInstance].apiManager POST:URL_AfterBase parameters:param callbackRunInGlobalQueue:YES parser:nil parseMethod:nil resultBlock:^(SNHTTPRequestOperation *request, SNServerAPIResultData *result){
        if (!result.hasError){
            SNBaseListModel *listModel = [[SNBaseListModel alloc] init];
            NSInteger errorCode = [result.responseObject integerForKeySafely:@"errorCode"];
            if (errorCode == 0){
                NSArray *dataArray = [[result.responseObject dictionaryForKeySafely:@"data"] arrayForKeySafely:@"dataList"];
                listModel.pageInfo.totalCount = [[[result.responseObject dictionaryForKeySafely:@"data"] valueForKeySafely:@"totalNum"] integerValue];
                for (int i = 0; i < dataArray.count ; i++) {
                    NSMutableDictionary *dic = [dataArray objectAtIndex:i];
                    TreatmentOrder *treatmentOrder = [[TreatmentOrder alloc]init];
                    treatmentOrder.clinic = [[Clinic alloc]init];
                    treatmentOrder.subject = [dic stringForKeySafely:@"DiagnosisSubject"];
                    treatmentOrder.clinic.address = [dic stringForKeySafely:@"address"];
                    treatmentOrder.clinic.name = [dic stringForKeySafely:@"name"];
                    treatmentOrder.fee = [dic integerForKeySafely:@"fee"];
                    treatmentOrder.num = [dic integerForKeySafely:@"num"];
                    treatmentOrder.orderno = [dic longlongForKeySafely:@"releaseID"];
                    treatmentOrder.startTime = [dic longlongForKeySafely:@"startTime"];
                    treatmentOrder.endTime = [dic longlongForKeySafely:@"endTime"];
                    treatmentOrder.editState = [dic integerForKeySafely:@"state"];
                    
                    long long inttime = [dic longlongForKeySafely:@"startTime"];
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
        }
        resultBlock(nil, result);
    } forKey:@"getList" forPageNameGroup:pageName];

}


//放号删除
- (void)deleteOrderWithOrderNumber:(long long)orderNo resultBlock:(SNServerAPIResultBlock)resultBlock pageName:(NSString *)pageName{
    NSMutableDictionary * param = [NSMutableDictionary dictionary];
    [param setObjectSafely:kPlatformFrom forKey:@"from"];
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
    [param setObjectSafely:kPlatformFrom forKey:@"from"];
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
            NSDictionary *dic = [[result.responseObject dictionaryForKeySafely:@"data"] dictionaryForKeySafely:@"list"];
            
            TreatmentOrder *treatmentOrder = [[TreatmentOrder alloc]init];
            treatmentOrder.clinic = [[Clinic alloc]init];
            treatmentOrder.subject = [dic stringForKeySafely:@"DiagnosisSubject"];
            treatmentOrder.clinic.address = [dic stringForKeySafely:@"address"];
            treatmentOrder.clinic.name = [dic stringForKeySafely:@"name"];
            treatmentOrder.fee = [dic integerForKeySafely:@"fee"];
            treatmentOrder.num = [dic integerForKeySafely:@"number"];
            
            long long inttime = [dic longlongForKeySafely:@"releasestarttime"]/1000;
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
    [param setObjectSafely:kPlatformFrom forKey:@"from"];
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
    [param setObjectSafely:kPlatformFrom forKey:@"from"];
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