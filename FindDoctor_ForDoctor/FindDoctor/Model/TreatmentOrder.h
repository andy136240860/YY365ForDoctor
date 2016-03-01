//
//  TreatmentOrder.h
//  FindDoctor
//
//  Created by Guo on 15/10/15.
//  Copyright © 2015年 li na. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Clinic.h"

typedef NS_ENUM(NSInteger, TreatmentOrderSortType) {
    TreatmentOrderSortTypetime      = 0,   // 按时间
    TreatmentOrderSortTypelevel      = 1  // 按等级
};



@interface TreatmentOrder : NSObject

@property  BOOL                                 loadInitialData;

@property   long long                           timestamp;
@property (nonatomic, strong) NSString          *date;
@property (nonatomic, strong) Clinic            *clinic;
@property (nonatomic, strong) NSString          *time_seg;
@property  NSInteger                            num;
@property  NSInteger                            fee;
@property (nonatomic, strong) NSString          *subject;
@property  BOOL                                 isInTime;
@property   long long                           orderno;
@property   NSInteger                           editState; //0能编辑， 1不能

@property NSTimeInterval startTime;
@property NSTimeInterval endTime;

@end


@interface TreatmentOrderFilter : NSObject

@property CGFloat longitude;
@property CGFloat latitude;
@property NSInteger level;
@property NSInteger typeId;
@property NSInteger subTypeId;
@property TreatmentOrderSortType sortType;

@property (nonatomic, strong) NSString *keyword;
@property (nonatomic, strong) NSString *priceRange;


@end


