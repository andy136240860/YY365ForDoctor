//
//  YueZhenRecordListModel.h
//  
//
//  Created by Guo on 15/10/6.
//
//

#import "SNBaseListModel.h"
#import "Patient.h"

@interface YueZhenRecordListModel : SNBaseListModel

@property (nonatomic, strong) YueZhenRecordFilter *filter;


- (instancetype)initWithSortType:(YueZhenRecordSortType)type;

@end
