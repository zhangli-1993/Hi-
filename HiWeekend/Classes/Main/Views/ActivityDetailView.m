//
//  ActivityDetailView.m
//  HiWeekend
//
//  Created by scjy on 16/1/7.
//  Copyright © 2016年 scjy. All rights reserved.
//

#import "ActivityDetailView.h"
#import <SDWebImage/UIImageView+WebCache.h>
@interface ActivityDetailView ()

@property (weak, nonatomic) IBOutlet UIImageView *HeadImageView;
@property (weak, nonatomic) IBOutlet UILabel *activityTitleLable;
@property (weak, nonatomic) IBOutlet UILabel *activityTimeLable;

@property (weak, nonatomic) IBOutlet UILabel *favouriteLable;
@property (weak, nonatomic) IBOutlet UILabel *PriceLable;
@property (weak, nonatomic) IBOutlet UILabel *activityAdressLable;
@property (weak, nonatomic) IBOutlet UILabel *phoneNumLable;



@property (weak, nonatomic) IBOutlet UIScrollView *mainScrollView;

@end

@implementation ActivityDetailView

-(void)awakeFromNib{
    self.mainScrollView.contentSize = CGSizeMake(kWidth, 1000);
}

- (void)setDataDic:(NSDictionary *)dataDic{
    [self.HeadImageView sd_setImageWithURL:[NSURL URLWithString:dataDic[@"image"]] placeholderImage:nil];
    self.activityTitleLable.text = dataDic[@"title"];
    self.favouriteLable.text = [NSString stringWithFormat:@"%@人已收藏", dataDic[@"fav"]];
    self.PriceLable.text = dataDic[@"pricedesc"];
    self.activityAdressLable.text = dataDic[@"address"];
    self.phoneNumLable.text = dataDic[@"tel"];
    
}





/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
