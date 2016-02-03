//
//  AddItemViewController.h
//  QuickBlox
//
//  Created by Tamqn on 2/1/16.
//  Copyright © 2016 Tamqn. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ModelItem.h"

@interface AddItemViewController : UITableViewController
@property (weak, nonatomic) IBOutlet UILabel *titleViewLabel;
@property (nonatomic, strong) ModelItem *modelItem;
- (IBAction)actionBackButton:(id)sender;
- (IBAction)actionDoneButton:(id)sender;


@end
