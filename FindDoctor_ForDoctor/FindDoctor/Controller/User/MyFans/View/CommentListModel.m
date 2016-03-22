//
//  CommentListModel.m
//  FindDoctor
//
//  Created by Guo on 15/10/1.
//  Copyright (c) 2015年 li na. All rights reserved.
//

#import "CommentListModel.h"
#import "TreatmentListAndDetailManager.h"

@implementation CommentListModel

- (instancetype)initWithSortType:(CommentSortType)type
{
    CommentListFilter *filter = [[CommentListFilter alloc] init];
//    filter.sortType = type;
    
    return [self initWithFilter:filter];
}

- (instancetype)initWithFilter:(CommentListFilter *)filter
{
    self = [super init];
    
    if (self) {
        _filter = filter;
    }
    
    return self;
}

- (void)gotoFirstPage:(SNServerAPIResultBlock)resultBlock
{
    [[TreatmentListAndDetailManager sharedInstance] getCommentWithLastID:self.filter resultBlock:^(SNHTTPRequestOperation *request, SNServerAPIResultData *result) {
        if (!result.hasError)
        {
            CommentListModel * list = result.parsedModelObject;
            NSArray *orderArray = list.items;
            
            [self.items removeAllObjects];
            [self.items addObjectsFromArray:orderArray];
            
            SNPageInfo * info = list.pageInfo;
            self.pageInfo.pageSize = info.pageSize;
            self.pageInfo.totalPage = info.totalPage;
            self.pageInfo.currentPage = startPageNum;
        }
        resultBlock(request,result);
    } pageName:@"CommentListViewController"];
}

- (void)gotoNextPage:(SNServerAPIResultBlock)resultBlock
{
    [[TreatmentListAndDetailManager sharedInstance] getCommentWithLastID:self.filter resultBlock:^(SNHTTPRequestOperation *request, SNServerAPIResultData *result) {
        if (!result.hasError)
        {
            SNBaseListModel * list = result.parsedModelObject;
            [self.items addObjectsFromArray:list.items];
            
            SNPageInfo * info = list.pageInfo;
            self.pageInfo.pageSize = info.pageSize;
            self.pageInfo.totalPage = info.totalPage;
            self.pageInfo.currentPage++;
        }
        resultBlock(request,result);
    } pageName:@"CommentListViewController"];
}

@end
