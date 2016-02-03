//
//  SignUpViewController.m
//  QuickBlox
//
//  Created by Tamqn on 1/27/16.
//  Copyright © 2016 Tamqn. All rights reserved.
//

#import "SignUpViewController.h"
#import <Quickblox/Quickblox.h>

@interface SignUpViewController ()

@end

@implementation SignUpViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self.navigationController.navigationBar setHidden:NO];
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    [self.navigationController.navigationBar setHidden:YES];
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

- (IBAction)actionRegisterButton:(id)sender {
    if (self.nameTextField.text.length && self.emailTextField.text.length && self.phoneTextField.text.length && self.passwordTextField.text.length) {
        if ([self.passwordTextField.text isEqualToString:self.rePasswordTextField.text]) {
            QBUUser *user = [QBUUser user];
            user.password = self.passwordTextField.text;
            user.login = self.nameTextField.text;
            user.email = self.emailTextField.text;
            user.phone = self.phoneTextField.text;
            
            // Registration/sign up of User
            [QBRequest signUp:user successBlock:^(QBResponse *response, QBUUser *user) {
                // Sign up was successful
                [self showMessage:@"Dang ky thanh cong"];
            } errorBlock:^(QBResponse *response) {
                // Handle error here
                [self showMessage:@"Dang ky loi"];
            }];
        }else{
            // alert
            [self showMessage:@"Sai mat khau"];
        }
    }else{
        // alert
        [self showMessage:@"Nhap thieu thong tin"];
    }
}

- (void)showMessage:(NSString *)message {
    [UIAlertController alertControllerWithTitle:nil message:message preferredStyle:UIAlertControllerStyleAlert];
}

- (IBAction)actionBackButton:(id)sender {
    [self.navigationController popViewControllerAnimated:YES];
}
@end
