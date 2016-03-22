//
//  Comment.h
//  FindDoctor
//
//  Created by ZhuHaoRan on 16/3/14.
//  Copyright © 2016年 li na. All rights reserved.
//

#import <Foundation/Foundation.h>
typedef NS_ENUM(NSInteger, CommentSortType) {
    MyCommentSortType1  = 1,
    MyCommentSortType2  = 2,  
};

//锦旗数据列表
@interface FlagListInfo : NSObject

@property (assign,nonatomic) NSInteger            ID;//锦旗ID
@property (strong,nonatomic) NSString           * icon;//锦旗图标
@property (assign,nonatomic) NSInteger            money;//锦旗给的钱
@property (strong,nonatomic) NSString           * name;//锦旗名
@property (assign,nonatomic) NSInteger            scoreForDoctorOnece;//（本次锦旗返回给医生的积分）
//---------------------------------------------------------------------------------//
@property (assign,nonatomic) NSInteger            num;//锦旗数量

@end

//评论数据列表
@interface CommentListInfo : NSObject

@property (strong,nonatomic) NSString           * content;//评论内容
@property (strong,nonatomic) NSString           * flagName;//锦旗名
@property (assign,nonatomic) NSInteger            numStar;//评论星级
@property (assign,nonatomic) NSTimeInterval       time;//评论时间
@property (strong,nonatomic) NSString           * userName;//用户名
@property (assign,nonatomic) NSInteger            num;//锦旗数量
@property (assign,nonatomic) NSInteger            score;//积分

@end

//11903
@interface CommentListFilter : NSObject

@property (assign,nonatomic) NSTimeInterval       lastID;//上次读取最后数据ID（就是点评的时间戳），第一次默认为0
@property CommentSortType sortType;

@end


