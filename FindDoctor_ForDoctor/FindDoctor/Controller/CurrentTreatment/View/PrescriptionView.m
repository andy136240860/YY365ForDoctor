//
//  PrescriptionView.m
//  FindDoctor
//
//  Created by 晓炜 郭 on 15/12/20.
//  Copyright © 2015年 li na. All rights reserved.
//

#import "PrescriptionView.h"
#import "CURecipeController.h"
#import "CUHerbSelect.h"

int topPadding = 15;
int leftPadding = 15;
int ButtonHeight = 30;

@interface PrescriptionView(){
    UIView *codeBaseView;
    UILabel *codeLabel;

    BingZhengImageView *imageView;
    
    CURecipeController *recipeController;
}

@end

@implementation PrescriptionView

- (instancetype)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = [UIColor whiteColor];
        [self initSubView];
    }
    return self;
}

- (void)initSubView{
    _codeButton = [[UIButton alloc]initWithFrame:CGRectMake(leftPadding, topPadding, (kScreenWidth - leftPadding*3) / 2, ButtonHeight)];
    _codeButton.layer.backgroundColor = UIColorFromHex(0x29a3dc).CGColor;
    _codeButton.layer.cornerRadius = 3;
    _codeButton.clipsToBounds = YES;
    [_codeButton setTitle:@"电子开方" forState:UIControlStateNormal];
    [_codeButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [_codeButton addTarget:self action:@selector(addPrescriptionCodeAction) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:_codeButton];
    
    _imageButton = [[UIButton alloc]initWithFrame:CGRectMake(CGRectGetMaxX(_codeButton.frame)+leftPadding,[_codeButton frameY], (kScreenWidth - leftPadding*3) / 2, ButtonHeight)];
    _imageButton.layer.backgroundColor = UIColorFromHex(Color_Hex_NavBackground).CGColor;
    _imageButton.layer.cornerRadius = 3;
    _imageButton.clipsToBounds = YES;
    [_imageButton setTitle:@"处方拍照" forState:UIControlStateNormal];
    [_imageButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [_imageButton addTarget:self action:@selector(addPrescriptionImageAction) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:_imageButton];
    
    codeBaseView = [[UIView alloc]initWithFrame:CGRectMake(leftPadding, CGRectGetMaxY(_imageButton.frame) + topPadding, kScreenWidth - 2*leftPadding, 100)];
    codeBaseView.layer.borderWidth = 1;
    codeBaseView.layer.borderColor = UIColorFromHex(0xd8d8d8).CGColor;
    [self addSubview:codeBaseView];
    
    CGRect frame = self.frame;
    frame.size.height = CGRectGetMaxY(codeBaseView.frame)+topPadding;
    self.frame = frame;
    
    codeLabel = [[UILabel alloc]initWithFrame:CGRectMake(leftPadding, topPadding, [codeBaseView frameWidth] - 2*leftPadding, 0)];
    codeLabel.font = [UIFont systemFontOfSize:14];
    codeLabel.textColor = UIColorFromHex(Color_Hex_Text_Normal);
    codeLabel.textAlignment = NSTextAlignmentLeft;
    codeLabel.numberOfLines = 0;
    [codeBaseView addSubview:codeLabel];
    
    imageView = [[BingZhengImageView alloc]initWithFrame:CGRectMake(leftPadding, topPadding, kScreenWidth - 2*leftPadding, kScreenWidth - 2*leftPadding)];
    imageView.hidden = YES;
    imageView.contentMode = UIViewContentModeScaleAspectFill;
    imageView.clipsToBounds = YES;
    imageView.userInteractionEnabled = YES;
    [imageView.deleteButton addTarget:self action:@selector(deletePrescriptionImageAction) forControlEvents:UIControlEventTouchUpInside];
    [imageView.showTap addTarget:self action:@selector(showPrescriptionImageAction)];
    [self addSubview:imageView];
}

- (void)initPrescriptionCodeView{

}

- (void)setPrescriptionArray:(NSMutableArray *)prescriptionArray{
    if (imageView) {
        imageView.hidden = YES;
    }
    codeBaseView.hidden = NO;
    
    _prescriptionArray = prescriptionArray;
    NSString *labelStr = [NSString stringWithFormat:@""];
    for (int i = 0; i < _prescriptionArray.count; i++) {
        CUHerbSelect *herb = [_prescriptionArray objectAtIndex:i];
        labelStr = [labelStr stringByAppendingFormat:@"\n%@\t%d%@",herb.name,herb.weight,herb.unit];
    }
    if(_prescriptionArray.count){
        labelStr = [labelStr substringFromIndex:1];
    }
    NSMutableParagraphStyle *paragraph = [NSMutableParagraphStyle new];
    paragraph.lineBreakMode = NSLineBreakByWordWrapping;
    paragraph.lineSpacing = 7;
    NSMutableAttributedString *lableAtrStr = [[NSMutableAttributedString alloc]initWithString:labelStr attributes:@{NSParagraphStyleAttributeName:paragraph}];
    codeLabel.attributedText = lableAtrStr;
    CGRect frame = codeLabel.frame;
    frame.size.height = [self sizeWithString:labelStr font:codeLabel.font lableWith:[codeLabel frameWidth] NSParagraphStyleAttributeName:paragraph].height;
    codeLabel.frame = frame;
    if (codeLabel.frame.size.height < 100 - 2*topPadding){
        frame.size.height = 70;
        codeLabel.frame = frame;
    }
    frame = codeBaseView.frame;
    frame.size.height = 2*topPadding + codeLabel.frame.size.height;
    codeBaseView.frame = frame;
    
    frame = self.frame;
    frame.size.height = CGRectGetMaxY(codeBaseView.frame)+topPadding;
    self.frame = frame;

}

- (void)setImage:(UIImage *)image{
    if (codeLabel) {
        codeBaseView.hidden = YES;
    }
    imageView.hidden = NO;
    _image = image;
    imageView.image = _image;
    
    self.frame = CGRectMake(self.frame.origin.x, self.frame.origin.y, kScreenWidth, kScreenWidth);
}

- (void)addPrescriptionCodeAction{
    _addPrescriptionCodeBlock();
}

- (void)addPrescriptionImageAction{
    _addPrescriptionImageBlock();
}

- (void)deletePrescriptionImageAction{
    if (imageView) {
        imageView.hidden = YES;
    }
    imageView.image = nil;
    codeBaseView.hidden = NO;
    
    CGRect frame = self.frame;
    frame.size.height = CGRectGetMaxY(codeBaseView.frame)+topPadding;
    self.frame = frame;
    _deletePrescriptionImageBlock();
}

- (void)showPrescriptionImageAction{
    _showPrescriptionImageBlock();
}

- (CGSize)sizeWithString:(NSString *)string font:(UIFont *)font lableWith:(CGFloat)lableWith NSParagraphStyleAttributeName:(NSMutableParagraphStyle *)paragraph{
    CGRect rect = [string boundingRectWithSize:CGSizeMake(lableWith, 8000)//限制最大的宽度和高度
                                       options:NSStringDrawingTruncatesLastVisibleLine | NSStringDrawingUsesFontLeading  |NSStringDrawingUsesLineFragmentOrigin//采用换行模式
                                    attributes:@{NSFontAttributeName: font, NSParagraphStyleAttributeName:paragraph}//传人的字体字典
                                       context:nil];
    
    return rect.size;
}
@end

@implementation BingZhengImageView

- (instancetype)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    if (self) {
        self.userInteractionEnabled = YES;
        UIImage *deleteImage = [UIImage imageNamed:@"ic_delete"];
        _deleteButton = [[UIButton alloc]init];
        _deleteButton.frame = CGRectMake([self frameWidth] - deleteImage.size.width, 0, deleteImage.size.width, deleteImage.size.height);
        [_deleteButton setBackgroundImage:deleteImage forState:UIControlStateNormal];
        [self addSubview:_deleteButton];
        
        _showTap = [[UITapGestureRecognizer alloc]init];
        _showTap.numberOfTapsRequired = 1;
        _showTap.numberOfTouchesRequired = 1;
        [self addGestureRecognizer:_showTap];
        
    }
    return self;
}

@end
