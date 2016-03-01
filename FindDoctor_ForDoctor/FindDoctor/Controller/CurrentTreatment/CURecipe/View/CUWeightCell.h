//
//  CUWeightCell.h
//  FindDoctor
//
//  Created by chai on 15/11/27.
//  Copyright © 2015年 li na. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface CUWeightCell : UITableViewCell

@property (nonatomic, weak) NSIndexPath *indexPath;
@property (nonatomic, assign) BOOL isLastCell;

@property (nonatomic, copy) NSString *weightText;

@property (nonatomic, assign) BOOL isChoose;

@end
