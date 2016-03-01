//
//  CUDoctorManager.h
//  FindDoctor
//
//  Created by zhouzhenhua on 15/8/13.
//  Copyright (c) 2015年 li na. All rights reserved.
//

#import "SNBusinessMananger.h"
#import "SNServerAPIDefine.h"
#import "Doctor.h"
#import "SubObject.h"

@interface CUDoctorManager : SNBusinessMananger

SINGLETON_DECLARE(CUDoctorManager);

- (void)getDoctorListWithPageNum:(NSInteger)pageNum pageSize:(NSInteger)pageSize filter:(DoctorFilter *)filter resultBlock:(SNServerAPIResultBlock)resultBlock pageName:(NSString *)pageName;

- (void)getSubObjectListWithResultBlock:(SNServerAPIResultBlock)resultBlock;

- (void)getCommentListWithDoctor_id:(NSString *)doctor_id resultBlock:(SNServerAPIResultBlock)resultBlock;

@end
