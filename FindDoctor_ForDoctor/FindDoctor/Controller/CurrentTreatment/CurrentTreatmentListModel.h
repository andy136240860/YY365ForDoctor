//
//  YueZhenRecordListModel.h
//  
//
//  Created by Guo on 15/10/6.
//
//

#import "SNBaseListModel.h"
#import "Patient.h"

@interface CurrentTreatmentListModel : SNBaseListModel

@property (nonatomic, strong) CurrentTreatmentFilter *filter;


- (instancetype)initWithSortType:(CurrentTreatmentSortType)type;

@end
