//
//  CUHerbSelectCell.m
//  FindDoctor
//
//  Created by chai on 15/11/25.
//  Copyright © 2015年 li na. All rights reserved.
//

#import "CUHerbSelectCell.h"

@interface CUHerbSelectCell ()
{
    UILabel *_herbNameLabel;
    UIView *_topLine;
    UIView *_bottomLine;
    
    UIButton *_deleteButton;
}
@end

@implementation CUHerbSelectCell

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
    
    _deleteButton = [[UIButton alloc]init];
    _deleteButton.frame = CGRectMake(kScreenWidth-60, 8, 50, 30);
    _deleteButton.layer.backgroundColor = [UIColor redColor].CGColor;
    _deleteButton.layer.cornerRadius = 5;
    [_deleteButton setTitle:@"删除" forState:UIControlStateNormal];
    _deleteButton.titleLabel.font = [UIFont systemFontOfSize:12];
    [_deleteButton setTintColor:[UIColor whiteColor]];
    [_deleteButton addTarget:self action:@selector(deleteHerb) forControlEvents:UIControlEventTouchUpInside];
    [self.contentView addSubview:_deleteButton];
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

- (void)setHerbselect:(CUHerbSelect *)herbselect
{
    _herbselect = herbselect;
    
//    NSString *showText = [NSString stringWithFormat:@"%@%d%@",_herbselect.name,_herbselect.weight,_herbselect.unit];
    
    NSString *showText = [NSString stringWithFormat:@"%@%d%@",_herbselect.name,_herbselect.weight,_herbselect.unit];
    
    NSMutableAttributedString *attributeStr = [[NSMutableAttributedString alloc] initWithString:showText];
    
    NSString *pattern = @"[0-9]{1,}";
    
    NSRegularExpression *regular = [NSRegularExpression regularExpressionWithPattern:pattern options:0 error:nil];
    
    NSArray *results = [regular matchesInString:showText options:0 range:NSMakeRange(0, showText.length)];
    
    for (int i=0; i<results.count; i++) {
        NSTextCheckingResult *expression = results[i];
        [attributeStr addAttributes:@{NSForegroundColorAttributeName:UIColorFromRGB(89, 180, 25),NSFontAttributeName:[UIFont systemFontOfSize:16]} range:expression.range];
    }

    
    _herbNameLabel.attributedText = attributeStr;
}

- (void)deleteHerb{
    self.deleteHerbBlock(self.herbselect);
}


@end
