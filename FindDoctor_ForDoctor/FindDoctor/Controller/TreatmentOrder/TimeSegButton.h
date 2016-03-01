//
//  TimeSegButton.h
//  FindDoctor
//
//  Created by Guo on 15/10/16.
//  Copyright © 2015年 li na. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef NS_ENUM(NSInteger, ButtonState) {
    Forbidden       = -1,
    Normal          = 0 ,    
    HighLight       = 1
};

@interface TimeSegButton : UIButton

@property (nonatomic) ButtonState buttonState;
@property NSInteger ID;

- (instancetype)initWithFrame:(CGRect)frame;
- (void)setState:(ButtonState)state;



@end
