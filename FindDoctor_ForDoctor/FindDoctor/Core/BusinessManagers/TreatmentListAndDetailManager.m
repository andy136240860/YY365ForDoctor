//
//  TreatmentListAndDetailManager.m
//  FindDoctor
//
//  Created by Guo on 15/11/16.
//  Copyright © 2015年 li na. All rights reserved.
//

#import "TreatmentListAndDetailManager.h"
#import "CUServerAPIConstant.h"
#import "SNPlatFormManager.h"
#import "JSONKit.h"
#import "SNNetworkClient.h"
#import "AppCore.h"
#import "CUUserManager.h"
#import "NSDate+SNExtension.h"
#import "SNBaseListModel.h"

#import "Patient.h"

#import "TipMessageData.h"
#import "MyAccount.h"

#import "AppDelegate.h"

#import "CUHerbSelect.h"


@implementation TreatmentListAndDetailManager

SINGLETON_IMPLENTATION(TreatmentListAndDetailManager);

@end

@implementation TreatmentListAndDetailManager (Network)

- (void)getCurrentTreatmentListWithPageNum:(NSInteger)pageNum pageSize:(NSInteger)pageSize resultBlock:(SNServerAPIResultBlock)resultBlock pageName:(NSString *)pageName
{
    NSMutableDictionary * param = [NSMutableDictionary dictionary];
    [param setObjectSafely:@"ios" forKey:@"from"];
    [param setObjectSafely:[CUUserManager sharedInstance].user.token forKey:@"token"];
    [param setObjectSafely:@"TodayUserDiagnosis" forKey:@"require"];
    [param setObjectSafely:@(22001) forKey:@"interfaceID"];
    [param setObjectSafely:@((NSInteger)[NSDate timeIntervalSince1970]) forKey:@"timestamp"];
    
    NSMutableDictionary * dataParam = [NSMutableDictionary dictionary];
    [dataParam setObjectSafely:@([CUUserManager sharedInstance].user.userId) forKey:@"accID"];
    [param setObjectSafely:[dataParam JSONString] forKey:@"data"];
    
    NSLog(@"%@",param);
    
    
    [[AppCore sharedInstance].apiManager POST:URL_AfterBase parameters:param callbackRunInGlobalQueue:YES parser:nil parseMethod:nil resultBlock:^(SNHTTPRequestOperation *request, SNServerAPIResultData *result){
#if !LOCAL
        if (!result.hasError){
//            NSInteger err_code = [[result.responseObject valueForKeySafely:@"errorCode"] integerValue];
//            if (err_code == 0) {
//                SNBaseListModel *listModel = [[SNBaseListModel alloc] init];
//                NSArray *data = [result.responseObject valueForKeySafely:@"data"];
//                NSLog(@"data.count = %d",data.count);
//                for(int i = 0;i < data.count;i++){
//                    Patient  *currentTreatment = [[Patient alloc] init];
//                    currentTreatment.diagnosisID = [NSString stringWithFormat:@"%@",[[data objectAtIndexSafely:i] valueForKeySafely:@"diagnosisID"]];
////                    currentTreatment.UserHeaderImageURL = [NSString stringWithFormat:@"%@",[[data objectAtIndexSafely:i] valueForKeySafely:@"ftppath"]];
//                    currentTreatment.UserName = [[data objectAtIndexSafely:i] valueForKeySafely:@"userName"];
//                    currentTreatment.UserAge= [[[data objectAtIndexSafely:i] valueForKeySafely:@"userAge"] integerValue];
//                    currentTreatment.UserSex = [[[data objectAtIndexSafely:i] valueForKeySafely:@"userSex"] integerValue];
//                    currentTreatment.UserCellPhone = [[data objectAtIndexSafely:i] valueForKeySafely:@"userPhone"];
//                    currentTreatment.orderNo = [[[data objectAtIndexSafely:i] valueForKeySafely:@"orderNo"] integerValue];
//                    currentTreatment.clinicAddress = [NSString stringWithFormat:@"%@",[[data objectAtIndexSafely:i] valueForKeySafely:@"clinicAddress"]];;
//                    currentTreatment.diagnosisFee = [[[data objectAtIndexSafely:i] valueForKeySafely:@"fee"] integerValue];
//                    currentTreatment.diagnosisID = [[data objectAtIndex:i] valueForKey:@"diagnosisID"];
//                    currentTreatment.state = [[[data objectAtIndex:i] valueForKey:@"state"] integerValue];
//                    currentTreatment.illnessDescription =   [[data objectAtIndex:i] valueForKey:@"illnessDescription"];
//                    [listModel.items addObject:currentTreatment];
//                }
//                result.parsedModelObject = listModel;
//            }
            NSInteger err_code = [[result.responseObject valueForKeySafely:@"errorCode"] integerValue];
            if (err_code == 0) {
                SNBaseListModel *listModel = [[SNBaseListModel alloc] init];
                NSMutableArray *data = [result.responseObject valueForKeySafely:@"data"];
                NSLog(@"data.count = %d",data.count);
                for(int i = 0;i < data.count ; i++ ){
                    NSMutableDictionary *dic = [data objectAtIndex:i];
                    Patient *zhenLiaoRecord = [[Patient alloc] init];
                    zhenLiaoRecord.diagnosisFee = [[dic objectForKeySafely:@"fee"] integerValue];
                    zhenLiaoRecord.UserName = [dic objectForKeySafely:@"userName"];
                    zhenLiaoRecord.UserSex = [[dic objectForKeySafely:@"userSex"] integerValue];
                    zhenLiaoRecord.UserAge = [[dic objectForKeySafely:@"userAge"] integerValue];
                    zhenLiaoRecord.UserCellPhone = [dic objectForKey:@"userPhone"];
                    zhenLiaoRecord.diagnosisID = [dic objectForKeySafely:@"diagnosisID"];
                    zhenLiaoRecord.state = [[dic objectForKeySafely:@"state"] integerValue];
                    zhenLiaoRecord.diagnosisTime = [[dic objectForKeySafely:@"diagnosisTime"] integerValue];
                    zhenLiaoRecord.submitTime = [[dic objectForKeySafely:@"submitTime"] integerValue];
                    zhenLiaoRecord.doctorName = [dic objectForKeySafely:@"doctorName"];
                    zhenLiaoRecord.doctorTitle = [dic objectForKeySafely:@"title"];
                    zhenLiaoRecord.clinicAddress = [dic objectForKeySafely:@"clinicAddress"];
                    zhenLiaoRecord.clinicName = [dic objectForKeySafely:@"clinicName"];
                    zhenLiaoRecord.illnessDescription = [dic objectForKeySafely:@"illnessDescription"];
                    zhenLiaoRecord.illnessPic =[dic objectForKeySafely:@"illnessPic"];
                    zhenLiaoRecord.orderNo =[[dic objectForKeySafely:@"orderNo"] integerValue];
                    zhenLiaoRecord.diagnosisContent = [dic objectForKeySafely:@"diagnosisContent"];
                    zhenLiaoRecord.recipeNum = [[dic objectForKeySafely:@"recipeNum"] integerValue];
                    zhenLiaoRecord.recipePic = [dic objectForKeySafely:@"recipePic"];
                    
                    zhenLiaoRecord.recipeData = [NSMutableArray new];
                    NSMutableArray *recipeDataArray = [dic objectForKeySafely:@"recipeData"];
                    for (int i = 0 ; i < recipeDataArray.count; i++) {
                        NSMutableDictionary *recipeDataDic = recipeDataArray[i];
                        CUHerbSelect *herb = [[CUHerbSelect alloc]init];
                        herb.herbid = [recipeDataDic objectForKeySafely:@"dataID"];
                        herb.name = [recipeDataDic objectForKeySafely:@"name"];
                        herb.weight = [[recipeDataDic objectForKeySafely:@"num"] integerValue];
                        herb.unit = [recipeDataDic objectForKeySafely:@"unit"];
                        [zhenLiaoRecord.recipeData addObject:herb];
                    }
                    
                    [listModel.items addObject:zhenLiaoRecord];
                }
                result.parsedModelObject = listModel;
            }
        }
    resultBlock(nil, result);
#else
        SNBaseListModel *listModel = [[SNBaseListModel alloc] init];
        for(int i = 0;i < 20;i++){
            CurrentTreatment  *currentTreatment = [[CurrentTreatment alloc] init];
            currentTreatment.queueId = @"123";
//            currentTreatment.UserHeaderImageURL = [NSString stringWithFormat:@"%@",[[data objectAtIndexSafely:i] valueForKeySafely:@"ftppath"]];
            currentTreatment.UserNickName = @"131313";
            currentTreatment.queueNumber = @"2342423";
//
//            NSString *date = [NSString stringWithFormat:@"%@",[[data objectAtIndexSafely:i] valueForKeySafely:@"startdiagnosistime"]];
//            date = [date substringToIndex:10];
//            NSLog(@"%@",date);
//            currentTreatment.queueTime = [NSDate convertDateIntervalToStringWith:date];
//            currentTreatment.DiseaseDescription = [[data objectAtIndexSafely:i] valueForKeySafely:@"description"];
            currentTreatment.isVIP = NO;
            currentTreatment.queueAddress = @"123";
            currentTreatment.queueState = @"243424";
            currentTreatment.orderno = 12313131312;
            currentTreatment.state = 0;
            [listModel.items addObject:currentTreatment];
        }
        result.parsedModelObject = listModel;
        resultBlock(nil, result);
     
#endif
    } forKey:@"currentTreatment" forPageNameGroup:pageName];
}


