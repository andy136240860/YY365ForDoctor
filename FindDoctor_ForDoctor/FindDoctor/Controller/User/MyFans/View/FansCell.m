//
//  FansCell.m
//  
//
//  Created by Guo on 15/10/5.
//
//

#import "FansCell.h"

@interface FansCell ()
{
    UIImageView *_headerView;
    UILabel *_nameLabel;
    UILabel *_dateLabel;
    UIImageView *VIPiconView;
    BOOL _isVIP;
}
@end

@implementation FansCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        [self createSubViews];
    }
    return self;
}

- (void)createSubViews
{
    _headerView = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"doctor_head"]];
    _headerView.frame = CGRectMake(20,15,44,44);
    _headerView.layer.cornerRadius = 22;
    _headerView.clipsToBounds = YES;
    [self.contentView addSubview:_headerView];
    
    //创建信息区域
    _nameLabel = [[UILabel alloc]initWithFrame:CGRectMake(80, 5+17, kScreenWidth-130, 14)];
    _nameLabel.font = [UIFont systemFontOfSize:14];
    _nameLabel.textColor = UIColorFromHex(0x030303);
    
    _dateLabel = [[UILabel alloc]initWithFrame:CGRectMake(80, 25+17, kScreenWidth-130, 14)];
    _dateLabel.textColor =  UIColorFromHex(0xbbbbbb);
    _dateLabel.font = [UIFont systemFontOfSize:11];
    _dateLabel.textColor = UIColorFromHex(0x454545);
    

    VIPiconView = [[UIImageView alloc]init];
    VIPiconView.frame = CGRectMake(kScreenWidth-24-20, (74-24)*0.5, 24, 24);
    VIPiconView.contentMode = 1;
    [self.contentView addSubview:VIPiconView];


    [self.contentView addSubview:_nameLabel];
    [self.contentView addSubview:_dateLabel];
}

- (void)setData:(Fans *)data
{
    _data = data;
    _nameLabel.text = _data.name;
    _dateLabel.text = _data.availableTime;
    if (_data.isVIP == YES) {
        VIPiconView.image =[UIImage imageNamed:@"VIPicon"];
    }
    if (_data.isVIP == NO) {
        VIPiconView.image =nil;
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
