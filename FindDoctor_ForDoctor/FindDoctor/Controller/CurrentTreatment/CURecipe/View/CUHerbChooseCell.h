//
//  CUHerbChooseCell.h
//  FindDoctor
//
//  Created by chai on 15/11/25.
//  Copyright © 2015年 li na. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CUHerb.h"

@interface CUHerbChooseCell : UITableViewCell

@property (nonatomic, weak) NSIndexPath *indexPath;
@property (nonatomic, assign) BOOL isLastCell;

@property (nonatomic, weak) CUHerb *herb;

@property (nonatomic, assign) BOOL isChoose;

@end
