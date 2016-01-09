//
//  ThemeViewController.m
//  HiWeekend
//  活动专题
//  Created by scjy on 16/1/6.
//  Copyright © 2016年 scjy. All rights reserved.
//

#import "ThemeViewController.h"
#import <AFNetworking/AFHTTPSessionManager.h>
#import "ActivityThemeView.h"
@interface ThemeViewController ()
@property (strong, nonatomic) ActivityThemeView *themeView;
@end

@implementation ThemeViewController
- (void)loadView{
    [super loadView];
    self.themeView = [[ActivityThemeView alloc] initWithFrame:self.view.frame];
    self.view = self.themeView;
    [self getModel];
    self.tabBarController.tabBar.hidden = YES;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self showBackButton];
    self.tabBarController.tabBar.hidden = YES;
}

#pragma mark--自定义方法
- (void)getModel{
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    manager.responseSerializer.acceptableContentTypes = [NSSet setWithObject:@"text/html"];
    [manager GET:[NSString stringWithFormat:@"%@&id=%@", kActivityTheme, self.ThemeId] parameters:nil progress:^(NSProgress * _Nonnull downloadProgress) {
        ZLLog(@"%@", downloadProgress);
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        NSDictionary *dic = responseObject;
        NSString *status = dic[@"status"];
        NSInteger code = [dic[@"code"] integerValue];
        if ([status isEqualToString:@"success"] && code == 0) {
            self.themeView.dataDic = dic[@"success"];
            self.title = dic[@"success"][@"title"];
        }
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
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
