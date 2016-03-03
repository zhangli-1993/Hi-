//
//  LoginViewController.m
//  HiWeekend
//
//  Created by scjy on 16/1/15.
//  Copyright © 2016年 scjy. All rights reserved.
//

#import "LoginViewController.h"
#import <BmobSDK/Bmob.h>
@interface LoginViewController ()
@property (weak, nonatomic) IBOutlet UITextField *emailTextField;
@property (weak, nonatomic) IBOutlet UITextField *codeTextFiled;

@end

@implementation LoginViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self showBackButton:@"back"];
    self.navigationController.navigationBar.barTintColor = kColor;
    self.view.backgroundColor = [UIColor colorWithRed:0.7 green:0.7 blue:0.7 alpha:0.3];
    
    self.title = @"登录";
    
    // Do any additional setup after loading the view.
}
- (IBAction)login:(id)sender {
    [BmobUser loginWithUsernameInBackground:self.emailTextField.text password:self.codeTextFiled.text block:^(BmobUser *user, NSError *error) {
        if (user) {
            ZLLog(@"名字%@", user);
        }
        ZLLog(@"error%@", error);
    }];
}

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