//约诊记录
- (void)getYueZhenRecordListWithPageNum:(NSInteger)pageNum pageSize:(NSInteger)pageSize resultBlock:(SNServerAPIResultBlock)resultBlock pageName:(NSString *)pageName
{
    NSMutableDictionary * param = [NSMutableDictionary dictionary];
    [param setObjectSafely:@"ios" forKey:@"from"];
    [param setObjectSafely:[CUUserManager sharedInstance].user.token forKey:@"token"];
    [param setObjectSafely:@"ReleaseOrderRecords" forKey:@"require"];
    [param setObjectSafely:@(23002) forKey:@"interfaceID"];
    [param setObjectSafely:@((NSInteger)[NSDate timeIntervalSince1970]) forKey:@"timestamp"];
    
    NSMutableDictionary * dataParam = [NSMutableDictionary dictionary];
    
    NSLog(@"%ld",(long)[CUUserManager sharedInstance].user.userId);
    
    [dataParam setObjectSafely:@([CUUserManager sharedInstance].user.userId) forKey:@"accID"];
    [param setObjectSafely:[dataParam JSONString] forKey:@"data"];
    
    NSLog(@"%@",param);
    
    [[AppCore sharedInstance].apiManager POST:URL_AfterBase parameters:param callbackRunInGlobalQueue:YES parser:nil parseMethod:nil resultBlock:^(SNHTTPRequestOperation *request, SNServerAPIResultData *result){
        if (!result.hasError){
            NSInteger err_code = [[result.responseObject valueForKeySafely:@"errorCode"] integerValue];
            if (err_code == 0) {
                SNBaseListModel *listModel = [[SNBaseListModel alloc] init];
                NSMutableArray *data = [result.responseObject valueForKeySafely:@"data"];
                NSLog(@"data.count = %d",data.count);
                for(int i = 0;i < data.count ; i++ ){
                    NSMutableDictionary *dic = [data objectAtIndex:i];
                    Patient *zhenLiaoRecord = [[Patient alloc] init];
                    zhenLiaoRecord.diagnosisFee = [[dic objectForKeySafely:@"fee"] integerValue];
                    zhenLiaoRecord.UserName = [dic objectForKeySafely:@"userName"];
                    zhenLiaoRecord.UserSex = [[dic objectForKeySafely:@"userSex"] integerValue];
                    zhenLiaoRecord.UserAge = [[dic objectForKeySafely:@"userAge"] integerValue];
                    zhenLiaoRecord.UserCellPhone = [dic objectForKey:@"userPhone"];
                    zhenLiaoRecord.diagnosisID = [dic objectForKeySafely:@"diagnosisID"];
                    zhenLiaoRecord.state = [[dic objectForKeySafely:@"state"] integerValue];
                    zhenLiaoRecord.diagnosisTime = [[dic objectForKeySafely:@"diagnosisTime"] integerValue];
                    zhenLiaoRecord.submitTime = [[dic objectForKeySafely:@"submitTime"] integerValue];
                    zhenLiaoRecord.doctorName = [dic objectForKeySafely:@"doctorName"];
                    zhenLiaoRecord.doctorTitle = [dic objectForKeySafely:@"title"];
                    zhenLiaoRecord.clinicAddress = [dic objectForKeySafely:@"clinicAddress"];
                    zhenLiaoRecord.clinicName = [dic objectForKeySafely:@"clinicName"];
                    zhenLiaoRecord.illnessDescription = [dic objectForKeySafely:@"illnessDescription"];
                    zhenLiaoRecord.illnessPic =[dic objectForKeySafely:@"illnessPic"];
                    zhenLiaoRecord.orderNo =[[dic objectForKeySafely:@"orderNo"] integerValue];
                    zhenLiaoRecord.diagnosisContent = [dic objectForKeySafely:@"diagnosisContent"];
                    zhenLiaoRecord.recipeNum = [[dic objectForKeySafely:@"recipeNum"] integerValue];
                    zhenLiaoRecord.recipePic = [dic objectForKeySafely:@"recipePic"];
                    zhenLiaoRecord.orderStartTime = [[dic objectForKeySafely:@"orderStartTime"] integerValue];
                    zhenLiaoRecord.orderEndTime = [[dic objectForKeySafely:@"orderEndTime"] integerValue];
                    
                    zhenLiaoRecord.recipeData = [NSMutableArray new];
                    NSMutableArray *recipeDataArray = [dic objectForKeySafely:@"recipeData"];
                    for (int i = 0 ; i < recipeDataArray.count; i++) {
                        NSMutableDictionary *recipeDataDic = recipeDataArray[i];
                        CUHerbSelect *herb = [[CUHerbSelect alloc]init];
                        herb.herbid = [recipeDataDic objectForKeySafely:@"dataID"];
                        herb.name = [recipeDataDic objectForKeySafely:@"name"];
                        herb.weight = [[recipeDataDic objectForKeySafely:@"num"] integerValue];
                        herb.unit = [recipeDataDic objectForKeySafely:@"unit"];
                        [zhenLiaoRecord.recipeData addObject:herb];
                    }
                    
                    [listModel.items addObject:zhenLiaoRecord];
                }
                result.parsedModelObject = listModel;
            }
        }
    resultBlock(nil, result);
    } forKey:@"yueZhenRecord" forPageNameGroup:pageName];
}

