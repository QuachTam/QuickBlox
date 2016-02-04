//
//  AddItemTableViewCell.h
//  QuickBlox
//
//  Created by Tamqn on 2/1/16.
//  Copyright © 2016 Tamqn. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ModelItem.h"

@interface AddItemTableViewCell : UITableViewCell
@property (nonatomic, strong) ModelItem *modelItem;
@property (weak, nonatomic) IBOutlet UITextField *nameTextField;
@property (weak, nonatomic) IBOutlet UITextField *dateInputTextField;
@property (weak, nonatomic) IBOutlet UITextField *dateOutputTextField;
@property (weak, nonatomic) IBOutlet UITextField *moneyInputTextField;
@property (weak, nonatomic) IBOutlet UITextField *moneyOutputTextField;
@property (weak, nonatomic) IBOutlet UITextField *qrCodeTextField;
@property (weak, nonatomic) IBOutlet UITextView *infoTextView;

- (void)actionValidInput:(void(^)(BOOL isValid))success;
- (void)setupDataForCell;
@end
