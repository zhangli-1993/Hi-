//
//  ClassifyViewController.m
//  HiWeekend
//
//  Created by scjy on 16/1/6.
//  Copyright © 2016年 scjy. All rights reserved.
//

#import "ClassifyViewController.h"
#import "VOSegmentedControl.h"
#import "PullingRefreshTableView.h"
#import "GoodActivityTableViewCell.h"
#import "ActivityDetailViewController.h"
#import <AFNetworking/AFHTTPSessionManager.h>
#import "ProgressHUD.h"
 
@interface ClassifyViewController ()<UITableViewDataSource, UITableViewDelegate,PullingRefreshTableViewDelegate>
{
    NSInteger _pageCount;
}
@property (nonatomic, strong) PullingRefreshTableView *tableView;
//用来负责展示数据的数组
@property (nonatomic, strong) NSMutableArray *showDataArray;
//演出剧目
@property (nonatomic, strong) NSMutableArray *showArray;
//景点场馆
@property (nonatomic, strong) NSMutableArray *touristArray;
//学习益智
@property (nonatomic, strong) NSMutableArray *studyArray;
//亲子旅游
@property (nonatomic, strong) NSMutableArray *FamilyArray;
@property (nonatomic, assign) BOOL refreshing;
@property (nonatomic, strong) VOSegmentedControl *segctrl1;
@end

@implementation ClassifyViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"分类列表";
    [self showBackButton:@"back"];
    self.tableView.tableFooterView = [[UIView alloc] init];
    [self.tableView launchRefreshing];
    [self.tableView registerNib:[UINib nibWithNibName:@"GoodActivityTableViewCell" bundle:nil] forCellReuseIdentifier:@"cell"];
    self.tabBarController.tabBar.hidden = YES;
   // _pageCount = 1;
    [self.tableView launchRefreshing];

    [self.view addSubview:self.tableView];
    [self.view addSubview:self.segctrl1];
}
#pragma mark----UITableViewDataSource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.showDataArray.count;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    GoodActivityTableViewCell *GACell = [tableView dequeueReusableCellWithIdentifier:@"cell" forIndexPath:indexPath];
        GACell.GAModel = self.showDataArray[indexPath.row];
    return GACell;
}


#pragma mark---UITableViewDelegate
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    UIStoryboard *mainSB = [UIStoryboard storyboardWithName:@"MainStoryboard" bundle:nil];
    ActivityDetailViewController *aVC = [mainSB instantiateViewControllerWithIdentifier:@"advc"];
    GoodActivityModel *model = self.showDataArray[indexPath.row];
    aVC.activityId = model.activityId;
    [self.navigationController pushViewController:aVC animated:YES];
    
}

#pragma mark----PullingRefreshTableViewDelegate
- (void)pullingTableViewDidStartRefreshing:(PullingRefreshTableView *)tableView{
    self.refreshing = YES;
    [self performSelector:@selector(chooseRequest) withObject:nil afterDelay:1.0];
    _pageCount = 1;
    
}
//tableView下拉刷新时调用
- (void)pullingTableViewDidStartLoading:(PullingRefreshTableView *)tableView{
    _pageCount += 1;
    self.refreshing = NO;
    [self performSelector:@selector(chooseRequest) withObject:nil afterDelay:1.0];
}
//刷新完成时间
- (NSDate *)pullingTableViewRefreshingFinishedDate{
    return [HWtools getSystemNowDate];
}



#pragma mark---自定义方法
- (void)segmentCtrlValuechange:(VOSegmentedControl *)segctrl{
    self.classifyListType = segctrl.selectedSegmentIndex + 1;
    [self.tableView launchRefreshing];
}

- (void)chooseRequest{
    switch (self.classifyListType) {
        case ClassifyListTypeShowRepertoire:
            [self getShowRequest];
            break;
        case ClassifyListTypeTouristPlace:
            [self getTouristRequest];
            break;
        case ClassifyListTypeStudyPUZ:
            [self getStudyRequest];
            break;
        case ClassifyListTypeFamilyTravel:
            [self getFamilyRequest];
            break;
        default:
            break;
    }
    [self.tableView tableViewDidFinishedLoading];
    self.tableView.reachedTheEnd = NO;

}

