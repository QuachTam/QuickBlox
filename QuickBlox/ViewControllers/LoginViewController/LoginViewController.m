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
#import "ChatManager.h"


@interface LoginViewController ()

@end

@implementation LoginViewController

- (void)setupView {
    self.loginButton.layer.cornerRadius = 4.0f;
    self.loginButton.layer.masksToBounds = YES;
    
    self.loginView.layer.cornerRadius = 4.0f;
    self.loginView.layer.masksToBounds = YES;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self setupView];
    
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
            __weak __typeof(self)weakSelf = self;
            QBUUser *current = [QBSession currentSession].currentUser;
            current.password = self.passwordTextField.text;
            [[ChatManager instance] logInWithUser:current completion:^(BOOL error) {
                if (!error) {
                    [MBProgressHUD hideHUDForView:weakSelf.view animated:YES];
                    SWRevealViewController *rootView = [weakSelf.storyboard instantiateViewControllerWithIdentifier:@"SWRevealViewController"];
                    if (sender) {
                        Keychain *keyObject = [Keychain shareInstance];
                        [keyObject setKeyChainWithPassword:weakSelf.passwordTextField.text email:weakSelf.emailTextField.text];
                    }
                    [weakSelf.navigationController pushViewController:rootView animated:YES];
                }
                else {
                    [MBProgressHUD hideHUDForView:weakSelf.view animated:YES];
                }
            } disconnectedBlock:^{
                [MBProgressHUD hideHUDForView:weakSelf.view animated:YES];
            } reconnectedBlock:^{
                [MBProgressHUD hideHUDForView:weakSelf.view animated:YES];
            }];
            
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
