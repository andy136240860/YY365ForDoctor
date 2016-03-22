//
//  CommentCell.h
//  
//
//  Created by Guo on 15/10/5.
//
//

#import <UIKit/UIKit.h>
#import "Comment.h"

@interface CommentCell : UITableViewCell

@property (nonatomic, strong) CommentListInfo *data;

- (NSInteger)CellHeight;

@end
