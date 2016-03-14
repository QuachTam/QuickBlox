//
//  CustomCellProfile.m
//  QuickBlox
//
//  Created by Quach Tam on 3/13/16.
//  Copyright © 2016 Tamqn. All rights reserved.
//

#import "CustomCellProfile.h"

@implementation CustomCellProfile

- (void)awakeFromNib {
    // Initialization code
    self.avatarImage.layer.cornerRadius = self.avatarImage.frame.size.width/2;
    self.avatarImage.layer.masksToBounds = YES;
    self.avatarImage.layer.borderWidth = 2.0f;
    self.avatarImage.layer.masksToBounds = YES;
    self.avatarImage.layer.borderColor = [UIColor whiteColor].CGColor;
    
    UITapGestureRecognizer *singleTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapCall)];
    singleTap.numberOfTapsRequired = 1;
    [self.phoneLabel setUserInteractionEnabled:YES];
    [self.phoneLabel addGestureRecognizer:singleTap];
}

- (BOOL)isPhoneLabel {
    return (self.phoneLabel.text!=nil && self.phoneLabel.text.length>0);
}

- (void)tapCall {
    if ([self isPhoneLabel] && [self scannerPhone]) {
        NSString *phoneNumber = self.phoneLabel.text;
        [[UIApplication sharedApplication] openURL:[NSURL URLWithString:phoneNumber]];
    }
}

- (BOOL)scannerPhone {
    NSScanner *scanner = [NSScanner scannerWithString:self.phoneLabel.text];
    BOOL isNumeric = [scanner scanInteger:NULL] && [scanner isAtEnd];
    return isNumeric;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (IBAction)callAction:(id)sender {
}

- (IBAction)friendAction:(id)sender {
}
@end
