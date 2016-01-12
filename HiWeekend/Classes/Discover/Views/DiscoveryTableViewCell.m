//
//  DiscoveryTableViewCell.m
//  HiWeekend
//
//  Created by scjy on 16/1/12.
//  Copyright © 2016年 scjy. All rights reserved.
//

#import "DiscoveryTableViewCell.h"
#import <SDWebImage/UIImageView+WebCache.h>
@interface DiscoveryTableViewCell ()
@property (weak, nonatomic) IBOutlet UIImageView *imageview;
@property (weak, nonatomic) IBOutlet UILabel *titleLabel;

@end

@implementation DiscoveryTableViewCell

- (void)awakeFromNib {
    // Initialization code
}
- (void)setModel:(DiscoveryModel *)model{
    [self.imageview sd_setImageWithURL:[NSURL URLWithString:model.image] placeholderImage:nil];
    self.imageview.layer.cornerRadius = 55;
    self.imageview.clipsToBounds = YES;
    self.titleLabel.text = model.title;
    self.titleLabel.numberOfLines = 0;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
