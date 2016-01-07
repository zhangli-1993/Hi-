//
//  ActivityDetailView.h
//  HiWeekend
//
//  Created by scjy on 16/1/7.
//  Copyright © 2016年 scjy. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ActivityDetailView : UIView
@property (weak, nonatomic) IBOutlet UIButton *MapButton;
@property (weak, nonatomic) IBOutlet UIButton *MakeCaiiButton;
@property (nonatomic, strong) NSDictionary *dataDic;
@end
