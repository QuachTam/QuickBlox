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
#import "Settings.h"

@interface LoginViewController ()
@property (strong, nonatomic) Settings *settings;
@end

@implementation LoginViewController

- (void)setupView {
    self.loginButton.layer.cornerRadius = 4.0f;
    self.loginButton.layer.masksToBounds = YES;
    
    self.loginView.layer.cornerRadius = 4.0f;
    self.loginView.layer.masksToBounds = YES;
    self.settings = Settings.instance;
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
            // connect to Chat
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
                    [CommonFeature showAlertTitle:@"Login Error" Message:@"" duration:2.0 showIn:self blockDismissView:nil];
                }
            } disconnectedBlock:^{
                [MBProgressHUD hideHUDForView:weakSelf.view animated:YES];
                [CommonFeature showAlertTitle:@"Login Error" Message:@"" duration:2.0 showIn:self blockDismissView:nil];
            } reconnectedBlock:^{
                [MBProgressHUD hideHUDForView:weakSelf.view animated:YES];
                [CommonFeature showAlertTitle:@"Login Error" Message:@"" duration:2.0 showIn:self blockDismissView:nil];
            }];
            
        } errorBlock:^(QBResponse *response) {
            [MBProgressHUD hideHUDForView:self.view animated:YES];
            NSLog(@"Response error %@:", response.error);
            [CommonFeature showAlertTitle:@"Login Error" Message:response.error.error.domain duration:2.0 showIn:self blockDismissView:nil];
        }];
    }
}

- (void)applyConfiguration {
    
    NSMutableArray *iceServers = [NSMutableArray array];
    
    for (NSString *url in self.settings.stunServers) {
        
        QBRTCICEServer *server = [QBRTCICEServer serverWithURL:url username:@"" password:@""];
        [iceServers addObject:server];
    }
    
    [iceServers addObjectsFromArray:[self quickbloxICE]];
    
    [QBRTCConfig setICEServers:iceServers];
    [QBRTCConfig setMediaStreamConfiguration:self.settings.mediaConfiguration];
    [QBRTCConfig setStatsReportTimeInterval:1.f];
}

- (NSArray *)quickbloxICE {
    
    NSString *password = @"baccb97ba2d92d71e26eb9886da5f1e0";
    NSString *userName = @"quickblox";
    
    NSArray *urls = @[
                      @"turn.quickblox.com",       //USA
                      @"turnsingapore.quickblox.com",   //Singapore
                      @"turnireland.quickblox.com"      //Ireland
                      ];
    
    NSMutableArray *result = [NSMutableArray arrayWithCapacity:urls.count];
    
    for (NSString *url in urls) {
        
        QBRTCICEServer *stunServer = [QBRTCICEServer serverWithURL:[NSString stringWithFormat:@"stun:%@", url]
                                                          username:@""
                                                          password:@""];
        
        
        QBRTCICEServer *turnUDPServer = [QBRTCICEServer serverWithURL:[NSString stringWithFormat:@"turn:%@:3478?transport=udp", url]
                                                             username:userName
                                                             password:password];
        
        QBRTCICEServer *turnTCPServer = [QBRTCICEServer serverWithURL:[NSString stringWithFormat:@"turn:%@:3478?transport=tcp", url]
                                                             username:userName
                                                             password:password];
        
        [result addObjectsFromArray:@[stunServer, turnTCPServer, turnUDPServer]];
    }
    
    return result;
}


- (void)saveKeychani:(NSString *)email password:(NSString*)password {
    Keychain *keyObject = [Keychain shareInstance];
    [keyObject setKeyChainWithPassword:password email:email];
}

@end
