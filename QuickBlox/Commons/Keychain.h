//
//  Keychain.h
//  QuickBlox
//
//  Created by Tamqn on 2/2/16.
//  Copyright © 2016 Tamqn. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Keychain : NSObject
+ (Keychain *)shareInstance;
- (void)deleteKeyChain;
- (void)setKeyChainWithPassword:(NSString *)password email:(NSString*)email;
- (void)getKeyChain:(void(^)(NSString *password, NSString *email))success;
@end
