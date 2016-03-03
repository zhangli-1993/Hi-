//
//  HWHeader.h
//  HiWeekend
//
//  Created by scjy on 16/1/6.
//  Copyright © 2016年 scjy. All rights reserved.
//

#ifndef HWHeader_h
#define HWHeader_h
#import <Foundation/Foundation.h>
typedef NS_ENUM(NSInteger, ClassifyListType) {
    ClassifyListTypeShowRepertoire = 1,  //演出剧目
    ClassifyListTypeTouristPlace,   //景点场馆
    ClassifyListTypeStudyPUZ,     //学习益智
    ClassifyListTypeFamilyTravel  //亲子旅游
};



//首页数据接口
//以后所有的接口都定义在这里
//#define kMainDataList @"http://e.kumi.cn/app/v1.3/index.php?_s_=02a411494fa910f5177d82a6b0a63788&_t_=1451307342&channelid=appstore&cityid=1&lat=34.62172291944134&limit=30&lng=112.4149512442411&page=1"
#define kMainDataList @"http://e.kumi.cn/app/v1.3/index.php?_s_=02a411494fa910f5177d82a6b0a63788&_t_=1451307342&channelid=appstore&limit=30&page=1"
//活动详情接口
#define kActivityDetail @"http://e.kumi.cn/app/articleinfo.php?_s_=6055add057b829033bb586a3e00c5e9a&_t_=1452071715&channelid=appstore&cityid=1&lat=34.61356779156581&lng=112.4141403843618"
//活动专题接口
#define kActivityTheme @"http://e.kumi.cn/app/positioninfo.php?_s_=1b2f0563dade7abdfdb4b7caa5b36110&_t_=1452218405&channelid=appstore&cityid=1&lat=34.61349052974207&limit=30&lng=112.4139739846577&page=1"
//精选活动接口
#define kGoodActivity @"http://e.kumi.cn/app/articlelist.php?_s_=a9d09aa8b7692ebee5c8a123deacf775&_t_=1452236979&channelid=appstore&cityid=1&lat=34.61351314785497&limit=30&lng=112.4140755658942&type=1"

//热门专题接口
#define kHotActivity @"http://e.kumi.cn/app/positionlist.php?_s_=e2b71c66789428d5385b06c178a88db2&_t_=1452237051&channelid=appstore&cityid=1&lat=34.61351314785497&limit=30&lng=112.4140755658942"
//分类列表接口
//#define kClassifyList @"http://e.kumi.cn/app/v1.3/catelist.php?_s_=dad924a9b9cd534b53fc2c521e9f8e84&_t_=1452495193&channelid=appstore&cityid=1&lat=34.61356398594803&limit=30&lng=112.4140434532402"
#define kClassifyList @"http://e.kumi.cn/app/v1.3/catelist.php?_s_=dad924a9b9cd534b53fc2c521e9f8e84&_t_=1452495193&channelid=appstore&limit=30"
//发现页面接口
#define kDiscovery @"http://e.kumi.cn/app/found.php?_s_=a82c7d49216aedb18c04a20fd9b0d5b2&_t_=1451310230&channelid=appstore&cityid=1&lat=34.62172291944134&lng=112.4149512442411"

//城市列表接口
#define kCityList @"http://e.kumi.cn/app/citylist.php"
//微博分享
#define kAppKey @"3331706835"
#define kRedirectURL @"http://api.weibo.com/oauth2/default.html"
#define kAppSecret @"7bc2ceb002d936b8a721502e1e14686a"
//微信分享
#define kWXAppID @"wx13b85b35061dcd72"
#define kWXAppSecret @"4dd040c3fa1adf3867fd56be90a29116"
//bmob
#define kBmobKey @"dca2bc975df99b707aa0f7b3690e3dd6"

#endif /* HWHeader_h */
