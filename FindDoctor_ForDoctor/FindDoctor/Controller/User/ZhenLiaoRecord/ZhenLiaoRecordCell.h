//
//  YueZhenRecordTableViewCell.h
//  
//
//  Created by Guo on 15/10/6.
//
//

#import <UIKit/UIKit.h>
#import "Patient.h"

@interface ZhenLiaoRecordCell : UITableViewCell

@property (nonatomic, strong) Patient *data;

+ (CGFloat)defaultHeight;

@end
