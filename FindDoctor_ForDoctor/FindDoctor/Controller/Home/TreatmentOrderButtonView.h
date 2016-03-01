//
//  FindDoctorButtonView.h
//  FindDoctor
//
//  Created by 晓炜 郭 on 15/12/10.
//  Copyright © 2015年 li na. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void (^ClickButtonBlock)(void);

@interface TreatmentOrderButtonView : UIView

@property (nonatomic, copy) ClickButtonBlock clickButtonBlock;

@end
