//
//  ActivityDetailViewController.m
//  HiWeekend
//  活动详情
//  Created by scjy on 16/1/6.
//  Copyright © 2016年 scjy. All rights reserved.
//

#import "ActivityDetailViewController.h"
#import <AFNetworking/AFHTTPSessionManager.h>

#import "ActivityDetailView.h"
@interface ActivityDetailViewController ()
{
    NSString *phoneNum;
}
@property (strong, nonatomic) IBOutlet ActivityDetailView *activityDetailView;

@end

@implementation ActivityDetailViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"活动详情";
    
    [self showBackButton:@"back"];
    //隐藏tabbar
    self.tabBarController.tabBar.hidden = YES;
    //去地图页面
    [self.activityDetailView.MapButton addTarget:self action:@selector(mapAction:) forControlEvents:UIControlEventTouchUpInside];
    //打电话页面
    [self.activityDetailView.MakeCaiiButton addTarget:self action:@selector(makeCallAction:) forControlEvents:UIControlEventTouchUpInside];
    
    [self getModel];
}

#pragma mark-------自定义方法
- (void)getModel{
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    manager.responseSerializer.acceptableContentTypes = [NSSet setWithObject:@"text/html"];

    [manager GET:[NSString stringWithFormat:@"%@&id=%@", kActivityDetail, self.activityId] parameters:nil progress:^(NSProgress * _Nonnull downloadProgress) {
        ZLLog(@"%@", downloadProgress);
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        //解析数据
        NSDictionary *dic = responseObject;
        NSString *status = dic[@"status"];
        NSInteger code = [dic[@"code"] integerValue];
        if ([status isEqualToString:@"success"] && code == 0) {
            NSDictionary *successDic = dic[@"success"];
            self.activityDetailView.dataDic = successDic;
            phoneNum = successDic[@"tel"];
        }
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
    }];
    
}
//去地图页面
- (void)mapAction:(UIButton *)btn{
    
}
//打电话
- (void)makeCallAction:(UIButton *)btn{
    //程序外打电话，不返回应用程序
    //[[UIApplication sharedApplication] openURL:[NSURL URLWithString:[NSString stringWithFormat:@"tel://%@", phoneNum]]];
    //程序内打电话，打完电话之后还返回当前应用程序
    UIWebView *cellPhoneWebView = [[UIWebView alloc] init];
    NSURLRequest *request = [NSURLRequest requestWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"tel://%@", phoneNum]]];
    [cellPhoneWebView loadRequest:request];
    [self.view addSubview:cellPhoneWebView];
    
}





- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