////约诊单详情
//- (void)getYueZhenDetailWithOrderno:(NSString *)orderno resultBlock:(SNServerAPIResultBlock)resultBlock pageName:(NSString *)pageName
//{
//    NSMutableDictionary * param = [NSMutableDictionary dictionary];
//    [param setObjectSafely:@"ios" forKey:@"from"];
//    [param setObjectSafely:[CUUserManager sharedInstance].user.token forKey:@"token"];
//    [param setObjectSafely:@"ReleaseOrderRecords" forKey:@"require"];
//    [param setObjectSafely:@(23003) forKey:@"interfaceID"];
//    [param setObjectSafely:@((NSInteger)[NSDate timeIntervalSince1970]) forKey:@"timestamp"];
//    
//    NSMutableDictionary * dataParam = [NSMutableDictionary dictionary];
//    
//    NSLog(@"%ld",(long)[CUUserManager sharedInstance].user.userId);
//    
//    [dataParam setObjectSafely:@([CUUserManager sharedInstance].user.userId) forKey:@"accID"];
//    [param setObjectSafely:[dataParam JSONString] forKey:@"data"];
//    
//    NSLog(@"%@",param);
//    
//    NSLog(@"%@",param);
//    
//    [[AppCore sharedInstance].apiManager POST:URL_PrescriptionConfirm parameters:param callbackRunInGlobalQueue:YES parser:nil parseMethod:nil resultBlock:^(SNHTTPRequestOperation *request, SNServerAPIResultData *result){
//        if (!result.hasError){
//            NSMutableDictionary *dic = [[result.responseObject valueForKeySafely:@"data"] valueForKeySafely:@"result"];
//            
//            YueZhenRecord *zhenLiaoRecord = [[YueZhenRecord alloc] init];
//            
//            zhenLiaoRecord.doctorTitle = [dic objectForKeySafely:@"doctor_title"];
//            zhenLiaoRecord.startTime = [[dic objectForKeySafely:@"starttime"] longLongValue]/1000;
//            zhenLiaoRecord.UserName = [dic objectForKeySafely:@"username"];
//            zhenLiaoRecord.UserAge = [[dic objectForKeySafely:@"age"] integerValue];
//            zhenLiaoRecord.UserSex = [dic objectForKeySafely:@"sex"];
//            zhenLiaoRecord.queueId = [NSString stringWithFormat:@"%lld",[[dic objectForKeySafely:@"orderno"] longLongValue]];
//            zhenLiaoRecord.medicineImageURL =[dic objectForKeySafely:@"ftppath"];
//            zhenLiaoRecord.fee = [[dic objectForKeySafely:@"fee"] integerValue]/100.f;
//            zhenLiaoRecord.clinicAddress = [dic objectForKeySafely:@"address"];
//            zhenLiaoRecord.medicineNumber = [[dic objectForKeySafely:@"medicinenumber"] integerValue];
//            zhenLiaoRecord.doctorName = [dic objectForKeySafely:@"doctorname"];
//            zhenLiaoRecord.clinicName = [dic objectForKeySafely:@"cname"];
//            zhenLiaoRecord.UserCellPhone = [dic objectForKeySafely:@"phone"];
////            zhenLiaoRecord.verid = [[dic objectForKeySafely:@"verid"] longLongValue]/1000;
//            zhenLiaoRecord.zhengZhuangMiaoShu = [dic objectForKeySafely:@"description"];
//            zhenLiaoRecord.diagnose = [dic objectForKeySafely:@"diagnose"];
//            
//            
//            result.parsedModelObject = zhenLiaoRecord;
//            resultBlock(nil, result);
//            
//        }
//    } forKey:@"zhenLiaoRecord" forPageNameGroup:pageName];
//}

