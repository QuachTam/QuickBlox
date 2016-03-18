//
//  QuickBloxCommon.m
//  QuickBlox
//
//  Created by Tamqn on 3/18/16.
//  Copyright © 2016 Tamqn. All rights reserved.
//

#import "QuickBloxCommon.h"
#import <QuickLook/QuickLook.h>

@interface QuickBloxCommon ()<QBChatDelegate>
@end

@implementation QuickBloxCommon

+ (instancetype)shareInstance {
    static dispatch_once_t predicate;
    static QuickBloxCommon *instance = nil;
    dispatch_once(&predicate, ^{
        instance = [[QuickBloxCommon alloc] init];
    });
    return instance;
}

- (instancetype)init {
    self = [super init];
    if (self) {
        [[QBChat instance] addDelegate:self];
    }
    return self;
}

- (void)addUserToContactListRequestWithID:(NSInteger)userID success:(void(^)(NSError *error))success{
    [[QBChat instance] addUserToContactListRequest:userID completion:^(NSError * _Nullable error) {
        if (success) {
            success (error);
        }
    }];

}

#pragma mark -
#pragma mark QBChatDelegate
- (void)chatDidReceiveContactAddRequestFromUser:(NSUInteger)userID{
    [QBRequest userWithID:userID successBlock:^(QBResponse * _Nonnull response, QBUUser * _Nullable user) {
        [[NSNotificationCenter defaultCenter] postNotificationName:keyNotificationConfirmAddUser object:user userInfo:nil];
    } errorBlock:^(QBResponse * _Nonnull response) {
        NSLog(@"chatDidReceiveContactAddRequestFromUser: %@", response);
    }];
}

- (void)chatDidReceiveAcceptContactRequestFromUser:(NSUInteger)userID{
    // notification confirm add user.
    [QBRequest userWithID:userID successBlock:^(QBResponse * _Nonnull response, QBUUser * _Nullable user) {
        [[NSNotificationCenter defaultCenter] postNotificationName:keyNotificationConfirmAcceptAddUser object:user userInfo:nil];
    } errorBlock:^(QBResponse * _Nonnull response) {
        NSLog(@"chatDidReceiveAcceptContactRequestFromUser: %@", response);
    }];
}

- (void)chatDidReceiveRejectContactRequestFromUser:(NSUInteger)userID {
    [QBRequest userWithID:userID successBlock:^(QBResponse * _Nonnull response, QBUUser * _Nullable user) {
        [[NSNotificationCenter defaultCenter] postNotificationName:keyNotificationReceiveRejectContactRequestFromUser object:user userInfo:nil];
    } errorBlock:^(QBResponse * _Nonnull response) {
        NSLog(@"chatDidReceiveRejectContactRequestFromUser: %@", response);
    }];
}

- (void)chatContactListDidChange:(QBContactList *)contactList{
     
}

- (void)chatDidReceiveContactItemActivity:(NSUInteger)userID isOnline:(BOOL)isOnline status:(NSString *)status{
    
}

#pragma mark _
#pragma mark Action After QBChatDelegate

- (void)confirmAddContactRequest:(NSNotification *)notification{
    QBUUser *userRequest = (QBUUser*)notification.object;
    [[QBChat instance] confirmAddContactRequest:userRequest.ID completion:^(NSError * _Nullable error) {
        
    }];
}

- (void)rejectAddContactRequest:(NSNotification *)notification{
    QBUUser *userRequest = (QBUUser*)notification.object;
    [[QBChat instance] rejectAddContactRequest:userRequest.ID completion:^(NSError * _Nullable error) {
        
    }];
}

@end
