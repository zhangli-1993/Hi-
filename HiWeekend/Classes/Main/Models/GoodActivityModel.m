//
//  GoodActivityModel.m
//  HiWeekend
//
//  Created by scjy on 16/1/8.
//  Copyright © 2016年 scjy. All rights reserved.
//

#import "GoodActivityModel.h"

@implementation GoodActivityModel
- (instancetype)initWithDictionary:(NSDictionary *)dic{
    self = [super init];
    if (self) {
        self.title = dic[@"title"];
        self.image = dic[@"image"];
        self.age = dic[@"age"];
        self.counts = dic[@"counts"];
        self.price = dic[@"price"];
        self.activityId = dic[@"id"];
        self.address = dic[@"address"];
        self.type = dic[@"type"];
    }
    return self;
}
@end
