//
//  CurrentTreatmentViewController.h
//  
//
//  Created by Guo on 15/10/7.
//
//

#import "CUViewController.h"
#import "CurrentTreatmentListViewController.h"

@interface CurrentTreatmentViewController : CUViewController

@property(strong,nonatomic) UISegmentedControl *segment;
@property(strong,nonatomic) UIScrollView *contentScrollView;

@property NSInteger PageNumber;

@end
