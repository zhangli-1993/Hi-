//
//  ActivityDetailViewController.m
//  HiWeekend
//
//  Created by scjy on 16/1/6.
//  Copyright © 2016年 scjy. All rights reserved.
//

#import "ActivityDetailViewController.h"
#import <AFNetworking/AFHTTPSessionManager.h>
#import "MBProgressHUD.h"
#import "ActivityDetailView.h"
@interface ActivityDetailViewController ()

@property (strong, nonatomic) IBOutlet ActivityDetailView *activityDetailView;

@end

@implementation ActivityDetailViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"活动详情";
    
    [self showBackButton];
    
    [self getModel];
}

#pragma mark-------自定义方法
- (void)getModel{
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    manager.responseSerializer.acceptableContentTypes = [NSSet setWithObject:@"text/html"];
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];

    [manager GET:[NSString stringWithFormat:@"%@&id=%@", kActivityDetail, self.activityId] parameters:nil progress:^(NSProgress * _Nonnull downloadProgress) {
        ZLLog(@"%@", downloadProgress);
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        [MBProgressHUD hideHUDForView:self.view animated:YES];
        //解析数据
        NSDictionary *dic = responseObject;
        NSString *status = dic[@"status"];
        NSInteger code = [dic[@"code"] integerValue];
        if ([status isEqualToString:@"success"] && code == 0) {
            NSDictionary *successDic = dic[@"success"];
            self.activityDetailView.dataDic = successDic;
        }
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        [MBProgressHUD hideHUDForView:self.view animated:YES];
        ZLLog(@"error = %@", error);
    }];
    
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
