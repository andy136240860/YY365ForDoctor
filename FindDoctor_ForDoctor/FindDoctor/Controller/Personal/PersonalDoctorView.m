//
//  Personal_myDoctorView.m
//  FindDoctor
//
//  Created by Guo on 15/8/26.
//  Copyright (c) 2015年 li na. All rights reserved.
//

#import "PersonalDoctorView.h"
#import "DoctorFaceView.h"

@implementation PersonalDoctorView

- (instancetype)init{
    self = [super init];
    if (self) {
        self.frame = CGRectMake(0, 0, kScreenWidth, 130);
        
        DoctorFaceView *doctorFaceView1 = [[DoctorFaceView alloc]initWithFrame:CGRectMake(20, 40, 45, 90) DoctorID:1111];
        
         DoctorFaceView *doctorFaceView2 = [[DoctorFaceView alloc]initWithFrame:CGRectMake(30+(kScreenWidth-80)*0.25,40 , 45, 90) DoctorID:11111];
        DoctorFaceView *doctorFaceView3 = [[DoctorFaceView alloc]initWithFrame:CGRectMake(40+(kScreenWidth-80)*0.5, 40, 45, 90) DoctorID:123];
        DoctorFaceView *doctorFaceView4 = [[DoctorFaceView alloc]initWithFrame:CGRectMake(50+(kScreenWidth-80)*0.75,40 , 45, 90) DoctorID:123];
        
        [self addSubview:doctorFaceView1];
        [self addSubview:doctorFaceView2];
        [self addSubview:doctorFaceView3];
        [self addSubview:doctorFaceView4];

        
        
    }
    return self;
}
/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
