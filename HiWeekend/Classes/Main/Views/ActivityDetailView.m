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
    self.mainScrollView.contentSize = CGSizeMake(kWidth, 6000);
}

- (void)setDataDic:(NSDictionary *)dataDic{
    NSArray *urls = dataDic[@"urls"];
    [self.HeadImageView sd_setImageWithURL:[NSURL URLWithString:urls[0]] placeholderImage:nil];
    self.activityTitleLable.text = dataDic[@"title"];
    self.favouriteLable.text = [NSString stringWithFormat:@"%@人已收藏", dataDic[@"fav"]];
    self.PriceLable.text = dataDic[@"pricedesc"];
    self.activityAdressLable.text = dataDic[@"address"];
    self.phoneNumLable.text = dataDic[@"tel"];
    //活动起止时间
    NSString *startTime = [HWtools getDataFromString:dataDic[@"new_end_date"]];
    NSString *endTime = [HWtools getDataFromString:dataDic[@"new_start_date"]];
    self.activityTimeLable.text = [NSString stringWithFormat:@" 正在进行：%@-%@", startTime, endTime];
    //活动详情
    [self drawContentWithArray:dataDic[@"content"]];
    
    
}
//400是前面所有东西的高度
- (void)drawContentWithArray:(NSArray *)contentArray{
    //前面每一个数组的累加高度
    NSInteger SUMH = 0;
    //title部分
    for (NSDictionary *dic in contentArray) {
        //如果标题存在
        NSString *title = dic[@"title"];
        if (title != nil) {
            UILabel *titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(10, 400 + SUMH + 5, kWidth - 20, 30)];
            titleLabel.text = title;
            [self.mainScrollView addSubview:titleLabel];
            //加上title的高度
            SUMH += 30;
         }
        //描述Label
        CGFloat height1 = [HWtools getLableTextHeight:dic[@"description"] bigestSize:CGSizeMake(kWidth - 20, 1000) textFont:15.0];
        //本次label的高度 = 405 + 前面每一个array的高度
        UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(10, 405 + SUMH, kWidth - 20, height1)];
        label.text = dic[@"description"];
        label.numberOfLines = 0;
        label.font = [UIFont systemFontOfSize:15.0];
        [self.mainScrollView addSubview:label];
        //加上description的高度
        SUMH+=height1;
        
        NSArray *urlsArray = dic[@"urls"];
        //图片的起始位置的高度
        CGFloat imageH = 0;
        for (NSDictionary *dic in urlsArray) {
            CGFloat width = [dic[@"width"] integerValue];
            CGFloat height = [dic[@"height"] integerValue];
            //本次图片的起始位置的高度=前面label的结束位置的高度+上一张图片的高度
            UIImageView *imageview = [[UIImageView alloc] initWithFrame:CGRectMake(10, label.bottom + imageH, kWidth - 20, height * (kWidth - 20)/ width)];
            [imageview sd_setImageWithURL:[NSURL URLWithString:dic[@"url"]] placeholderImage:nil];
            [self.mainScrollView addSubview:imageview];
            imageH += height * (kWidth - 20)/ width + 5;
        }
        //加上所有图片的高度
        SUMH += imageH;
    }
}










/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
