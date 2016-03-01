//
//  DoctorFaceView.m
//  FindDoctor
//
//  Created by Guo on 15/8/27.
//  Copyright (c) 2015年 li na. All rights reserved.
//

#import "DoctorFaceView.h"


@implementation DoctorFaceView


- (instancetype)initWithFrame:(CGRect)frame DoctorID:(NSInteger *)DoctorID{
    self = [super init];
    if (self) {
        
        NSInteger is_available = 1;
        
        __Doctor = DoctorID;

        self.frame = frame;
        self.backgroundColor = [UIColor clearColor];

        
        
        //医生头像
        UIImageView *doctorFaceView = [[UIImageView alloc]init];
        doctorFaceView.frame = CGRectMake(0,2.5,frame.size.width-2.5,frame.size.width-2.5);
        doctorFaceView.layer.cornerRadius = frame.size.width / 2;
        doctorFaceView.clipsToBounds = YES;
        doctorFaceView.contentMode = 0;
        doctorFaceView.image = [self DoctorFaceImageWithDoctorID:DoctorID];
        
        [self addSubview:doctorFaceView];

        
        //医生名字
        UILabel *doctorName = [[UILabel alloc]initWithFrame:CGRectMake(0, frame.size.width+7, frame.size.width, 12)];
        doctorName.font = [UIFont systemFontOfSize:12];
        doctorName.textColor = UIColorFromHex(0x333333);
        doctorName.text= [self DoctorNameWithDoctorID:DoctorID];
        doctorName.textAlignment = NSTextAlignmentCenter;
        
        //“诊”角标
        if(is_available == 1)
        {
            UIImageView *is_availableView = [[UIImageView alloc]initWithFrame:CGRectMake(frame.size.width-19,0, 19, 19)];
            is_availableView.image = [UIImage imageNamed:@"zhenjiaobiao"];
            [self addSubview:is_availableView];
            
        }


        [self addSubview:doctorName];
        
        [self addTarget:self action:@selector(turnToDoctorViewWithDoctorID:) forControlEvents:UIControlEventTouchUpInside];
    }
    return self;
}

//根据医生ID返回医生头像
- (UIImage *)DoctorFaceImageWithDoctorID:(NSInteger *)_DoctorID{
    UIImage *DoctorFaceImage = [UIImage imageNamed:@"DoctorFaceImage"];
    return DoctorFaceImage;
}

//根据医生ID返回医生名字
- (NSString *)DoctorNameWithDoctorID:(NSInteger *)_DoctorID{
    return @"孙思涵";
}

//头像点击事件跳转页面
- (void)turnToDoctorViewWithDoctorID:(NSInteger *)_DoctorID{
    NSLog(@"跳转到ID为%i的医生",__Doctor);
}

@end
