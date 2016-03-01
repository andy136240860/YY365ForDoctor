//
//  Clinic.h
//  FindDoctor
//
//  Created by Guo on 15/11/24.
//  Copyright © 2015年 li na. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Clinic : NSObject

@property NSInteger ID;
@property (nonatomic, strong) NSString  *name;
@property (nonatomic, strong) NSString  *address;
@property (nonatomic, strong) NSString  *timeSeg;
@property (nonatomic, strong) NSMutableArray *timeUesdArray;

@end


@interface TimeUesd : NSObject

@property   NSTimeInterval  startTime;
@property   NSTimeInterval  endTime;

@end


