//
//  UserModel.h
//  QuickBlox
//
//  Created by Tamqn on 3/14/16.
//  Copyright © 2016 Tamqn. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <QuickBlox/Quickblox.h>

@interface UserModel : NSObject
@property (nonatomic, strong) NSString *fullName;
@property (nonatomic, strong) NSString *descriptions;
@property (nonatomic, strong) NSString *privateUrl;

@property (nonatomic, strong) QBCBlob *blob;
@property (nonatomic, strong) QBUUser *user;
- (instancetype)initWithUser:(QBUUser *)user blob:(QBCBlob *)blob;
@end
