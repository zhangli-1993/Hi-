//
//  DiscoverViewController.m
//  HiWeekend
//
//  Created by scjy on 16/1/4.
//  Copyright © 2016年 scjy. All rights reserved.
//

#import "DiscoverViewController.h"
#import "DiscoveryTableViewCell.h"
#import "PullingRefreshTableView.h"
#import <AFNetworking/AFHTTPSessionManager.h>
#import "ProgressHUD.h"
#import "DiscoveryModel.h"
#import "ActivityDetailViewController.h"
@interface DiscoverViewController ()<UITableViewDataSource, UITableViewDelegate, PullingRefreshTableViewDelegate>
@property (nonatomic, strong) PullingRefreshTableView *tableView;
@property (nonatomic, strong) NSMutableArray *likeArray;
@end

@implementation DiscoverViewController

- (void)viewDidLoad {
    [self.view addSubview:self.tableView];
    self.navigationController.navigationBar.barTintColor = kColor;
    //edgesForExtendedLayout默认的值是UIRectEdgeAll就是全部布局的意思
    self.edgesForExtendedLayout = UIRectEdgeNone;
    
    [self.tableView registerNib:[UINib nibWithNibName:@"DiscoveryTableViewCell" bundle:nil] forCellReuseIdentifier:@"discover"];
    [self.tableView launchRefreshing];
}
- (void)viewDidAppear:(BOOL)animated{
    self.tabBarController.tabBar.hidden = NO;
}
- (void)loadData{
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    manager.responseSerializer.acceptableContentTypes = [NSSet setWithObject:@"text/html"];
    [manager GET:kDiscovery parameters:nil progress:^(NSProgress * _Nonnull downloadProgress) {
        ZLLog(@"%@", downloadProgress);
        [ProgressHUD showSuccess:@"Success"];
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        ZLLog(@"%@", responseObject);
        NSDictionary *dict = responseObject;
        NSString *code = dict[@"code"];
        NSString *status = dict[@"status"];
        if ([status isEqualToString:@"success"]&& [code integerValue] == 0) {
            NSDictionary *dic = dict[@"success"];
            NSArray *array = dic[@"like"];
            for (NSDictionary *dictionary in array) {
                DiscoveryModel *model = [[DiscoveryModel alloc]initWithDictionary:dictionary];
                [self.likeArray addObject:model];
            }
        }
        
        [self.tableView reloadData];
        self.tableView.reachedTheEnd = NO;
        [self.tableView tableViewDidFinishedLoading];
        
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        ZLLog(@"%@", error);
        [ProgressHUD showError:[NSString stringWithFormat:@"%@", error]];
    }];
    
}

#pragma mark---UITableViewDataSource

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.likeArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    DiscoveryTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"discover" forIndexPath:indexPath];
    cell.model = self.likeArray[indexPath.row];
    return cell;
}


#pragma mark---UITableViewDelegate
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    UIStoryboard *mainSs = [UIStoryboard storyboardWithName:@"MainStoryboard" bundle:nil];
    ActivityDetailViewController *aVC = [mainSs instantiateViewControllerWithIdentifier:@"advc"];
    DiscoveryModel *model = self.likeArray[indexPath.row];
    aVC.activityId = model.activityId;
    [self.navigationController pushViewController:aVC animated:YES];
}
- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section{
    return @"大家都喜欢";
}
#pragma mark---PullingRefreshTableViewDelegate
//下拉刷新
- (void)pullingTableViewDidStartRefreshing:(PullingRefreshTableView *)tableView{
    [self performSelector:@selector(loadData) withObject:nil afterDelay:1.0];
}
- (NSDate *)pullingTableViewRefreshingFinishedDate{
    return [HWtools getSystemNowDate];
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



#pragma mark---懒加载
- (UITableView *)tableView{
    if (_tableView == nil) {
        self.tableView = [[PullingRefreshTableView alloc]initWithFrame:CGRectMake(0, 0, kWidth, kHeight - 64 - 44) pullingDelegate:self];
        self.tableView.delegate = self;
        self.tableView.dataSource = self;
        self.tableView.separatorColor = [UIColor grayColor];
        self.tableView.rowHeight = 120;
        //只有上边的下拉刷新
        [self.tableView setHeaderOnly:YES];
    }
    return _tableView;
}
- (NSMutableArray *)likeArray{
    if (_likeArray == nil) {
        self.likeArray = [NSMutableArray new];
    }
    return _likeArray;
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
