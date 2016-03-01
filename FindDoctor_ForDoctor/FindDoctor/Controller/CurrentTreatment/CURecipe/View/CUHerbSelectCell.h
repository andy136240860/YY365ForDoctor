//
//  CUHerbSelectCell.h
//  FindDoctor
//
//  Created by chai on 15/11/25.
//  Copyright © 2015年 li na. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CUHerbSelect.h"
#import "CUHerbSelect.h"

typedef void(^DeleteHerbBlock)(CUHerbSelect *herb);

@interface CUHerbSelectCell : UITableViewCell

@property (nonatomic, weak) NSIndexPath *indexPath;
@property (nonatomic, assign) BOOL isLastCell;

@property (nonatomic, weak) CUHerbSelect *herbselect;

@property (nonatomic, copy) DeleteHerbBlock deleteHerbBlock;

@end
