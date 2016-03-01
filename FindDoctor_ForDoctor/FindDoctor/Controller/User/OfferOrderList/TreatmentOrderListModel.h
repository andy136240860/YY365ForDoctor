//
//  YueZhenRecordListModel.h
//  
//
//  Created by Guo on 15/10/6.
//
//

#import "SNBaseListModel.h"
#import "TreatmentOrder.h"

@interface TreatmentOrderListModel : SNBaseListModel

@property (nonatomic, strong) TreatmentOrderFilter *filter;


- (instancetype)initWithSortType:(TreatmentOrderSortType)type;

@end
