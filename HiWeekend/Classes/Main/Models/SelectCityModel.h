//
//  SelectCityModel.h
//  HiWeekend
//
//  Created by scjy on 16/3/1.
//  Copyright © 2016年 scjy. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface SelectCityModel : NSObject
@property (nonatomic, strong) NSString *cityId;
@property (nonatomic, strong) NSString *cityName;
- (instancetype)initWithDictionary:(NSDictionary *)dic;


@end