- (void)getShowRequest{
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    manager.responseSerializer.acceptableContentTypes = [NSSet setWithObject:@"text/html"];
    [ProgressHUD show:@"拼命加载中..."];
    [manager GET:[NSString stringWithFormat:@"%@&page=%ld&typeid=%@", kClassifyList, _pageCount, @(6)] parameters:nil progress:^(NSProgress * _Nonnull downloadProgress) {
        ZLLog(@"%@", downloadProgress);
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        [ProgressHUD showSuccess:@"数据已经加载成功"];
        NSDictionary *dic = responseObject;
        NSString *code = dic[@"code"];
        NSString *status = dic[@"status"];
        if ([code integerValue] == 0 && [status isEqualToString:@"success"]) {
            NSArray *array = dic[@"success"][@"acData"];
            if (self.refreshing) {
                if (self.showArray.count > 0) {
                    [self.showArray removeAllObjects];
                }
            }
            for (NSDictionary *dic in array) {
                GoodActivityModel *model = [[GoodActivityModel alloc] initWithDictionary:dic];
                [self.showArray addObject:model];
            }
            [self.tableView reloadData];
        } else {
            
        }
        [self showPreviousSelectButton];
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        [ProgressHUD showError:[NSString stringWithFormat:@"%@", error ]];
    }];
}

- (void)getTouristRequest{
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    manager.responseSerializer.acceptableContentTypes = [NSSet setWithObject:@"text/html"];
    [ProgressHUD show:@"拼命加载中..."];

    [manager GET:[NSString stringWithFormat:@"%@&page=%ld&typeid=%@", kClassifyList, _pageCount, @(23)] parameters:nil progress:^(NSProgress * _Nonnull downloadProgress) {
        ZLLog(@"%@", downloadProgress);
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        [ProgressHUD showSuccess:@"数据已经加载成功"];

        NSDictionary *dic = responseObject;
        NSString *code = dic[@"code"];
        NSString *status = dic[@"status"];
        if ([code integerValue] == 0 && [status isEqualToString:@"success"]) {
            NSArray *array = dic[@"success"][@"acData"];
            if (self.refreshing) {
                if (self.touristArray.count > 0) {
                    [self.touristArray removeAllObjects];
                }
            }

            for (NSDictionary *dic in array) {
                GoodActivityModel *model = [[GoodActivityModel alloc] initWithDictionary:dic];
                [self.touristArray addObject:model];
            }
            [self.tableView reloadData];

        } else {
            
        }
        [self showPreviousSelectButton];
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        [ProgressHUD showError:[NSString stringWithFormat:@"%@", error ]];
    }];
}
- (void)getStudyRequest{
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    manager.responseSerializer.acceptableContentTypes = [NSSet setWithObject:@"text/html"];
    [ProgressHUD show:@"拼命加载中..."];

    [manager GET:[NSString stringWithFormat:@"%@&page=%ld&typeid=%@", kClassifyList, _pageCount, @(22)] parameters:nil progress:^(NSProgress * _Nonnull downloadProgress) {
        ZLLog(@"%@", downloadProgress);
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        [ProgressHUD showSuccess:@"数据已经加载成功"];

        NSDictionary *dic = responseObject;
        NSString *code = dic[@"code"];
        NSString *status = dic[@"status"];
        if ([code integerValue] == 0 && [status isEqualToString:@"success"]) {
            NSArray *array = dic[@"success"][@"acData"];
            if (self.refreshing) {
                if (self.studyArray.count > 0) {
                    [self.studyArray removeAllObjects];
                }
            }

            for (NSDictionary *dic in array) {
                GoodActivityModel *model = [[GoodActivityModel alloc] initWithDictionary:dic];
                [self.studyArray addObject:model];
            }
            [self.tableView reloadData];
        } else {
            
        }
        [self showPreviousSelectButton];
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
         [ProgressHUD showError:[NSString stringWithFormat:@"%@", error ]];
    }];
}

