//
//  WeatherManager.m
//  FindDoctor
//
//  Created by Guo on 15/12/7.
//  Copyright © 2015年 li na. All rights reserved.
//

#import "WeatherManager.h"



@implementation WeatherManager

SINGLETON_IMPLENTATION(WeatherManager);

- (void)getWeatherWithResultBlock:(SNServerAPIResultBlock)resultBlock pageName:(NSString *)pageName
{
    SNServerAPIManager *apiManager = [[SNServerAPIManager alloc]initWithServer:@"http://www.weather.com.cn/"];
    
    [apiManager GET:@"data/sk/101270101.html" parameters:nil callbackRunInGlobalQueue:YES parser:nil parseMethod:nil resultBlock:^(SNHTTPRequestOperation *request, SNServerAPIResultData *result) {

        resultBlock(request,result);
    }];
    

}

@end
