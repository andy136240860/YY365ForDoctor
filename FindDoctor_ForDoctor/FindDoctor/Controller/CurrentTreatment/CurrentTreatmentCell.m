//
//  PrescriptionConfirmCell.m
//  
//
//  Created by Guo on 15/10/7.
//
//

#import "CurrentTreatmentCell.h"
#import "UIImageView+WebCache.h"

@interface CurrentTreatmentCell()
{
    UILabel *label1;
    UILabel *label2;
    UILabel *label3;
    UILabel *label4;
    UILabel *label5;
    UIImageView *_stateImageView;
}
@end


@implementation CurrentTreatmentCell

+ (CGFloat)defaultHeight
{
    return 150;
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
    int leftpadding = 20;
    int intervalY = 12;
    
    self.backgroundColor = UIColorFromHex(Color_Hex_ImageDefault);
    UIView *baseView = [[UIView alloc]initWithFrame:CGRectMake(KTableViewCellLeftDistence, 7.5, kScreenWidth-KTableViewCellLeftDistence*2,155 - 15)];
    baseView.backgroundColor = [UIColor whiteColor];
    baseView.layer.borderWidth = 0.5;
    baseView.layer.borderColor = [UIColorFromHex(0xCCCCCC)CGColor];
    [self.contentView addSubview:baseView];
    
//    _headerImageView = [[UIImageView alloc]initWithFrame:CGRectMake(17, 17, 78, 78)];
//    _headerImageView.contentMode = 1;
//    _headerImageView.layer.cornerRadius = _headerImageView.frame.size.width / 2;
//    _headerImageView.clipsToBounds = YES;
//    [baseView addSubview:_headerImageView];
//    
//    _VIPiconImageView = [[UIImageView alloc]initWithFrame:CGRectMake(75, 16, 26, 26)];
//    _VIPiconImageView.contentMode = 1;
//    [baseView addSubview:_VIPiconImageView];
//    
//    _userNickNameLable = [[UILabel alloc]initWithFrame:CGRectMake(15, 110, 78, 14)];
//    _userNickNameLable.textAlignment = NSTextAlignmentCenter;
//    _userNickNameLable.font = [UIFont systemFontOfSize:14.0];
//    [baseView addSubview:_userNickNameLable];
    
    label1 = [[UILabel alloc]initWithFrame:CGRectMake(leftpadding, 15, baseView.frameWidth - leftpadding*2, 12)];
    label1.font = [UIFont systemFontOfSize:12];
    [baseView addSubview:label1];
    
    label2 = [[UILabel alloc]initWithFrame:CGRectMake(leftpadding, CGRectGetMaxY(label1.frame)+intervalY, baseView.frameWidth - leftpadding*2, 12)];
    label2.font = [UIFont systemFontOfSize:12];
    [baseView addSubview:label2];
    
    label3 = [[UILabel alloc]initWithFrame:CGRectMake(leftpadding, CGRectGetMaxY(label2.frame)+intervalY, baseView.frameWidth - leftpadding*2, 12)];
    label3.font = [UIFont systemFontOfSize:12];
    [baseView addSubview:label3];
    
    label4 = [[UILabel alloc]initWithFrame:CGRectMake(leftpadding, CGRectGetMaxY(label3.frame)+intervalY, baseView.frameWidth - leftpadding*2, 12)];
    label4.font = [UIFont systemFontOfSize:12];
    [baseView addSubview:label4];
    
    label5 = [[UILabel alloc]initWithFrame:CGRectMake(leftpadding, CGRectGetMaxY(label4.frame)+intervalY, baseView.frameWidth - leftpadding*2, 12)];
    label5.font = [UIFont systemFontOfSize:12];
    [baseView addSubview:label5];
    
    
    _stateImageView = [[UIImageView alloc]initWithFrame:CGRectMake(baseView.frameWidth - 65, 0, 65, 65)];
    _stateImageView.contentMode = 1;
    [baseView addSubview:_stateImageView];
    
}

- (void)setData:(Patient *)data
{
    _data = data;
    
    label1.text = [NSString stringWithFormat:@"单   号: %@",_data.diagnosisID];
    
    label2.text = [NSString stringWithFormat:@"约诊号: 第 %ld 号",(long)_data.orderNo];
    
    label3.text = [NSString stringWithFormat:@"患者: %@ , %@ , %ld岁",_data.UserName,(_data.UserSex == 0 ? @"女":@"男"),(long)_data.UserAge];
    
    label4.text = [NSString stringWithFormat:@"地点: %@",_data.clinicAddress];
    
    label5.text = [NSString stringWithFormat:@"病症: %@",_data.illnessDescription];
    
    switch (_data.state) {
        case 1:// 下单未支付
        {
            _stateImageView.image = [UIImage imageNamed:@"pay_no"];
        }break;
        case 2://下单已支付， 这里因为在诊疗列表，所以显示为未完成
        {
//            _stateImageView.image = [UIImage imageNamed:@"pay_yes"];
            _stateImageView.image = [UIImage imageNamed:@"icon_unfinish"];
        }break;
        case 3://开方未提交
        {
            _stateImageView.image = [UIImage imageNamed:@"icon_unfinish"];
        }break;
        case 4:{//开方已完成
            _stateImageView.image = [UIImage imageNamed:@"icon_finish"];
        }break;
        case 5:{//开方已完成
            _stateImageView.image = [UIImage imageNamed:@"icon_finish"];
        }break;
        default:

            break;
    }
    
    [self setNeedsDisplay];
}


- (void)awakeFromNib {
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
    
    // Configure the view for the selected state
}

@end
