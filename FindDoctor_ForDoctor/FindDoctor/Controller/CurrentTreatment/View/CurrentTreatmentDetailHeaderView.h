//
//  CurrentTreatmentDetailHeaderView.h
//  FindDoctor
//
//  Created by 晓炜 郭 on 15/12/14.
//  Copyright © 2015年 li na. All rights reserved.
//

#import <UIKit/UIKit.h>
typedef void (^YueZhenDanBlock)(void);
@interface CurrentTreatmentDetailHeaderView : UIView

- (instancetype)initWithFrame:(CGRect)frame;

- (void)setDataWithName:(NSString *)name
                    sex:(NSString *)sex
              cellPhone:(NSString *)cellPhone
                    age:(NSInteger)age
                orderNo:(long long)orderNo;
@property (nonatomic, copy) YueZhenDanBlock yueZhenDanBlock;
@end
