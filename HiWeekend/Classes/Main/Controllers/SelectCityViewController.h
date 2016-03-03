//
//  SelectCityViewController.h
//  HiWeekend
//
//  Created by scjy on 16/1/6.
//  Copyright © 2016年 scjy. All rights reserved.
//

#import <UIKit/UIKit.h>
@protocol SelectCityDelegate <NSObject>
- (void)getCityName:(NSString *)cityName CityId:(NSString *)cityid;
@end
@interface SelectCityViewController : UIViewController
@property (nonatomic, assign) id<SelectCityDelegate>selectdelegate;
@end
