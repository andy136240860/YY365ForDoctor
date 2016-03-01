//
//  YueZhenRecordListModel.m
//  
//
//  Created by Guo on 15/10/6.
//
//

#import "YueZhenRecordListModel.h"
#import "TreatmentListAndDetailManager.h"


@implementation YueZhenRecordListModel

- (instancetype)initWithSortType:(YueZhenRecordSortType)type
{
    YueZhenRecordFilter *filter = [[YueZhenRecordFilter alloc] init];
    filter.sortType = type;
    
    return [self initWithFilter:filter];
}

- (instancetype)initWithFilter:(YueZhenRecordFilter *)filter
{
    self = [super init];
    
    if (self) {
        _filter = filter;
    }
    
    return self;
}

- (void)gotoFirstPage:(SNServerAPIResultBlock)resultBlock
{
    [[TreatmentListAndDetailManager sharedInstance] getYueZhenRecordListWithPageNum:startPageNum pageSize:pageSize resultBlock:^(SNHTTPRequestOperation *request, SNServerAPIResultData *result) {
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
    } pageName:@"YueZhenRecordViewController"];
}

- (void)gotoNextPage:(SNServerAPIResultBlock)resultBlock
{
    [[TreatmentListAndDetailManager sharedInstance] getYueZhenRecordListWithPageNum:self.pageInfo.currentPage + 1  pageSize:pageSize resultBlock:^(SNHTTPRequestOperation *request, SNServerAPIResultData *result) {
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
    } pageName:@"YueZhenRecordViewController"];
}


@end
