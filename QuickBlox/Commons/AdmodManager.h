//
//  AdmodManager.h
//  QuickBlox
//
//  Created by Tamqn on 3/10/16.
//  Copyright © 2016 Tamqn. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface AdmodManager : NSObject
+ (AdmodManager*)sharedInstance;
- (void)showAdmodInViewController;
@end
