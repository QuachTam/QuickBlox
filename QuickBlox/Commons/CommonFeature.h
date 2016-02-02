//
//  CommonFeature.h
//  QuickBlox
//
//  Created by Tamqn on 2/2/16.
//  Copyright © 2016 Tamqn. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface CommonFeature : NSObject
+ (CommonFeature*)shareInstance;
+ (void)setShadownWithBoderWidth:(NSInteger)width view:(UIView*)view;
@end
