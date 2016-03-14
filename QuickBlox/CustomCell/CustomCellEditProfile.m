//
//  CustomCellEditProfile.m
//  QuickBlox
//
//  Created by Quach Tam on 3/13/16.
//  Copyright © 2016 Tamqn. All rights reserved.
//

#import "CustomCellEditProfile.h"

@implementation CustomCellEditProfile

- (void)awakeFromNib {
    // Initialization code
    UITapGestureRecognizer *singleTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(changeAvatar)];
    singleTap.numberOfTapsRequired = 1;
    [self.avatarImageView setUserInteractionEnabled:YES];
    [self.avatarImageView addGestureRecognizer:singleTap];
    
    self.avatarImageView.layer.cornerRadius = self.avatarImageView.frame.size.width/2;
    self.avatarImageView.layer.masksToBounds = YES;
    self.avatarImageView.layer.borderWidth = 2.0f;
    self.avatarImageView.layer.masksToBounds = YES;
    self.avatarImageView.layer.borderColor = [UIColor whiteColor].CGColor;
}

-(void)changeAvatar{
    if (self.didClickUpdateAvatar) {
        self.didClickUpdateAvatar();
    }
}

- (BOOL)isNameTextField {
    return (self.nameTextField.text!=nil && self.nameTextField.text.length>0);
}

- (BOOL)isPhoneTextField {
    return (self.phoneTextField.text!=nil && self.phoneTextField.text.length>0);
}

- (BOOL)isAddressTextField {
    return (self.addressTextField.text!=nil && self.addressTextField.text.length>0);
}

- (BOOL)isDescriptionTextView {
    return (self.descriptionTextView.text!=nil && self.descriptionTextView.text.length>0);
}

- (void)actionValidInput:(void(^)(BOOL isValid))success {
    BOOL isValidInput = YES;
    if (![self isNameTextField]) {
        isValidInput = NO;
        self.nameTextField.backgroundColor = [UIColor redColor];
    }else{
        self.nameTextField.backgroundColor = [UIColor whiteColor];
    }
    
    if (![self isPhoneTextField]) {
        isValidInput = NO;
        self.phoneTextField.backgroundColor = [UIColor redColor];
    }else{
        self.phoneTextField.backgroundColor = [UIColor whiteColor];
    }
    
    if (![self isAddressTextField]) {
        isValidInput = NO;
        self.addressTextField.backgroundColor = [UIColor redColor];
    }else{
        self.addressTextField.backgroundColor = [UIColor whiteColor];
    }
    
    if (![self isDescriptionTextView]) {
        isValidInput = NO;
        self.descriptionTextView.backgroundColor = [UIColor redColor];
    }else{
        self.descriptionTextView.backgroundColor = [UIColor whiteColor];
    }
    if (success) {
        success (isValidInput);
    }
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
