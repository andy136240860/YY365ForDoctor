//
//  YueZhenDanViewController.m
//  FindDoctor
//
//  Created by Guo on 15/10/26.
//  Copyright © 2015年 li na. All rights reserved.
//

#import "YueZhenDanViewController.h"
#import "YYZhenDanLineView.h"
#import "NSDate+SNExtension.h"

#define intervalLeft 10
#define intervalTop 8
#define intervalY 15

@interface YueZhenDanViewController (){
    YYZhenDanLineView *view0;
    YYZhenDanLineView *view1;
    YYZhenDanLineView *view2;
    YYZhenDanLineView *view3;
    YYZhenDanLineView *view4;
    YYZhenDanLineView *view5;
    YYZhenDanLineView *view6;
    YYZhenDanLineView *view7;
    YYZhenDanLineView *view8;
    YYZhenDanLineView *view9;
    YYZhenDanLineView *view10;
}

@end

@implementation YueZhenDanViewController

- (void)viewDidLoad {
    self.title = @"约诊单";
    [self loadContentView];
    [super viewDidLoad];
}

- (void)loadContentView{
    int paadingLeft = 15;
    view0 = [[YYZhenDanLineView alloc]initWithFrame:CGRectMake(paadingLeft, 0, kScreenWidth - paadingLeft*2, 0)];
    [view0 setTitle:@"单        号:"];
    [view0 setContentText:_data.diagnosisID];
    view0.frame = CGRectMake([view0 frameX], [view0 frameY], kScreenWidth - paadingLeft*2, [view0 getframeHeight]);
    
    view1 = [[YYZhenDanLineView alloc]initWithFrame:CGRectMake(paadingLeft, 0, kScreenWidth - paadingLeft*2, 0)];
    [view1 setTitle:@"约  诊  人:"];
    [view1 setContentText:[NSString stringWithFormat:@"%@,%@,%ld岁\n手机号%@",_data.UserName,(_data.UserSex == 0 ? @"女":@"男"),_data.UserAge,_data.UserCellPhone]];
    view1.frame = CGRectMake(paadingLeft, CGRectGetMaxY(view0.frame), kScreenWidth - paadingLeft*2, [view1 getframeHeight]);
    
    view2 = [[YYZhenDanLineView alloc]initWithFrame:CGRectMake(paadingLeft, 0, kScreenWidth - paadingLeft*2, 0)];
    [view2 setTitle:@"约单时间:"];
    [view2 setContentText:[[NSDate dateWithTimeIntervalSince1970:_data.submitTime] stringWithDateFormat:@"yyyy-MM-dd HH:mm"]];
    view2.frame = CGRectMake(paadingLeft, CGRectGetMaxY(view1.frame), kScreenWidth - paadingLeft*2, [view2 getframeHeight]);
    
    view3 = [[YYZhenDanLineView alloc]initWithFrame:CGRectMake(paadingLeft, 0, kScreenWidth - paadingLeft*2, 0)];
    [view3 setTitle:@"约诊医生:"];
    [view3 setContentText:[NSString stringWithFormat:@"%@ %@",_data.doctorName,_data.doctorTitle]];
    view3.frame = CGRectMake(paadingLeft, CGRectGetMaxY(view2.frame), kScreenWidth - paadingLeft*2, [view3 getframeHeight]);
    
    view4 = [[YYZhenDanLineView alloc]initWithFrame:CGRectMake(paadingLeft, 0, kScreenWidth - paadingLeft*2, 0)];
    [view4 setTitle:@"诊       金:"];
    [view4 setContentText:[NSString stringWithFormat:@"￥%.2lf",_data.diagnosisFee/100.f]];
    view4.frame = CGRectMake(paadingLeft, CGRectGetMaxY(view3.frame), kScreenWidth - paadingLeft*2, [view4 getframeHeight]);
    
    view5 = [[YYZhenDanLineView alloc]initWithFrame:CGRectMake(paadingLeft, 0, kScreenWidth - paadingLeft*2, 0)];
    [view5 setTitle:@"就诊时间:"];
    [view5 setContentText:[[NSDate dateWithTimeIntervalSince1970:_data.orderStartTime] stringWithDateFormat:@"yyyy-MM-dd HH:mm"] ];
    if(_data.orderStartTime == 0){
        [view5 setContentText:@"暂无记录"];
    }
    view5.frame = CGRectMake(paadingLeft, CGRectGetMaxY(view4.frame), kScreenWidth - paadingLeft*2, [view5 getframeHeight]);
    
    view6 = [[YYZhenDanLineView alloc]initWithFrame:CGRectMake(paadingLeft, 0, kScreenWidth - paadingLeft*2, 0)];
    [view6 setTitle:@"就诊地点:"];
    [view6 setContentText:[NSString stringWithFormat:@"%@(%@)",_data.clinicName,_data.clinicAddress]];
    view6.frame = CGRectMake(paadingLeft, CGRectGetMaxY(view5.frame), kScreenWidth - paadingLeft*2, [view6 getframeHeight]);
    
//    view7 = [[YYZhenDanLineView alloc]initWithFrame:CGRectMake(paadingLeft, 0, kScreenWidth - paadingLeft*2, 0)];
//    [view7 setTitle:@"医疗诊点:"];
//    [view7 setContentText:_data.clinicName];
//    view7.frame = CGRectMake(paadingLeft, CGRectGetMaxY(view6.frame), kScreenWidth - paadingLeft*2, [view7 getframeHeight]);
//    
    view8 = [[YYZhenDanLineView alloc]initWithFrame:CGRectMake(paadingLeft, 0, kScreenWidth - paadingLeft*2, 0)];
    [view8 setTitle:@"病症描述:"];
    [view8 setContentText:_data.illnessDescription];
    view8.frame = CGRectMake(paadingLeft, CGRectGetMaxY(view6.frame), kScreenWidth - paadingLeft*2, [view8 getframeHeight]);
    
    [self.contentView addSubview:view0];
    [self.contentView addSubview:view1];
    [self.contentView addSubview:view2];
    [self.contentView addSubview:view3];
    [self.contentView addSubview:view4];
    [self.contentView addSubview:view5];
    [self.contentView addSubview:view6];
    [self.contentView addSubview:view7];
    [self.contentView addSubview:view8];
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)loadNavigationBar
{
    [self addLeftBackButtonItemWithImage];
}
@end