//诊疗记录
- (void)getZhenLiaoRecordListWithPageNum:(NSInteger)pageNum pageSize:(NSInteger)pageSize resultBlock:(SNServerAPIResultBlock)resultBlock pageName:(NSString *)pageName
{
    NSMutableDictionary * param = [NSMutableDictionary dictionary];
    [param setObjectSafely:@"ios" forKey:@"from"];
    [param setObjectSafely:[CUUserManager sharedInstance].user.token forKey:@"token"];
    [param setObjectSafely:@"DoctorDiagnosisRecords" forKey:@"require"];
    [param setObjectSafely:@(23003) forKey:@"interfaceID"];
    [param setObjectSafely:@((NSInteger)[NSDate timeIntervalSince1970]) forKey:@"timestamp"];
    
    NSMutableDictionary * dataParam = [NSMutableDictionary dictionary];
    
    NSLog(@"%ld",(long)[CUUserManager sharedInstance].user.userId);
    
    [dataParam setObjectSafely:@([CUUserManager sharedInstance].user.userId) forKey:@"accID"];  
    [param setObjectSafely:[dataParam JSONString] forKey:@"data"];
    
    NSLog(@"%@",param);
    
    [[AppCore sharedInstance].apiManager POST:URL_AfterBase parameters:param callbackRunInGlobalQueue:YES parser:nil parseMethod:nil resultBlock:^(SNHTTPRequestOperation *request, SNServerAPIResultData *result){
        if (!result.hasError){
            NSInteger err_code = [[result.responseObject valueForKeySafely:@"errorCode"] integerValue];
            if (err_code == 0) {
                SNBaseListModel *listModel = [[SNBaseListModel alloc] init];
                NSMutableArray *data = [result.responseObject valueForKeySafely:@"data"];
                NSLog(@"data.count = %d",data.count);
                for(int i = 0;i < data.count ; i++ ){
                    NSMutableDictionary *dic = [data objectAtIndex:i];
                    Patient *zhenLiaoRecord = [[Patient alloc] init];
                    zhenLiaoRecord.diagnosisFee = [[dic objectForKeySafely:@"fee"] integerValue];
                    zhenLiaoRecord.UserName = [dic objectForKeySafely:@"userName"];
                    zhenLiaoRecord.UserSex = [[dic objectForKeySafely:@"userSex"] integerValue];
                    zhenLiaoRecord.UserAge = [[dic objectForKeySafely:@"userAge"] integerValue];
                    zhenLiaoRecord.UserCellPhone = [dic objectForKey:@"userPhone"];
                    zhenLiaoRecord.diagnosisID = [dic objectForKeySafely:@"diagnosisID"];
                    zhenLiaoRecord.state = [[dic objectForKeySafely:@"state"] integerValue];
                    zhenLiaoRecord.diagnosisTime = [[dic objectForKeySafely:@"diagnosisTime"] integerValue];
                    zhenLiaoRecord.submitTime = [[dic objectForKeySafely:@"submitTime"] integerValue];
                    zhenLiaoRecord.doctorName = [dic objectForKeySafely:@"doctorName"];
                    zhenLiaoRecord.doctorTitle = [dic objectForKeySafely:@"title"];
                    zhenLiaoRecord.clinicAddress = [dic objectForKeySafely:@"clinicAddress"];
                    zhenLiaoRecord.clinicName = [dic objectForKeySafely:@"clinicName"];
                    zhenLiaoRecord.illnessDescription = [dic objectForKeySafely:@"illnessDescription"];
                    zhenLiaoRecord.illnessPic =[dic objectForKeySafely:@"illnessPic"];
                    zhenLiaoRecord.orderNo =[[dic objectForKeySafely:@"orderNo"] integerValue];
                    zhenLiaoRecord.diagnosisContent = [dic objectForKeySafely:@"diagnosisContent"];
                    zhenLiaoRecord.recipeNum = [[dic objectForKeySafely:@"recipeNum"] integerValue];
                    zhenLiaoRecord.recipePic = [dic objectForKeySafely:@"recipePic"];
                    zhenLiaoRecord.orderStartTime = [[dic objectForKeySafely:@"orderStartTime"] integerValue];
                    zhenLiaoRecord.orderEndTime = [[dic objectForKeySafely:@"orderEndTime"] integerValue];
                    
                    zhenLiaoRecord.recipeData = [NSMutableArray new];
                    NSMutableArray *recipeDataArray = [dic objectForKeySafely:@"recipeData"];
                    for (int i = 0 ; i < recipeDataArray.count; i++) {
                        NSMutableDictionary *recipeDataDic = recipeDataArray[i];
                        CUHerbSelect *herb = [[CUHerbSelect alloc]init];
                        herb.herbid = [recipeDataDic objectForKeySafely:@"dataID"];
                        herb.name = [recipeDataDic objectForKeySafely:@"name"];
                        herb.weight = [[recipeDataDic objectForKeySafely:@"num"] integerValue];
                        herb.unit = [recipeDataDic objectForKeySafely:@"unit"];
                        [zhenLiaoRecord.recipeData addObject:herb];
                    }
                    
                    [listModel.items addObject:zhenLiaoRecord];
                }
                result.parsedModelObject = listModel;
            }
        }
    resultBlock(nil, result);
    } forKey:@"zhenLiaoRecord" forPageNameGroup:pageName];
}

