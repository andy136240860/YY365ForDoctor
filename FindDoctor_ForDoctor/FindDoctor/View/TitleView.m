//
//  GXWHeaderView.m
//  FindDoctor
//
//  Created by Guo on 15/8/25.
//  Copyright (c) 2015年 li na. All rights reserved.
//

#import "TitleView.h"

@implementation TitleView


- (instancetype)initWithFrame:(CGRect)frame title:(NSString *)title{
    self = [super init];
    if (self) {
        self.frame = frame;
        self.backgroundColor = [UIColor clearColor];
        _headerLabel = [[UILabel alloc]init];
        _headerLabel.text = title;
        _headerLabel.font =[UIFont systemFontOfSize:14];
        _headerLabel.textColor = UIColorFromHex(0x51b526);
        CGSize size =  [self sizeWithString:title font:[UIFont systemFontOfSize:14]];
        _headerLabel.frame = CGRectMake((kScreenWidth-size.width)/2,10,size.width,size.height);
        [self addSubview:_headerLabel];
        
        UIImage *headerline = [UIImage imageNamed:@"headerline"];
        UIImageView *headerlionView1 = [[UIImageView alloc]initWithImage:headerline];
        UIImageView *headerlionView2 = [[UIImageView alloc]initWithImage:headerline];
        headerlionView1.frame = CGRectMake(0,17,((kScreenWidth-size.width)/2.0-10),1);
        headerlionView1.contentMode = 0;
        headerlionView2.frame = CGRectMake((kScreenWidth+size.width)/2+10,17,((kScreenWidth-size.width)/2.0-10),1);
        headerlionView2.contentMode = 0;
        
        [self addSubview:headerlionView1];
        [self addSubview:headerlionView2];
    }
    return self;
}


- (CGSize)sizeWithString:(NSString *)string font:(UIFont *)font
{
    CGRect rect = [string boundingRectWithSize:CGSizeMake(320, 8000)//限制最大的宽度和高度
                                       options:NSStringDrawingTruncatesLastVisibleLine | NSStringDrawingUsesFontLeading  |NSStringDrawingUsesLineFragmentOrigin//采用换行模式
                                    attributes:@{NSFontAttributeName: font}//传人的字体字典
                                       context:nil];
    
    return rect.size;
}
@end
