//
//  SubStatisticsViewController.h
//  QuickBlox
//
//  Created by Quach Tam on 3/2/16.
//  Copyright © 2016 Tamqn. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SubStatisticsViewController : UIViewController<UITableViewDelegate, UITableViewDataSource>
- (IBAction)actionBackView:(id)sender;
@property (weak, nonatomic) IBOutlet UITableView *tbView;
@property (nonatomic, strong) NSArray *arrayData;
@end
