//
//  ForgotPasswordViewController.h
//  QuickBlox
//
//  Created by Tamqn on 2/3/16.
//  Copyright © 2016 Tamqn. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ForgotPasswordViewController : UIViewController
@property (weak, nonatomic) IBOutlet UITextField *emailTextField;
- (IBAction)actionForgotpassword:(id)sender;
- (IBAction)actionBackButton:(id)sender;

@end
