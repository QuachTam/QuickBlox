//
//  ItemsTableViewCell.h
//  QuickBlox
//
//  Created by Tamqn on 2/1/16.
//  Copyright © 2016 Tamqn. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "RWLabel.h"

@interface ItemsTableViewCell : UITableViewCell
@property (weak, nonatomic) IBOutlet RWLabel *nameLabel;
@property (weak, nonatomic) IBOutlet UILabel *moneyLabel;
@property (weak, nonatomic) IBOutlet RWLabel *infoLabel;
@property (weak, nonatomic) IBOutlet UILabel *statusLabel;

@end
