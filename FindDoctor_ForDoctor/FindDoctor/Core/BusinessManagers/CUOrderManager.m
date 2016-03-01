//
//  CUOrderManager.m
//  CollegeUnion
//
//  Created by li na on 15/2/18.
//  Copyright (c) 2015年 li na. All rights reserved.
//

#import "CUOrderManager.h"
#import "CUServerAPIConstant.h"
#import "CUOrderParser.h"
#import "AppCore.h"

@implementation CUOrderManager

SINGLETON_IMPLENTATION(CUOrderManager);


@end

@implementation CUOrderManager (Network)

- (void)submitOrder:(CUService *)service user:(CUUser *)user resultBlock:(SNServerAPIResultBlock)resultBlock pageName:(NSString *)pageName
{
    // param
    NSMutableDictionary * param = [NSMutableDictionary dictionary];
    [param setObjectSafely:user.token forKey:Key_Token];

    CUOrderParser * parser = [[CUOrderParser alloc] init];
    
    [[AppCore sharedInstance].apiManager POST:URL_AfterBase parameters:param callbackRunInGlobalQueue:YES parser:parser parseMethod:@selector(parseSubmitOrderWithDict:) resultBlock:resultBlock forKey:URL_AfterBase forPageNameGroup:pageName];
}

- (void)updateOrder:(CUOrder *)order status:(OrderStatus)status user:(CUUser *)user resultBlock:(SNServerAPIResultBlock)resultBlock pageName:(NSString *)pageName
{
    // param
    NSMutableDictionary * param = [NSMutableDictionary dictionary];
    [param setObjectSafely:user.token forKey:Key_Token];
    [param setObjectSafely:order.orderId forKey:@"orderId"];
    [param setObjectSafely:@(status) forKey:@"status"];
    
    CUOrderParser * parser = [[CUOrderParser alloc] init];
    
    [[AppCore sharedInstance].apiManager POST:URL_AfterBase parameters:param callbackRunInGlobalQueue:YES parser:parser parseMethod:@selector(parseUpdateOrderWithDict:) resultBlock:resultBlock forKey:URL_AfterBase forPageNameGroup:pageName];
}

- (void)cancelOrder:(CUOrder *)order user:(CUUser *)user resultBlock:(SNServerAPIResultBlock)resultBlock pageName:(NSString *)pageName
{
    // param
    NSMutableDictionary * param = [NSMutableDictionary dictionary];
    [param setObjectSafely:user.token forKey:Key_Token];
    [param setObjectSafely:order.orderId forKey:@"orderId"];
    
    CUOrderParser * parser = [[CUOrderParser alloc] init];
    
    [[AppCore sharedInstance].apiManager POST:URL_AfterBase parameters:param callbackRunInGlobalQueue:YES parser:parser parseMethod:@selector(parseCancelOrderWithDict:) resultBlock:resultBlock forKey:URL_AfterBase forPageNameGroup:pageName];
}

- (void)getOrderListWithPageNum:(NSInteger)pageNum pageSize:(NSInteger)pageSize user:(CUUser *)user searchedWithOrderStatus:(OrderStatus)orderStatus resultBlock:(SNServerAPIResultBlock)resultBlock pageName:(NSString *)pageName
{
    /*
    // param
    NSMutableDictionary * param = [NSMutableDictionary dictionary];
    [param setObjectSafely:user.token forKey:Key_Token];
    [param setObjectSafely:[NSNumber numberWithInteger:pageNum] forKey:Key_PageNum];
    [param setObjectSafely:[NSNumber numberWithInteger:pageSize] forKey:Key_PageSize];
    if (orderStatus != ORDERSTATUS_NONE)
    {
        [param setObjectSafely:@(orderStatus) forKey:@"status"];
    }
    
    CUOrderParser * parser = [[CUOrderParser alloc] init];
    
    if (orderStatus == ORDERSTATUS_NONE)
    {
        [[AppCore sharedInstance].apiManager POST:URL_GetOrderListReady parameters:param callbackRunInGlobalQueue:YES parser:parser parseMethod:@selector(parseGetOrderListWithDict:) resultBlock:resultBlock forKey:URL_GetOrderListReady forPageNameGroup:pageName];
    }
    else
    {
        [[AppCore sharedInstance].apiManager POST:URL_GetOrderList parameters:param callbackRunInGlobalQueue:YES parser:parser parseMethod:@selector(parseGetOrderListWithDict:) resultBlock:resultBlock forKey:URL_GetOrderList forPageNameGroup:pageName];
    }*/
    
    if (resultBlock) {
        SNBaseListModel *listModel  =[[SNBaseListModel alloc] init];
        listModel.items = [self fakeOrderList];
        
        SNServerAPIResultData *result = [[SNServerAPIResultData alloc] init];
        result.parsedModelObject = listModel;
        
        resultBlock(nil, result);
    }
}

