//
//  ItemsTableViewController.h
//  QuickBlox
//
//  Created by Tamqn on 2/1/16.
//  Copyright © 2016 Tamqn. All rights reserved.
//
@class GADBannerView;

#import <UIKit/UIKit.h>
#import "SWRevealViewController.h"

@interface ItemsTableViewController : UITableViewController
@property (weak, nonatomic) IBOutlet UIButton *menuButton;
- (IBAction)actionQRCode:(id)sender;
@property(nonatomic, strong) IBOutlet GADBannerView *bannerView;

@end
