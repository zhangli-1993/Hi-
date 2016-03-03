//
//  SelectCityViewController.m
//  HiWeekend
//
//  Created by scjy on 16/1/6.
//  Copyright © 2016年 scjy. All rights reserved.
//

#import "SelectCityViewController.h"
#import "HeaderCollectionView.h"
#import <AFNetworking/AFHTTPSessionManager.h>
#import "SelectCityModel.h"
#import "MainViewController.h"
//#import "DataBaseManager.h"

static NSString *itemIdentifier = @"item";
static NSString *headerIdentifier = @"header";

@interface SelectCityViewController ()<UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout>
@property (nonatomic, strong) UICollectionView *collectView;
@property (nonatomic, strong) NSMutableArray *cityArray;
@property (nonatomic, strong) HeaderCollectionView *headerView;
@end

@implementation SelectCityViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationItem.title = @"切换城市";
    [self showBackButton:@"camera_cancel_up"];
    self.navigationController.navigationBar.barTintColor = kColor;
    [self.view addSubview:self.collectView];
    //加载数据
    [self loadData];
    
}
- (void)loadData{
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    manager.responseSerializer.acceptableContentTypes = [NSSet setWithObject:@"text/html"];
    [manager GET:kCityList parameters:nil progress:^(NSProgress * _Nonnull downloadProgress) {
        ZLLog(@"%lld", downloadProgress.totalUnitCount);
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        NSDictionary *resultDic = responseObject;
        NSString *status = resultDic[@"status"];
        NSInteger code = [resultDic[@"code"] integerValue];
        if ([status isEqualToString:@"success"] && code == 0) {
            NSDictionary *dic = resultDic[@"success"];
            NSArray *listArray = dic[@"list"];
            for (NSDictionary *dict in listArray) {
                SelectCityModel *cityModel = [[SelectCityModel alloc] initWithDictionary:dict];
                 [self.cityArray addObject:cityModel];
            }
            [self.collectView reloadData];

        } else {
            
        }
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        ZLLog(@"%@", error);
    }];

}

#pragma mark---懒加载
- (UICollectionView *)collectView{
    if (_collectView == nil) {
        //创建一个layout布局类
        UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc] init];
        //设置布局方向为垂直（默认垂直方向）
        layout.scrollDirection = UICollectionViewScrollDirectionVertical;
        layout.headerReferenceSize = CGSizeMake(kWidth, 137);
        //设置item的间距
        layout.minimumInteritemSpacing = 1;
        //设置每一行的间距
        layout.minimumLineSpacing = 1;
        //section的边距
        layout.sectionInset = UIEdgeInsetsMake(1, 0, 0, 0);
        //设置每个item的大小
        //layout.itemSize = CGSizeMake(kWidth / 3 - 10, kWidth / 7);
        //通过一个layout布局来创建一个collectView
        self.collectView = [[UICollectionView alloc] initWithFrame:self.view.frame collectionViewLayout:layout];
        self.collectView.backgroundColor = [UIColor colorWithRed:0.7 green:0.7 blue:0.7 alpha:0.7];
        //设置代理
        self.collectView.dataSource = self;
        self.collectView.delegate = self;
        //注册item类型
        [self.collectView registerClass:[UICollectionViewCell class] forCellWithReuseIdentifier:itemIdentifier];
        [self.collectView registerNib:[UINib nibWithNibName:@"HeaderCollectionView" bundle:nil] forSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:headerIdentifier];
    }
    return _collectView;
}
- (NSMutableArray *)cityArray{
    if (_cityArray == nil) {
        self.cityArray = [NSMutableArray new];
    }
    return _cityArray;
}
#pragma mark---UICollectionViewDataSource
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    return self.cityArray.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    UICollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:itemIdentifier forIndexPath:indexPath];
    cell.backgroundColor = [UIColor whiteColor];
    SelectCityModel *model = self.cityArray[indexPath.row];
    UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, kWidth / 3 - 1, kWidth / 6)];
    label.text = model.cityName;
    label.textAlignment = NSTextAlignmentCenter;
    [cell addSubview:label];
    return cell;
}
- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath{
    return CGSizeMake(kWidth / 3 - 1, kWidth / 6);
}
- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath{
//    DataBaseManager *dataBase = [DataBaseManager sharedInstance];
//    [dataBase deleteModel];
    SelectCityModel *model =  self.cityArray[indexPath.row];
//    [dataBase insertIntoNew:model];
//    self.headerView.locationLabel.text = model.cityName;
//    ZLLog(@"***%@", self.headerView.locationLabel.text);
    if (self.selectdelegate && [self.selectdelegate respondsToSelector:@selector(getCityName:CityId:)]) {
        ZLLog(@"name%@id%@", model.cityName, model.cityId);
        [self.selectdelegate getCityName:model.cityName CityId:model.cityId];
    }
    [self.navigationController dismissViewControllerAnimated:YES completion:nil];

}
#pragma mark---UICollectionViewDelegate
- (UICollectionReusableView *)collectionView:(UICollectionView *)collectionView viewForSupplementaryElementOfKind:(NSString *)kind atIndexPath:(NSIndexPath *)indexPath{
    HeaderCollectionView *headerView = [collectionView dequeueReusableSupplementaryViewOfKind:kind withReuseIdentifier:headerIdentifier forIndexPath:indexPath];
    headerView.backgroundColor = [UIColor colorWithRed:0.7 green:0.7 blue:0.7 alpha:0.7];
    return headerView;
}

#pragma mark---UICollectionViewDelegateFlowLayout


- (void)back{
    [self.navigationController dismissViewControllerAnimated:YES completion:nil];
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
