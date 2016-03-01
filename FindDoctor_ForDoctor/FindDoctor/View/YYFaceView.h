//
//  YYFaceView.h
//  FindDoctor
//
//  Created by Guo on 15/11/3.
//  Copyright © 2015年 li na. All rights reserved.
//

//  Frame 的 weith 与 height 一定要相等

#import <UIKit/UIKit.h>
typedef NS_ENUM(NSInteger, YYFaceViewMode) {
    YYFaceViewModeNone      = 0,
    YYFaceViewModeZhen      = 1,
    YYFaceViewModeVIP       = 2
};

@interface YYFaceView : UIControl

- (instancetype)initWithFrame:(CGRect)frame image:(UIImage *)image mode:(NSInteger *)mode;
- (instancetype)initWithFrame:(CGRect)frame image:(UIImage *)image;

@end
