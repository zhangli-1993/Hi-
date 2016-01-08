//
//  GoodActivityModel.h
//  HiWeekend
//
//  Created by scjy on 16/1/8.
//  Copyright © 2016年 scjy. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface GoodActivityModel : NSObject
@property (nonatomic, strong) NSString *title;
@property (nonatomic, strong) NSString *image;
@property (nonatomic, strong) NSString *age;
@property (nonatomic, strong) NSString *counts;
@property (nonatomic, strong) NSString *price;
@property (nonatomic, strong) NSString *address;
@property (nonatomic, strong) NSString *type;
@property (nonatomic, strong) NSString *activityId;
- (instancetype)initWithDictionary:(NSDictionary *)dic;

@end
