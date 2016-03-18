//
//  ServiceFriends.h
//  QuickBlox
//
//  Created by Tamqn on 3/18/16.
//  Copyright © 2016 Tamqn. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ServiceFriends : NSObject
@property(nonatomic, readwrite, copy) void(^didCompleteFetchFriends)();
- (void)getListFriendsSuccess:(void(^)(NSArray *listFriends))success;

@end
