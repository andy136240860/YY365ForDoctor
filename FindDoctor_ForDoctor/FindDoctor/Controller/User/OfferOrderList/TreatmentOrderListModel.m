//
//  YueZhenRecordListModel.m
//  
//
//  Created by Guo on 15/10/6.
//
//

#import "TreatmentOrderListModel.h"
#import "TreatmentListAndDetailManager.h"
#import "TreatmentOrderManager.h"


@implementation TreatmentOrderListModel

- (instancetype)initWithSortType:(TreatmentOrderSortType)type
{
    TreatmentOrderFilter *filter = [[TreatmentOrderFilter alloc] init];
    filter.sortType = type;
    
    return [self initWithFilter:filter];
}

- (instancetype)initWithFilter:(TreatmentOrderFilter *)filter
{
    self = [super init];
    
    if (self) {
        _filter = filter;
    }
    
    return self;
}



- (void)gotoFirstPage:(SNServerAPIResultBlock)resultBlock
{
    [[TreatmentOrderManager sharedInstance] getListWithPageSize:self.pageInfo.pageSize CurrentPage:0 resultBlock:^(SNHTTPRequestOperation *request, SNServerAPIResultData *result) {
        if (!result.hasError)
        {
            SNBaseListModel * list = result.parsedModelObject;
            NSArray *orderArray = list.items;
            
            [self.items removeAllObjects];
            [self.items addObjectsFromArray:orderArray];
            
            SNPageInfo * info = list.pageInfo;
            self.pageInfo.pageSize = info.pageSize;
            self.pageInfo.totalPage = info.totalPage;
            self.pageInfo.totalCount = info.totalCount;
            self.pageInfo.currentPage = startPageNum;
        }
        resultBlock(request,result);
    } pageName:@"TreatmentOrderList"];

}

- (void)gotoNextPage:(SNServerAPIResultBlock)resultBlock
{
    [[TreatmentOrderManager sharedInstance] getListWithPageSize:self.pageInfo.pageSize CurrentPage:self.pageInfo.currentPage+1 resultBlock:^(SNHTTPRequestOperation *request, SNServerAPIResultData *result) {
        if (!result.hasError)
        {
            SNBaseListModel * list = result.parsedModelObject;
            [self.items addObjectsFromArray:list.items];
            
            SNPageInfo * info = list.pageInfo;
            self.pageInfo.pageSize = info.pageSize;
            self.pageInfo.totalPage = info.totalPage;
            self.pageInfo.totalCount = info.totalCount;
            self.pageInfo.currentPage++;
        }
        resultBlock(request,result);
    } pageName:@"TreatmentOrderList"];
}



@end
