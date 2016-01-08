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
#import "HotActivityTableViewCell.h"
@interface HotActivityViewController ()<PullingRefreshTableViewDelegate, UITableViewDataSource, UITableViewDelegate>
{
    NSInteger _page;
}
@property (nonatomic, strong) PullingRefreshTableView *tableView;
@property (nonatomic, assign) BOOL refreshing;
@property (nonatomic, strong) NSMutableArray *acData;

@end

@implementation HotActivityViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"热门专题";
    [self showBackButton];
    self.hidesBottomBarWhenPushed = YES;
    [self loadData];
    [self.view addSubview:self.tableView];
    //如果整张视图只想让他显示4行的话，后面就变成空白
    self.tableView.tableFooterView = [[UIView alloc] init];
    [self.tableView launchRefreshing];
    [self.tableView registerNib:[UINib nibWithNibName:@"GoodActivityTableViewCell" bundle:nil] forCellReuseIdentifier:@"cell"];

}

- (void)loadData{
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    manager.responseSerializer.acceptableContentTypes = [NSSet setWithObject:@"text/html"];
    [manager GET:[NSString stringWithFormat:@"%@&page=%ld", kHotActivity, _page] parameters:nil progress:^(NSProgress * _Nonnull downloadProgress) {
        ZLLog(@"%@", downloadProgress)
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        ZLLog(@"%@", responseObject);
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        ZLLog(@"error = %@", error);
    }];
}
#pragma mark--UITableViewDataSource

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.acData.count;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    HotActivityTableViewCell *Cell = [tableView dequeueReusableCellWithIdentifier:@"cell" forIndexPath:indexPath];
    //Cell.GAModel = self.acData[indexPath.row];
    return Cell;
}

#pragma mark--UITableViewDelegate
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
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
