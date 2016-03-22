//
//  CommentListModel.h
//  FindDoctor
//
//  Created by Guo on 15/10/1.
//  Copyright (c) 2015年 li na. All rights reserved.
//

#import "SNBaseListModel.h"
#import "Comment.h"
#import "Doctor.h"


@interface CommentListModel : SNBaseListModel

@property (nonatomic, strong) CommentListFilter *filter;
@property (nonatomic, strong) Doctor * data;

- (instancetype)initWithSortType:(CommentSortType)type;

@end
