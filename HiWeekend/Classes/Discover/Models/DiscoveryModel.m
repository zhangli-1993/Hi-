//
//  DiscoveryModel.m
//  HiWeekend
//
//  Created by scjy on 16/1/12.
//  Copyright © 2016年 scjy. All rights reserved.
//

#import "DiscoveryModel.h"

@implementation DiscoveryModel
- (instancetype)initWithDictionary:(NSDictionary *)dic{
    self = [super init];
    if (self) {
        self.image = dic[@"image"];
        self.title = dic[@"title"];
        self.type = dic[@"type"];
        self.activityId = dic[@"id"];
    }
    return self;
}
@end
