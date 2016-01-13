//
//  AppDelegate.m
//  HiWeekend
//
//  Created by scjy on 16/1/4.
//  Copyright © 2016年 scjy. All rights reserved.
//

#import "AppDelegate.h"
#import "MainViewController.h"
#import "DiscoverViewController.h"
#import "MineViewController.h"
#import "WeiboSDK.h"
@interface AppDelegate ()<WeiboSDKDelegate>

@property (strong, nonatomic) NSString *wbRefreshToken;
@property (strong, nonatomic) NSString *wbCurrentUserID;


@end

@implementation AppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    self.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    // Override point for customization after application launch.
    [WeiboSDK enableDebugMode:YES];
    [WeiboSDK registerApp:kAppKey];

    self.tab = [[UITabBarController alloc] init];
    self.tab.tabBar.barTintColor = [UIColor whiteColor];
    
    
    //主页
    UIStoryboard *main = [UIStoryboard storyboardWithName:@"MainStoryboard" bundle:nil];
    UINavigationController *mainNav = main.instantiateInitialViewController;
    //mainNav.tabBarItem.title = @"主页";
    mainNav.tabBarItem.image = [UIImage imageNamed:@"ft_home_normal_ic"];
    mainNav.tabBarItem.imageInsets = UIEdgeInsetsMake(6, 0, -6, 0);
    //tabbar设置选中图片按照原始状态显示
    UIImage *image = [UIImage imageNamed:@"ft_home_selected_ic"];
    mainNav.tabBarItem.selectedImage = [image imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    
    
    //发现
    UIStoryboard *discovery = [UIStoryboard storyboardWithName:@"DiscoverStoryboard" bundle:nil];
    UINavigationController *nav2 = discovery.instantiateInitialViewController;
    //nav2.tabBarItem.title = @"发现";
    nav2.tabBarItem.image = [UIImage imageNamed:@"ft_found_normal_ic"];
    nav2.tabBarItem.imageInsets = UIEdgeInsetsMake(6, 0, -6, 0);
    UIImage *image1 = [UIImage imageNamed:@"ft_found_selected_ic"];
    nav2.tabBarItem.selectedImage = [image1 imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    
    
    //我的
    UIStoryboard *mine = [UIStoryboard storyboardWithName:@"MineStoryboard" bundle:nil];
    UINavigationController *nav3 = mine.instantiateInitialViewController;
    //nav3.tabBarItem.title = @"我的";
    nav3.tabBarItem.image = [UIImage imageNamed:@"ft_person_normal_ic"];
    //按照上左下右的顺序设置
    nav3.tabBarItem.imageInsets = UIEdgeInsetsMake(6, 0, -6, 0);
    UIImage *image2 = [UIImage imageNamed:@"ft_person_selected_ic"];
    nav3.tabBarItem.selectedImage = [image2 imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    
    
    
    //添加被管理的视图控制器
    self.tab.viewControllers = @[mainNav, nav2, nav3];
    
    self.window.rootViewController = self.tab;
    self.window.backgroundColor = [UIColor whiteColor];
    [self.window makeKeyAndVisible];
    return YES;
}
#pragma mark---微博分享
- (BOOL)application:(UIApplication *)application openURL:(NSURL *)url sourceApplication:(NSString *)sourceApplication annotation:(id)annotation{
    return [WeiboSDK handleOpenURL:url delegate:self];
}
- (BOOL)application:(UIApplication *)application handleOpenURL:(NSURL *)url{
    return [WeiboSDK handleOpenURL:url delegate:self];
}
- (void)didReceiveWeiboRequest:(WBBaseRequest *)request{
    
}

- (void)didReceiveWeiboResponse:(WBBaseResponse *)response{
//    if ([response isKindOfClass:WBSendMessageToWeiboResponse.class])
//    {
//        NSString *title = NSLocalizedString(@"发送结果", nil);
//        NSString *message = [NSString stringWithFormat:@"%@: %d\n%@: %@\n%@: %@", NSLocalizedString(@"响应状态", nil), (int)response.statusCode, NSLocalizedString(@"响应UserInfo数据", nil), response.userInfo, NSLocalizedString(@"原请求UserInfo数据", nil),response.requestUserInfo];
//        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:title message:message delegate:nil cancelButtonTitle:NSLocalizedString(@"确定", nil) otherButtonTitles:nil];
//        WBSendMessageToWeiboResponse* sendMessageToWeiboResponse = (WBSendMessageToWeiboResponse*)response;
//        NSString* accessToken = [sendMessageToWeiboResponse.authResponse accessToken];
//        if (accessToken)
//        {
//            self.wbtoken = accessToken;
//        }
//        NSString* userID = [sendMessageToWeiboResponse.authResponse userID];
//        if (userID) {
//            self.wbCurrentUserID = userID;
//        }
//        [alert show];
//    }    else if ([response isKindOfClass:WBAuthorizeResponse.class])
//    {
//        NSString *title = NSLocalizedString(@"认证结果", nil);
//        NSString *message = [NSString stringWithFormat:@"%@: %d\nresponse.userId: %@\nresponse.accessToken: %@\n%@: %@\n%@: %@", NSLocalizedString(@"响应状态", nil), (int)response.statusCode,[(WBAuthorizeResponse *)response userID], [(WBAuthorizeResponse *)response accessToken],  NSLocalizedString(@"响应UserInfo数据", nil), response.userInfo, NSLocalizedString(@"原请求UserInfo数据", nil), response.requestUserInfo];
//        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:title message:message delegate:nil cancelButtonTitle:NSLocalizedString(@"确定", nil) otherButtonTitles:nil];
//        self.wbtoken = [(WBAuthorizeResponse *)response accessToken];
//        self.wbCurrentUserID = [(WBAuthorizeResponse *)response userID];
//        self.wbRefreshToken = [(WBAuthorizeResponse *)response refreshToken];
//        [alert show];
//    }
}

- (void)applicationWillResignActive:(UIApplication *)application {
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}

- (void)applicationDidEnterBackground:(UIApplication *)application {
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}

- (void)applicationWillEnterForeground:(UIApplication *)application {
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
}

- (void)applicationDidBecomeActive:(UIApplication *)application {
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}

- (void)applicationWillTerminate:(UIApplication *)application {
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}

@end
