//
//  LoginViewController.m
//  QuickBlox
//
//  Created by Tamqn on 1/22/16.
//  Copyright © 2016 Tamqn. All rights reserved.
//

#import "LoginViewController.h"
#import <Quickblox/Quickblox.h>
#include "SWRevealViewController.h"
#import "Keychain.h"


@interface LoginViewController ()

@end

@implementation LoginViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    Keychain *keyObject = [Keychain shareInstance];
    [keyObject getKeyChain:^(NSString *password, NSString *email) {
        if (email && password) {
            self.emailTextField.text = email;
            self.passwordTextField.text = password;
            [self actionLogin:nil];
        }
    }];
    AdmodManager *managerAd = [AdmodManager sharedInstance];
    [managerAd showAdmodInViewController];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self.navigationController.navigationBar setHidden:NO];
    Keychain *keyObject = [Keychain shareInstance];
    [keyObject getKeyChain:^(NSString *password, NSString *email) {
        if (email && password) {
            self.emailTextField.text = email;
            self.passwordTextField.text = password;
        }else{
            self.emailTextField.text = @"";
            self.passwordTextField.text = @"";
        }
    }];
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    [self.navigationController.navigationBar setHidden:YES];
}

-(IBAction)actionLogin:(id)sender {
    if (self.emailTextField.text.length && self.passwordTextField.text.length) {
        [MBProgressHUD showHUDAddedTo:self.view animated:YES];
        [QBRequest logInWithUserEmail:self.emailTextField.text password:self.passwordTextField.text successBlock:^(QBResponse *response, QBUUser *user) {
            [MBProgressHUD hideHUDForView:self.view animated:YES];
            SWRevealViewController *rootView = [self.storyboard instantiateViewControllerWithIdentifier:@"SWRevealViewController"];
            if (sender) {
                Keychain *keyObject = [Keychain shareInstance];
                [keyObject setKeyChainWithPassword:self.passwordTextField.text email:self.emailTextField.text];
            }
            [self.navigationController pushViewController:rootView animated:YES];
        } errorBlock:^(QBResponse *response) {
            [MBProgressHUD hideHUDForView:self.view animated:YES];
            NSLog(@"Response error %@:", response.error);
        }];
    }
}

- (void)saveKeychani:(NSString *)email password:(NSString*)password {
    Keychain *keyObject = [Keychain shareInstance];
    [keyObject setKeyChainWithPassword:password email:email];
}

@end