- (NSMutableArray *)fakeOrderList
{
    NSMutableArray *dataArray = [NSMutableArray array];
    
    for (NSInteger i = 0; i < 10; i ++) {
        Doctor *doctor = [[Doctor alloc] init];
        doctor.doctorId = [NSString stringWithFormat:@"%@", @(i + 100)];
        doctor.name = @"华佗";
        doctor.avatar = @"http://www.91danji.com/attachments/201406/25/13/28lp1eh2g.jpg";
        doctor.desc = @"华佗被后人称为“外科圣手”[5]  、“外科鼻祖”。被后人多用神医华佗称呼他，又以“华佗再世”、“元化重生”称誉有杰出医术的医师。";
        doctor.levelDesc = @"主任医师";
        doctor.subject = @"内科 皮肤科 慢性支气管炎 儿科 头疼";
        doctor.availableTime = @"2015-8-18";
        doctor.isAvailable = i % 2;
        doctor.rate = 4.5;
        doctor.area = @"青羊区";
        doctor.city = @"成都";
        doctor.address = @"华西医院";
        doctor.price = 200;
        doctor.background = @"华佗[1]  （约公元145年－公元208年），字元化，一名旉，沛国谯县人，东汉末年著名的医学家。华佗与董奉、张仲景并称为“建安三神医”。少时曾在外游学，行医足迹遍及安徽、河南、山东、江苏等地，钻研医术而不求仕途。他医术全面，尤其擅长外科，精于手术。并精通内、妇、儿、针灸各科。[2-4]  晚年因遭曹操怀疑，下狱被拷问致死。";
        doctor.skilledDisease = @"疑难杂症";
        doctor.skilledSubject = @"外科、内、妇、儿、针灸各科";
        
        CUOrder *order = [[CUOrder alloc] init];
        order.orderId = @"u90989087";
        order.orderNumber = @"888888";
        order.orderStatus = i % 3 + 1;
        
        order.service.doctor = doctor;
        order.service.serviceTime = @"2015-9-1";
        
        order.service.patience = [[CUUser alloc] init];
        order.service.patience.name = @"李四";
        order.service.patience.age = 26;
        order.service.patience.gender = CUUserGenderMale;
        order.service.patience.cellPhone = @"8789809";
        
        [dataArray addObjectSafely:order];
    }
    
    return dataArray;
}

- (void)getUncommentOrderListWithPageNum:(NSInteger)pageNum pageSize:(NSInteger)pageSize user:(CUUser *)user searchedWithOrderStatus:(OrderStatus)orderStatus resultBlock:(SNServerAPIResultBlock)resultBlock pageName:(NSString *)pageName
{
    // param
    NSMutableDictionary * param = [NSMutableDictionary dictionary];
    [param setObjectSafely:user.token forKey:Key_Token];
    [param setObjectSafely:[NSNumber numberWithInteger:pageNum] forKey:Key_PageNum];
    [param setObjectSafely:[NSNumber numberWithInteger:pageSize] forKey:Key_PageSize];
    if (orderStatus != ORDERSTATUS_NONE)
    {
        [param setObjectSafely:@(orderStatus) forKey:@"status"];
    }
    
    CUOrderParser * parser = [[CUOrderParser alloc] init];
    
    [[AppCore sharedInstance].apiManager POST:URL_AfterBase parameters:param callbackRunInGlobalQueue:YES parser:parser parseMethod:@selector(parseGetOrderListWithDict:) resultBlock:resultBlock forKey:URL_AfterBase forPageNameGroup:pageName];
}

- (void)getOrderDetailWithOrderId:(NSString *)orderId user:(CUUser *)user resultBlock:(SNServerAPIResultBlock)resultBlock pageName:(NSString *)pageName
{
    // param
    NSMutableDictionary * param = [NSMutableDictionary dictionary];
    [param setObjectSafely:user.token forKey:Key_Token];
    [param setObjectSafely:orderId forKey:@"orderId"];
    
    CUOrderParser * parser = [[CUOrderParser alloc] init];
    
    [[AppCore sharedInstance].apiManager POST:URL_AfterBase parameters:param callbackRunInGlobalQueue:YES parser:parser parseMethod:@selector(parseGetOrderDetailWithDict:) resultBlock:resultBlock forKey:URL_AfterBase forPageNameGroup:pageName];

}


@end