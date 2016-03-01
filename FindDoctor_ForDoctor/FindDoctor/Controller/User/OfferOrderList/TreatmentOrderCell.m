//
//  YueZhenRecordTableViewCell.m
//  
//
//  Created by Guo on 15/10/6.
//
//



#import "TreatmentOrderCell.h"
#import "UIImageView+WebCache.h"
#import "NSDate+SNExtension.h"
#import "TreatmentOrderManager.h"

#define kTreatmentOrderCellHeight 155.0

#define interValY 22
#define leftPadding 9
#define topPadding 6




@interface TreatmentOrderCell()
{
    UIView *baseView;
    
    UILabel *_timeLable;
    UILabel *_clinicNameLable;
    UILabel *_clinicAddressLable;
    UILabel *_feeLable;
    UILabel *_numLable;
    UILabel *_subjectLable;

    UILabel *_queueTimeLable;
    
    UIButton *editButton;
    UIButton *deleteButton;

}

@end

@implementation TreatmentOrderCell

+ (CGFloat)defaultHeight
{
    return kTreatmentOrderCellHeight;
}


- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        [self createSubViews];
    }
    return self;
}

- (void)createSubViews{
    
    self.backgroundColor = UIColorFromHex(Color_Hex_ImageDefault);
    baseView = [[UIView alloc]init];
    baseView.backgroundColor = [UIColor whiteColor];
    baseView.layer.borderWidth = 0.5;
    baseView.layer.borderColor = [UIColorFromHex(0xCCCCCC)CGColor];
    [self.contentView addSubview:baseView];
    
    UIImageView *headerImageView = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, ksubViewWeith, 30)];
    headerImageView.image = [UIImage imageNamed:@"wave_line"];
    headerImageView.contentMode = 0;
    [baseView addSubview:headerImageView];
    
    _timeLable = [[UILabel alloc]initWithFrame:CGRectMake(leftPadding,topPadding,baseView.frame.size.width - 2*leftPadding , 14)];
    _timeLable.textAlignment = NSTextAlignmentLeft;
    _timeLable.font = [UIFont systemFontOfSize:14.0];
    _timeLable.textColor = [UIColor whiteColor];
    [baseView addSubview:_timeLable];
    
    _clinicNameLable = [[UILabel alloc]init];
    _clinicNameLable.font = [UIFont systemFontOfSize:12];
    _clinicNameLable.numberOfLines = 0;
    [baseView addSubview:_clinicNameLable];
    
    _clinicAddressLable = [[UILabel alloc]init];
    _clinicAddressLable.font = [UIFont systemFontOfSize:12];
    _clinicAddressLable.numberOfLines = 0;
    [baseView addSubview:_clinicAddressLable];
    
    _feeLable = [[UILabel alloc]init];
    _feeLable.font = [UIFont systemFontOfSize:12];
    [baseView addSubview:_feeLable];
    
    _numLable = [[UILabel alloc]init];
    _numLable.font = [UIFont systemFontOfSize:12];
    _numLable.numberOfLines = 0;
    [baseView addSubview:_numLable];
    
    _subjectLable = [[UILabel alloc]initWithFrame:CGRectMake(120, 15+23*2, baseView.frameWidth-120, 12)];
    _subjectLable.font = [UIFont systemFontOfSize:12];
    _subjectLable.numberOfLines = 0;
//    [baseView addSubview:_subjectLable];
    
    _queueTimeLable = [[UILabel alloc]initWithFrame:CGRectMake(120, 15+23*3, baseView.frameWidth-120, 12)];
    _queueTimeLable.font = [UIFont systemFontOfSize:12];
    [baseView addSubview:_queueTimeLable];
    
    editButton = [[UIButton alloc]init];
    [baseView addSubview:editButton];
    
    deleteButton = [[UIButton alloc]init];
    [baseView addSubview:deleteButton];


}

