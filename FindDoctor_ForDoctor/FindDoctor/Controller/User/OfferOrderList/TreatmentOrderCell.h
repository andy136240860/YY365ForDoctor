//
//  YueZhenRecordTableViewCell.h
//  
//
//  Created by Guo on 15/10/6.
//
//

#import <UIKit/UIKit.h>
#import "TreatmentOrder.h"
typedef void(^RefreshDataBlock)(void);
typedef void(^EditOrderBlock)(TreatmentOrder *data);

@interface TreatmentOrderCell : UITableViewCell<UIAlertViewDelegate>

@property (nonatomic, strong) TreatmentOrder *data;

+ (CGFloat)defaultHeight;

@property (nonatomic, copy) RefreshDataBlock refreshDataBlock;
@property (nonatomic, copy) EditOrderBlock editOrderBlock;
@end
