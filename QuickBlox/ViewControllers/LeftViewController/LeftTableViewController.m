//
//  LeftTableViewController.m
//  QuickBlox
//
//  Created by Tamqn on 1/22/16.
//  Copyright © 2016 Tamqn. All rights reserved.
//

#import "LeftTableViewController.h"
#import "LeftCustomCell.h"
#import <Quickblox/Quickblox.h>
#import "Keychain.h"
#import "CustomViewProfile.h"

@interface LeftTableViewController ()
@property (nonatomic, strong) NSArray *itemsArray;
@property (nonatomic, strong) NSArray *iconItemsArray;
@end

@implementation LeftTableViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self headerView];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(updateProfile) name:@"didCompleteUpdateProfile" object:nil];
}

- (void)updateProfile {
    CustomViewProfile *header = (CustomViewProfile*)self.tableView.tableHeaderView;
    NSUInteger userProfilePictureID = [QBSession currentSession].currentUser.blobID; // user - an instance of QBUUser class
    // download user profile picture
    [QBRequest downloadFileWithID:userProfilePictureID successBlock:^(QBResponse * _Nonnull response, NSData * _Nonnull fileData) {
        if (fileData) {
            UIImage *image = [UIImage imageWithData:fileData];
            header.avatarImage.image = image;
        }
    } statusBlock:^(QBRequest * _Nonnull request, QBRequestStatus * _Nullable status) {
        
    } errorBlock:^(QBResponse * _Nonnull response) {
        header.avatarImage.image = [UIImage imageNamed:@"IconDefault.png"];
    }];
}

- (void)headerView {
    CustomViewProfile *header = [[[NSBundle mainBundle] loadNibNamed:@"CustomViewProfile"
                                          owner:self
                                        options:nil] objectAtIndex:0];
    self.tableView.tableHeaderView = header;
    CGRect newFrame = self.tableView.tableHeaderView.frame;
    newFrame.size.height = newFrame.size.height;
    self.tableView.tableHeaderView.frame = newFrame;
    [self updateProfile];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (NSArray *)itemsArray {
    if (!_itemsArray) {
        _itemsArray = @[@"Profile", @"Kho hàng", @"Giỏ hàng", @"Thống kê", @"Thiết lập", @"Friends", @"Members", @"Thoát"];
        _iconItemsArray = @[@"profileIcon", @"home", @"shopping", @"analyticsIcon", @"settingIcon",@"friend", @"member", @"logoutIcon"];
    }
    return _itemsArray;
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.itemsArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    LeftCustomCell *cell = (LeftCustomCell *)[tableView dequeueReusableCellWithIdentifier:@"LeftCustomCell" forIndexPath:indexPath];
    cell.itemIcon.image = [UIImage imageNamed:[self.iconItemsArray objectAtIndex:indexPath.row]];
    cell.itemName.text = [self.itemsArray objectAtIndex:indexPath.row];
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    NSString *name = [self.itemsArray objectAtIndex:indexPath.row];
    if ([name isEqualToString:@"Thoát"]) {
        [QBRequest logOutWithSuccessBlock:^(QBResponse * _Nonnull response) {
            Keychain *keyObject = [Keychain shareInstance];
            [keyObject deleteKeyChain];
           [self.navigationController popToRootViewControllerAnimated:YES];
        } errorBlock:^(QBResponse * _Nonnull response) {
            NSLog(@"logout error");
        }];
    }else{
        NSString *stringIdentifier = nil;
        switch (indexPath.row) {
            case 0:
                stringIdentifier = @"profile";
                break;
            case 1:
                stringIdentifier = @"khohang";
                break;
            case 2:
                stringIdentifier = @"giohang";
                break;
            case 3:
                stringIdentifier = @"thongke";
                break;
            case 4:
                stringIdentifier = @"thietlap";
                break;
            case 5:
                stringIdentifier = @"friends";
                break;
            case 6:
                stringIdentifier = @"member";
                break;

            default:
                break;
        }
        if (stringIdentifier) {
            [self performSegueWithIdentifier:stringIdentifier sender:self];
        }
    }
}

@end
