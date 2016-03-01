//
//  CurrentTreatmentDetail.h
//  FindDoctor
//
//  Created by Guo on 15/11/3.
//  Copyright © 2015年 li na. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface CurrentTreatmentDetail : NSObject

@property (strong,nonatomic)    NSString        *userID;
@property (strong,nonatomic)    NSString        *userName;
@property (strong,nonatomic)    NSString        *sex;
@property                       NSInteger       age;
@property (strong,nonatomic)    NSString        *phoneNumber;
@property (strong,nonatomic)    NSMutableArray  *chuFangPhotoArray;
@property (strong,nonatomic)    NSMutableArray  *bingZhengPhotoArray;

@end
