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
            [QBRequest logInWithUserEmail:email password:password successBlock:^(QBResponse *response, QBUUser *user) {
                SWRevealViewController *rootView = [self.storyboard instantiateViewControllerWithIdentifier:@"SWRevealViewController"];
                [self.navigationController pushViewController:rootView animated:YES];
            } errorBlock:^(QBResponse *response) {
                NSLog(@"Response error %@:", response.error);
            }];
        }
    }];
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

- (IBAction)actionForgotPassword:(id)sender {
    
}

-(IBAction)actionLogin:(id)sender {
    if (self.emailTextField.text.length && self.passwordTextField.text.length) {
        [QBRequest logInWithUserEmail:self.emailTextField.text password:self.passwordTextField.text successBlock:^(QBResponse *response, QBUUser *user) {
            SWRevealViewController *rootView = [self.storyboard instantiateViewControllerWithIdentifier:@"SWRevealViewController"];
            [self.navigationController pushViewController:rootView animated:YES];
        } errorBlock:^(QBResponse *response) {
            NSLog(@"Response error %@:", response.error);
        }];
    }
}

- (void)saveKeychani:(NSString *)email password:(NSString*)password {
    Keychain *keyObject = [Keychain shareInstance];
    [keyObject setKeyChainWithPassword:password email:email];
}

@end
