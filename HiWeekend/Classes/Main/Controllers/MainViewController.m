//
//  MainViewController.m
//  HiWeekend
//
//  Created by scjy on 16/1/4.
//  Copyright © 2016年 scjy. All rights reserved.
//

#import "MainViewController.h"
#import "MainTableViewCell.h"
#import <AFNetworking/AFHTTPSessionManager.h>
#import "MainModel.h"
#import <SDWebImage/UIImageView+WebCache.h>
#import "SelectCityViewController.h"
#import "SearchViewController.h"
#import "ActivityDetailViewController.h"
#import "ThemeViewController.h"
#import "ClassifyViewController.h"
#import "GoodActivityViewController.h"
#import "HotActivityViewController.h"
//#import "DataBaseManager.h"
#import "SelectCityModel.h"
@interface MainViewController ()<UITableViewDelegate, UITableViewDataSource, UIScrollViewDelegate, SelectCityDelegate>
{
    NSString *cityId;
}
@property (weak, nonatomic) IBOutlet UITableView *tableView;
//全部列表数据
@property(nonatomic, strong) NSMutableArray *listArray;
//推荐活动数据
@property(nonatomic, strong) NSMutableArray *activityArray;
//推荐专题数据
@property(nonatomic, strong) NSMutableArray *themeArray;
//广告
@property(nonatomic, strong) NSMutableArray *adArray;
@property(nonatomic, strong) UIScrollView *scrollView;
@property(nonatomic, strong) UIPageControl *pageControl;
//定时器用于图片滚动播放
@property(nonatomic, strong) NSTimer *timer;
@property(nonatomic, strong) UIButton *btn1;
@property(nonatomic, strong) UIButton *btn2;
@property (nonatomic, strong) UIButton *leftBtn;
@property (nonatomic, strong) SelectCityModel *cityModel;
//@property (nonatomic, strong) DataBaseManager *dataBase;
@end

@implementation MainViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.navigationController.navigationBar.barTintColor = kColor;
    self.automaticallyAdjustsScrollViewInsets = NO;
    cityId = @"1";
    //注册cell
    [self.tableView registerNib:[UINib nibWithNibName:@"MainTableViewCell" bundle:nil] forCellReuseIdentifier:@"abc"];
    self.leftBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    self.leftBtn.frame = CGRectMake(0, 0, 60, 44);
    [self.leftBtn setImageEdgeInsets:UIEdgeInsetsMake(0, self.leftBtn.frame.size.width - 20, 0, 0)];

    [self.leftBtn setImage:[UIImage imageNamed:@"btn_chengshi"] forState:UIControlStateNormal];
    //调整图片的位置
    
    //调整文字的位置，距离button各个边界的距离
    [self.leftBtn setTitleEdgeInsets:UIEdgeInsetsMake(0, -20, 0, 7)];
    self.leftBtn.titleLabel.font = [UIFont systemFontOfSize:16];
    [self.leftBtn setTitle:@"北京" forState:UIControlStateNormal];

    [self.leftBtn addTarget:self action:@selector(selectCityAction) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *leftBarBtn = [[UIBarButtonItem alloc] initWithCustomView:self.leftBtn];
    
    leftBarBtn.tintColor = [UIColor whiteColor];
    self.navigationItem.leftBarButtonItem = leftBarBtn;
    
    //右边按钮
    UIButton *rightBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    rightBtn.frame = CGRectMake(0, 0, 20, 20);
    [rightBtn setImage:[UIImage imageNamed:@"btn_search"] forState:UIControlStateNormal];
    [rightBtn addTarget:self action:@selector(SearchAcitivity) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *right = [[UIBarButtonItem alloc] initWithCustomView:rightBtn];
    self.navigationItem.rightBarButtonItem = right;
    [self configTableViewHeaderView];
    //请求网络数据
    [self requestModel];
    //启动定时器
    [self startTimer];
    
}

//当主页面再次出来时，tabbar显示
- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    self.tabBarController.tabBar.hidden = NO;
//    self.dataBase = [DataBaseManager sharedInstance];
//    self.cityModel = [self.dataBase selectCityModel];
//    [self.leftBtn setTitle:self.cityModel.cityName forState:UIControlStateNormal];
    [self.listArray removeAllObjects];
    [self.adArray removeAllObjects];
    [self.activityArray removeAllObjects];
    [self.themeArray removeAllObjects];
    [self requestModel];
}
#pragma mark---UITableViewDataSource


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    MainTableViewCell *mainCell = [tableView dequeueReusableCellWithIdentifier:@"abc" forIndexPath:indexPath];
    mainCell.model = self.listArray[indexPath.section][indexPath.row];
    return mainCell;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return self.listArray.count;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    NSArray *array = self.listArray[section];
    return array.count;
}

