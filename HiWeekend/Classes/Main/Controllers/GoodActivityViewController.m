//
//  GoodActivityViewController.m
//  HiWeekend
//
//  Created by scjy on 16/1/6.
//  Copyright © 2016年 scjy. All rights reserved.
//

#import "GoodActivityViewController.h"
#import "PullingRefreshTableView.h"
#import "GoodActivityTableViewCell.h"
#import <AFNetworking/AFHTTPSessionManager.h>
#import "ActivityDetailViewController.h"
@interface GoodActivityViewController ()<UITableViewDataSource, UITableViewDelegate, PullingRefreshTableViewDelegate>
{
    NSInteger _pageCount;
}
@property (nonatomic, strong) PullingRefreshTableView *tableView;
@property (nonatomic, assign) BOOL refreshing;
@property (nonatomic, strong) NSMutableArray *acData;
@end

@implementation GoodActivityViewController


- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"精选活动";
    [self showBackButton:@"back"];
    [self.view addSubview:self.tableView];
    //如果整张视图只想让他显示4行的话，后面就变成空白
    self.tableView.tableFooterView = [[UIView alloc] init];
    [self.tableView launchRefreshing];
    //    [self.tableView setHeaderOnly:YES];          //只有上拉刷新
    //    [self.tableView setFooterOnly:YES];          //只有下拉刷新
    [self.tableView registerNib:[UINib nibWithNibName:@"GoodActivityTableViewCell" bundle:nil] forCellReuseIdentifier:@"cell"];
    self.acData = [NSMutableArray new];
    self.tabBarController.tabBar.hidden = YES;

}

#pragma mark--UITableViewDataSource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.acData.count;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
        GoodActivityTableViewCell *GACell = [tableView dequeueReusableCellWithIdentifier:@"cell" forIndexPath:indexPath];
    GACell.GAModel = self.acData[indexPath.row];
    return GACell;
}

#pragma mark--UITableViewDelegate
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    UIStoryboard *mainSB = [UIStoryboard storyboardWithName:@"MainStoryboard" bundle:nil];
    ActivityDetailViewController *aVC = [mainSB instantiateViewControllerWithIdentifier:@"advc"];
    GoodActivityModel *model = self.acData[indexPath.row];
    aVC.activityId = model.activityId;
    [self.navigationController pushViewController:aVC animated:YES];

}

#pragma mark---PullingRefreshTableViewDelegate
//tableView上拉刷新时调用
- (void)pullingTableViewDidStartRefreshing:(PullingRefreshTableView *)tableView{
    self.refreshing = YES;
    [self performSelector:@selector(loadData) withObject:nil afterDelay:1.0];
    _pageCount = 1;
    
}
//tableView下拉刷新时调用
- (void)pullingTableViewDidStartLoading:(PullingRefreshTableView *)tableView{
    _pageCount += 1;
    self.refreshing = NO;
    [self performSelector:@selector(loadData) withObject:nil afterDelay:1.0];
}
//加载数据
- (void)loadData{
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    manager.responseSerializer.acceptableContentTypes = [NSSet setWithObject:@"text/html"];
    [manager GET:[NSString stringWithFormat:@"%@&page=%ld", kGoodActivity, _pageCount] parameters:nil progress:^(NSProgress * _Nonnull downloadProgress) {
        ZLLog(@"%@", downloadProgress);
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        NSDictionary *dic = responseObject;
        NSString *code = dic[@"code"];
        NSString *status = dic[@"status"];
        if ([code integerValue] == 0 && [status isEqualToString:@"success"]) {
        NSArray *array = dic[@"success"][@"acData"];
            //下拉刷新需要移除数组中的数据
        if (self.refreshing) {
                if (self.acData.count > 0) {
                    [self.acData removeAllObjects];
                }
            }
        for (NSDictionary *dic in array) {
            GoodActivityModel *model = [[GoodActivityModel alloc] initWithDictionary:dic];
            [self.acData addObject:model];
        }
        [self.tableView reloadData];
        } else {
            
        }
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        ZLLog(@"error = %@", error);
    }];
    [self.tableView tableViewDidFinishedLoading];
    self.tableView.reachedTheEnd = NO;
}
//刷新完成时间
- (NSDate *)pullingTableViewRefreshingFinishedDate{
    return [HWtools getSystemNowDate];
}

#pragma mark---懒加载
- (PullingRefreshTableView *)tableView{
    if (_tableView == nil) {
        self.tableView = [[PullingRefreshTableView alloc] initWithFrame:CGRectMake(0, 0, kWidth, kHeight - 64) pullingDelegate:self];
        self.tableView.dataSource = self;
        self.tableView.delegate = self;
        self.tableView.rowHeight = 90;
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
