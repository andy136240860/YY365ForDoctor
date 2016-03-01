//
//  CUDoctorManager.m
//  FindDoctor
//
//  Created by zhouzhenhua on 15/8/13.
//  Copyright (c) 2015年 li na. All rights reserved.
//

#import "CUDoctorManager.h"
#import "AppCore.h"
#import "CUServerAPIConstant.h"
#import "CUDoctorParser.h"

@implementation CUDoctorManager

SINGLETON_IMPLENTATION(CUDoctorManager);

- (void)getDoctorListWithPageNum:(NSInteger)pageNum pageSize:(NSInteger)pageSize filter:(DoctorFilter *)filter resultBlock:(SNServerAPIResultBlock)resultBlock pageName:(NSString *)pageName
{
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    [params setValue:@(filter.sortType) forKey:@"sort_type"];
    [params setValue:@(filter.typeId) forKey:@"type_id"];
    [params setValue:@(filter.subTypeId) forKey:@"subType_id"];
    [params setValue:@(filter.level) forKey:@"doctor_level"];
    [params setValue:@(filter.longitude) forKey:@"longitude"];
    [params setValue:@(filter.latitude) forKey:@"latitude"];
    [params setValue:filter.keyword forKey:@"keyword"];
    [params setValue:filter.priceRange forKey:@"price_range"];
    
    CUDoctorParser *parser = [[CUDoctorParser alloc] init];
    
    [[AppCore sharedInstance].apiManager POST:URL_AfterBase parameters:params callbackRunInGlobalQueue:YES parser:parser parseMethod:@selector(parseDoctorDetailWithDict:) resultBlock:resultBlock forKey:URL_AfterBase forPageNameGroup:pageName];
    
    if (resultBlock) {
        SNBaseListModel *listModel = [[SNBaseListModel alloc] init];
        listModel.items = [self fakeDoctorList];
        
        SNServerAPIResultData * result = [[SNServerAPIResultData alloc] init];
        result.parsedModelObject = listModel;
        
        resultBlock(nil, result);
    }
}

- (void)getSubObjectListWithResultBlock:(SNServerAPIResultBlock)resultBlock
{
    CUDoctorParser *parser = [[CUDoctorParser alloc] init];
    
//    [[AppCore sharedInstance].apiManager POST:URL_SubObject
//                                   parameters:nil
//                     callbackRunInGlobalQueue:YES
//                                       parser:parser
//                                  parseMethod:@selector(parseSubObjectListWithDict:)
//                                  resultBlock:resultBlock];
    if (resultBlock) {
        SNBaseListModel *listModel  =[[SNBaseListModel alloc] init];
        listModel.items = [self fakeSubObjectList];
        
        SNServerAPIResultData *result = [[SNServerAPIResultData alloc] init];
        result.parsedModelObject = listModel;
        
        resultBlock(nil, result);
    }
}

- (void)getCommentListWithDoctor_id:(NSString *)doctor_id resultBlock:(SNServerAPIResultBlock)resultBlock
{
    
}

- (NSMutableArray *)fakeSubObjectList
{
    NSMutableArray *subobjectArray = [NSMutableArray new];
    for (int i=0; i<10; i++) {
        SubObject *subobject = [[SubObject alloc] init];
        subobject.type_id = [NSString stringWithFormat:@"%@",@(i+10)];
        subobject.name = @"内科";
        subobject.imageURL = @"http://wenwen.soso.com/p/20101003/20101003092618-1015437083.jpg";
        [subobjectArray addObject:subobject];
    }
    return subobjectArray;
}

- (NSMutableArray *)fakeDoctorList
{
    NSMutableArray *doctorArray = [NSMutableArray array];
    
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
        doctor.price = 200;
        doctor.area = @"青羊区";
        doctor.city = @"成都";
        doctor.address = @"华西医院";
        doctor.background = @"华佗[1]  （约公元145年－公元208年），字元化，一名旉，沛国谯县人，东汉末年著名的医学家。华佗与董奉、张仲景并称为“建安三神医”。少时曾在外游学，行医足迹遍及安徽、河南、山东、江苏等地，钻研医术而不求仕途。他医术全面，尤其擅长外科，精于手术。并精通内、妇、儿、针灸各科。[2-4]  晚年因遭曹操怀疑，下狱被拷问致死。";
        doctor.skilledDisease = @"疑难杂症";
        doctor.skilledSubject = @"外科、内、妇、儿、针灸各科";
        [doctorArray addObjectSafely:doctor];
    }
    
    return doctorArray;
}

@end
