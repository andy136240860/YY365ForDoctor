//
//  PrescriptionConfirmCell.h
//  
//
//  Created by Guo on 15/10/7.
//
//

#import <UIKit/UIKit.h>
#import "Patient.h"

@interface CurrentTreatmentCell : UITableViewCell

@property (nonatomic, strong) Patient *data;

+ (CGFloat)defaultHeight;

@end
