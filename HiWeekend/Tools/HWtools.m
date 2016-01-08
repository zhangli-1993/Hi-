//
//  HWtools.m
//  HiWeekend
//
//  Created by scjy on 16/1/7.
//  Copyright © 2016年 scjy. All rights reserved.
//

#import "HWtools.h"

@implementation HWtools
+ (NSString *)getDataFromString:(NSString *)timeTamp{
    NSDate *date = [NSDate dateWithTimeIntervalSince1970:[timeTamp doubleValue]];
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat:@"yyyy.MM.dd"];
    //NSTimeZone *timezone = [NSTimeZone timeZoneWithName:@"Asia/Shanghai"];
     //[formatter setTimeZone:timezone];
    NSString *nowTimeStr = [formatter stringFromDate:date];
    return nowTimeStr;

    
}

+ (NSDate *)getSystemNowDate{
        NSDateFormatter *df = [[NSDateFormatter alloc] init ];
        df.dateFormat = @"yyyy-MM-dd HH:mm";
        NSString *dateStr = [df stringFromDate:[NSDate date]];
        NSDate *date = [df dateFromString:dateStr];
        return date;
}



+ (CGFloat)getLableTextHeight:(NSString *)text bigestSize:(CGSize)bigestSize textFont:(CGFloat)font{
    CGFloat textHeight;
    CGRect textRect = [text boundingRectWithSize:bigestSize options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:font]} context:nil];
    return textRect.size.height;
    return textHeight;
}


@end
