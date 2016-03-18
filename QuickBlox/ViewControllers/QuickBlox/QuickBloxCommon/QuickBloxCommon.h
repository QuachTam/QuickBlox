//
//  QuickBloxCommon.h
//  QuickBlox
//
//  Created by Tamqn on 3/18/16.
//  Copyright © 2016 Tamqn. All rights reserved.
//

#import <Foundation/Foundation.h>

static NSString *keyNotificationConfirmAddUser = @"keyNotificationConfirmAddUser";
static NSString *keyNotificationConfirmAcceptAddUser = @"keyNotificationConfirmAcceptAddUser";
static NSString *keyNotificationReceiveRejectContactRequestFromUser = @"keyNotificationReceiveRejectContactRequestFromUser";
@interface QuickBloxCommon : NSObject
+ (instancetype)shareInstance;
- (void)addUserToContactListRequestWithID:(NSInteger)userID success:(void(^)(NSError *error))success;
@end