#pragma mark---UITableViewDelegate


//自定义分区头部
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 26;
}
- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    UIView *view = [[UIView alloc] init];
    UIImageView *sectionView = [[UIImageView alloc] initWithFrame:CGRectMake(kWidth / 2 - 160, 6, 320, 16)];
    if (section == 0) {
        sectionView.image = [UIImage imageNamed:@"home_recommed_ac"];;
    } else {
        sectionView.image = [UIImage imageNamed:@"home_recommd_rc"];
    }
    [view addSubview:sectionView];
    return view;
}



- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 203;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    MainModel *mainModel = self.listArray[indexPath.section][indexPath.row];
    if (indexPath.section == 0) {
        UIStoryboard *mainStoryboard = [UIStoryboard storyboardWithName:@"MainStoryboard" bundle:nil];
        ActivityDetailViewController *aVC = [mainStoryboard instantiateViewControllerWithIdentifier:@"advc"];
        aVC.activityId = mainModel.activityId;
        [self.navigationController pushViewController:aVC animated:YES];
    } else {
        ThemeViewController *tVC = [[ThemeViewController alloc] init];
        tVC.ThemeId = mainModel.activityId;
        [self.navigationController pushViewController:tVC animated:YES];
    }
}



#pragma mark----Custom Method
//自定义tableView头部
- (void)configTableViewHeaderView{
    UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kWidth, 343)];
        //添加轮播图
    self.tableView.tableHeaderView = view;
    self.pageControl.numberOfPages = self.adArray.count;
    [view addSubview:self.scrollView];
    [view addSubview:self.pageControl];
    for (int i = 0; i < self.adArray.count; i++) {
        UIImageView *imageview = [[UIImageView alloc] initWithFrame:CGRectMake(kWidth * i, 0, kWidth, 186)];
        [imageview sd_setImageWithURL:[NSURL URLWithString:self.adArray[i][@"url"]] placeholderImage:nil];
        imageview.userInteractionEnabled = YES;
        [self.scrollView addSubview:imageview];
        UIButton *touchBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        touchBtn.frame = imageview.frame;
        touchBtn.tag = 100 + i;
        [touchBtn addTarget:self action:@selector(touchAD:) forControlEvents:UIControlEventTouchUpInside];
        [self.scrollView addSubview:touchBtn];
    }
    for (int i = 0; i < 4; i++) {
    UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
        btn.frame = CGRectMake(i * kWidth / 4, 186, kWidth / 4, kWidth / 4);
        NSString *str = [NSString stringWithFormat:@"home_icon_%d", i + 1];
        [btn setImage:[UIImage imageNamed:str] forState:UIControlStateNormal];
        btn.tag = 100 + i;
        [btn addTarget:self action:@selector(mainActivityButtonAction:) forControlEvents:UIControlEventTouchUpInside];
        [view addSubview:btn];
    }
    //精选活动
    [view addSubview:self.btn1];
    //热门活动
    [view addSubview:self.btn2];
}
//分类列表
- (void)mainActivityButtonAction:(UIButton *)btn{
    ClassifyViewController *cVVC = [[ClassifyViewController alloc] init];
    cVVC.classifyListType = btn.tag - 100 + 1;
    cVVC.cityID = cityId;
    [self.navigationController pushViewController:cVVC animated:YES];
}
//精选活动
- (void)goodActivityButtonAction{
    GoodActivityViewController *gVC = [[GoodActivityViewController alloc] init];
    
    [self.navigationController pushViewController:gVC animated:YES];
}

