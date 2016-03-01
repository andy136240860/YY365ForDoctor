//
//  CUWeightCell.m
//  FindDoctor
//
//  Created by chai on 15/11/27.
//  Copyright © 2015年 li na. All rights reserved.
//

#import "CUWeightCell.h"

@interface CUWeightCell ()
{
    UILabel *_weightLabel;
    UIView *_topLine;
    UIView *_bottomLine;
}
@end

@implementation CUWeightCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        [self createSubviews];
    }
    return self;
}

- (void)createSubviews
{
    float padding_left = 15.f;
    
    float line_width = 1.f;
    
    float item_height = 46.f;
    
    _weightLabel = [[UILabel alloc] init];
    _weightLabel.font = SystemFont_14;
    _weightLabel.textColor = kDarkGrayColor;
    _weightLabel.frame = (CGRect){padding_left,line_width,kScreenWidth-padding_left,item_height-line_width*2};
    [self.contentView addSubview:_weightLabel];
    
    _topLine = [[UIView alloc] init];
    _topLine.frame = (CGRect){0,0,kScreenWidth,line_width};
    _topLine.backgroundColor = UIColorFromRGB(224, 224, 224);
    [self.contentView addSubview:_topLine];
    
    _bottomLine = [[UIView alloc] init];
    _bottomLine.frame = (CGRect){padding_left,item_height-line_width,kScreenWidth-padding_left,line_width};
    _bottomLine.backgroundColor = UIColorFromRGB(224, 224, 224);
    [self.contentView addSubview:_bottomLine];
}

- (void)setIsChoose:(BOOL)isChoose
{
    _isChoose = isChoose;
    if (_isChoose) {
        _weightLabel.textColor = kOrangeColor;
    }else{
        _weightLabel.textColor = kDarkGrayColor;
    }
}

- (void)setIndexPath:(NSIndexPath *)indexPath
{
    _indexPath = indexPath;
    _topLine.hidden = YES;
    if (_indexPath.row==0) {
        _topLine.hidden = NO;
    }
}

- (void)setIsLastCell:(BOOL)isLastCell
{
    _isLastCell = isLastCell;
    float padding_left = 15.f;
    
    float line_width = 1.f;
    
    float item_height = 46.f;
    
    if (_isLastCell) {
        _bottomLine.frame = (CGRect){0,item_height-line_width,kScreenWidth,line_width};
    }else{
        _bottomLine.frame = (CGRect){padding_left,item_height-line_width,kScreenWidth-padding_left,line_width};
    }
}

- (void)setWeightText:(NSString *)weightText
{
    _weightText = weightText;
    _weightLabel.text = _weightText;
}

@end