////诊疗单详情
//- (void)getZhenLiaoDetailWithOrderno:(NSString *)orderno resultBlock:(SNServerAPIResultBlock)resultBlock pageName:(NSString *)pageName
//{
//    NSMutableDictionary * param = [NSMutableDictionary dictionary];
//    [param setObjectSafely:@"ios" forKey:@"from"];
//    [param setObjectSafely:[CUUserManager sharedInstance].user.token forKey:@"token"];
//    [param setObjectSafely:@"ReleaseOrderRecords" forKey:@"require"];
//    [param setObjectSafely:@(23003) forKey:@"interfaceID"];
//    [param setObjectSafely:@((NSInteger)[NSDate timeIntervalSince1970]) forKey:@"timestamp"];
//    
//    NSMutableDictionary * dataParam = [NSMutableDictionary dictionary];
//    
//    NSLog(@"%ld",(long)[CUUserManager sharedInstance].user.userId);
//    
//    [dataParam setObjectSafely:@([CUUserManager sharedInstance].user.userId) forKey:@"accID"];
//    [param setObjectSafely:[dataParam JSONString] forKey:@"data"];
//    
//    NSLog(@"%@",param);
//    
//    NSLog(@"%@",param);
//    
//    [[AppCore sharedInstance].apiManager POST:URL_PrescriptionConfirm parameters:param callbackRunInGlobalQueue:YES parser:nil parseMethod:nil resultBlock:^(SNHTTPRequestOperation *request, SNServerAPIResultData *result){
//        if (!result.hasError){
//            NSMutableDictionary *dic = [[result.responseObject valueForKeySafely:@"data"] valueForKeySafely:@"jiuzhendan"];
//
//            ZhenLiaoRecord *zhenLiaoRecord = [[ZhenLiaoRecord alloc] init];
//            
//            zhenLiaoRecord.doctorTitle = [dic objectForKeySafely:@"doctor_title"];
//            zhenLiaoRecord.startTime = [[dic objectForKeySafely:@"starttime"] longLongValue]/1000;
//            zhenLiaoRecord.UserName = [dic objectForKeySafely:@"username"];
//            zhenLiaoRecord.UserAge = [[dic objectForKeySafely:@"age"] integerValue];
//            zhenLiaoRecord.UserSex = [dic objectForKeySafely:@"sex"];
//            zhenLiaoRecord.queueId = [NSString stringWithFormat:@"%lld",[[dic objectForKeySafely:@"orderno"] longLongValue]];
//            zhenLiaoRecord.medicineImageURL =[dic objectForKeySafely:@"ftppath"];
//            zhenLiaoRecord.fee = [[dic objectForKeySafely:@"fee"] integerValue]/100.f;
//            zhenLiaoRecord.clinicAddress = [dic objectForKeySafely:@"address"];
//            zhenLiaoRecord.medicineNumber = [[dic objectForKeySafely:@"medicinenumber"] integerValue];
//            zhenLiaoRecord.doctorName = [dic objectForKeySafely:@"doctorname"];
//            zhenLiaoRecord.clinicName = [dic objectForKeySafely:@"cname"];
//            zhenLiaoRecord.UserCellPhone = [dic objectForKeySafely:@"userphone"];
//            zhenLiaoRecord.varid = [[dic objectForKeySafely:@"verid"] longLongValue]/1000;
//            zhenLiaoRecord.zhengZhuangMiaoShu = [dic objectForKeySafely:@"zhengzhuangmiaoshu"];
//            zhenLiaoRecord.diagnose = [dic objectForKeySafely:@"diagnose"];
//            zhenLiaoRecord.yaoFangDescription = [dic objectForKeySafely:@"description"];
//
//            
//            result.parsedModelObject = zhenLiaoRecord;
//            resultBlock(nil, result);
//            
//        }
//    } forKey:@"zhenLiaoRecord" forPageNameGroup:pageName];
//}

