//
//  HFRequestModel.h
//  FindDoctor
//
//  Created by 晓炜 郭 on 16/3/29.
//  Copyright © 2016年 li na. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface HFRequestModel : NSObject

+ (NSDictionary *)paramDicWithRequire:(NSString *)require interfaceID:(NSInteger)interfaceID data:(id)data;

@end
