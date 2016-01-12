//
//  DiscoveryModel.h
//  HiWeekend
//
//  Created by scjy on 16/1/12.
//  Copyright © 2016年 scjy. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface DiscoveryModel : NSObject
@property (nonatomic, strong) NSString *image;
@property (nonatomic, strong) NSString *title;
@property (nonatomic, strong) NSString *activityId;
@property (nonatomic, strong) NSString *type;
- (instancetype)initWithDictionary:(NSDictionary *)dic;
@end
