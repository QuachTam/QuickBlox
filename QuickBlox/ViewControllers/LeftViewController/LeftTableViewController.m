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
}

- (void)headerView {
    CustomViewProfile *header = [[[NSBundle mainBundle] loadNibNamed:@"CustomViewProfile"
                                          owner:self
                                        options:nil] objectAtIndex:0];
    self.tableView.tableHeaderView = header;
    CGRect newFrame = self.tableView.tableHeaderView.frame;
    newFrame.size.height = newFrame.size.height;
    self.tableView.tableHeaderView.frame = newFrame;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (NSArray *)itemsArray {
    if (!_itemsArray) {
        _itemsArray = @[@"Kho hàng", @"Giỏ hàng", @"Thống kê", @"Thiết lập", @"Thoát"];
        _iconItemsArray = @[@"home", @"shopping", @"analyticsIcon", @"settingIcon", @"logoutIcon"];
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
                stringIdentifier = @"khohang";
                break;
            case 1:
                stringIdentifier = @"giohang";
                break;
            case 2:
                stringIdentifier = @"thongke";
                break;
            case 3:
                stringIdentifier = @"thietlap";
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
