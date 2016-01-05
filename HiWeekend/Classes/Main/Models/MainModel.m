//
//  MainModel.m
//  HiWeekend
//
//  Created by scjy on 16/1/5.
//  Copyright © 2016年 scjy. All rights reserved.
//

#import "MainModel.h"

@implementation MainModel
- (instancetype)initWithDictionary:(NSDictionary *)dic{
    self = [super init];
    if (self) {
        self.type = dic[@"type"];
        if ([self.type integerValue] == RecommendTypeActivity) {
            self.price = dic[@"price"];
            self.lat = [dic[@"lat"] floatValue];
            self.lng = [dic[@"lng"] floatValue];
            self.address = dic[@"address"];
            self.startTime = dic[@"startTime"];
            self.endTime = dic[@"endTime"];
            self.counts = dic[@"counts"];
        } else{
            self.activiytDescription = dic[@"description"];
        }
        self.image_big = dic[@"image_big"];
        self.title = dic[@"title"];
        self.activityId = dic[@"id"];
     }
    return self;
}







@end
