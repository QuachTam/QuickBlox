//
//  CustomCellMember.h
//  QuickBlox
//
//  Created by Tamqn on 3/14/16.
//  Copyright © 2016 Tamqn. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "RWLabel.h"

@interface CustomCellMember : UITableViewCell
@property (weak, nonatomic) IBOutlet UIImageView *avatarImageView;
@property (weak, nonatomic) IBOutlet RWLabel *nameLabel;
@property (weak, nonatomic) IBOutlet RWLabel *descriptionLabel;
@property (weak, nonatomic) IBOutlet UIButton *friendButton;
@property (weak, nonatomic) IBOutlet UIActivityIndicatorView *indicator;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *constraintWidthButtonAddfriend;

@end
