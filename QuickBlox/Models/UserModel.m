//
//  UserModel.m
//  QuickBlox
//
//  Created by Tamqn on 3/14/16.
//  Copyright © 2016 Tamqn. All rights reserved.
//

#import "UserModel.h"

@implementation UserModel

- (instancetype)initWithUser:(QBUUser *)user blob:(QBCBlob *)blob {
    self = [super init];
    if (self) {
        self.user = user;
    }
    return self;
}

- (NSString *)fullName {
    if (!_fullName) {
        _fullName = self.user.fullName ? self.user.fullName : @"";
    }
    return _fullName;
}

- (NSString *)descriptions {
    if (!_descriptions) {
        if (self.user.customData) {
            NSData *data = [self.user.customData dataUsingEncoding:NSUTF8StringEncoding];
            NSDictionary *jsonResponse = [NSJSONSerialization JSONObjectWithData:data
                                                                         options:kNilOptions
                                                                           error:nil];
            if (jsonResponse) {
                _descriptions = [jsonResponse valueForKey:@"description"];
            }else{
                _descriptions=  @"";
            }
        }else{
            _descriptions = @"";
        }
    }
    return _descriptions;
}

- (NSString *)privateUrl {
    if (!_privateUrl) {
        _privateUrl = self.blob.privateUrl ? self.blob.privateUrl : @"";
    }
    return _privateUrl;
}

@end
