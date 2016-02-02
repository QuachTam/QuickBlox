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

@interface LeftTableViewController ()
@property (nonatomic, strong) NSArray *itemsArray;
@end

@implementation LeftTableViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
    
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (NSArray *)itemsArray {
    if (!_itemsArray) {
        _itemsArray = @[@"Kho hàng", @"Giỏ hàng", @"Thống kê", @"Thiết lập", @"Thoát"];
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
    cell.itemIcon.image = [UIImage imageNamed:@"home"];
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

//- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
//    
//    // Set the title of navigation bar by using the menu items
//    NSIndexPath *indexPath = [self.tableView indexPathForSelectedRow];
//    UINavigationController *destViewController = (UINavigationController*)segue.destinationViewController;
//    destViewController.title = [[self.itemsArray objectAtIndex:indexPath.row] capitalizedString];
//    
//    // Set the photo if it navigates to the PhotoView
//    if ([segue.identifier isEqualToString:@"showPhoto"]) {
//        UINavigationController *navController = segue.destinationViewController;
//        PhotoViewController *photoController = [navController childViewControllers].firstObject;
//        NSString *photoFilename = [NSString stringWithFormat:@"%@_photo", [menuItems objectAtIndex:indexPath.row]];
//        photoController.photoFilename = photoFilename;
//    }
//}
@end
