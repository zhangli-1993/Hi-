//
//  HotActivityViewController.m
//  HiWeekend
//
//  Created by scjy on 16/1/6.
//  Copyright © 2016年 scjy. All rights reserved.
//

#import "HotActivityViewController.h"
#import <AFNetworking/AFHTTPSessionManager.h>
#import "PullingRefreshTableView.h"
#import <SDWebImage/UIImageView+WebCache.h>
#import "ThemeViewController.h"
@interface HotActivityViewController ()<PullingRefreshTableViewDelegate, UITableViewDataSource, UITableViewDelegate>
{
    NSInteger _page;
}
@property (nonatomic, strong) PullingRefreshTableView *tableView;
@property (nonatomic, assign) BOOL refreshing;
@property (nonatomic, strong) NSMutableArray *rcData;

@end

@implementation HotActivityViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"热门专题";
    [self showBackButton];
    [self.view addSubview:self.tableView];
    //如果整张视图只想让他显示4行的话，后面就变成空白
    //self.tableView.tableFooterView = [[UIView alloc] init];
    [self.tableView launchRefreshing];
    self.rcData = [NSMutableArray new];
    self.tabBarController.tabBar.hidden = YES;
}
#pragma mark--UITableViewDataSource

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.rcData.count;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    static NSString *str = @"123";
    UITableViewCell *Cell = [self.tableView dequeueReusableCellWithIdentifier:str];
    if (Cell == nil) {
        Cell = [[UITableViewCell alloc] initWithStyle:(UITableViewCellStyleSubtitle) reuseIdentifier:str];
    }
    UIImageView *imageview = [[UIImageView alloc] initWithFrame:CGRectMake(5, 5, kWidth - 10, 200)];
    [imageview sd_setImageWithURL:[NSURL URLWithString:self.rcData[indexPath.row][@"img"]] placeholderImage:nil];
    [Cell addSubview:imageview];
    return Cell;
}

#pragma mark--UITableViewDelegate
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    ThemeViewController *tVC = [[ThemeViewController alloc] init];
    tVC.ThemeId = self.rcData[indexPath.row][@"id"];
    [self.navigationController pushViewController:tVC animated:YES];
}
#pragma mark---PullingRefreshTableViewDelegate
//tableView上拉刷新时调用
- (void)pullingTableViewDidStartRefreshing:(PullingRefreshTableView *)tableView{
    self.refreshing = YES;
    [self performSelector:@selector(loadData) withObject:nil afterDelay:1.0];
    _page = 1;
    
}
//tableView下拉刷新时调用
- (void)pullingTableViewDidStartLoading:(PullingRefreshTableView *)tableView{
    _page += 1;
    [self performSelector:@selector(loadData) withObject:nil afterDelay:1.0];
    
}


- (void)loadData{
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    manager.responseSerializer.acceptableContentTypes = [NSSet setWithObject:@"text/html"];
    [manager GET:[NSString stringWithFormat:@"%@&page=%ld", kHotActivity, _page] parameters:nil progress:^(NSProgress * _Nonnull downloadProgress) {
        ZLLog(@"%@", downloadProgress)
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        NSDictionary *dic = responseObject;
        NSString *code = dic[@"code"];
        NSString *status = dic[@"status"];
        if ([code integerValue] == 0 && [status isEqualToString:@"success"]) {
            NSArray *array = dic[@"success"][@"rcData"];
            for (NSDictionary *dic in array) {
                [self.rcData addObject:dic];
            }
            [self.tableView reloadData];
        }
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        ZLLog(@"error = %@", error);
    }];
    [self.tableView tableViewDidFinishedLoading];
    self.tableView.reachedTheEnd = NO;
}

- (NSDate *)pullingTableViewRefreshingFinishedDate{
    return [HWtools getSystemNowDate];
}

#pragma mark---懒加载
- (PullingRefreshTableView *)tableView{
    if (_tableView == nil) {
        self.tableView = [[PullingRefreshTableView alloc] initWithFrame:CGRectMake(0, 0, kWidth, kHeight - 64) pullingDelegate:self];
        self.tableView.dataSource = self;
        self.tableView.delegate = self;
        self.tableView.rowHeight = 210;

    }
    return _tableView;
}


#pragma mark - ScrollView Method
//手指开始拖动方法
- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    [self.tableView tableViewDidScroll:scrollView];
}

//手指结束拖动方法
- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate
{
    [self.tableView tableViewDidEndDragging:scrollView];
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
