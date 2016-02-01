//
//  ItemsTableViewCell.m
//  QuickBlox
//
//  Created by Tamqn on 2/1/16.
//  Copyright © 2016 Tamqn. All rights reserved.
//

#import "ItemsTableViewCell.h"

@implementation ItemsTableViewCell

- (void)awakeFromNib {
    // Initialization code
    self.statusLabel.layer.cornerRadius = self.statusLabel.frame.size.width/2;
    self.statusLabel.layer.masksToBounds = YES;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
