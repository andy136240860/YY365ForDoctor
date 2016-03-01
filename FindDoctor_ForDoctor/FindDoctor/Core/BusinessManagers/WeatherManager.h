//
//  WeatherManager.h
//  FindDoctor
//
//  Created by Guo on 15/12/7.
//  Copyright © 2015年 li na. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "CUServerAPIConstant.h"
#import "AppCore.h"
#import "SNPlatFormManager.h"
#import "SNNetworkClient.h"
#import "JSONKit.h"


@interface WeatherManager : NSObject
SINGLETON_DECLARE(WeatherManager);

- (void)getWeatherWithResultBlock:(SNServerAPIResultBlock)resultBlock pageName:(NSString *)pageName;

@end
