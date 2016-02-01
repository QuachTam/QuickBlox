//
//  ItemsTableViewCell.h
//  QuickBlox
//
//  Created by Tamqn on 2/1/16.
//  Copyright © 2016 Tamqn. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ItemsTableViewCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UIView *nameLabel;
@property (weak, nonatomic) IBOutlet UIView *moneyLabel;
@property (weak, nonatomic) IBOutlet UIView *infoLabel;
@property (weak, nonatomic) IBOutlet UILabel *statusLabel;

@end
