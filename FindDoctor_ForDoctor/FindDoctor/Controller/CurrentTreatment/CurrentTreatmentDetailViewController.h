//
//  CurrentTreatmentDetailViewController.h
//  FindDoctor
//
//  Created by Guo on 15/11/2.
//  Copyright © 2015年 li na. All rights reserved.
//

#import "CUViewController.h"
#import "Patient.h"
#import "PrescriptionView.h"

@interface CurrentTreatmentDetailViewController : CUViewController<UITextViewDelegate,UIActionSheetDelegate,UINavigationControllerDelegate,UIImagePickerControllerDelegate>
{
//    //输入框
//    UITextView *_textEditor;
//    
//    //下拉菜单
    UIActionSheet *myActionSheet;
//
//    
//    //图片2进制路径
//    NSString* filePath;
}

@property  (strong,nonatomic) Patient *data;

@property  (strong,nonatomic) PrescriptionView *prescriptionView;
@property  (strong,nonatomic)    UIScrollView    *contentScrollView;

@end


