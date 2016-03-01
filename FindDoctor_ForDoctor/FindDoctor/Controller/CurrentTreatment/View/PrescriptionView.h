//
//  PrescriptionView.h
//  FindDoctor
//
//  Created by 晓炜 郭 on 15/12/20.
//  Copyright © 2015年 li na. All rights reserved.
//

#import <UIKit/UIKit.h>
typedef void (^AddPrescriptionCodeBlock)(void);
typedef void (^AddPrescriptionImageBlock)(void);
typedef void (^DeletePrescriptionImageBlock)(void);
typedef void (^ShowPrescriptionImageBlock)(void);

@interface PrescriptionView : UIView

- (instancetype)initWithFrame:(CGRect)frame;
- (void)setPrescriptionArray:(NSMutableArray *)prescriptionArray;

@property (nonatomic, copy) AddPrescriptionCodeBlock addPrescriptionCodeBlock;
@property (nonatomic, copy) AddPrescriptionImageBlock addPrescriptionImageBlock;
@property (nonatomic, copy) DeletePrescriptionImageBlock deletePrescriptionImageBlock;
@property (nonatomic, copy) ShowPrescriptionImageBlock showPrescriptionImageBlock;

@property (nonatomic, strong) UIButton *codeButton;
@property (nonatomic, strong) UIButton *imageButton;

@property (nonatomic, weak) NSMutableArray *prescriptionArray;
@property (nonatomic, weak) UIImage *image;
@end


@interface BingZhengImageView : UIImageView

@property (strong,nonatomic) UIButton *deleteButton;
@property (strong,nonatomic) UITapGestureRecognizer  *showTap;




- (instancetype)initWithFrame:(CGRect)frame;

@end
