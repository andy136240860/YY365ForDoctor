//
//  patient.h
//  FindDoctor
//
//  Created by 晓炜 郭 on 16/1/20.
//  Copyright © 2016年 li na. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef NS_ENUM(NSInteger, ZhenLiaoRecordSortType) {
    ZhenLiaoRecordSortTypetime      = 0,   // 按时间
    ZhenLiaoRecordSortTypelevel      = 1  // 按等级
};

@interface Patient : NSObject

@property (nonatomic, strong) NSString *diagnosisID;   //就诊单号

@property                     NSInteger diagnosisFee;   //诊金

@property (nonatomic, strong) NSString *clinicName;
@property (nonatomic, strong) NSString *clinicAddress;

@property (nonatomic, strong) NSString *doctorName;
@property (nonatomic, strong) NSString *doctorTitle;  //医生头衔
@property (nonatomic, strong) NSString *doctorIcon;

@property (nonatomic, strong) NSString *illnessDescription;  //病症描述(from patient)
@property (nonatomic, strong) NSArray *illnessPic;  //病症图片(from patient)

@property NSInteger orderNo;   //预约号

@property NSTimeInterval payTime;
@property NSTimeInterval submitTime;
@property NSTimeInterval diagnosisTime;
@property NSTimeInterval orderStartTime;
@property NSTimeInterval orderEndTime;

@property NSInteger state;    // 如果是0是未支付， 1就是已支付

@property NSInteger totalPrice;

@property (nonatomic, strong) NSString *UserID;
@property (nonatomic, strong) NSString *UserName;
@property                     NSInteger UserSex;
@property                     NSInteger UserAge;
@property (nonatomic, strong) NSString *UserCellPhone;

//-----------就诊单需要的Data----------

@property (nonatomic, strong) NSString *diagnosisContent;
@property (nonatomic, strong) NSMutableArray *recipeData;   //处方单药材数组
@property (nonatomic, strong) NSString *recipePic;   //药方照片，没有药方为空
@property                     NSInteger recipeNum;

@end

//约诊单列表
typedef NS_ENUM(NSInteger, YueZhenRecordSortType) {
    YueZhenRecordSortTypetime      = 0,   // 按时间
    YueZhenRecordSortTypelevel      = 1  // 按等级
};

@interface YueZhenRecordFilter : NSObject

@property YueZhenRecordSortType sortType;

@end

//诊疗单列表

@interface ZhenLiaoRecordFilter : NSObject

@property ZhenLiaoRecordSortType sortType;

@end

//当日诊疗列表
typedef NS_ENUM(NSInteger, CurrentTreatmentSortType) {
    CurrentTreatmentSortTypetime      = 0,   // 按时间
    CurrentTreatmentSortTypelevel      = 1  // 按等级
};

@interface CurrentTreatmentFilter : NSObject

@property CurrentTreatmentSortType sortType;

@end