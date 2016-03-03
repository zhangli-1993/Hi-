//
//  RegisterViewController.m
//  HiWeekend
//
//  Created by scjy on 16/3/2.
//  Copyright © 2016年 scjy. All rights reserved.
//

#import "RegisterViewController.h"
#import <BmobSDK/BmobUser.h>
#import "ProgressHUD.h"
@interface RegisterViewController ()<UITextFieldDelegate>
@property (weak, nonatomic) IBOutlet UITextField *userNameTF;
@property (weak, nonatomic) IBOutlet UITextField *CodeTF;
@property (weak, nonatomic) IBOutlet UITextField *SureCodeTF;
@property (weak, nonatomic) IBOutlet UISwitch *codeSwitch;

@end

@implementation RegisterViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"注册";
    self.view.backgroundColor = [UIColor colorWithRed:0.7 green:0.7 blue:0.7 alpha:0.3];
    [self showBackButton:@"back"];
    //密码密文显示
    self.CodeTF.secureTextEntry = YES;
    self.SureCodeTF.secureTextEntry = YES;
    //默认switch关闭
    self.codeSwitch.on = NO;
    // Do any additional setup after loading the view.
}
- (IBAction)pressSwitchAction:(id)sender {
    UISwitch *codeSwitch = sender;
    if (codeSwitch.on) {
        self.CodeTF.secureTextEntry = NO;
        self.SureCodeTF.secureTextEntry = NO;
    } else {
        self.CodeTF.secureTextEntry = YES;
        self.SureCodeTF.secureTextEntry = YES;

    }
}
- (IBAction)registerAction:(id)sender {
    if (![self checkout]) {
        return;
    }
    [ProgressHUD show:@"正在为您注册..."];
    BmobUser *bmobUser = [[BmobUser alloc] init];
    [bmobUser setUsername:self.userNameTF.text];
    [bmobUser setPassword:self.CodeTF.text];
    [bmobUser signUpInBackgroundWithBlock:^(BOOL isSuccessful, NSError *error) {
        if (isSuccessful) {
            [ProgressHUD showSuccess:@"注册成功"];
             ZLLog(@"注册成功");
        } else {
            [ProgressHUD showError:@"注册失败"];
            ZLLog(@"注册失败");
        }
    }];
}
- (BOOL)checkout{
    //注册之前需要判断用户名不能为空且不能为空格
    if (self.userNameTF.text.length <= 0 || [self.userNameTF.text stringByReplacingOccurrencesOfString:@" " withString:@""].length <= 0) {
        //alert提示框
        UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"温馨提示" message:@"用户名不能为空" preferredStyle:UIAlertControllerStyleAlert];
        UIAlertAction *alertAction1 = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
            
        }];
        UIAlertAction *alertAction2 = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
            
        }];
        [alert addAction:alertAction1];
        [alert addAction:alertAction2];
        [self presentViewController:alert animated:YES completion:nil];
         return NO;
    }
    //两次输入密码一致
    if (![self.CodeTF.text isEqualToString:self.SureCodeTF.text]) {
        //alert提示框
        UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"温馨提示" message:@"两次输入密码不一致" preferredStyle:UIAlertControllerStyleAlert];
        UIAlertAction *alertAction1 = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
            
        }];
        UIAlertAction *alertAction2 = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
            
        }];
        [alert addAction:alertAction1];
        [alert addAction:alertAction2];
        [self presentViewController:alert animated:YES completion:nil];

        return NO;
    }
    //输入的密码不能为空
    if (self.CodeTF.text.length <= 0) {
        UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"温馨提示" message:@"输入的密码不能为空" preferredStyle:UIAlertControllerStyleAlert];
        UIAlertAction *alertAction1 = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
            
        }];
        UIAlertAction *alertAction2 = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
            
        }];
        [alert addAction:alertAction1];
        [alert addAction:alertAction2];
        [self presentViewController:alert animated:YES completion:nil];

        return NO;
    }
    //正则表达式
    //判断手机号是否有效
    
    //判断邮箱是否存在
    return YES;
}
#pragma mark---UITextFieldDelegate
//点击右下角回收键盘
- (BOOL)textFieldShouldReturn:(UITextField *)textField{
    [textField resignFirstResponder];
    return YES;
}
//点击空白处回收键盘
- (void)touchesEnded:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
//    [self.userNameTF resignFirstResponder];
//    [self.CodeTF resignFirstResponder];
//    [self.SureCodeTF resignFirstResponder];
    [self.view endEditing:YES];
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
