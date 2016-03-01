//
//  Fans.h
//  FindDoctor
//
//  Created by Guo on 15/9/29.
//  Copyright (c) 2015年 li na. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef NS_ENUM(NSInteger, FansSortType) {
    FansSortTypetime      = 0,   // 按时间
    FansSortTypelevel      = 1  // 按等级
};

@interface Fans : NSObject

@property BOOL isVIP;    //是不是VIP粉丝

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


@property BOOL isAvailable;
@property CGFloat rate;
@property double price;

@property NSInteger queueNumber;  // 已预约数量
@property NSInteger queueCount;   // 可预约总数

- (NSString *)availableDesc;

@end

@interface FansFilter : NSObject

@property CGFloat longitude;
@property CGFloat latitude;
@property NSInteger level;
@property NSInteger typeId;
@property NSInteger subTypeId;
@property FansSortType sortType;

@property (nonatomic, strong) NSString *keyword;
@property (nonatomic, strong) NSString *priceRange;

@end


