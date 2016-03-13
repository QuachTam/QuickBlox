//
//  CustomViewProfile.m
//  QuickBlox
//
//  Created by Quach Tam on 3/13/16.
//  Copyright © 2016 Tamqn. All rights reserved.
//

#import "CustomViewProfile.h"

@implementation CustomViewProfile

- (void)awakeFromNib {
    self.avatarImage.layer.cornerRadius = self.avatarImage.frame.size.width/2;
    self.avatarImage.layer.borderColor = [UIColor whiteColor].CGColor;
    self.avatarImage.layer.borderWidth = 2.0f;
    self.avatarImage.layer.masksToBounds = YES;
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
