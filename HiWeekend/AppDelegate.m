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
@interface AppDelegate ()

@end

@implementation AppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    self.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    // Override point for customization after application launch.

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
