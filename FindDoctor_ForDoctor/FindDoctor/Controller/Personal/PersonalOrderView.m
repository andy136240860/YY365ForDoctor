//
//  PersonalOrderView.m
//  FindDoctor
//
//  Created by Guo on 15/9/8.
//  Copyright (c) 2015年 li na. All rights reserved.
//

#import "PersonalOrderView.h"

@implementation PersonalOrderView

- (instancetype)initWithFrame:(CGRect)frame OrderID:(NSInteger *)OrderID{
    
    self = [super init];
    if (self) {
        
        self.frame = frame;
        
        NSInteger *_order_id = 12354546564;
        NSString *_user = @"李四";
        NSString *_doctor = @"张仲景";
        NSInteger *_queue_number = 35;
        NSString *_service_time = @"2015-08-25 15:44-16:10";
        NSString *_address = @"成都市成华区建设北路2段就诊处成都市成华区建设北路2段就诊处";
        
        NSString *content = [NSString stringWithFormat:@"约诊单号:%d\n%@约诊%@医生\n约诊号:预约号第%d号\n约诊时间:%@\n地点:%@",_order_id,_user,_doctor,_queue_number,_service_time,_address];
        
        UILabel *orderLaber = [[UILabel alloc]initWithFrame:CGRectMake(15, 30, kScreenWidth-40, 200)];
        orderLaber.text = content;
        orderLaber.numberOfLines = 0;
        orderLaber.font = [UIFont systemFontOfSize:14.0f];
        orderLaber.lineBreakMode = UILineBreakModeWordWrap;
        [orderLaber sizeToFit];
        
//        CGSize size =  [self sizeWithString:orderLaber font:[UIFont systemFontOfSize:14]];
//        
//        
//        UIButton *reviseButtom = [[UIButton alloc]initWithFrame:CGRectMake((self.frame.size.width-193)/4.0, self.frame.size.height - 30, 193/2.0, 45/2.0)];
//        reviseButtom.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"btn_white_nor"]];
        
//        [self addSubview:reviseButtom];
        [self addSubview:orderLaber];
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
