////
////  OfferOrderViewController.m
////  FindDoctor
////
////  Created by Guo on 15/9/19.
////  Copyright (c) 2015年 li na. All rights reserved.
////
//
//#import "OfferOrderViewController.h"
//#import "NSDate+SNExtension.h"
//#import "TimeSegButton.h"
//#import "TreatmentOrderManager.h"
//#import "Clinic.h"
//
//#import "MBProgressHUD.h"   
//
//#define segTimeIntervalX 30
//
//@interface OfferOrderViewController (){
//    BOOL timeSegMark;   // NO就是第一次打开， 非重新编辑放号， 所有timeseg不可点击
//}
//@end
//
//@implementation OfferOrderViewController
//
//{
//    UIScrollView   *contentScrollView;
//    
//    //第一行日期选择
//    UILabel        *timeLable;
//    UIDatePicker   *dayTimePickerView;
//    NSDate         *dayTimePickerViewData;
//    BOOL           dayTimePickerViewIsShowing;
//    
//    //第二行周期选择
//    UIPickerView   *clinicPickerView;
//    UILabel        *clinicLable;
//    NSMutableArray *clinicList;
//    UITapGestureRecognizer *clinicLabletap;
//    Clinic         *currentClinic;
//    BOOL           clinicPickerViewIsShowing;
//    
//    //第三行时间段选择
//    NSMutableArray *time_segButtonArray;
//    NSMutableArray *time_segLableArray;
//    NSInteger      time_segID;
//    BOOL tempState ;
//    
//    
//    //第三行时间（小时）选择
//    UILabel        *preHourTimeLable;
//    UIDatePicker   *preHourTimePickerView;
//    NSDate         *preHourTimePickerViewData;
//    BOOL           preHourTimePickerViewIsShowing;
//    
//    UILabel        *folHourTimeLable;
//    UIDatePicker   *folHourTimePickerView;
//    NSDate         *folHourTimePickerViewData;
//    BOOL           folHourTimePickerViewIsShowing;
//    
//    //第四行地址选择
//    //    UIImageView    *addressInputView;
//    //    UILabel        *addressLable;
//    UITextField    *addressTextField;
//    BOOL           addressViewIsEditing;
//    
//    //第五行放号数量
//    UIImageView    *numberOfOfferInputView;
//    UITextField    *numberOfOfferTextField;
//    
//    //第六号费用
//    UIImageView    *billInputView;
//    UITextField    *billTextField;
//    
//    //第七号详细信息
//    UIImageView    *detailsInputView;
//    UITextView     *detailsTextView;
//    
//    UIView         *blackView;
//    
//    CGFloat        tempContentScrollViewY;
//    
//    UIButton       *instantOrNotButton;
//    BOOL           instantOrNot;
//    
//    UIButton       *submitButton;
//    
//    NSInteger      modify;
//}
//@synthesize isEditOrder;
//
//- (void)viewWillAppear:(BOOL)animated{
//    if (_data == nil) {
//        _data = [[TreatmentOrder alloc]init];
//        modify = 0;
//        isEditOrder = NO;
//        timeSegMark = NO;
//    }
//    
//    
//    else{
//        isEditOrder = YES;
//        timeSegMark = NO;
//        modify = 1;
//        numberOfOfferTextField.text = [NSString stringWithFormat:@"%ld",_data.num];
//        billTextField.text = [NSString stringWithFormat:@"%ld",_data.fee];
//        detailsTextView.text = [NSString stringWithFormat:@"%@",_data.subject];
//        timeLable.text = [NSString stringWithFormat:@"%@",_data.date];
//        
//        NSDateFormatter *formattor = [[NSDateFormatter alloc]init];
//        [formattor setDateFormat:@"yyyy-MM-dd"];
//        NSDate *date = [formattor dateFromString:_data.date];
//        
//        _data.timestamp = [date timeIntervalSince1970];
//        
//        [[TreatmentOrderManager sharedInstance] FangHaoForGetClinicWithTiemstamp:_data.timestamp resultBlock:^(SNHTTPRequestOperation *request, SNServerAPIResultData *result) {
//            if (!result.hasError) {
//                NSMutableArray *clinicarray = result.parsedModelObject;
//                
//                clinicList = [NSMutableArray new];
//                for (int i = 0; i < clinicarray.count; i++) {
//                    Clinic *clinic = (Clinic *)[clinicarray objectAtIndex:i];
//                    [clinicList addObjectSafely:clinic];
//                }
//                [clinicPickerView reloadAllComponents];
//                NSLog(@"刷新诊疗点信息");
//                clinicLabletap.numberOfTapsRequired = 1;
//                currentClinic.ID = _data.clinic.ID;
//                currentClinic.name = [NSString stringWithFormat:@"%@",_data.clinic.name];
//                clinicLable.text = [NSString stringWithFormat:@"%@",_data.clinic.name];
//            }
//        } pageName:@"OfferOrderViewController"];
//
//    }
//}
//
//
//- (void)viewDidLoad {
//    [super viewDidLoad];
//    self.title = @"放号";
//    currentClinic = [[Clinic alloc]init];
//    [self initContentScrollView];
//    //后面修改要加个判断， 是否为重新编辑， 重新编辑就改
//    [self initInputView];
//    
//    // Do any additional setup after loading the view.
//}
//
//- (void)setData:(TreatmentOrder *)data{
//    _data = data;
//}
//
////第一次打开放号接口 设置所有seg都不允许点击
//- (void)loadTimeSegData{
//    for (int k = 0; k < 15; k++) {
//        TimeSegButton *temp = (TimeSegButton *)[time_segButtonArray objectAtIndex:k];
//        temp.timeState = [NSNumber numberWithInteger:0];
//    }
//}
//
//
//- (void)loadNavigationBar
//{
//    [self addLeftBackButtonItemWithImage];
//}
//
//- (void)initInputView{
//    
//    //============================================添加第一行设置日期DatePicker对应的Lable===============================
//    dayTimePickerViewData = [NSDate date];
//    
//    UIImageView *dayTimeOrderInputView = [[UIImageView alloc]initWithFrame:CGRectMake((kScreenWidth-306)/2, 18, 306, 79/2.0)];
//    dayTimeOrderInputView.image = [UIImage imageNamed:@"DayTimeOrderInputBackground"];
//    dayTimeOrderInputView.userInteractionEnabled = YES;
//    
//    timeLable = [[UILabel alloc]initWithFrame:CGRectMake(135, 14, 160, 14)];
//    timeLable.font = [UIFont systemFontOfSize:14];
//    timeLable.text = @"请选择日期";
//    timeLable.textAlignment = NSTextAlignmentRight;
//    timeLable.textColor = UIColorFromHex(Color_Hex_Text_Readed);
//    timeLable.userInteractionEnabled = YES;
//    UITapGestureRecognizer *timeLabletap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(ShowdayTimePickerView)];
//    timeLabletap.numberOfTapsRequired = 1;
//    [dayTimeOrderInputView addGestureRecognizer:timeLabletap];
//    
//    [contentScrollView addSubview:dayTimeOrderInputView];
//    [dayTimeOrderInputView addSubview:timeLable];
//    
//    
//    //=========================================添加第2行设置诊疗点PickerView =====================================
//    
//    UIImageView *clinicInputView = [[UIImageView alloc]initWithFrame:CGRectMake((kScreenWidth-306)/2, 18*2+79/2.0f, 306, 79/2.0)];
//    clinicInputView.image = [UIImage imageNamed:@"ClinicOrderInputBackground@2x.png"];
//    clinicInputView.userInteractionEnabled = YES;
//    
//    clinicLable = [[UILabel alloc]initWithFrame:CGRectMake(306-150-10-50, 14, 160, 14)];
//    clinicLable.font = [UIFont systemFontOfSize:12];
//    clinicLable.text = @"请先选择日期";
//    clinicLable.textAlignment = NSTextAlignmentRight;
//    clinicLable.textColor = UIColorFromHex(Color_Hex_Text_Normal);
//    clinicLable.userInteractionEnabled = YES;
//    
//    [clinicLable addObserver:self forKeyPath:@"text" options:NSKeyValueObservingOptionNew|NSKeyValueObservingOptionOld context:NULL];
//    
//    
//    clinicList = [NSMutableArray new];
//    
//    
//    clinicLabletap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(ShowClinicPickerView)];
//    clinicLabletap.numberOfTapsRequired = 1000;
//    [clinicInputView addGestureRecognizer:clinicLabletap];
//    
//    
//    [contentScrollView addSubview:clinicInputView];
//    [clinicInputView addSubview:clinicLable];
//    
//    
//    //=========================================    添加第3行时间段    =================================
//    
//    UIView *time_segView = [[UIView alloc]initWithFrame:CGRectMake((kScreenWidth-306)/2, 18*3+79, 306, 300)];
//    
//    UILabel *titleLable = [[UILabel alloc]initWithFrame:CGRectMake(5, 0, time_segView.frame.size.width, 14)];
//    titleLable.text = @"预约时间";
//    titleLable.font = [UIFont systemFontOfSize:12];
//    titleLable.textAlignment = NSTextAlignmentLeft;
//    titleLable.textColor = UIColorFromHex(0xa9a9a9);
//    [time_segView addSubview:titleLable];
//    
//    //时间段button数组初始化
//    time_segButtonArray = [NSMutableArray new];
//    time_segLableArray = [NSMutableArray new];
//    for (int k = 0; k < 15; k++) {
//        TimeSegButton  *time_segButton = [[TimeSegButton alloc]init];
//        [time_segButtonArray addObject:time_segButton];
//    }
//    [self loadTimeSegData];
//    
//    //初始化时间段数组的ID与frame
//    int k = 0;
//    for (int i=0; i<3; i++) {
//        for (int j=0; j<6; j++) {
//            k = i * 6 + j;
//            if(i<2){
//                TimeSegButton *temp = (TimeSegButton *)[time_segButtonArray objectAtIndex:k];
//                temp.frame = CGRectMake(j*51, (i+1)*25+i*67*0.5, 51, 67*0.5);
//                temp.tag = i*6+j;
//                temp.ID = [NSNumber numberWithInteger:(i*6+j)];
//                [self addTimeSegAction:temp];
//                
//                UILabel *segTimeLable = [[UILabel alloc]initWithFrame:CGRectMake(temp.frame.origin.x, temp.frame.origin.y + segTimeIntervalX, temp.frame.size.width,temp.frame.size.height)];
//                segTimeLable.tag = i*6+j;
//                [time_segLableArray addObject:segTimeLable];
//                
//            }
//            if(i == 2){
//                if (k>14) {
//                    break;
//                }
//                TimeSegButton *temp = (TimeSegButton *)[time_segButtonArray objectAtIndex:k];
//                temp.frame = CGRectMake(j*102, (i+1)*25+i*67*0.5, 102, 67*0.5);
//                temp.tag = i*6+j;
//                temp.ID = [NSNumber numberWithInteger:(i*6+j)];
//                [self addTimeSegAction:temp];
//                UILabel *segTimeLable = [[UILabel alloc]initWithFrame:CGRectMake(temp.frame.origin.x, temp.frame.origin.y + segTimeIntervalX, temp.frame.size.width,temp.frame.size.height)];
//                segTimeLable.tag = temp.tag = i*6+j;
//                [time_segLableArray addObject:segTimeLable];
//            }
//        }//j循环
//    }//i循环
//    
//    for ( int k = 0 ; k < time_segLableArray.count; k++) {
//        UILabel *temp = (UILabel *)[time_segLableArray objectAtIndex:k];
//        temp.textAlignment = NSTextAlignmentLeft;
//        temp.font = [UIFont systemFontOfSize:11];
//        temp.textColor = UIColorFromHex(0xcccccc);
//        [time_segView addSubview:temp];
//        if (temp.tag == 0) {
//            temp.text = @"8:00";
//        }
//        if (temp.tag == 1) {
//            temp.text = @"9:00";
//        }
//        if (temp.tag == 2) {
//            temp.text = @"10:00";
//        }
//        if (temp.tag == 3) {
//            temp.text = @"11:00";
//        }
//        if (temp.tag == 4) {
//            temp.text = @"12:00";
//        }
//        if (temp.tag == 5) {
//            temp.text = @"13:00";
//        }
//        if (temp.tag == 6) {
//            temp.text = @"14:00";
//        }
//        if (temp.tag == 7) {
//            temp.text = @"15:00";
//        }
//        if (temp.tag == 8) {
//            temp.text = @"16:00";
//        }
//        if (temp.tag == 9) {
//            temp.text = @"17:00";
//        }
//        if (temp.tag == 10) {
//            temp.text = @"18:00";
//        }
//        if (temp.tag == 11) {
//            temp.text = @"19:00";
//        }
//        if (temp.tag == 12) {
//            temp.text = @"20:00";
//        }
//        if (temp.tag == 13) {
//            temp.text = @"24:00";
//        }
//        if (temp.tag == 14) {
//            temp.text = @"第二天4:00 - 8:00";
//        }
//    }
//    
//    [contentScrollView addSubview:time_segView];
//    for (int k = 0; k < 15; k++) {
//        [time_segView addSubview:[time_segButtonArray objectAtIndex:k]];
//    }
//    
//    
//    //=========================================添加第5行设置放号数量对应的textField=================================
//    numberOfOfferInputView = [[UIImageView alloc]initWithFrame:CGRectMake((kScreenWidth-306)/2, 18*7+79*3, 306, 79/2.0)];
//    numberOfOfferInputView.image = [UIImage imageNamed:@"NumberOfOrderInputBackground"];
//    numberOfOfferInputView.userInteractionEnabled = YES;
//    
//    UILabel *GELable  = [[UILabel alloc]initWithFrame:CGRectMake(282, 14, 14, 14)];
//    //    addressLable.backgroundColor = [UIColor yellowColor];
//    GELable.text = @"个";
//    GELable.textColor = UIColorFromHex(Color_Hex_Text_Readed);
//    GELable.textAlignment = NSTextAlignmentRight;
//    GELable.font = [UIFont systemFontOfSize:14];
//    GELable.userInteractionEnabled = YES;
//    
//    numberOfOfferTextField = [[UITextField alloc]initWithFrame:CGRectMake(202, 14, 70, 14)];
//    numberOfOfferTextField.delegate = self;
//    numberOfOfferTextField.text = @"0";
//    numberOfOfferTextField.textAlignment = NSTextAlignmentRight;
//    numberOfOfferTextField.clearsOnBeginEditing = YES;
//    numberOfOfferTextField.keyboardType = UIKeyboardTypeNumberPad;
//    
//    UITapGestureRecognizer *numberOfOfferLabletap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(ShowNumberOfOfferTextField)];
//    numberOfOfferLabletap.numberOfTapsRequired = 1;
//    [numberOfOfferInputView addGestureRecognizer:numberOfOfferLabletap];
//    
//    [numberOfOfferInputView addSubview:numberOfOfferTextField];
//    [numberOfOfferInputView addSubview:GELable];
//    
//    [contentScrollView addSubview:numberOfOfferInputView];
//    
//    //=========================================添加第6行设置费用对应的textField=================================
//    billInputView = [[UIImageView alloc]initWithFrame:CGRectMake((kScreenWidth-306)/2, 18*8+79*3.5, 306, 79/2.0)];
//    billInputView.image = [UIImage imageNamed:@"BillInputBackground"];
//    billInputView.userInteractionEnabled = YES;
//    
//    UILabel *YUANLable  = [[UILabel alloc]initWithFrame:CGRectMake(282, 14, 14, 14)];
//    //    addressLable.backgroundColor = [UIColor yellowColor];
//    YUANLable.text = @"元";
//    YUANLable.textColor = UIColorFromHex(Color_Hex_Text_Readed);
//    YUANLable.textAlignment = NSTextAlignmentRight;
//    YUANLable.font = [UIFont systemFontOfSize:14];
//    YUANLable.userInteractionEnabled = YES;
//    
//    billTextField = [[UITextField alloc]initWithFrame:CGRectMake(202, 14, 70, 14)];
//    billTextField.delegate = self;
//    billTextField.text = @"0";
//    billTextField.textAlignment = NSTextAlignmentRight;
//    billTextField.clearsOnBeginEditing = YES;
//    billTextField.keyboardType = UIKeyboardTypeNumberPad;
//    
//    UITapGestureRecognizer *billLabletap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(ShowBillTextField)];
//    billLabletap.numberOfTapsRequired = 1;
//    [billInputView addGestureRecognizer:billLabletap];
//    
//    [billInputView addSubview:billTextField];
//    [billInputView addSubview:YUANLable];
//    
//    [contentScrollView addSubview:billInputView];
//    //=========================================添加第7行设置详情对应的textView=================================
//    detailsInputView = [[UIImageView alloc]initWithFrame:CGRectMake((kScreenWidth-306)/2, 18*9+79*4, 306, 229/2.0)];
//    detailsInputView.image = [UIImage imageNamed:@"DetailsInputBackground"];
//    detailsInputView.userInteractionEnabled = YES;
//    
//    detailsTextView = [[UITextView alloc]initWithFrame:CGRectMake(88, 5, 208, 229/2.0-10)];
//    detailsTextView.delegate = self;
//    detailsTextView.textAlignment = NSTextAlignmentLeft;
//    detailsTextView.keyboardType = UIKeyboardTypeDefault;
//    detailsTextView.font = [UIFont systemFontOfSize:14];
//    
//    UITapGestureRecognizer *detailsLabletap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(ShowdetailsTextView)];
//    detailsLabletap.numberOfTapsRequired = 1;
//    [detailsInputView addGestureRecognizer:detailsLabletap];
//    
//    [detailsInputView addSubview:detailsTextView];
//    
//    [contentScrollView addSubview:detailsInputView];
//    
//    
//    //=========================================添加即时就医勾选框===============================================
//    instantOrNotButton = [[UIButton alloc]initWithFrame:CGRectMake((kScreenWidth-306)/2, 18*10+79*4+229*0.5, 173*0.5, 58*0.5)];
//    [self setButtonImage];
//    [instantOrNotButton addTarget:self action:@selector(changeButtonImage) forControlEvents:UIControlEventTouchUpInside];
//    [contentScrollView  addSubview:instantOrNotButton];
//    
//    //=========================================添加提交按钮====================================================
//    submitButton = [[UIButton alloc]initWithFrame:CGRectMake( (kScreenWidth-516*0.5)*0.5, 18*11+79*4+229*0.5+29, 516*0.5, 73*0.5)];
//    NSLog(@"当前View的高度为%f",self.contentView.frame.size.height);
//    submitButton.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"SubmitButton"]];
//    [submitButton addTarget:self action:@selector(submitOrderData) forControlEvents:UIControlEventTouchUpInside];
//    [contentScrollView  addSubview:submitButton];
//}
//
//
//#pragma mark - 弹出第1行时间（日期）选择DatePicker
//
////弹出第一个选择日期的DatePicker
//- (void)ShowdayTimePickerView{
//    [self HideTextField];
//    NSLog(@"弹出第1个PickerView");
//    
//    blackView =[[UIView alloc]initWithFrame:CGRectMake(0, 0,kScreenWidth,kScreenHeight)];
//    blackView.backgroundColor = [UIColor colorWithRed:0 green:0 blue:0 alpha:0.2];
//    blackView.userInteractionEnabled = YES;
//    
//    dayTimePickerView = [[UIDatePicker alloc]initWithFrame:CGRectMake(0, self.contentView.frame.size.height/2-100, kScreenWidth, 200)];
//    dayTimePickerView.backgroundColor = [UIColor whiteColor];
//    dayTimePickerView.datePickerMode = UIDatePickerModeDate;
//    [dayTimePickerView setLocale:[[NSLocale alloc]initWithLocaleIdentifier:@"zh_Hans_CN"]];
//    [dayTimePickerView setCalendar:[NSCalendar currentCalendar]];
//    [dayTimePickerView setTimeZone:[NSTimeZone defaultTimeZone]];
//    
//    [dayTimePickerView setDate:dayTimePickerViewData];
//    [dayTimePickerView setMinimumDate:[dayTimePickerViewData dateByAddingDays:1]];
//    [dayTimePickerView setMaximumDate:[dayTimePickerViewData dateByAddingDays:8]];
//    [dayTimePickerView setDatePickerMode:UIDatePickerModeDate];
//    
//    [blackView  addSubview:dayTimePickerView];
//    
//    
//    
//    [contentScrollView addSubview:blackView];
//    contentScrollView.scrollEnabled = NO;
//    dayTimePickerViewIsShowing = YES;
//    
//}
//
//#pragma mark - 弹出第2行周期选择PickerView
//
//- (void)ShowClinicPickerView{
//    [self HideTextField];
//    
//    blackView =[[UIView alloc]initWithFrame:CGRectMake(0, 0,kScreenWidth,kScreenHeight)];
//    blackView.backgroundColor = [UIColor colorWithRed:0 green:0 blue:0 alpha:0.2];
//    blackView.userInteractionEnabled = YES;
//    
//    clinicPickerView = [[UIPickerView alloc]initWithFrame:CGRectMake(0, self.contentView.frame.size.height/2-100, kScreenWidth, 200)];
//    clinicPickerView.backgroundColor = [UIColor whiteColor];
//    clinicPickerView.showsSelectionIndicator=YES;
//    clinicPickerView.dataSource = self;
//    clinicPickerView.delegate = self;
//    [blackView addSubview:clinicPickerView];
//    
//    
//    [contentScrollView addSubview:blackView];
//    contentScrollView.scrollEnabled = NO;
//    clinicPickerViewIsShowing = YES;
//    
//}
//
//#pragma mark - 时间段按钮点击实现
//
//- (void)addTimeSegAction:(TimeSegButton *)button{
//    [button removeTarget:self action:@selector(changeTimeSegButtonState:) forControlEvents:UIControlEventTouchUpInside];
//    if( button.timeState != 0){
//        [self changeTimeSegButtonImage:button];
//        [button addTarget:self action:@selector(changeTimeSegButtonState:) forControlEvents:UIControlEventTouchUpInside];
//    }
//}
//
//- (void)changeTimeSegButtonState:(id)sender{
//    TimeSegButton *temp = (TimeSegButton *)sender;
//    
//    switch ([temp.timeState integerValue]) {
//        case 1:
//        {
//            temp.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"time_segment_small_left_Normal"]];
//            temp.timeState = [NSNumber numberWithInteger:2];
//        }
//            break;
//        case 2:
//        {
//            temp.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"time_segment_small_left_HighLight"]];
//            temp.timeState = [NSNumber numberWithInteger:1];
//        }
//            break;
//        default:
//            break;
//    }
//    [self changeTimeSegButtonImage:sender];
//}
//
//- (void)changeTimeSegButtonImage:(TimeSegButton *)button{
//    //    NSLog(@"%@",button);
//    if (button.tag==0||button.tag==6) {
//        if ([button.timeState intValue] == 0) {
//            button.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"time_segment_small_left_Forbidden"]];
//        }
//        if ([button.timeState intValue] == 1) {
//            button.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"time_segment_small_left_Normal"]];
//        }
//        if ([button.timeState intValue] == 2) {
//            button.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"time_segment_small_left_HighLight"]];
//        }
//    }//前两行的第一个左侧按钮
//    
//    if ((button.tag>0&&button.tag<5)||(button.tag>6&&button.tag<11)) {
//        if ([button.timeState intValue] == 0) {
//            button.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"time_segment_small_mid_Forbidden"]];
//        }
//        if ([button.timeState intValue] == 1) {
//            button.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"time_segment_small_mid_Normal"]];
//        }
//        if ([button.timeState intValue] == 2) {
//            button.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"time_segment_small_mid_HighLight"]];
//        }
//    }//前两行的中间的按钮
//    
//    if ( button.tag == 5 || button.tag == 11) {
//        if ([button.timeState intValue] == 0) {
//            button.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"time_segment_small_right_Forbidden"]];
//        }
//        if ([button.timeState intValue] == 1) {
//            button.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"time_segment_small_right_Normal"]];
//        }
//        if ([button.timeState intValue] == 2) {
//            button.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"time_segment_small_right_HighLight"]];
//        }
//    }//前两行的右侧按钮
//    
//    if (button.tag == 12) {
//        if ([button.timeState intValue] == 0) {
//            button.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"time_segment_big_left_Forbidden"]];
//        }
//        if ([button.timeState intValue] == 1) {
//            button.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"time_segment_big_left_Normal"]];
//        }
//        if ([button.timeState intValue] == 2) {
//            button.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"time_segment_big_left_HighLight"]];
//        }
//    }//3行1个
//    if (button.tag == 13) {
//        if ([button.timeState intValue] == 0) {
//            button.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"time_segment_big_mid_Forbidden"]];
//        }
//        if ([button.timeState intValue] == 1) {
//            button.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"time_segment_big_mid_Normal"]];
//        }
//        if ([button.timeState intValue] == 2) {
//            button.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"time_segment_big_mid_HighLight"]];
//        }
//    }//3行2个
//    if (button.tag == 14) {
//        if ([button.timeState intValue] == 0) {
//            button.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"time_segment_big_right_Forbidden"]];
//        }
//        if ([button.timeState intValue] == 1) {
//            button.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"time_segment_big_right_Normal"]];
//        }
//        if ([button.timeState intValue] == 2) {
//            button.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"time_segment_big_right_HighLight"]];
//        }
//    }//3行第三个
//    
//}
//
//#pragma mark - 隐藏第四行Lable，显示TextField
//
//-(void)ShowaddressTextField{
//    [addressTextField becomeFirstResponder];
//}
//
//-(void)HideTextField{
//    [addressTextField endEditing:YES];
//    [numberOfOfferTextField endEditing:YES];
//    [billTextField endEditing:YES];
//    [detailsTextView endEditing:YES];
//    
//    if ((self.contentView.frame.size.height + contentScrollView.contentOffset.y) > contentScrollView.contentSize.height ) {
//        
//        [contentScrollView setContentOffset:CGPointMake(0, tempContentScrollViewY) animated:YES];
//    }
//}
//
//
//- (void)ShowNumberOfOfferTextField{
//    [numberOfOfferTextField becomeFirstResponder];
//}
//
//- (void)ShowBillTextField{
//    [billTextField becomeFirstResponder];
//}
//
//- (void)ShowdetailsTextView{
//    [detailsTextView becomeFirstResponder];
//}
//
//- (void)setButtonImage{
//    if (instantOrNot == YES) {
//        instantOrNotButton.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"InstantOrNot_YES"]];
//    }
//    if (instantOrNot == NO) {
//        instantOrNotButton.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"InstantOrNot_NO"]];
//    }
//}
//
//- (void)changeButtonImage{
//    instantOrNot = !instantOrNot;
//    [self setButtonImage];
//}
//#pragma mark - PickerView代理方法
//
//// pickerView 列数
//- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView {
//    if (pickerView == clinicPickerView) {
//        return 1;
//    }
//    return 1;
//}
//
//// pickerView 每列个数
//- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component {
//    if (pickerView == clinicPickerView) {
//        return [clinicList count];
//    }
//    
//    return 0;
//}
//
//// 每列宽度
//- (CGFloat)pickerView:(UIPickerView *)pickerView widthForComponent:(NSInteger)component {
//    
//    if (pickerView == clinicPickerView) {
//        return 200;
//    }
//    return 180;
//}
//// 返回选中的行
//- (void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component
//{
//    if (pickerView == clinicPickerView) {
//        Clinic *temp = (Clinic *)[clinicList objectAtIndex:row];
//        clinicLable.text = temp.name;
//        currentClinic = temp;
//    }
//}
//
////返回当前行的内容,此处是将数组中数值添加到滚动的那个显示栏上
//-(NSString*)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component
//{
//    if (pickerView == clinicPickerView) {
//        Clinic *temp = (Clinic *)[clinicList objectAtIndex:row];
//        return temp.name;
//    }
//    Clinic *temp = (Clinic *)[clinicList objectAtIndex:row];
//    return temp.name;
//}
//
//- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string{
//    
//    
//    if(textField == numberOfOfferTextField){
//        if (range.location>= 5){
//            return NO;}
//    }
//    if(textField == billTextField){
//        if (range.location>= 5){
//            return NO;}
//    }
//    
//    return YES;
//    
//}
//
//- (BOOL)textFieldShouldReturn:(UITextField *)textField{
//    [self HideTextField];
//    return YES;
//}
//
//- (BOOL)textFieldShouldBeginEditing:(UITextField *)textField{
//    tempContentScrollViewY = contentScrollView.contentOffset.y;
//    if (self.contentView.frame.size.height - [textField superview].frame.origin.y > 253){
//        return  YES;
//    }
//    
//    [contentScrollView setContentOffset:CGPointMake(0,([textField superview].frame.origin.y - (self.contentView.frame.size.height - 253 -[textField superview].frame.size.height) )) animated:YES];
//    return YES;
//}
//
//- (BOOL)textViewShouldBeginEditing:(UITextField *)textView{
//    tempContentScrollViewY = contentScrollView.contentOffset.y;
//    if ((self.contentView.frame.size.height - [textView superview].frame.origin.y - textView.frame.size.height)> 253){
//        
//        return  YES;
//    }
//    //    CGFloat abc = self.contentView.frame.size.height - textView.frame.origin.y - textView.frame.size.height;
//    //    NSLog(@"%f",abc);
//    //
//    //    NSLog(@"%f",self.contentView.frame.size.height);
//    //    NSLog(@"%f",[textView superview].frame.origin.y );
//    //    NSLog(@"%f",textView.frame.size.height);
//    
//    [contentScrollView setContentOffset:CGPointMake(0,([textView superview].frame.origin.y - (self.contentView.frame.size.height - 253 -[textView superview].frame.size.height) )) animated:YES];
//    return YES;
//}
//
//- (void)initContentScrollView{
//    contentScrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, self.contentView.frame.size.height)];
//    contentScrollView.contentSize = CGSizeMake(kScreenWidth, 720);
//    contentScrollView.backgroundColor = UIColorFromHex(Color_Hex_ImageDefault);
//    [self.contentView addSubview:contentScrollView];
//    
//    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(endEdit)];
//    [contentScrollView addGestureRecognizer:tap];
//}
//
//- (void)endEdit{
//    [self HideTextField];
//    NSLog(@"检测到点击屏幕收回PickerView");
//    if (dayTimePickerViewIsShowing == YES) {
//        [dayTimePickerView removeFromSuperview];
//        [blackView removeFromSuperview];
//        dayTimePickerViewData = [dayTimePickerView date];
//        NSString *preDayTimePickerViewTimeString = [NSString stringWithFormat:@"%@",[NSDate dateWithTimeInterval:3600*8 sinceDate:[dayTimePickerView date]]];
//        timeLable.text = [preDayTimePickerViewTimeString substringToIndex:10];
//        timeLable.textColor = UIColorFromHex(Color_Hex_Text_Normal);
//        contentScrollView.scrollEnabled = YES;
//        dayTimePickerViewIsShowing = NO;
//        
//        [dayTimePickerViewData dateAtStartOfDay];
//        
//        _data.timestamp = [[dayTimePickerViewData dateAtStartOfDay] timeIntervalSince1970];
//        
//        [[TreatmentOrderManager sharedInstance] FangHaoForGetClinicWithTiemstamp:_data.timestamp resultBlock:^(SNHTTPRequestOperation *request, SNServerAPIResultData *result) {
//            if (!result.hasError) {
//                NSMutableArray *clinicarray = result.parsedModelObject;
//                
//                clinicList = [NSMutableArray new];
//                for (int i = 0; i < clinicarray.count; i++) {
//                    Clinic *clinic = (Clinic *)[clinicarray objectAtIndex:i];
//                    [clinicList addObjectSafely:clinic];
//                }
//                [clinicPickerView reloadAllComponents];
//                NSLog(@"刷新诊疗点信息");
//                clinicLabletap.numberOfTapsRequired = 1;
//                Clinic *temp = (Clinic *)[clinicList objectAtIndex:0];
//                currentClinic = temp;
//                [clinicLable setText:temp.name];
//            }
//        } pageName:@"OfferOrderViewController"];
//        
//        
//        NSLog(@"仅收回日期pickerView,%d",_data.timestamp);
//    }
//    if (clinicPickerViewIsShowing == YES) {
//        [clinicPickerView removeFromSuperview];
//        [blackView removeFromSuperview];
//        contentScrollView.scrollEnabled = YES;
//        clinicPickerViewIsShowing = NO;
//        NSLog(@"仅收回第二行诊疗点选择pickerView");
//    }
//}
//
//
//- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary<NSString *,id> *)change context:(void *)context {
//    NSLog(@"调用KVO更改TimeSeg");
//    if ([keyPath isEqualToString:@"text"]) {
//        [self reloadTimeSeg];
//    }
//}
//
//- (void)reloadTimeSeg{
//    NSInteger clinicID = 0;
//    for (int i = 0; i < clinicList.count; i++) {
//        Clinic *temp = (Clinic *)[clinicList objectAtIndex:i];
//        if ([clinicLable.text isEqualToString:temp.name]) {
//            clinicID = temp.ID;
//        }
//    }
//    
//    [[TreatmentOrderManager sharedInstance] FangHaoForGetTimeSegWithTiemstamp:_data.timestamp clinicID:clinicID resultBlock:^(SNHTTPRequestOperation *request, SNServerAPIResultData *result) {
//        if (clinicID == currentClinic.ID) {
//            currentClinic.timeSeg = result.parsedModelObject;
//            
//            
//            if (timeSegMark == NO) {
//                for (int i = 0; i < 15; i++) {
//                    TimeSegButton *temp = (TimeSegButton *)[time_segButtonArray objectAtIndex:i];
//                    temp.timeState = [NSNumber numberWithInteger:1];
//                    [self addTimeSegAction:temp];
//                }
//                timeSegMark = YES;
//            } // 如果是第一次打开， 则把所有seg刷新为可点击
//            
//            for (int i = 0; i < 15; i++) {
//                int j = 1;
//                TimeSegButton *temp = (TimeSegButton *)[time_segButtonArray objectAtIndex:i];
//                
//                for(int k = 0 ; k < currentClinic.timeSeg.count ; k++){
//                    NSInteger tempint = [[currentClinic.timeSeg objectAtIndex:k] integerValue];
//                    if ( i == tempint){
//                        j = 0;
//                        break;
//                    }
//                } //寻找不可点击的seg
//                
//                if (j == 0) {
//                    temp.timeState = [NSNumber numberWithInteger:j];
//                }
//                NSLog(@"第 %d 个按钮 状态是%@",i,temp.timeState);
//                [self addTimeSegAction:temp];
//            }
//        }
//        NSLog(@"更改TimeSeg");
//        
//        if(isEditOrder == YES){
//            [self reloadTimeSegForSeleted];
//        }
//    } pageName:@"OfferOrderViewController"];
//}
//
//- (void)reloadTimeSegForSeleted{
//    NSArray *listItems = [_data.time_seg componentsSeparatedByString:@","];
//    NSMutableArray *array = [NSMutableArray new];
//    for (int i = 0; i < listItems.count; i++) {
//        NSInteger  temp = [[listItems objectAtIndex:i] integerValue];
//        temp -= 8;
//        if (temp >= 0 && temp < 12) {
//            temp = temp;
//        }
//        if (temp >= 12 && temp < 16) {
//            temp = 12;
//        }
//        if (temp >= 16 && temp < 20) {
//            temp = 13;
//        }
//        if (temp >= 20 && temp < 24) {
//            temp = 14;
//        }
//
//        [array addObject:@(temp)];
//    }
//    listItems = [[NSSet setWithArray:array] allObjects];
//    for (int i = 0; i < 15; i++) {
//        int j = 1;
//        TimeSegButton *temp = (TimeSegButton *)[time_segButtonArray objectAtIndex:i];
//        
//        for(int k = 0 ; k < listItems.count ; k++){
//            NSInteger tempint = [[listItems objectAtIndex:k] integerValue];
//            if ( i == tempint){
//                j = 2;
//                break;
//            }
//        } //寻找不可点击的seg
//        
//        if (j == 2) {
//            temp.timeState = [NSNumber numberWithInteger:j];
//        }
//        NSLog(@"第 %d 个按钮 状态是%@",i,temp.timeState);
//        [self addTimeSegAction:temp];
//    }
//
//}
//
//- (void)submitOrderData{
//    NSLog(@"点击提交按钮， 开始检查数据完整性");
//    NSString *timeseg = [NSString stringWithFormat:@""];
//    for (int i = 0; i < time_segButtonArray.count; i++) {
//        TimeSegButton *temp = (TimeSegButton *)[time_segButtonArray objectAtIndex:i];
//        if ([temp.timeState integerValue] == 2) {
////            if (i < 12){
////                timeseg = [timeseg stringByAppendingFormat:@",%d",i];
////            }
////            if (i == 12) {
////                timeseg = [timeseg stringByAppendingFormat:@",12,13,14,15"];
////            }
////            if (i == 13) {
////                timeseg = [timeseg stringByAppendingFormat:@",16,17,18,19"];
////            }
////            if (i == 14) {
////                timeseg = [timeseg stringByAppendingFormat:@",20,21,22,23"];
////            }
//            if (i < 12){
//                timeseg = [timeseg stringByAppendingFormat:@",%d",i+8];
//            }
//            if (i == 12) {
//                timeseg = [timeseg stringByAppendingFormat:@",20,21,22,23"];
//            }
//            if (i == 13) {
//                timeseg = [timeseg stringByAppendingFormat:@",24,25,26,27"];
//            }
//            if (i == 14) {
//                timeseg = [timeseg stringByAppendingFormat:@",28,29,30,31"];
//            }
//            
//        }
//    }
//    
//    if (timeseg.length == 0) {
//        UIAlertView *alert = [[UIAlertView alloc]initWithTitle:nil message:@"请选择您要赴诊的时间段" delegate:nil cancelButtonTitle:nil otherButtonTitles:@"确定", nil];
//        [alert show];
//    }
//    else{
//        timeseg = [timeseg substringFromIndex:1];
//        
//        if ([numberOfOfferTextField.text isEqualToString:@""]) {
//            UIAlertView *alert = [[UIAlertView alloc]initWithTitle:nil message:@"请输入您将会放号的数量" delegate:nil cancelButtonTitle:nil otherButtonTitles:@"确定", nil];
//            [alert show];
//        }
//        else{
//            if ([billTextField.text isEqualToString:@""]) {
//                UIAlertView *alert = [[UIAlertView alloc]initWithTitle:nil message:@"请输入您的诊金" delegate:nil cancelButtonTitle:nil otherButtonTitles:@"确定", nil];
//                [alert show];
//            }
//            else{
//                if (detailsTextView.text.length <6) {
//                    if(detailsTextView.text.length == 0){
//                        UIAlertView *alert = [[UIAlertView alloc]initWithTitle:nil message:@"请输入约诊内容" delegate:nil cancelButtonTitle:nil otherButtonTitles:@"确定", nil];
//                        [alert show];
//                    }
//                    else{
//                        UIAlertView *alert = [[UIAlertView alloc]initWithTitle:nil message:@"您输入的约诊内容过少，请重新输入" delegate:nil cancelButtonTitle:nil otherButtonTitles:@"确定", nil];
//                        [alert show];
//                    }
//                    
//                }
//                else{
//                    [self showProgressView];
//                    if (isEditOrder){
//                        [[TreatmentOrderManager sharedInstance]FangHaoForSecondTimeWithTiemstamp:_data.timestamp
//                                                                                      clinic_id:currentClinic.ID
//                                                                                       time_seg:timeseg
//                                                                                  IsImmediately:1
//                                                                                            num:[numberOfOfferTextField.text integerValue]
//                                                                                            fee:[billTextField.text integerValue]
//                                                                               DiagnosisSubject:detailsTextView.text
//                                                                                         modify:isEditOrder
//                                                                                         orderNo:_data.orderno
//                                                                                    resultBlock:^(SNHTTPRequestOperation *request, SNServerAPIResultData *result)
//                         {
//                             [self hideProgressView];
//                             [self.slideNavigationController popViewControllerAnimated:YES];
//                             
//                         } pageName:@"OfferOrderViewController"];
//                    }
//                    else{
//                        [[TreatmentOrderManager sharedInstance]FangHaoForFirstTimeWithTiemstamp:_data.timestamp
//                                                                                      clinic_id:currentClinic.ID
//                                                                                       time_seg:timeseg
//                                                                                  IsImmediately:1
//                                                                                            num:[numberOfOfferTextField.text integerValue]
//                                                                                            fee:[billTextField.text integerValue]
//                                                                               DiagnosisSubject:detailsTextView.text
//                                                                                         modify:isEditOrder
//                                                                                    resultBlock:^(SNHTTPRequestOperation *request, SNServerAPIResultData *result)
//                         {
//                             [self hideProgressView];
//                             [self.slideNavigationController popViewControllerAnimated:YES];
//                             
//                         } pageName:@"OfferOrderViewController"];
//                    }
//                    
//                }
//            }
//        }
//    }
//    
//    
//    
//}
//
//- (void)didReceiveMemoryWarning {
//    [super didReceiveMemoryWarning];
//    // Dispose of any resources that can be recreated.
//}
//
//
//- (void)dealloc{
//    [clinicLable removeObserver:self forKeyPath:@"text"];
//}
//
//@end
