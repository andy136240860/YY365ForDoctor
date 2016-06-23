//
//  TreatmentOrderManager.h
//  FindDoctor
//
//  Created by Guo on 15/11/16.
//  Copyright © 2015年 li na. All rights reserved.
//

#import "SNBusinessMananger.h"
#import "SNServerAPIDefine.h"
#import "TreatmentOrder.h"

@interface TreatmentOrderManager : SNBusinessMananger

@property (strong,nonatomic) TreatmentOrder  *treatmentOrder;

SINGLETON_DECLARE(TreatmentOrderManager);

@end

@interface TreatmentOrderManager (Network)

//获取诊疗点数据库
- (void)FangHaoForGetClinicWithResultBlock:(SNServerAPIResultBlock)resultBlock pageName:(NSString *)pageName;

// 提交时间与诊疗点ID获取时间占用情况
- (void)FangHaoForGetTimeUsedStateWithTiemstamp:(NSInteger)timeStamp
                                         clinic:(Clinic *)clinic
                                    resultBlock:(SNServerAPIResultBlock)resultBlock pageName:(NSString *)pageName;

// 提交放号信息
- (void)FangHaoWithDate:(NSInteger)date
              clinic_id:(NSInteger)clinic_id
                    num:(NSInteger)num
                    fee:(NSInteger)fee
                orderNo:(long long)orderNo
              startTime:(NSTimeInterval)startTime
                endTime:(NSTimeInterval)endTime
            resultBlock:(SNServerAPIResultBlock)resultBlock pageName:(NSString *)pageName;
// 获取放号列表
- (void)getListWithPageSize:(NSInteger)pageSize CurrentPage:(NSInteger)currentPage resultBlock:(SNServerAPIResultBlock)resultBlock pageName:(NSString *)pageName;

// 放号删除
- (void)deleteOrderWithOrderNumber:(long long)orderNo resultBlock:(SNServerAPIResultBlock)resultBlock pageName:(NSString *)pageName;

// 获取放号详情
- (void)getOrderDetailWithOrderNumber:(NSInteger)orderno resultBlock:(SNServerAPIResultBlock)resultBlock pageName:(NSString *)pageName;

//文字代码开方
- (void)medicineWithOrderNumber:(long long)orderno
                recipeData:(NSMutableArray *)recipeData
                         number:(NSInteger)number
                       diagnose:(NSString *)diagnose
                    resultBlock:(SNServerAPIResultBlock)resultBlock pageName:(NSString *)pageName;

//拍照开方
- (void)medicineWithOrderNumber:(long long)orderno
                        ftppath:(NSString *)ftppath
                         number:(NSInteger)number
                       diagnose:(NSString *)diagnose
                    resultBlock:(SNServerAPIResultBlock)resultBlock pageName:(NSString *)pageName;

@end