//首页推送
- (void)getHomeTipListWithResultBlock:(SNServerAPIResultBlock)resultBlock pageName:(NSString *)pageName
{
    NSMutableDictionary * param = [NSMutableDictionary dictionary];
    [param setObjectSafely:@"ios" forKey:@"from"];
    [param setObjectSafely:[CUUserManager sharedInstance].user.token forKey:@"token"];
    [param setObjectSafely:@"DoctorAppMainPush" forKey:@"require"];
    [param setObjectSafely:@(20001) forKey:@"interfaceID"];
    [param setObjectSafely:@((NSInteger)[NSDate timeIntervalSince1970]) forKey:@"timestamp"];
    
    NSMutableDictionary * dataParam = [NSMutableDictionary dictionary];
    
    NSLog(@"%ld",(long)[CUUserManager sharedInstance].user.userId);
    
    [dataParam setObjectSafely:@([CUUserManager sharedInstance].user.userId) forKey:@"accID"];
    [dataParam setObjectSafely:@(510100) forKey:@"regionID"];
    [dataParam setObjectSafely:@(104.22) forKey:@"longitude"];
    [dataParam setObjectSafely:@(30.234) forKey:@"latitude"];
    [param setObjectSafely:[dataParam JSONString] forKey:@"data"];
    
    NSLog(@"%@",param);
    
    [[AppCore sharedInstance].apiManager POST:URL_AfterBase parameters:param callbackRunInGlobalQueue:YES parser:nil parseMethod:nil resultBlock:^(SNHTTPRequestOperation *request, SNServerAPIResultData *result){
        if (!result.hasError){
            NSInteger err_code = [[result.responseObject valueForKeySafely:@"errorCode"] integerValue];
            if (err_code == 0) {
                NSMutableArray *dataArray = [[result.responseObject valueForKeySafely:@"data"] valueForKeySafely:@"msgCompany"];
                NSMutableArray *resultArray = [NSMutableArray new];
                for (int i = 0; i < dataArray.count; i++) {
                    NSMutableDictionary *dic = [dataArray objectAtIndex:i];
                    TipMessageData *data = [[TipMessageData alloc]init];
                    data.title = [dic valueForKeySafely:@"title"];
                    
                    //                    NSInteger pageid = [[dic valueForKeySafely:@"type"] integerValue];
                    //                    [resultArray addObjectSafely:data];
                }
                
                NSMutableArray *dataArray2 = [[result.responseObject valueForKeySafely:@"data"] valueForKeySafely:@"msgClinic"];
                for (int i = 0; i < dataArray2.count; i++) {
                    NSMutableDictionary *dic = [dataArray2 objectAtIndex:i];
                    TipMessageData *data = [[TipMessageData alloc]init];
                    data.title = [dic valueForKeySafely:@"title"];
                    [resultArray addObjectSafely:data];
                }
                
                NSMutableArray *dataArray3 = [[result.responseObject valueForKeySafely:@"data"] valueForKeySafely:@"msgReleaseDiagnosis"];
                for (int i = 0; i < dataArray3.count; i++) {
                    NSMutableDictionary *dic = [dataArray3 objectAtIndex:i];
                    TipMessageData *data = [[TipMessageData alloc]init];
                    data.title = [NSString stringWithFormat:@"已放号%@于%@",[dic valueForKeySafely:@"name"],[[NSDate dateWithTimeIntervalSince1970:[[dic valueForKeySafely:@"startTime"] integerValue]] stringWithDateFormat:@"MM-dd HH:mm"]];
                    //                    NSInteger pageid = [[dic valueForKeySafely:@"type"] integerValue];
                    [resultArray addObjectSafely:data];
                }
                
                NSMutableArray *dataArray4 = [[result.responseObject valueForKeySafely:@"data"] valueForKeySafely:@"msgUserOrderDiagnosis"];
                for (int i = 0; i < dataArray4.count; i++) {
                    NSMutableDictionary *dic = [dataArray4 objectAtIndex:i];
                    TipMessageData *data = [[TipMessageData alloc]init];
                    data.title = [NSString stringWithFormat:@"%@约诊%@于%@",[dic valueForKeySafely:@"userName"],[[NSDate dateWithTimeIntervalSince1970:[[dic valueForKeySafely:@"submitTime"] integerValue]] stringWithDateFormat:@"MM-dd HH:mm"],[dic valueForKeySafely:@"clinicName"]];
                    
                    [resultArray addObjectSafely:data];
                }
                
//                NSMutableArray *arr = [NSMutableArray new];
//                for (int i = 0; i < 6; i++) {
//                    if (i < resultArray.count) {
//                        [arr addObject:[resultArray objectAtIndex:i]];
//                    }
//                }
                result.parsedModelObject = resultArray;
            }
            else if (err_code < 0){
#if useErrCodeForLogout
                [[CUUserManager sharedInstance] clear];
                [[AppDelegate app] launchMainView];
#endif
            }
            
            resultBlock(nil, result);
            
        }
    } forKey:@"HomeTipList" forPageNameGroup:pageName];
}



