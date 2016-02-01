//
//  AddItemTableViewCell.h
//  QuickBlox
//
//  Created by Tamqn on 2/1/16.
//  Copyright © 2016 Tamqn. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface AddItemTableViewCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UITextField *nameTextField;
@property (weak, nonatomic) IBOutlet UITextField *dateInputTextField;
@property (weak, nonatomic) IBOutlet UITextField *dateOutputTextField;
@property (weak, nonatomic) IBOutlet UITextField *moneyInputTextField;
@property (weak, nonatomic) IBOutlet UITextField *moneyOutput;
@property (weak, nonatomic) IBOutlet UITextView *textViewInfo;

@end
