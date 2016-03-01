//
//  CurrentTreatmentDetailHeaderView.m
//  FindDoctor
//
//  Created by 晓炜 郭 on 15/12/14.
//  Copyright © 2015年 li na. All rights reserved.
//

#import "CurrentTreatmentDetailHeaderView.h"
@interface CurrentTreatmentDetailHeaderView(){
    UILabel *nameLabel;
    UILabel *sexLabel;
    UILabel *cellPhoneLabel;
    UILabel *ageLabel;
    UILabel *orderNoLabel;

}
@end

@implementation CurrentTreatmentDetailHeaderView

- (instancetype)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = [UIColor whiteColor];
        [self initSubView];
    }
    return self;
}

- (void)initSubView{
    int intervalX = 20;
    int intervalY = 15;
    
    nameLabel = [[UILabel alloc]initWithFrame:CGRectMake(intervalX, intervalY, (kScreenWidth - 3 * intervalX) * 0.65, 14)];
    nameLabel.font = SystemFont_14;
    [self addSubview:nameLabel];
    
    sexLabel = [[UILabel alloc]initWithFrame:CGRectMake(CGRectGetMaxX(nameLabel.frame), intervalY, (kScreenWidth - 3 * intervalX) * 0.35, 14)];
    sexLabel.font = SystemFont_14;
    [self addSubview:sexLabel];
    
    cellPhoneLabel = [[UILabel alloc]initWithFrame:CGRectMake(intervalX, CGRectGetMaxY(nameLabel.frame)+intervalY, (kScreenWidth - 3 * intervalX) * 0.65, 14)];
    cellPhoneLabel.font = SystemFont_14;
    [self addSubview:cellPhoneLabel];
    
    ageLabel = [[UILabel alloc]initWithFrame:CGRectMake(CGRectGetMaxX(cellPhoneLabel.frame), CGRectGetMaxY(nameLabel.frame)+intervalY, (kScreenWidth - 3 * intervalX) * 0.35, 14)];
    ageLabel.font = SystemFont_14;
    [self addSubview:ageLabel];
    
    orderNoLabel = [[UILabel alloc]initWithFrame:CGRectMake(intervalX, CGRectGetMaxY(cellPhoneLabel.frame)+intervalY, (kScreenWidth - 2 * intervalX), 14)];
    orderNoLabel.font = SystemFont_14;
    [self addSubview:orderNoLabel];
    
    UIImage *image = [UIImage imageNamed:@"more"];
    UIButton *moreButton = [[UIButton alloc]initWithFrame:CGRectMake(self.frameWidth - 30, 0, 30, self.frameHeight)];
    UIImageView *moreImageView = [[UIImageView alloc]initWithImage:image];
    moreImageView.frame = CGRectMake((moreButton.frameWidth - image.size.width)/2, (moreButton.frameHeight - image.size.height)/2, image.size.width, image.size.height);
    moreImageView.userInteractionEnabled = YES;
    [moreButton  addSubview:moreImageView];
    [moreButton addTarget:self action:@selector(moreButtonAction) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:moreButton];
}

- (void)setDataWithName:(NSString *)name
                    sex:(NSString *)sex
              cellPhone:(NSString *)cellPhone
                    age:(NSInteger)age
                orderNo:(long long)orderNo{
    NSMutableAttributedString *nameStr = [[NSMutableAttributedString alloc]initWithString:[NSString stringWithFormat:@"姓名：%@",name]];
    [nameStr addAttribute:NSForegroundColorAttributeName value:UIColorFromHex(0x71c33a) range:NSMakeRange(0, 3)];
    nameLabel.attributedText = nameStr;
    
    NSMutableAttributedString *sexStr = [[NSMutableAttributedString alloc]initWithString:[NSString stringWithFormat:@"性别：%@",sex]];
    [sexStr addAttribute:NSForegroundColorAttributeName value:UIColorFromHex(0x71c33a) range:NSMakeRange(0, 3)];
    sexLabel.attributedText = sexStr;
    
    NSMutableAttributedString *cellPhoneStr = [[NSMutableAttributedString alloc]initWithString:[NSString stringWithFormat:@"电话：%@",cellPhone]];
    [cellPhoneStr addAttribute:NSForegroundColorAttributeName value:UIColorFromHex(0x71c33a) range:NSMakeRange(0, 3)];
    cellPhoneLabel.attributedText = cellPhoneStr;
    
    NSMutableAttributedString *ageStr = [[NSMutableAttributedString alloc]initWithString:[NSString stringWithFormat:@"年龄：%ld",age]];
    [ageStr addAttribute:NSForegroundColorAttributeName value:UIColorFromHex(0x71c33a) range:NSMakeRange(0, 3)];
    ageLabel.attributedText = ageStr;
    
    NSMutableAttributedString *orderNoStr = [[NSMutableAttributedString alloc]initWithString:[NSString stringWithFormat:@"单号：%lld",orderNo]];
    [orderNoStr addAttribute:NSForegroundColorAttributeName value:UIColorFromHex(0x71c33a) range:NSMakeRange(0, 3)];
    orderNoLabel.attributedText = orderNoStr;
}

- (void)moreButtonAction{
    _yueZhenDanBlock();
}

@end
