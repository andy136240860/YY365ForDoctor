//
//  CUHerbChooseCell.m
//  FindDoctor
//
//  Created by chai on 15/11/25.
//  Copyright © 2015年 li na. All rights reserved.
//

#import "CUHerbChooseCell.h"

@interface CUHerbChooseCell ()
{
    UILabel *_herbNameLabel;
    UIView *_topLine;
    UIView *_bottomLine;
}
@end

@implementation CUHerbChooseCell

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
    
    _herbNameLabel = [[UILabel alloc] init];
    _herbNameLabel.font = SystemFont_14;
    _herbNameLabel.textColor = kDarkGrayColor;
    _herbNameLabel.frame = (CGRect){padding_left,line_width,kScreenWidth-padding_left,item_height-line_width*2};
    [self.contentView addSubview:_herbNameLabel];
    
    _topLine = [[UIView alloc] init];
    _topLine.frame = (CGRect){0,0,kScreenWidth,line_width};
    _topLine.backgroundColor = UIColorFromRGB(224, 224, 224);
    [self.contentView addSubview:_topLine];
    
    _bottomLine = [[UIView alloc] init];
    _bottomLine.frame = (CGRect){padding_left,item_height-line_width,kScreenWidth-padding_left,line_width};
    _bottomLine.backgroundColor = UIColorFromRGB(224, 224, 224);
    [self.contentView addSubview:_bottomLine];
}

- (void)setIndexPath:(NSIndexPath *)indexPath
{
    _indexPath = indexPath;
    _topLine.hidden = YES;
    if (_indexPath.row==0) {
        _topLine.hidden = NO;
    }
}

- (void)setIsChoose:(BOOL)isChoose{
    _isChoose = isChoose;
    if (_isChoose) {
        _herbNameLabel.textColor = kOrangeColor;
    }else{
        _herbNameLabel.textColor = kDarkGrayColor;
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

- (void)setHerb:(CUHerb *)herb
{
    _herb = herb;
    _herbNameLabel.text = herb.name;
}

@end
