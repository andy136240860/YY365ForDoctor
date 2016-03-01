//
//  YueZhenRecordTableViewCell.h
//  
//
//  Created by Guo on 15/10/6.
//
//

#import <UIKit/UIKit.h>
#import "Patient.h"

@interface YueZhenRecordCell : UITableViewCell

@property (nonatomic, strong) Patient *data;

+ (CGFloat)defaultHeight;

@end
