//
//  YueZhenRecordListModel.h
//  
//
//  Created by Guo on 15/10/6.
//
//

#import "SNBaseListModel.h"
#import "Patient.h"

@interface ZhenLiaoRecordListModel : SNBaseListModel

@property (nonatomic, strong) ZhenLiaoRecordFilter *filter;


- (instancetype)initWithSortType:(ZhenLiaoRecordSortType)type;

@end
