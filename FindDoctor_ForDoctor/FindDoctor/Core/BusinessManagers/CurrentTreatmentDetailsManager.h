//
//  CurrentTreatmentDetailsManager.h
//  FindDoctor
//
//  Created by Guo on 15/11/21.
//  Copyright © 2015年 li na. All rights reserved.
//

#import "SNBusinessMananger.h"
#import "CurrentTreatmentDetail.h"
#import "SNServerAPIDefine.h"

@interface CurrentTreatmentDetailsManager : SNBusinessMananger

@property (strong, nonatomic) CurrentTreatmentDetailsManager *currentTreatmentDetail;

SINGLETON_DECLARE(CurrentTreatmentDetailsManager);

@end

@interface CurrentTreatmentDetailsManager (Network)

- (void)uploadChuFang:(NSMutableArray *)array resultBlock:(SNServerAPIResultBlock)resultBlock pageName:(NSString *)pageName progressBlock:(SNServerAPIProgressBlock)progressBlock;

- (void)uploadBingZheng:(NSMutableArray *)array resultBlock:(SNServerAPIResultBlock)resultBlock pageName:(NSString *)pageName progressBlock:(SNServerAPIProgressBlock)progressBlock;

@end