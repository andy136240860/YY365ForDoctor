//
//  TimeSegButtonsView.h
//  FindDoctor
//
//  Created by 晓炜 郭 on 15/12/15.
//  Copyright © 2015年 li na. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface TimeSegButtonsView : UIView

- (instancetype)initWithFrame:(CGRect)frame;

- (void)setButtonsUsedWithString:(NSString *)string;
- (void)setButtonsNotAvailableWithString:(NSString *)string;

- (void)setButtonsNotAvailableBecauseOfDateIsToday;
- (void)setButtonsAllAvailable;

- (NSString *)loadUsedButton;

@end