//我的账户
- (void)getMyAccountWithResultBlock:(SNServerAPIResultBlock)resultBlock pageName:(NSString *)pageName
{
    NSMutableDictionary * param = [NSMutableDictionary dictionary];
    [param setObjectSafely:@"ios" forKey:@"from"];
    [param setObjectSafely:[CUUserManager sharedInstance].user.token forKey:@"token"];
    [param setObjectSafely:@"DoctorConsumeRecords" forKey:@"require"];
    [param setObjectSafely:@(23004) forKey:@"interfaceID"];
    [param setObjectSafely:@((NSInteger)[NSDate timeIntervalSince1970]) forKey:@"timestamp"];
    
    NSMutableDictionary * dataParam = [NSMutableDictionary dictionary];
    [dataParam setObjectSafely:@([CUUserManager sharedInstance].user.userId) forKey:@"accID"];
    [param setObjectSafely:[dataParam JSONString] forKey:@"data"];
    
    NSLog(@"%@",param);
    
    
    [[AppCore sharedInstance].apiManager POST:URL_AfterBase parameters:param callbackRunInGlobalQueue:YES parser:nil parseMethod:nil resultBlock:^(SNHTTPRequestOperation *request, SNServerAPIResultData *result){
#if !LOCAL
        if (!result.hasError){
            NSInteger err_code = [[result.responseObject valueForKeySafely:@"errorCode"] integerValue];
            if (err_code == 0) {
                NSMutableDictionary  *dic = [result.responseObject valueForKeySafely:@"data"];
                if([dic isKindOfClass:[NSDictionary class]]){
                    NSMutableArray *dataArray1 = [NSMutableArray new];
                    id obj = [dic objectForKey:@"moneyRecords"];
                    if (obj){
                        dataArray1 = [dic objectForKey:@"moneyRecords"];
                    }
                    MyAccount *myAccount = [[MyAccount alloc]init];
                    myAccount.totalCost = [[[result.responseObject valueForKeySafely:@"data"] valueForKeySafely:@"moneyTotal"] doubleValue]/100.f;
                    myAccount.totalIncome = [[[result.responseObject valueForKeySafely:@"data"] valueForKeySafely:@"couponTotal"] doubleValue]/100.f;
                    myAccount.costDetailList = [NSMutableArray new];
                    myAccount.incomeDetailList = [NSMutableArray new];
                    for (int i = 0; i < dataArray1.count; i ++) {
                        CostDetail *item = [[CostDetail alloc]init];
                        item.timeStamp = [[[dataArray1 objectAtIndex:i] valueForKeySafely:@"time"] longLongValue];
                        item.massage = [[dataArray1 objectAtIndex:i] valueForKeySafely:@"information"];
                        item.fee = [[[dataArray1 objectAtIndex:i] valueForKeySafely:@"fee"] integerValue]/100.f;
                        [myAccount.costDetailList addObject:item];
                    }
                    result.parsedModelObject = myAccount;
                }
            }
            else if (err_code < 0){
#if useErrCodeForLogout
                [[CUUserManager sharedInstance] clear];
                [[AppDelegate app] launchMainView];
#endif
            }

            
            resultBlock(nil, result);
        }
#else
        MyAccount *myAccount = [[MyAccount alloc]init];
        myAccount.totalCost = 1255.3;
        myAccount.totalIncome = 2325;
        myAccount.costDetailList = [NSMutableArray new];
        myAccount.incomeDetailList = [NSMutableArray new];
        for (int i = 0; i < 20; i ++) {
            CostDetail *item = [[CostDetail alloc]init];
            item.timeStamp = 1450855230;
            item.massage = @"下单约诊张仲景医生，支付定金";
            item.fee = 200;
            [myAccount.costDetailList addObject:item];
        }
        for (int i = 0; i < 20; i ++) {
            IncomeDetail *item = [[IncomeDetail alloc]init];
            item.timeStamp = 1450855230;
            item.massage = @"用户余智伟在电子科技大学校医院支付定金";
            item.fee = 200;
            [myAccount.incomeDetailList addObject:item];
        }
        result.parsedModelObject = myAccount;
        resultBlock(nil,result);
#endif
    } forKey:@"HomeTipList" forPageNameGroup:pageName];
}







@end