//
//  ZhenLiaoDetailViewController.m
//  FindDoctor
//
//  Created by 晓炜 郭 on 15/12/27.
//  Copyright © 2015年 li na. All rights reserved.
//

#import "ZhenLiaoDetailViewController.h"
#import "YYZhenDanLineView.h"
#import "NSDate+SNExtension.h"
#import "UIImageView+WebCache.h"
#import "CUHerbSelect.h"
#import "YYPhotoView.h"
#import "PhotosShowView.h"

@interface ZhenLiaoDetailViewController (){
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
    YYZhenDanLineView *view11;
    YYZhenDanLineView *view12;
}

@property (nonatomic, strong) UIScrollView *contentScrollView;
@property (nonatomic, strong) UIImageView *imageView;

@end

@implementation ZhenLiaoDetailViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.isPanValid = NO;
    self.title = [NSString stringWithFormat:@"%@ 就诊单",_data.UserName];


    [self loadContentScrollView];
    [self loadContent];

}

-(void)loadContentScrollView{
    _contentScrollView = [[UIScrollView alloc]initWithFrame:CGRectMake(0, 0, kScreenWidth, self.contentView.frame.size.height)];
    _contentScrollView.scrollEnabled = YES;
    [self.contentView addSubview:_contentScrollView];
}

