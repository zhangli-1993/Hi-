//
//  HWtools.h
//  HiWeekend
//
//  Created by scjy on 16/1/7.
//  Copyright © 2016年 scjy. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface HWtools : NSObject
#pragma mark----时间转换
//根据时间戳返回字符串类型时间
+ (NSString *)getDataFromString:(NSString *)timeTamp;
//获取系统当前时间
+ (NSDate *)getSystemNowDate;
#pragma ---根据文字最大显示宽高计算高度
+ (CGFloat)getLableTextHeight:(NSString *)text bigestSize:(CGSize)bigestSize textFont:(CGFloat)font;

@end
