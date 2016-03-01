//
//  CUUser.h
//  CollegeUnion
//
//  Created by li na on 15/2/18.
//  Copyright (c) 2015年 li na. All rights reserved.
//
// 注：也能当做是FamilyMember来使用

#import <Foundation/Foundation.h>

typedef NS_ENUM(NSInteger, CUUserGender) {
    CUUserGenderMale   = 1, // 男
    CUUserGenderFemale = 2  // 女
};

@interface CUUser : NSObject<NSCoding>
@property (nonatomic,strong) NSString *token;
@property (nonatomic,assign) NSInteger userId;
@property (nonatomic,strong) NSString *name;
@property (nonatomic,strong) NSString *profile;
@property (nonatomic,strong) NSString *nickName;
@property (nonatomic,strong) NSString *cellPhone;
@property (nonatomic,strong) NSString *hiddenCellPhone;
@property (nonatomic,assign) NSInteger doctorId;
@property (nonatomic,strong) NSString *icon;

@property NSInteger points;  // 积分
@property CUUserGender gender;
@property NSInteger age;

- (NSString *)genderDesc;

@end