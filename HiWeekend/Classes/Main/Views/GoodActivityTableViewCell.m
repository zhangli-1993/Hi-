//
//  GoodActivityTableViewCell.m
//  HiWeekend
//
//  Created by scjy on 16/1/8.
//  Copyright © 2016年 scjy. All rights reserved.
//

#import "GoodActivityTableViewCell.h"
#import <SDWebImage/UIImageView+WebCache.h>
@interface GoodActivityTableViewCell ()
@property (weak, nonatomic) IBOutlet UIImageView *headImageView;

@property (weak, nonatomic) IBOutlet UILabel *activityTitleLabel;
@property (weak, nonatomic) IBOutlet UILabel *activityDistanceLabel;
@property (weak, nonatomic) IBOutlet UILabel *activityPriceLabel;
@property (weak, nonatomic) IBOutlet UIButton *loveCountButton;
@property (weak, nonatomic) IBOutlet UIImageView *ageImageView;
@property (weak, nonatomic) IBOutlet UILabel *ageLabel;


@end

@implementation GoodActivityTableViewCell

- (void)awakeFromNib {
    // Initialization code
    self.frame = CGRectMake(0, 0, kWidth, 90);
}
- (void)setGAModel:(GoodActivityModel *)GAModel{
    [self.headImageView sd_setImageWithURL:[NSURL URLWithString:GAModel.image] placeholderImage:nil];
    self.activityTitleLabel.text = GAModel.title;
    self.activityPriceLabel.text = GAModel.price;
    self.ageLabel.text = GAModel.age;
    [self.loveCountButton setTitle:[NSString stringWithFormat:@"%@", GAModel.counts] forState:UIControlStateNormal];
    
}



- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
