//
//  CUServerAPIConstant.h
//  CollegeUnion
//
//  Created by li na on 15/2/26.
//  Copyright (c) 2015年 li na. All rights reserved.
//

#ifndef CollegeUnion_CUServerAPIConstant_h
#define CollegeUnion_CUServerAPIConstant_h

#define CollegeUnion_Distribution
//#define CollegeUnion_Develop



// ------------------------ ERROR CODE ------------------------
#define ErrorCode_None 0

// ------------------------ COMMEN KEY ------------------------
#define Key_PageNum @"pageNum"
#define Key_PageSize @"pageSize"
#define Key_Search @"search"
#define Key_Token @"token"
#define Key_List @"list"

#define kPageSize 20

// ------------------------ URL ------------------------

/* 
 * Base URL
 */
#if defined(CollegeUnion_Develop)

//#define URL_Base @"http://192.168.1.110:8080"
//#define URL_Base @"http://192.168.1.104:8080"
//#define URL_Base @"http://192.168.1.101:8888"
#define URL_Base @"http://www.uyi365.com"
//#define URL_Base @"http://www.baidu.com"


#elif defined(CollegeUnion_Distribution)

#define URL_Base @"http://www.uyi365.com"

#endif



/*
 * Business URL
 */

// { -----------图片相关

// 上传图片
#define URL_ImageUpload @"/baseFrame/base/FileUpload.jmv"
#define URL_ImageBase @"http://www.51eshijia.com"
// }

// { -----------用户相关

// 获取手机验证码
#if defined(CollegeUnion_Develop)
#define URL_AfterBase @"/baseFrame/base/server.jmt"
#elif defined(CollegeUnion_Distribution)
#define URL_AfterBase @"/baseFrame/base/server.jmw"
#endif

#define Plist_User @"user"
#define Plist_AllCityServices @"AllCityServices"
#define Plist_CurrentCity @"CurrentCity"


#endif