- (void)getFamilyRequest{
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    manager.responseSerializer.acceptableContentTypes = [NSSet setWithObject:@"text/html"];
    [ProgressHUD show:@"拼命加载中..."];

    [manager GET:[NSString stringWithFormat:@"%@&page=%ld&typeid=%@", kClassifyList, _pageCount, @(21)] parameters:nil progress:^(NSProgress * _Nonnull downloadProgress) {
        ZLLog(@"%@", downloadProgress);
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        [ProgressHUD showSuccess:@"数据已经加载成功"];

        NSDictionary *dic = responseObject;
        NSString *code = dic[@"code"];
        NSString *status = dic[@"status"];
        if ([code integerValue] == 0 && [status isEqualToString:@"success"]) {
            NSArray *array = dic[@"success"][@"acData"];
            if (self.refreshing) {
                if (self.FamilyArray.count > 0) {
                    [self.FamilyArray removeAllObjects];
                }
            }

            for (NSDictionary *dic in array) {
                GoodActivityModel *model = [[GoodActivityModel alloc] initWithDictionary:dic];
                [self.FamilyArray addObject:model];
            }
            [self.tableView reloadData];

        } else {
            
        }
        [self showPreviousSelectButton];
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        [ProgressHUD showError:[NSString stringWithFormat:@"%@", error ]];
    }];
}

- (void)showPreviousSelectButton{
    if (self.refreshing) { //下拉删除原来的元素
        if (self.showDataArray.count > 0) {
            [self.showDataArray removeAllObjects];
        }
    }
    switch (self.classifyListType) {
        case ClassifyListTypeShowRepertoire:
        {
            self.showDataArray = self.showArray;
        }
            break;
        case ClassifyListTypeTouristPlace:
        {
            self.showDataArray = self.touristArray;
        }
            break;
        case ClassifyListTypeStudyPUZ:
        {
            self.showDataArray = self.studyArray;
        }
            break;
        case ClassifyListTypeFamilyTravel:
        {
            self.showDataArray = self.FamilyArray;
        }
            break;
        default:
            break;
    }
    [self.tableView reloadData];
    

}





#pragma mark---懒加载
- (PullingRefreshTableView *)tableView{
    if (_tableView == nil) {
        self.tableView = [[PullingRefreshTableView alloc] initWithFrame:CGRectMake(0, 40, kWidth, kHeight - 64 - 40) pullingDelegate:self];
        self.tableView.delegate = self;
        self.tableView.dataSource = self;
        self.tableView.rowHeight = 90;
     }
    return _tableView;
}

- (NSMutableArray *)showDataArray{
    if (_showDataArray == nil) {
        self.showDataArray = [NSMutableArray new];
    }
    return _showDataArray;
}
- (NSMutableArray *)showArray{
    if (_showArray == nil) {
        self.showArray = [NSMutableArray new];
    }
    return _showArray;
}
- (NSMutableArray *)studyArray{
    if (_studyArray == nil) {
        self.studyArray = [NSMutableArray new];
    }
    return _studyArray;
}
- (NSMutableArray *)FamilyArray{
    if (_FamilyArray == nil) {
        self.FamilyArray = [NSMutableArray new];
    }
    return _FamilyArray;
}
- (NSMutableArray *)touristArray{
    if (_touristArray == nil) {
        self.touristArray = [NSMutableArray new];
    }
    return _touristArray;
}
- (VOSegmentedControl *)segctrl1{
    if (_segctrl1 == nil) {
        self.segctrl1 = [[VOSegmentedControl alloc] initWithSegments:@[@{VOSegmentText: @"演出剧目"},@{VOSegmentText: @"景点场馆"},@{VOSegmentText: @"学习益智"}, @{VOSegmentText: @"亲子旅游"}]];
        self.segctrl1.contentStyle = VOContentStyleTextAlone;
        self.segctrl1.indicatorStyle = VOSegCtrlIndicatorStyleBottomLine;
        self.segctrl1.backgroundColor = [UIColor groupTableViewBackgroundColor];
        self.segctrl1.selectedBackgroundColor = self.segctrl1.backgroundColor;
        self.segctrl1.allowNoSelection = NO;
        self.segctrl1.frame = CGRectMake(0, 0, kWidth, 40);
        self.segctrl1.indicatorThickness = 4;
         self.segctrl1.selectedSegmentIndex = (NSInteger)self.classifyListType - 1;
        //返回点击的是哪一个按钮
        //__block ClassifyViewController *weakVC = self;
        [self.segctrl1 setIndexChangeBlock:^(NSInteger index) {
        }];
        [self.segctrl1 addTarget:self action:@selector(segmentCtrlValuechange:) forControlEvents:UIControlEventValueChanged];

    }
    return _segctrl1;
}


#pragma mark---手指拖动
//手指结束拖动方法
- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate
{
    [self.tableView tableViewDidEndDragging:scrollView];
}
- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    [self.tableView tableViewDidScroll:scrollView];
}
- (void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:YES];
    [ProgressHUD dismiss];
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
