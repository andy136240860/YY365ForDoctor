//
//  YueZhenRecordListModel.m
//  
//
//  Created by Guo on 15/10/6.
//
//

#import "ZhenLiaoRecordListModel.h"
#import "TreatmentListAndDetailManager.h"


@implementation ZhenLiaoRecordListModel

- (instancetype)initWithSortType:(ZhenLiaoRecordSortType)type
{
    ZhenLiaoRecordFilter *filter = [[ZhenLiaoRecordFilter alloc] init];
    filter.sortType = type;
    
    return [self initWithFilter:filter];
}

- (instancetype)initWithFilter:(ZhenLiaoRecordFilter *)filter
{
    self = [super init];
    
    if (self) {
        _filter = filter;
    }
    
    return self;
}



- (void)gotoFirstPage:(SNServerAPIResultBlock)resultBlock
{
    [[TreatmentListAndDetailManager sharedInstance] getZhenLiaoRecordListWithPageNum:startPageNum pageSize:pageSize resultBlock:^(SNHTTPRequestOperation *request, SNServerAPIResultData *result) {
        if (!result.hasError)
        {
            SNBaseListModel * list = result.parsedModelObject;
            NSArray *orderArray = list.items;
            
            [self.items removeAllObjects];
            [self.items addObjectsFromArray:orderArray];
            
            SNPageInfo * info = list.pageInfo;
            self.pageInfo.pageSize = info.pageSize;
            self.pageInfo.totalPage = info.totalPage;
            self.pageInfo.currentPage = startPageNum;
        }
        resultBlock(request,result);
    } pageName:@"getCurrentTreatmentList"];
}

- (void)gotoNextPage:(SNServerAPIResultBlock)resultBlock
{
    [[TreatmentListAndDetailManager sharedInstance] getZhenLiaoRecordListWithPageNum:self.pageInfo.currentPage + 1  pageSize:pageSize resultBlock:^(SNHTTPRequestOperation *request, SNServerAPIResultData *result) {
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
    } pageName:@"getCurrentTreatmentList"];
}



@end
