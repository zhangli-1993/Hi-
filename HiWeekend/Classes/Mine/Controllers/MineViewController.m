//
//  MineViewController.m
//  HiWeekend
//
//  Created by scjy on 16/1/4.
//  Copyright © 2016年 scjy. All rights reserved.
//

#import "MineViewController.h"
#import <SDWebImage/SDImageCache.h>
#import <MessageUI/MessageUI.h>
#import "ProgressHUD.h"
#import "WeiboSDK.h"
#import "AppDelegate.h"
#import "ShareView.h"

@interface MineViewController ()<UITableViewDelegate, UITableViewDataSource, MFMailComposeViewControllerDelegate, WBHttpRequestDelegate>
@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) UIButton *headImageBtn;
@property (nonatomic, strong) NSArray *imageArray;
@property (nonatomic, strong) NSMutableArray *titleArray;
@property (nonatomic, strong) UILabel *nikeNameLabel;
@property (nonatomic, strong) ShareView *shareView;

@end

@implementation MineViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self.view addSubview:self.tableView];
    [self setHeaderView];
    self.navigationController.navigationBar.barTintColor = kColor;
    self.imageArray = @[@"clear", @"return", @"share", @"user", @"now"];
    self.titleArray = [NSMutableArray arrayWithObjects:@"清除缓存", @"用户反馈", @"分享给好友", @"给我评分", @"当前版本1.0", nil];

}

- (void)viewWillAppear:(BOOL)animated{
    SDImageCache *cache = [SDImageCache sharedImageCache];
    NSInteger cacheSize = [cache getSize];
    NSString *cacheStr = [NSString stringWithFormat:@"清除图片缓存(%.2fM)", (CGFloat)cacheSize / 1024 / 1024];
    [self.titleArray replaceObjectAtIndex:0 withObject:cacheStr];
    NSIndexPath *index = [NSIndexPath indexPathForRow:0 inSection:0];
    [self.tableView reloadRowsAtIndexPaths:@[index] withRowAnimation:UITableViewRowAnimationAutomatic];

}



#pragma mark---UITableViewDataSource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return 5;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    static NSString *str = @"mine";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:str];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:str];
    }
    cell.selectionStyle = UITableViewCellSelectionStyleNone;

    cell.imageView.image = [UIImage imageNamed:self.imageArray[indexPath.row]];
    cell.textLabel.text = self.titleArray[indexPath.row];
    cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    return cell;
}

#pragma mark----UITableViewDelegate
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    switch (indexPath.row) {
        case 0:
        {
            SDImageCache *cache = [SDImageCache sharedImageCache];
            [cache clearDisk];
            [self.titleArray replaceObjectAtIndex:0 withObject:@"清除缓存"];
            NSIndexPath *index = [NSIndexPath indexPathForRow:0 inSection:0];
            [self.tableView reloadRowsAtIndexPaths:@[index] withRowAnimation:UITableViewRowAnimationAutomatic];

        }
            break;
        case 1:
        {
            [self sendEmail];
        }
            
            break;
        case 2:
        {
            [self share];
 
        }
            
            break;
        case 3:
        {
            NSString *str = [NSString stringWithFormat:
                             @"itms-apps://itunes.apple.com/app"];
            [[UIApplication sharedApplication] openURL:[NSURL URLWithString:str]];
        }
            
            break;
        case 4:
        {
            //检测当前版本
            [ProgressHUD show:@"正在检测中..."];
            [self performSelector:@selector(checkVerson) withObject:nil afterDelay:2.0];
        }
            break;
        default:
            break;
    }
    
}
#pragma mark--自定义
- (void)setHeaderView{
    UIView *headView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kWidth, 200)];
    headView.backgroundColor = kColor;
    self.tableView.tableHeaderView = headView;
    self.headImageBtn=[UIButton buttonWithType:UIButtonTypeCustom];
    self.headImageBtn.frame=CGRectMake(25, 40, kWidth/3, kWidth/3);
    self.headImageBtn.layer.cornerRadius=kWidth/6;
    self.headImageBtn.clipsToBounds=YES;
    [self.headImageBtn setTitle:@"登录/注册" forState:UIControlStateNormal];
    [self.headImageBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    self.headImageBtn.backgroundColor=[UIColor whiteColor];
    [self.headImageBtn addTarget:self action:@selector(login) forControlEvents:UIControlEventTouchUpInside];
    [headView addSubview:self.headImageBtn];
    [headView addSubview:self.nikeNameLabel];
}

- (void)login{
    
}

- (void)sendEmail{
    Class mailClass = NSClassFromString(@"MFMailComposeViewController");
    if (mailClass != nil) {
        if ([MFMailComposeViewController canSendMail]) {
            MFMailComposeViewController *picker = [[MFMailComposeViewController alloc] init];
            picker.mailComposeDelegate = self;
            //设置主题
            [picker setSubject:@"用户信息反馈"];
            //设置收件人
            NSArray *toRecipients = [NSArray arrayWithObjects:@"2678976615@qq.com", nil];
            [picker setToRecipients:toRecipients];
            //设置发送内容
            NSString *text = @"请留下您宝贵的意见";
            [picker setMessageBody:text isHTML:NO];
            [self presentModalViewController:picker animated:YES];

        } else {
            ZLLog(@"未配置邮箱账号");
        }
    } else {
        ZLLog(@"当前设备不能发送");
    }
}

-(void)mailComposeController:(MFMailComposeViewController *)controller didFinishWithResult:(MFMailComposeResult)result error:(NSError *)error
{
    switch (result)
    {
        case MFMailComposeResultCancelled: //取消
            NSLog(@"MFMailComposeResultCancelled-取消");
            break;
        case MFMailComposeResultSaved: // 保存
            NSLog(@"MFMailComposeResultSaved-保存邮件");
            break;
        case MFMailComposeResultSent: // 发送
            NSLog(@"MFMailComposeResultSent-发送邮件");
            break;
        case MFMailComposeResultFailed: // 尝试保存或发送邮件失败
            NSLog(@"MFMailComposeResultFailed: %@...",[error localizedDescription]);
            break;
    }
    
    // 关闭邮件发送视图
    [self dismissViewControllerAnimated:YES completion:nil];
}
- (void)checkVerson{
    [ProgressHUD showSuccess:@"当前已是最新版本"];
}

- (void)share{
    self.shareView = [[ShareView alloc] init];
}
    
#pragma mark---WBHttpRequestDelegate
- (void)request:(WBHttpRequest *)request didFinishLoadingWithResult:(NSString *)result{
    
}



#pragma mark---懒加载
- (UITableView *)tableView{
    if (_tableView == nil) {
        self.tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, kWidth, kHeight - 64 - 44) style:UITableViewStylePlain];
        self.tableView.delegate = self;
        self.tableView.dataSource = self;
        self.tableView.rowHeight = 80;

    }
    return _tableView;
}

- (UILabel *)nikeNameLabel{
    if (_nikeNameLabel == nil) {
        self.nikeNameLabel = [[UILabel alloc] initWithFrame:CGRectMake(190, 80, kWidth - 200, 40)];
        self.nikeNameLabel.text = @"欢迎来到Hi周末";
        self.nikeNameLabel.textColor = [UIColor whiteColor];
        self.nikeNameLabel.numberOfLines = 0;
    }
    return _nikeNameLabel;
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
