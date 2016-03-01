//
//  SelectCityModel.m
//  HiWeekend
//
//  Created by scjy on 16/3/1.
//  Copyright © 2016年 scjy. All rights reserved.
//

#import "SelectCityModel.h"

@implementation SelectCityModel
- (instancetype)initWithDictionary:(NSDictionary *)dic{
    self = [super init];
    if (self) {
        self.cityId = dic[@"cat_id"];
        self.cityName = dic[@"cat_name"];
    }
    return self;
}
@end