- (void)loadContent{
    int paadingLeft = 15;
    view0 = [[YYZhenDanLineView alloc]initWithFrame:CGRectMake(paadingLeft, 10, kScreenWidth - paadingLeft*2, 0)];
    [view0 setTitle:@"单        号:"];
    [view0 setContentText:[NSString stringWithFormat:@"%@",_data.diagnosisID]];
    view0.frame = CGRectMake([view0 frameX], [view0 frameY], kScreenWidth - paadingLeft*2, [view0 getframeHeight]);
    
    view1 = [[YYZhenDanLineView alloc]initWithFrame:CGRectMake(paadingLeft, 0, kScreenWidth - paadingLeft*2, 0)];
    [view1 setTitle:@"约  诊  人:"];
    [view1 setContentText:[NSString stringWithFormat:@"%@,%@,%ld岁\n手机号%@",_data.UserName,(_data.UserSex == 0 ? @"女":@"男"),_data.UserAge,_data.UserCellPhone]];
    view1.frame = CGRectMake(paadingLeft, CGRectGetMaxY(view0.frame), kScreenWidth - paadingLeft*2, [view1 getframeHeight]);
    
    view2 = [[YYZhenDanLineView alloc]initWithFrame:CGRectMake(paadingLeft, 0, kScreenWidth - paadingLeft*2, 0)];
    [view2 setTitle:@"下单时间:"];
    [view2 setContentText:[[NSDate dateWithTimeIntervalSince1970:_data.submitTime] stringWithDateFormat:@"yyyy-MM-dd HH:mm"]];
    view2.frame = CGRectMake(paadingLeft, CGRectGetMaxY(view1.frame), kScreenWidth - paadingLeft*2, [view2 getframeHeight]);
    
    view3 = [[YYZhenDanLineView alloc]initWithFrame:CGRectMake(paadingLeft, 0, kScreenWidth - paadingLeft*2, 0)];
    [view3 setTitle:@"预约医生:"];
    [view3 setContentText:[NSString stringWithFormat:@"%@ %@",_data.doctorName,_data.doctorTitle]];
    view3.frame = CGRectMake(paadingLeft, CGRectGetMaxY(view2.frame), kScreenWidth - paadingLeft*2, [view3 getframeHeight]);
    
    view4 = [[YYZhenDanLineView alloc]initWithFrame:CGRectMake(paadingLeft, 0, kScreenWidth - paadingLeft*2, 0)];
    [view4 setTitle:@"诊       金:"];
    [view4 setContentText:[NSString stringWithFormat:@"￥%.2lf",_data.diagnosisFee/100.f]];
    view4.frame = CGRectMake(paadingLeft, CGRectGetMaxY(view3.frame), kScreenWidth - paadingLeft*2, [view4 getframeHeight]);
    
    
    view5 = [[YYZhenDanLineView alloc]initWithFrame:CGRectMake(paadingLeft, 0, kScreenWidth - paadingLeft*2, 0)];
    [view5 setTitle:@"预  约  号:"];
    [view5 setContentText:[NSString stringWithFormat:@"第  %d  号",_data.orderNo]];
    view5.frame = CGRectMake(paadingLeft, CGRectGetMaxY(view4.frame), kScreenWidth - paadingLeft*2, [view5 getframeHeight]);
    
    
    view6 = [[YYZhenDanLineView alloc]initWithFrame:CGRectMake(paadingLeft, 0, kScreenWidth - paadingLeft*2, 0)];
    [view6 setTitle:@"就诊时间:"];
    [view6 setContentText:[[NSDate dateWithTimeIntervalSince1970:_data.diagnosisTime] stringWithDateFormat:@"yyyy-MM-dd HH:mm"]];
    if (_data.diagnosisTime == 0) {
        [view6 setContentText:[[NSDate dateWithTimeIntervalSince1970:_data.orderStartTime] stringWithDateFormat:@"yyyy-MM-dd HH:mm"]];
    }
    view6.frame = CGRectMake(paadingLeft, CGRectGetMaxY(view5.frame), kScreenWidth - paadingLeft*2, [view6 getframeHeight]);
    
    view7 = [[YYZhenDanLineView alloc]initWithFrame:CGRectMake(paadingLeft, 0, kScreenWidth - paadingLeft*2, 0)];
    [view7 setTitle:@"就诊地点:"];
    [view7 setContentText:[NSString stringWithFormat:@"%@(%@)",_data.clinicName,_data.clinicAddress]];
    view7.frame = CGRectMake(paadingLeft, CGRectGetMaxY(view6.frame), kScreenWidth - paadingLeft*2, [view7 getframeHeight]);
    
    view8 = [[YYZhenDanLineView alloc]initWithFrame:CGRectMake(paadingLeft, 0, kScreenWidth - paadingLeft*2, 0)];
    [view8 setTitle:@"病症描述:"];
    [view8 setContentText:[NSString stringWithFormat:@"%@",_data.illnessDescription]];
    if ([_data.illnessDescription isEmpty]) {
        [view8 setContentText:@"暂无"];
    }
    view8.frame = CGRectMake(paadingLeft, CGRectGetMaxY(view7.frame), kScreenWidth - paadingLeft*2, [view8 getframeHeight]);
    
    view9 = [[YYZhenDanLineView alloc]initWithFrame:CGRectMake(paadingLeft, 0, kScreenWidth - paadingLeft*2, 0)];
    [view9 setTitle:@"病症图片:"];
    [view9 setContentText:@"暂无"];
    view9.frame = CGRectMake(paadingLeft, CGRectGetMaxY(view8.frame), kScreenWidth - paadingLeft*2, [view9 getframeHeight]);
    if (_data.illnessPic.count){
        [view9 setContentText:@""];
        PhotosShowView *photosShowView = [[PhotosShowView alloc]initWithFrame:CGRectMake(paadingLeft, CGRectGetMaxY(view9.frame), kScreenWidth - paadingLeft*2, 0)];
        __weak __block PhotosShowView *blockPhotosShowView = photosShowView;
        photosShowView.imageURLArray = _data.illnessPic;
        photosShowView.photosShowBlock = ^(NSInteger inex){
            YYPhotoView *view = [[YYPhotoView alloc]initWithPhotoArray:blockPhotosShowView.imageArray numberOfClickedPhoto:inex];
            [[self.view superview] addSubview:view];
        };
        [_contentScrollView  addSubview:photosShowView];
        NSString *str = [_data.illnessPic objectAtIndex:0];
        if ([str isEmpty]) {
            _contentScrollView.contentSize = CGSizeMake(kScreenWidth, CGRectGetMaxY(view9.frame) + 10);
        }
        else{
            _contentScrollView.contentSize = CGSizeMake(kScreenWidth, CGRectGetMaxY(view9.frame) + photosShowView.frameHeight + 10);
        }
        
    }
    else{
        _contentScrollView.contentSize = CGSizeMake(kScreenWidth, CGRectGetMaxY(view9.frame) + 10);
    }
    
    
    
    if (_data.state == 4 || _data.state == 5) {
        view10 = [[YYZhenDanLineView alloc]initWithFrame:CGRectMake(paadingLeft, 0, kScreenWidth - paadingLeft*2, 0)];
        [view10 setTitle:@"诊断信息:"];
        [view10 setContentText:@"暂无"];
        view10.frame = CGRectMake(paadingLeft, _contentScrollView.contentSize.height - 10, kScreenWidth - paadingLeft*2, [view10 getframeHeight]);
        if(![_data.diagnosisContent isEmpty]){
            [view10 setContentText:[NSString stringWithFormat:@"%@",_data.diagnosisContent]];
            view10.frame = CGRectMake(paadingLeft, _contentScrollView.contentSize.height - 10, kScreenWidth - paadingLeft*2, [view10 getframeHeight]);
            
        }
        
        
        if (![_data.recipePic isEmpty]) {
            view11 = [[YYZhenDanLineView alloc]initWithFrame:CGRectMake(paadingLeft, 0, kScreenWidth - paadingLeft*2, 0)];
            [view11 setTitle:@"药       方:"];
            [view11 setContentText:[NSString stringWithFormat:@"图片"]];
            view11.frame = CGRectMake(paadingLeft,CGRectGetMaxY(view10.frame), kScreenWidth - paadingLeft*2, [view10 getframeHeight]);
            [view11 setContentText:[NSString stringWithFormat:@""]];
            
            PhotosShowView *photosShowView = [[PhotosShowView alloc]initWithFrame:CGRectMake(paadingLeft, CGRectGetMaxY(view11.frame), kScreenWidth - paadingLeft*2, 0)];
            __weak __block PhotosShowView *blockPhotosShowView = photosShowView;
            photosShowView.imageURLArray = [NSArray arrayWithObject:[NSURL URLWithString:_data.recipePic]];
            photosShowView.photosShowBlock = ^(NSInteger inex){
                YYPhotoView *view = [[YYPhotoView alloc]initWithPhotoArray:blockPhotosShowView.imageArray numberOfClickedPhoto:inex];
                [[self.view superview] addSubview:view];
            };
            [_contentScrollView  addSubview:photosShowView];
            _contentScrollView.contentSize = CGSizeMake(kScreenWidth, CGRectGetMaxY(view11.frame) + photosShowView.frameHeight + 10);
            
            view12 = [[YYZhenDanLineView alloc]initWithFrame:CGRectMake(paadingLeft, 0, kScreenWidth - paadingLeft*2, 0)];
            [view12 setTitle:@"付       数:"];
            [view12 setContentText:[NSString stringWithFormat:@"%ld",_data.recipeNum]];
            view12.frame = CGRectMake(paadingLeft, _contentScrollView.contentSize.height - 10 , kScreenWidth - paadingLeft*2, [view12 getframeHeight]);
            [self.contentScrollView addSubview:view12];
            
            _contentScrollView.contentSize = CGSizeMake(kScreenWidth, CGRectGetMaxY(view12.frame)+10);
        }
        else{
            view11 = [[YYZhenDanLineView alloc]initWithFrame:CGRectMake(paadingLeft, 0, kScreenWidth - paadingLeft*2, 0)];
            [view11 setTitle:@"药       方:"];
            NSString *string = [[NSString alloc]init];
            for (int i = 0 ; i < _data.recipeData.count; i++) {
                CUHerbSelect *herb = [_data.recipeData objectAtIndex:i];
                if (i) {
                    if(i%2 == 1){
                        string = [string stringByAppendingFormat:@"      %@ %D %@",[herb name],[herb weight],[herb unit]];
                    }
                    else{
                        string = [string stringByAppendingFormat:@"\n%@ %D %@",[herb name],[herb weight],[herb unit]];
                    }
                }
                else{
                    string = [string stringByAppendingFormat:@"%@ %D %@",[herb name],[herb weight],[herb unit]];
                }
                
            }
            [view11 setContentText:string];
            view11.frame = CGRectMake(paadingLeft, CGRectGetMaxY(view10.frame), kScreenWidth - paadingLeft*2, [view11 getframeHeight]);
            
            view12 = [[YYZhenDanLineView alloc]initWithFrame:CGRectMake(paadingLeft, 0, kScreenWidth - paadingLeft*2, 0)];
            [view12 setTitle:@"付       数:"];
            [view12 setContentText:[NSString stringWithFormat:@"%ld",_data.recipeNum]];
            view12.frame = CGRectMake(paadingLeft, CGRectGetMaxY(view11.frame), kScreenWidth - paadingLeft*2, [view12 getframeHeight]);
            
            [self.contentScrollView addSubview:view12];
            
            _contentScrollView.contentSize = CGSizeMake(kScreenWidth, CGRectGetMaxY(view12.frame) + 10);
        }
        
    }
    
    
    NSLog(@"%@",_contentScrollView);
    
    [self.contentScrollView addSubview:view0];
    [self.contentScrollView addSubview:view1];
    [self.contentScrollView addSubview:view2];
    [self.contentScrollView addSubview:view3];
    [self.contentScrollView addSubview:view4];
    [self.contentScrollView addSubview:view5];
    [self.contentScrollView addSubview:view6];
    [self.contentScrollView addSubview:view7];
    [self.contentScrollView addSubview:view8];
    [self.contentScrollView addSubview:view9];
    [self.contentScrollView addSubview:view10];
    [self.contentScrollView addSubview:view11];
    [self.contentScrollView addSubview:view12];
}

- (void)setData:(Patient *)data{
    _data = data;
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