//热门专题
- (void)hotActivityButtonAction{
    HotActivityViewController *hVC = [[HotActivityViewController alloc] init];
    [self.navigationController pushViewController:hVC animated:YES];
}

- (void)selectCityAction{
    SelectCityViewController *selectCity = [[SelectCityViewController alloc] init];
    selectCity.selectdelegate = self;
    
    UINavigationController *nav = [[UINavigationController alloc] initWithRootViewController:selectCity];
    [self.navigationController presentViewController:nav animated:YES completion:nil];
}
- (void)getCityName:(NSString *)cityName CityId:(NSString *)cityid{
    [self.leftBtn setTitle:cityName forState:UIControlStateNormal];
    NSInteger edge = -20;
    if (cityName.length > 2) {
        edge = -10;
    }
    [self.leftBtn setImageEdgeInsets:UIEdgeInsetsMake(0, self.leftBtn.frame.size.width + edge, 0, 0)];
    cityId = cityid;
    [self requestModel];
}
- (void)SearchAcitivity{
    SearchViewController *searchVC = [[SearchViewController alloc] init];
    [self.navigationController pushViewController:searchVC animated:YES];
}
//点击广告
- (void)touchAD:(UIButton *)btn{
    NSString *type = self.adArray[btn.tag - 100][@"type"];
    if ([type integerValue] == 1) {
        UIStoryboard *mainSB = [UIStoryboard storyboardWithName:@"MainStoryboard" bundle:nil];
         ActivityDetailViewController *aVC = [mainSB instantiateViewControllerWithIdentifier:@"advc"];
        aVC.activityId = self.adArray[btn.tag - 100][@"id"];
        
        [self.navigationController pushViewController:aVC animated:YES];
    } else {
        ThemeViewController *tVC = [[ThemeViewController alloc] init];
        tVC.ThemeId = self.adArray[btn.tag - 100][@"id"];
        [self.navigationController pushViewController:tVC animated:YES];
        
    }

}

- (void)requestModel{
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    manager.responseSerializer.acceptableContentTypes = [NSSet setWithObject:@"text/html"];
    NSNumber *lat = [[NSUserDefaults standardUserDefaults] valueForKey:@"lat"];
    NSNumber *lng = [[NSUserDefaults standardUserDefaults] valueForKey:@"lng"];

    [manager GET:[NSString stringWithFormat:@"%@&cityid=%ld&lat=%@&lng=%@", kMainDataList, (long)[cityId integerValue], lat, lng] parameters:nil progress:^(NSProgress * _Nonnull downloadProgress) {
        ZLLog(@"%lld", downloadProgress.totalUnitCount);
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        NSDictionary *resultDic = responseObject;
        NSString *status = resultDic[@"status"];
        NSInteger code = [resultDic[@"code"] integerValue];
        if ([status isEqualToString:@"success"] && code == 0) {
            NSDictionary *dic = resultDic[@"success"];
            //推荐活动

            NSArray *acDataArray = dic[@"acData"];
            //广告
            NSArray *adDataArray = dic[@"adData"];
            for (NSDictionary *dic in adDataArray) {
                NSDictionary *dict = @{@"url":dic[@"url"], @"id":dic[@"id"], @"type":dic[@"type"]};
                [self.adArray addObject:dict];
            }
            //拿到数据之后重新刷新headerView
            [self configTableViewHeaderView];
            //推荐专题
            NSArray *rcDataArray = dic[@"rcData"];
            NSString *cityName = dic[@"cityname"];
            //以请求回来的城市作为导航栏标题
            self.navigationItem.leftBarButtonItem.title = cityName;
            for (NSDictionary *dic1 in acDataArray) {
                MainModel *model = [[MainModel alloc] initWithDictionary:dic1];
                [self.activityArray addObject:model];
            }
            [self.listArray addObject:self.activityArray];
            //推荐专题
            for (NSDictionary *dic2 in rcDataArray) {
                MainModel *model = [[MainModel alloc] initWithDictionary:dic2];
                [self.themeArray addObject:model];
            }
            [self.listArray addObject:self.themeArray];
            [self.tableView reloadData];
            
        } else {
            
        }
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        ZLLog(@"%@", error);
    }];
    
}

