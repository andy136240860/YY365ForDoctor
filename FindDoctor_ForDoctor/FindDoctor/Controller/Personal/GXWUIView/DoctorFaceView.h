//
//  DoctorFaceView.h
//  FindDoctor
//
//  Created by Guo on 15/8/27.
//  Copyright (c) 2015年 li na. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface DoctorFaceView : UIControl

- (instancetype)initWithFrame:(CGRect)frame DoctorID:(NSInteger *)DoctorID;

@property(nonatomic) NSInteger *_Doctor;

@end
