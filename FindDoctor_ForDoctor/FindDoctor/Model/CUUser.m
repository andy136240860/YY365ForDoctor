//
//  CUUser.m
//  CollegeUnion
//
//  Created by li na on 15/2/18.
//  Copyright (c) 2015年 li na. All rights reserved.
//

#import "CUUser.h"

#define Key_CUUser_Token @"token"
#define Key_CUUser_UserId @"userId"
#define Key_CUUser_profile @"profile"
#define Key_CUUser_nickName @"nickName"
#define Key_CUUser_points @"points"
#define Key_CUUser_cellPhone @"cellPhone"
#define Key_CUUser_hiddenCellPhone @"hiddenCellPhone"
#define Key_CUUser_docotorId @"docotorId"
#define Key_CUUser_icon @"icon"

@implementation CUUser

- (void)encodeWithCoder:(NSCoder *)aCoder
{
    [aCoder encodeInteger:self.userId forKey:Key_CUUser_UserId];
    [aCoder encodeObject:self.profile forKey:Key_CUUser_profile];
    [aCoder encodeObject:self.nickName forKey:Key_CUUser_nickName];
    [aCoder encodeObject:self.cellPhone forKey:Key_CUUser_cellPhone];
    [aCoder encodeObject:self.hiddenCellPhone forKey:Key_CUUser_hiddenCellPhone];
    [aCoder encodeInteger:self.points forKey:Key_CUUser_points];
    [aCoder encodeInteger:self.doctorId forKey:Key_CUUser_docotorId];
    [aCoder encodeObject:self.icon forKey:Key_CUUser_icon];
    [aCoder encodeObject:self.token forKey:Key_CUUser_Token];
}

- (id)initWithCoder:(NSCoder *)aDecoder
{
    if (self = [self init])
    {
        self.userId = [aDecoder decodeIntegerForKey:Key_CUUser_UserId];
        self.profile = [aDecoder decodeObjectForKey:Key_CUUser_profile];
        self.nickName = [aDecoder decodeObjectForKey:Key_CUUser_nickName];
        self.points = [aDecoder decodeIntegerForKey:Key_CUUser_points];
        self.cellPhone = [aDecoder decodeObjectForKey:Key_CUUser_cellPhone];
        self.hiddenCellPhone = [aDecoder decodeObjectForKey:Key_CUUser_hiddenCellPhone];
        self.doctorId = [aDecoder decodeIntegerForKey:Key_CUUser_docotorId];
        self.icon = [aDecoder decodeObjectForKey:Key_CUUser_icon];
        self.token = [aDecoder decodeObjectForKey:Key_CUUser_Token];
    }
    return self;
}

- (NSString *)description
{
    return [NSString stringWithFormat:@"userId=%d,token=%@,ponint=%d,profile=%@,nickName=%@,,cellPhone=%@",self.userId,self.token,self.points,self.profile,self.nickName,self.cellPhone];
}

- (BOOL)isEqual:(CUUser *)object
{
    if ([object isKindOfClass:[CUUser class]] && object.userId==self.userId) {
        return YES;
    }
    
    return NO;
}

- (NSInteger)hash
{
    return self.userId;
}

- (NSString *)genderDesc
{
    if (self.gender == CUUserGenderMale) {
        return @"男";
    }
    else if (self.gender == CUUserGenderFemale) {
        return @"女";
    }
    
    return nil;
}

@end
