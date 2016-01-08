//
//  ActivityThemeView.m
//  HiWeekend
// 活动专题视图
//  Created by scjy on 16/1/8.
//  Copyright © 2016年 scjy. All rights reserved.
//

#import "ActivityThemeView.h"
#import <SDWebImage/UIImageView+WebCache.h>
@interface ActivityThemeView ()
@property (strong, nonatomic) UIImageView *headImageView;
@property (strong, nonatomic) UIScrollView *mainScrollView;
@property (nonatomic, assign) CGFloat SUMH;
@end

@implementation ActivityThemeView
- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self configView];
    }
    return self;
}
#pragma mark--自定义视图
- (void)configView {
    [self addSubview:self.mainScrollView];
    [self.mainScrollView addSubview:self.headImageView];
}
#pragma mark--懒加载
- (UIImageView *)headImageView{
    if (_headImageView == nil) {
        self.headImageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, kWidth, 186)];
        
    }
    return _headImageView;
}
- (UIScrollView *)mainScrollView{
    if (_mainScrollView == nil) {
        self.mainScrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 0, kWidth, kHeight)];
     }
    return _mainScrollView;
}
//在setter方法中赋值
- (void)setDataDic:(NSDictionary *)dataDic{
    [self.headImageView sd_setImageWithURL:[NSURL URLWithString:dataDic[@"image"]] placeholderImage:nil];
    [self drawContentWithArray:dataDic[@"content"]];
    
}
- (void)drawContentWithArray:(NSArray *)contentArray{
    //前面每一个数组的累加高度
    self.SUMH = 0;
    //title部分
    for (NSDictionary *dic in contentArray) {
        //如果标题存在
        NSString *title = dic[@"title"];
        if (title != nil) {
            UILabel *titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(10, 186 + self.SUMH + 5, kWidth - 20, 30)];
            titleLabel.text = title;
            [self.mainScrollView addSubview:titleLabel];
            //加上title的高度
            self.SUMH += 30;
        }
        //描述Label
        CGFloat height1 = [HWtools getLableTextHeight:dic[@"description"] bigestSize:CGSizeMake(kWidth - 20, 1000) textFont:15.0];
        //本次label的高度 = 405 + 前面每一个array的高度
        UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(10, 191 + self.SUMH, kWidth - 20, height1)];
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
   self.mainScrollView.contentSize = CGSizeMake(kWidth,  self.SUMH + 30 + 186);
}




@end
