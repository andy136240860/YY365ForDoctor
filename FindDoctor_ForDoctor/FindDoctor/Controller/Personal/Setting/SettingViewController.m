//
//  SettingViewController.m
//  FindDoctor
//
//  Created by Guo on 15/9/11.
//  Copyright (c) 2015年 li na. All rights reserved.
//

#import "SettingViewController.h"
#import "massageTextFieldView.h"
#import "FamilyMemberListView.h"
#import "FamilyMemberDetailController.h"
#import "CUUserManager+FamilyMember.h"
#import "TipHandler+HUD.h"
#import "TitleView.h"

#define kDeleteMemeberAlertTag  100

#define kInformationinSettingViewHight 140


@interface SettingViewController ()<UITextFieldDelegate, UITextViewDelegate>

@property (nonatomic, strong) NSMutableArray *memberArray;
@property NSInteger selectedMemberIndex;

@property (nonatomic, strong) FamilyMemberListView *memberListView;

@end

@implementation SettingViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"个人设置";
    [self loadViewLoginInformation];
    [self initMemberListView];
    [self loadAddress];
    
    // Do any additional setup after loading the view.
}
- (void)loadNavigationBar
{
    [self addLeftBackButtonItemWithImage];
}

- (void)loadViewLoginInformation
{
    //创建个人信息区域，设置背景
    UIView *loginInformationView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, kScreenWidth, kInformationinSettingViewHight)];
    loginInformationView.backgroundColor = UIColorFromHex(0xf7fcf4);
    
    //创建圆形头像区域
    UIImageView *personalFaceView = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"DoctorPortrait"]];
    personalFaceView.frame = CGRectMake(25,10,40,40);
    personalFaceView.layer.cornerRadius = personalFaceView.frame.size.width / 2;
    personalFaceView.clipsToBounds = YES;
    [loginInformationView addSubview:personalFaceView];
    
    //创建信息区域
    UILabel *line1 = [[UILabel alloc]initWithFrame:CGRectMake(90, 12, kScreenWidth-130, 14)];
    line1.text = @"昵称:XiXi      等级:1级";
    line1.font = [UIFont systemFontOfSize:12];
    line1.textColor = UIColorFromHex(0x999999);
    UILabel *line2 = [[UILabel alloc]initWithFrame:CGRectMake(90, 32, kScreenWidth-130, 14)];
    line2.text = @"账号:13588888888";
    line2.font = [UIFont systemFontOfSize:12];
    line2.textColor = UIColorFromHex(0x999999);
    
    [loginInformationView addSubview:line1];
    [loginInformationView addSubview:line2];
    
    //创建昵称邮箱修改区域
    massageTextFieldView  *nickNameView = [[massageTextFieldView alloc]initTextFieldWithPointY:60 Title:@"昵   称"];
    [loginInformationView addSubview:nickNameView];
    
    massageTextFieldView  *emailView = [[massageTextFieldView alloc]initTextFieldWithPointY:100 Title:@"邮   箱"];
    [loginInformationView addSubview:emailView];
    
    [self.contentView addSubview:loginInformationView];
    
}

-(void)loadAddress{
    
    CGFloat addressViewHight = 100;
    UIView *addressView = [[UIView alloc]initWithFrame:CGRectMake(0, kInformationinSettingViewHight, kScreenWidth, addressViewHight)];
    addressView.backgroundColor = [UIColor yellowColor];
    
    //添加标题
    TitleView *addressTitle = [[TitleView alloc]initWithFrame:CGRectMake(0, 0, kScreenWidth, 30) title:@"快递地址管理"];
    [addressView addSubview:addressTitle];
    
    [self.contentView addSubview:addressView];
}








- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

#pragma mark - Private Action

- (void)showDeleteMemeberAlert
{
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"" message:@"确定要删除该家庭成员吗？" delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"确定", nil];
    alert.tag = kDeleteMemeberAlertTag;
    [alert show];
}

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (alertView.cancelButtonIndex != buttonIndex) {
        if (alertView.tag == kDeleteMemeberAlertTag) {
            [self deleteMemberAction];
        }
    }
}

- (void)addMemberAction
{
    FamilyMemberDetailController *memberVC = [[FamilyMemberDetailController alloc] init];
    memberVC.editType = FamilyMemberEditTypeAdd;
    [self.slideNavigationController pushViewController:memberVC animated:YES];
    
    __weak typeof(self) weakSelf = self;
    memberVC.addBlock = ^(CUUser *user) {
        [weakSelf.memberArray addObjectSafely:user];
        
        [weakSelf.memberListView reloadData:self.memberArray];
    };
}


- (void)deleteMemberAction
{
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    
    CUUser *user = [self.memberArray objectAtIndex:self.selectedMemberIndex];
    [[CUUserManager sharedInstance] deleteMember:user resultBlock:^(SNHTTPRequestOperation *request, SNServerAPIResultData * result) {
        [MBProgressHUD hideAllHUDsForView:self.view animated:YES];
        
        if (!result.hasError) {
            [self.memberArray removeObjectAtIndex:self.selectedMemberIndex];
            self.selectedMemberIndex = 0;
            
            [self.memberListView reloadData:self.memberArray];
            
            [TipHandler showHUDText:@"删除成功" state:TipStateSuccess inView:self.view];
        }
        else {
            [TipHandler showHUDText:@"删除失败" state:TipStateFail inView:self.view];
        }
    } pageName:@"DeleteMember"];
}



- (void)initMemberListView
{
    self.memberArray = [NSMutableArray array];
    for (NSInteger i = 0; i < 1; i ++) {
        CUUser *user = [[CUUser alloc] init];
        user.name = [NSString stringWithFormat:@"华佗 %lu", i];
        user.profile = @"http://www.91danji.com/attachments/201406/25/13/28lp1eh2g.jpg";
        [self.memberArray addObjectSafely:user];
    }
    
    self.memberListView = [[FamilyMemberListView alloc] initWithFrame:CGRectMake(0, self.contentView.frameHeight - [FamilyMemberListView defaultHeight], self.contentView.frameWidth, [FamilyMemberListView defaultHeight])];
    [self.contentView addSubview:self.memberListView];
    
    [self.memberListView reloadData:self.memberArray];
    
    __weak typeof(self) weakSelf = self;
    self.memberListView.deleteMemberBlock = ^(NSInteger index) {
        weakSelf.selectedMemberIndex = index;
        [weakSelf showDeleteMemeberAlert];
    };
    
    self.memberListView.addMemberBlock = ^{
        [weakSelf addMemberAction];
    };
}
@end
