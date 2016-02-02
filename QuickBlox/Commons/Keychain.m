//
//  Keychain.m
//  QuickBlox
//
//  Created by Tamqn on 2/2/16.
//  Copyright © 2016 Tamqn. All rights reserved.
//

#import "Keychain.h"
#import <FDKeychain/FDKeychain.h>

static NSString *emailIdentifier = @"tamqnEmail";
static NSString *passwordIdentifier = @"tamqnPassword";
static NSString *keyAppIdentifier = @"quachtamappshopmanager";

@implementation Keychain

+ (Keychain *)shareInstance {

    static Keychain *_shareInstance = nil;
    static dispatch_once_t oncePredicate;
    dispatch_once(&oncePredicate, ^{
        _shareInstance = [[Keychain alloc] init];
    });
    return _shareInstance;
}

- (void)setKeyChainWithPassword:(NSString *)password email:(NSString*)email{
    [FDKeychain saveItem:email forKey:emailIdentifier forService:keyAppIdentifier error:nil];
    [FDKeychain saveItem:password forKey:passwordIdentifier forService:keyAppIdentifier error:nil];
}

- (void)deleteKeyChain {
    [FDKeychain deleteItemForKey:emailIdentifier forService:keyAppIdentifier error:nil];
    [FDKeychain deleteItemForKey:passwordIdentifier forService:keyAppIdentifier error:nil];
}

- (void)getKeyChain:(void(^)(NSString *password, NSString *email))success {
    NSString *password = [FDKeychain itemForKey:passwordIdentifier
                                     forService:keyAppIdentifier
                                          error:nil];
    
    NSString *email = [FDKeychain itemForKey:emailIdentifier
                                  forService:keyAppIdentifier
                                       error:nil];
    if (success) {
        success(password, email);
    }
}

@end
