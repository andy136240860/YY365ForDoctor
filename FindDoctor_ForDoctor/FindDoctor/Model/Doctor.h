//
//  Doctor.h
//  FindDoctor
//
//  Created by zhouzhenhua on 15/8/13.
//  Copyright (c) 2015年 li na. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef NS_ENUM(NSInteger, DoctorSortType) {
    DoctorSortTypeRate      = 1,  // 按评分
    DoctorSortTypeDistance  = 2,  // 按距离
    DoctorSortTypeAvailable = 3,  // 按可预约
    DoctorSortTypeNone      = 0
};

@interface Doctor : NSObject

@property (nonatomic, strong) NSString *doctorId;
@property (nonatomic, strong) NSString *name;
@property (nonatomic, strong) NSString *avatar;
@property (nonatomic, strong) NSString *phoneNumber;
@property (nonatomic, strong) NSString *city;
@property (nonatomic, strong) NSString *area;
@property (nonatomic, strong) NSString *address;
@property (nonatomic, strong) NSString *desc;
@property (nonatomic, strong) NSString *levelDesc;
@property (nonatomic, strong) NSString *subject;
@property (nonatomic, strong) NSString *availableTime;
@property (nonatomic, strong) NSString *background;

@property (nonatomic, strong) NSString *skilledDisease;  // 擅长疾病
@property (nonatomic, strong) NSString *skilledSubject;  // 擅长科目

@property BOOL isAvailable;
@property CGFloat rate;
@property double price;

@property NSInteger queueNumber;  // 已预约数量
@property NSInteger queueCount;   // 可预约总数

@property (nonatomic, strong) NSMutableArray *flagList;

- (NSString *)availableDesc;

@end

@interface DoctorFilter : NSObject

@property CGFloat longitude;
@property CGFloat latitude;
@property NSInteger level;
@property NSInteger typeId;
@property NSInteger subTypeId;
@property DoctorSortType sortType;

@property (nonatomic, strong) NSString *keyword;
@property (nonatomic, strong) NSString *priceRange;

@end
