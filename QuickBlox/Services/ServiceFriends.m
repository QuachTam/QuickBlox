//
//  ServiceFriends.m
//  QuickBlox
//
//  Created by Tamqn on 3/18/16.
//  Copyright © 2016 Tamqn. All rights reserved.
//

#import "ServiceFriends.h"
#import <QuickLook/QuickLook.h>
#import "UserModel.h"

@interface ServiceFriends ()
@property (nonatomic, strong) NSMutableArray *contactList;
@property (nonatomic, strong) NSMutableArray *friendsList;
@end
@implementation ServiceFriends

- (instancetype)init {
    self = [super init];
    if (self) {
        self.contactList = [NSMutableArray new];
        self.friendsList = [NSMutableArray new];
    }
    return self;
}

- (void)getListFriendsSuccess:(void(^)(NSArray *listFriends))success {
    [self.friendsList removeAllObjects];
    self.contactList = [NSMutableArray arrayWithArray:[QBChat instance].contactList.contacts];
    self.didCompleteFetchFriends = ^{
        if (success) {
            success ([self.friendsList copy]);
        }
    };
}

- (void)startFetchUser{
    if (self.contactList.count) {
        QBContactListItem *firstItem = [self.contactList objectAtIndex:0];
        [self getUserWithID:firstItem.userID];
    }else{
        if (self.didCompleteFetchFriends) {
            self.didCompleteFetchFriends();
        }
    }
}

- (void)getUserWithID:(NSInteger)userID {
    if (userID>1) {
        [QBRequest userWithID:userID successBlock:^(QBResponse * _Nonnull response, QBUUser * _Nullable user) {
            [self.contactList removeObjectAtIndex:0];
            __block UserModel *model;
            if (user) {
                [QBRequest blobWithID:user.blobID successBlock:^(QBResponse * _Nonnull response, QBCBlob * _Nullable blob) {
                    model = [[UserModel alloc] initWithUser:user blob:blob];
                    [self.friendsList addObject:model];
                    [self startFetchUser];
                } errorBlock:^(QBResponse * _Nonnull response) {
                    model = [[UserModel alloc] initWithUser:user blob:[QBCBlob new]];
                    [self startFetchUser];
                }];
            }else{
                [self startFetchUser];
            }
        } errorBlock:^(QBResponse * _Nonnull response) {
            [self startFetchUser];
        }];
    }else{
        [self startFetchUser];
    }
}

@end