#pragma mark---懒加载
//懒加载
- (NSMutableArray *)listArray{
    if (_listArray == nil) {
        self.listArray = [NSMutableArray new];
    }
    return _listArray;
}
- (NSMutableArray *)activityArray{
    if (_activityArray == nil) {
        self.activityArray = [NSMutableArray new];
    }
    return _activityArray;
}
- (NSMutableArray *)themeArray{
    if (_themeArray == nil) {
        self.themeArray = [NSMutableArray new];
    }
    return _themeArray;
}
- (NSMutableArray *)adArray{
    if (_adArray == nil) {
        self.adArray = [NSMutableArray new];
    }
    return _adArray;
}
- (UIScrollView *)scrollView{
    if (_scrollView == nil) {
        self.scrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 0, kWidth, 186)];
        self.scrollView.contentSize = CGSizeMake(kWidth * self.adArray.count, 186);
        self.scrollView.pagingEnabled = YES;
        //不显示滚动条
        self.scrollView.showsHorizontalScrollIndicator = NO;
        self.scrollView.delegate = self;
 

    }
    return _scrollView;
}

- (UIPageControl *)pageControl{
    if (_pageControl == nil) {
        self.pageControl = [[UIPageControl alloc] initWithFrame:CGRectMake(0, 186 - 30, kWidth, 30)];
        
        self.pageControl.currentPageIndicatorTintColor = [UIColor cyanColor];
        
        [self.pageControl addTarget:self action:@selector(pageSelectAction:) forControlEvents:UIControlEventValueChanged];
    }
    return _pageControl;
}
- (UIButton *)btn1{
    if (_btn1 == nil) {
        self.btn1 = [UIButton buttonWithType:UIButtonTypeCustom];
        self.btn1.frame = CGRectMake(0, 186 + kWidth / 4, kWidth / 2, 343 - 186 - kWidth / 4);
        NSString *str1 = @"home_huodong";
        [self.btn1 setImage:[UIImage imageNamed:str1] forState:UIControlStateNormal];
        [self.btn1 addTarget:self action:@selector(goodActivityButtonAction) forControlEvents:UIControlEventTouchUpInside];
    }
    return _btn1;
}
- (UIButton *)btn2{
    if (_btn2 == nil) {
        self.btn2 = [UIButton buttonWithType:UIButtonTypeCustom];
        self.btn2.frame = CGRectMake(kWidth / 2, 186 + kWidth / 4, kWidth / 2, 343 - 186 - kWidth / 4);
        NSString *str2 = @"home_zhuanti";
        [self.btn2 setImage:[UIImage imageNamed:str2] forState:UIControlStateNormal];
        [self.btn2 addTarget:self action:@selector(hotActivityButtonAction) forControlEvents:UIControlEventTouchUpInside];
    }
    return _btn2;
}
#pragma mark----首页轮播图

- (void)pageSelectAction:(UIPageControl *)pageControl{
    NSInteger pageNum = pageControl.currentPage;
    CGFloat pageWideth = self.scrollView.frame.size.width;
    self.scrollView.contentOffset = CGPointMake(pageNum * pageWideth, 0);
}
//手动滑动scrollView，定时器依然在计时，所以需要下面两个方法
- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView{
    [self.timer invalidate];
    //停止定时器后设置为nil，再次启动定时器才能正常执行
    self.timer = nil;
}

- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate{
    [self startTimer];
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView{
    CGFloat width = self.scrollView.frame.size.width;
    CGPoint offset = self.scrollView.contentOffset;
    NSInteger pageNum = offset.x / width;
    self.pageControl.currentPage = pageNum;
}


#pragma mark-----轮播图
- (void)startTimer{
    //防止定时器重复创建
    if (self.timer != nil) {
        return;
    }
    self.timer = [NSTimer scheduledTimerWithTimeInterval:2.0 target:self selector:@selector(rollAnimation) userInfo:nil repeats:YES];
    
}

- (void)rollAnimation{
    int page = (int)self.pageControl.currentPage;
    if (page == self.adArray.count - 1) {
        page = 0;
    } else {
        page++;
    }
    CGFloat x = page * kWidth;
    [self.scrollView setContentOffset:CGPointMake(x, 0) animated:YES];
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
