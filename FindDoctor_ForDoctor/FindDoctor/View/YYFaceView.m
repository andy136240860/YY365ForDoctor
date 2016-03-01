//
//  YYFaceView.m
//  FindDoctor
//
//  Created by Guo on 15/11/3.
//  Copyright © 2015年 li na. All rights reserved.
//

#import "YYFaceView.h"

@implementation YYFaceView

- (instancetype)initWithFrame:(CGRect)frame image:(UIImage *)image mode:(int *)mode;{
    self = [super initWithFrame:frame];
    if (self) {
      
        UIImageView *circularFaceView = [[UIImageView alloc]init];
        circularFaceView.frame = CGRectMake(0,frame.size.width*0.1,frame.size.width*0.9,frame.size.width*0.9);
        circularFaceView.layer.cornerRadius = frame.size.width / 2;
        circularFaceView.clipsToBounds = YES;
        circularFaceView.contentMode = 0;
        circularFaceView.image = image;
        
        [self addSubview:circularFaceView];

        //“诊”角标
        if(mode == 1)
        {
            UIImageView *is_availableView = [[UIImageView alloc]initWithFrame:CGRectMake(frame.size.width*0.65,0, frame.size.width*0.35, frame.size.width*0.35)];
            is_availableView.image = [UIImage imageNamed:@"zhenjiaobiao"];
            [self addSubview:is_availableView];
            
        }
        
        if(mode == 2)
        {
            UIImageView *is_availableView = [[UIImageView alloc]initWithFrame:CGRectMake(frame.size.width*0.65,0, frame.size.width*0.35, frame.size.width*0.35)];
            is_availableView.image = [UIImage imageNamed:@"VIPicon"];
            [self addSubview:is_availableView];
            
        }

    }
    return self;
}

- (instancetype)initWithFrame:(CGRect)frame image:(UIImage *)image{
    self = [super initWithFrame:frame];
    if (self) {
        
        UIImageView *circularFaceView = [[UIImageView alloc]init];
        circularFaceView.frame = CGRectMake(0,2.5,frame.size.width*0.9,frame.size.width*0.9);
        circularFaceView.layer.cornerRadius = frame.size.width / 2;
        circularFaceView.clipsToBounds = YES;
        circularFaceView.contentMode = 0;
        circularFaceView.image = image;
        [self addSubview:circularFaceView];

    }
    return self;
}


@end
