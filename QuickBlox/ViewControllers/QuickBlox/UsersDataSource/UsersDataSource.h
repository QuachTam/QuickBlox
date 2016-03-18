//
//  UsersDataSource.h
//  QBRTCChatSemple
//
//  Created by Andrey Ivanov on 11.12.14.
//  Copyright (c) 2014 QuickBlox Team. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "QBUUser+IndexAndColor.h"

@interface UsersDataSource : NSObject

@property (strong, nonatomic, readonly) NSArray *users;
@property (strong, nonatomic, readonly) QBUUser *currentUser;
@property (strong, nonatomic, readonly) NSArray *usersWithoutMe;

+ (instancetype)instance;

- (void)loadUsersWithList;
- (UIColor *)colorAtUser:(QBUUser *)user;

- (NSUInteger)indexOfUser:(QBUUser *)user;
- (NSArray *)idsWithUsers:(NSArray *)users;
- (NSArray *)usersWithIDS:(NSArray *)ids;
- (NSArray *)usersWithIDSWithoutMe:(NSArray *)ids;
- (QBUUser *)userWithID:(NSNumber *)userID;

@end
