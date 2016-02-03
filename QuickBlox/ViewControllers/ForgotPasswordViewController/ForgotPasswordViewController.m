//
//  ForgotPasswordViewController.m
//  QuickBlox
//
//  Created by Tamqn on 2/3/16.
//  Copyright © 2016 Tamqn. All rights reserved.
//

#import "ForgotPasswordViewController.h"
#import <QuickBlox/Quickblox.h>

@interface ForgotPasswordViewController ()

@end

@implementation ForgotPasswordViewController

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

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

- (IBAction)actionForgotpassword:(id)sender {
    // Reset User's password with email
    if (self.emailTextField.text.length) {
        [QBRequest resetUserPasswordWithEmail:@"test@test.te" successBlock:^(QBResponse *response) {
            // Reset was successful
            [UIAlertController alertControllerWithTitle:nil message:@"Gui thanh cong" preferredStyle:UIAlertControllerStyleAlert];
        } errorBlock:^(QBResponse *response) {
            // Error
            [UIAlertController alertControllerWithTitle:nil message:@"Da xay ra loi, xin gui lai" preferredStyle:UIAlertControllerStyleAlert];
        }];
    }else{
        [UIAlertController alertControllerWithTitle:nil message:@"Hay nhap vao email" preferredStyle:UIAlertControllerStyleAlert];
    }
}

- (IBAction)actionBackButton:(id)sender {
    [self.navigationController popViewControllerAnimated:YES];
}
@end