- (void)setData:(TreatmentOrder *)data
{
    _data = data;
    
    NSMutableParagraphStyle *paragraph = [NSMutableParagraphStyle new];
    paragraph.lineBreakMode = NSLineBreakByWordWrapping;
    paragraph.lineSpacing = 3;

    CGSize size;
    
    _timeLable.frame = CGRectMake(kleftPadding,topPadding,ksubTextWeith , 14);
    _timeLable.text = [NSString stringWithFormat:@"%@ %@-%@",
                       [[NSDate dateWithTimeIntervalSince1970:_data.timestamp] stringWithDateFormat:@"日期: yyyy-MM-dd"],
                       [[NSDate dateWithTimeIntervalSince1970:_data.startTime] stringWithDateFormat:@"HH:mm"],
                       [[NSDate dateWithTimeIntervalSince1970:_data.endTime] stringWithDateFormat:@"HH:mm"]
                       ];
    
    _clinicNameLable.text = [NSString stringWithFormat:@"诊疗点：%@",_data.clinic.name];
    size = [self sizeWithString:_clinicNameLable.text font:_clinicNameLable.font lableWith:ksubTextWeith  NSParagraphStyleAttributeName:paragraph];
    _clinicNameLable.frame = CGRectMake(kleftPadding, CGRectGetMaxY(_timeLable.frame) + 2*topPadding, size.width, size.height);
    
    _clinicAddressLable.text = [NSString stringWithFormat:@"地   址：%@",_data.clinic.address];
    [self setNeedsDisplay];
    size = [self sizeWithString:_clinicAddressLable.text font:_clinicAddressLable.font lableWith:ksubTextWeith NSParagraphStyleAttributeName:paragraph];
    _clinicAddressLable.frame = CGRectMake(leftPadding, CGRectGetMaxY(_clinicNameLable.frame), size.width, size.height);
    
    _feeLable.text = [NSString stringWithFormat:@"费   用：%.2lf",(_data.fee)/100.f];

    size = [self sizeWithString:_feeLable.text font:_feeLable.font lableWith:ksubTextWeith NSParagraphStyleAttributeName:paragraph];
    _feeLable.frame = CGRectMake(leftPadding, CGRectGetMaxY(_clinicAddressLable.frame), size.width, size.height);
    
    _numLable.text = [NSString stringWithFormat:@"放号数量：%d",_data.num];
    size = [self sizeWithString:_numLable.text font:_numLable.font lableWith:ksubTextWeith NSParagraphStyleAttributeName:paragraph];
    _numLable.frame = CGRectMake(leftPadding, CGRectGetMaxY(_feeLable.frame), size.width, size.height);
    
    _subjectLable.text = [NSString stringWithFormat:@"约诊内容：%@",_data.subject];
    size = [self sizeWithString:_subjectLable.text font:_subjectLable.font lableWith:ksubTextWeith NSParagraphStyleAttributeName:paragraph];
    _subjectLable.frame = CGRectMake(leftPadding, CGRectGetMaxY(_numLable.frame), size.width, size.height);
    

    
    baseView.frame = CGRectMake(KTableViewCellLeftDistence, kHalfTableViewCellInteralY, ksubViewWeith,CGRectGetMaxY(_numLable.frame)+topPadding+35);
    
    deleteButton.frame = CGRectMake(([baseView frameWidth] - 4*leftPadding)/2 + 3*leftPadding, [baseView frameHeight] - 35, ([baseView frameWidth] - 4*leftPadding)/2, 25);
    deleteButton.layer.cornerRadius = 3;
    [deleteButton setTitle:@"删      除" forState:UIControlStateNormal];
    deleteButton.titleLabel.font = [UIFont systemFontOfSize:12];
    
    editButton.frame = CGRectMake(leftPadding, [baseView frameHeight] - 35, ([baseView frameWidth] - 4*leftPadding)/2, 25);
    [editButton setTitle:@"修      改" forState:UIControlStateNormal];
    editButton.titleLabel.font = [UIFont systemFontOfSize:12];
    editButton.layer.cornerRadius = 3;
    

    if (_data.editState == 0) {
        [deleteButton setTitleColor:[UIColor redColor] forState:UIControlStateNormal];
        deleteButton.layer.backgroundColor = [UIColor whiteColor].CGColor;
        deleteButton.layer.borderWidth = 1;
        deleteButton.layer.borderColor = deleteButton.titleLabel.textColor.CGColor;
        [deleteButton addTarget:self action:@selector(deleteOrder:) forControlEvents:UIControlEventTouchUpInside];
        
        [editButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        editButton.layer.backgroundColor = UIColorFromHex(Color_Hex_NavBackground).CGColor;
        [editButton addTarget:self action:@selector(editOrder) forControlEvents:UIControlEventTouchUpInside];
    }
    else{
        [deleteButton setTitleColor:UIColorFromHex(Color_Hex_ImageDefault) forState:UIControlStateNormal];
        deleteButton.layer.backgroundColor = UIColorFromHex(Color_Hex_ImageDefault).CGColor;
        deleteButton.layer.borderWidth = 1;
        deleteButton.layer.borderColor = deleteButton.titleLabel.textColor.CGColor;
        
        [editButton setTitleColor:UIColorFromHex(Color_Hex_ImageDefault) forState:UIControlStateNormal];
        editButton.layer.backgroundColor = UIColorFromHex(Color_Hex_ImageDefault).CGColor;
    }
    
    [self setNeedsDisplay];
}

- (void)deleteOrder:(id)sender{
    UIAlertView *alert = [[UIAlertView alloc]initWithTitle:nil message:@"删除此放号不可恢复\n确认删除？" delegate:nil cancelButtonTitle:@"取消" otherButtonTitles:@"确认删除", nil];
    alert.delegate = self;
    [alert show];
}

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex{
    if (buttonIndex == 0) {
    }
    else{
        NSLog(@"准备删除单号为 %lld 的放号单",_data.orderno);
        [[TreatmentOrderManager sharedInstance] deleteOrderWithOrderNumber:_data.orderno resultBlock:^(SNHTTPRequestOperation *request, SNServerAPIResultData *result) {
            NSLog(@"已经删除单号为 %lld 的放号单",_data.orderno);
            _refreshDataBlock();
        } pageName:@"TreatmentOrderCell"];
    }
}

- (void)editOrder{
    NSLog(@"进入单号为 %lld 的放号单详情准备修改",_data.orderno);
//    [[TreatmentOrderManager sharedInstance] editOrderWithOrderNumber:_data.orderno resultBlock:^(SNHTTPRequestOperation *request, SNServerAPIResultData *result) {
//        NSLog(@"已经获取单号为 %lld 的放号单信息",_data.orderno);
//        TreatmentOrder *editData = result.parsedModelObject;
//        editData.subject = _data.subject;
//        _editOrderBlock(editData);
//    } pageName:@"TreatmentOrderCell"];
    _editOrderBlock(_data);
}


- (void)awakeFromNib {
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (CGSize)sizeWithString:(NSString *)string font:(UIFont *)font lableWith:(CGFloat)lableWith NSParagraphStyleAttributeName:(NSMutableParagraphStyle *)paragraph{
    CGRect rect = [string boundingRectWithSize:CGSizeMake(lableWith, 8000)//限制最大的宽度和高度
                                       options:NSStringDrawingTruncatesLastVisibleLine | NSStringDrawingUsesFontLeading  |NSStringDrawingUsesLineFragmentOrigin//采用换行模式
                                    attributes:@{NSFontAttributeName: font, NSParagraphStyleAttributeName:paragraph}//传人的字体字典
                                       context:nil];
    
    return rect.size;
}

@end
