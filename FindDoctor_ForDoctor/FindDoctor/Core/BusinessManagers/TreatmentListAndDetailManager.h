//
//  TreatmentListAndDetailManager.h
//  FindDoctor
//
//  Created by Guo on 15/11/16.
//  Copyright © 2015年 li na. All rights reserved.
//

#import "SNBusinessMananger.h"
#import "SNServerAPIDefine.h"
#import "Comment.h"


@interface TreatmentListAndDetailManager : SNBusinessMananger


// state 0表示未支付  3表示支付完成但是诊疗（约诊完成）   4表示就诊完成    5表示退款成功

SINGLETON_DECLARE(TreatmentListAndDetailManager);

@end

@interface TreatmentListAndDetailManager (Network)
// 当前诊疗列表
- (void)getCurrentTreatmentListWithPageNum:(NSInteger)pageNum pageSize:(NSInteger)pageSize resultBlock:(SNServerAPIResultBlock)resultBlock pageName:(NSString *)pageName;

// 约诊记录列表
- (void)getYueZhenRecordListWithPageNum:(NSInteger)pageNum pageSize:(NSInteger)pageSize resultBlock:(SNServerAPIResultBlock)resultBlock pageName:(NSString *)pageName;
//// 约诊记录单详情
//- (void)getYueZhenDetailWithOrderno:(NSString *)orderno resultBlock:(SNServerAPIResultBlock)resultBlock pageName:(NSString *)pageName;

// 诊疗记录列表
- (void)getZhenLiaoRecordListWithPageNum:(NSInteger)pageNum pageSize:(NSInteger)pageSize resultBlock:(SNServerAPIResultBlock)resultBlock pageName:(NSString *)pageName;

////诊疗记录单详情
//- (void)getZhenLiaoDetailWithOrderno:(NSString *)orderno resultBlock:(SNServerAPIResultBlock)resultBlock pageName:(NSString *)pageName;

//首页推送
- (void)getHomeTipListWithResultBlock:(SNServerAPIResultBlock)resultBlock pageName:(NSString *)pageName;

//我的账户
- (void)getMyAccountWithResultBlock:(SNServerAPIResultBlock)resultBlock pageName:(NSString *)pageName;

- (void)getCommentWithLastID:(CommentListFilter *)filter resultBlock:(SNServerAPIResultBlock)resultBlock pageName:(NSString *)pageName;

@end