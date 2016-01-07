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
@property (nonatomic, assign) CGFloat SUMH;

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
    //温馨提示
    [self showReminderWithString:dataDic[@"reminder"]];
    
}
//400是前面所有东西的高度
- (void)drawContentWithArray:(NSArray *)contentArray{
    //前面每一个数组的累加高度
    self.SUMH = 0;
    //title部分
    for (NSDictionary *dic in contentArray) {
        //如果标题存在
        NSString *title = dic[@"title"];
        if (title != nil) {
            UILabel *titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(10, 400 + self.SUMH + 5, kWidth - 20, 30)];
            titleLabel.text = title;
            [self.mainScrollView addSubview:titleLabel];
            //加上title的高度
            self.SUMH += 30;
         }
        //描述Label
        CGFloat height1 = [HWtools getLableTextHeight:dic[@"description"] bigestSize:CGSizeMake(kWidth - 20, 1000) textFont:15.0];
        //本次label的高度 = 405 + 前面每一个array的高度
        UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(10, 405 + self.SUMH, kWidth - 20, height1)];
        label.text = dic[@"description"];
        label.numberOfLines = 0;
        label.font = [UIFont systemFontOfSize:15.0];
        [self.mainScrollView addSubview:label];
        //加上description的高度
        self.SUMH+=height1;
        
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
        self.SUMH += imageH;
    }
}

- (void)showReminderWithString:(NSString *)str{
    UIImageView *line1 = [[UIImageView alloc] initWithFrame:CGRectMake(0, self.SUMH + 420, kWidth, 8)];
    [line1 setImage:[UIImage imageNamed:@"grayLine"]];
    [self.mainScrollView addSubview:line1];
    UILabel *title = [[UILabel alloc] initWithFrame:CGRectMake(25, self.SUMH + 431, kWidth - 25, 30)];
    title.text = @"温馨提示";
    title.font = [UIFont systemFontOfSize:15.0];
    [self.mainScrollView addSubview:title];
    UIImageView *line2 = [[UIImageView alloc] initWithFrame:CGRectMake(0, title.bottom + 3, kWidth, 1)];
    [line2 setImage:[UIImage imageNamed:@"grayLine"]];
    [self.mainScrollView addSubview:line2];
    
    CGFloat height = [HWtools getLableTextHeight:str bigestSize:CGSizeMake(kWidth - 20, 1000) textFont:15.0];
    UILabel *reminderLabel = [[UILabel alloc] initWithFrame:CGRectMake(10, title.bottom + 7, kWidth - 20, height)];
    reminderLabel.text = str;
    reminderLabel.numberOfLines = 0;
    reminderLabel.font = [UIFont systemFontOfSize:15.0];
    [self.mainScrollView addSubview:reminderLabel];
    self.mainScrollView.contentSize = CGSizeMake(kWidth, reminderLabel.bottom + 80);
}








/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
