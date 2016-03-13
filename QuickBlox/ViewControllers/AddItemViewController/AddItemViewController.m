//
//  AddItemViewController.m
//  QuickBlox
//
//  Created by Tamqn on 2/1/16.
//  Copyright © 2016 Tamqn. All rights reserved.
//

#import "AddItemViewController.h"
#import "AddItemTableViewCell.h"
#import "DatePickerViewController.h"
#import <Quickblox/Quickblox.h>
#import "Storage.h"

@interface AddItemViewController ()

@end

@implementation AddItemViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
    
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
    if (!self.modelItem) {
        self.modelItem = [[ModelItem alloc] init];
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 1;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 442;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    AddItemTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"addCustomCell" forIndexPath:indexPath];
    cell.modelItem = self.modelItem;
    cell.tag = 100;
    [cell setupDataForCell];
    return cell;
}

#pragma mark - Navigation
// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    DatePickerViewController *viewDetail = [segue destinationViewController];
    viewDetail.didSelectedDate = ^(NSDate *date){
        if ([[segue identifier] isEqualToString:@"dateInputIdentifier"]) {
            self.modelItem.dateInput = @([CommonFeature convertDateToLongtime:date]);
        }else{
            self.modelItem.dateOutput = @([CommonFeature convertDateToLongtime:date]);
        }
        [self.tableView reloadData];
    };
}


- (IBAction)actionBackButton:(id)sender {
    [self.navigationController popViewControllerAnimated:YES];
}

- (IBAction)actionDoneButton:(id)sender {
    AddItemTableViewCell *cell = (AddItemTableViewCell*)[self.tableView viewWithTag:100];
    [cell actionValidInput:^(BOOL isValid) {
        if (isValid) {
            [self addNewItem];
        }
    }];
}

- (void)addNewItem {
    // Create note
    QBCOCustomObject *object = [QBCOCustomObject customObject];
    object.className = kItemClassName;
    object.fields[@"uuid"] = [[[NSUUID UUID] UUIDString] lowercaseString];
    object.fields[@"name"] = self.modelItem.name;
    object.fields[@"dateInput"] = [self.modelItem.dateInput stringValue];
    object.fields[@"dateOutput"] = [self.modelItem.dateOutput stringValue];
    object.fields[@"moneyInput"] = self.modelItem.moneyInput;
    object.fields[@"moneyOutput"] = self.modelItem.moneyOutput;
    object.fields[@"qrCode"] = self.modelItem.qrCode;
    object.fields[@"info"] = self.modelItem.info;
    if (!self.modelItem.ID) {
        object.fields[@"isSell"] = @(0);
    }
    __weak typeof(self)weakSelf = self;
    if (self.modelItem.ID) {
        object.ID = self.modelItem.ID;
        [QBRequest updateObject:object successBlock:^(QBResponse * _Nonnull response, QBCOCustomObject * _Nullable object) {
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Thành công"
                                                            message:@"Chỉn sửa thông tin thành công"
                                                           delegate:weakSelf
                                                  cancelButtonTitle:@"Đồng ý"
                                                  otherButtonTitles:nil];
            [alert show];
        } errorBlock:^(QBResponse * _Nonnull response) {
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Chỉn sửa thông tin lỗi"
                                                            message:[response.error description]
                                                           delegate:nil
                                                  cancelButtonTitle:@"Đồng ý"
                                                  otherButtonTitles:nil];
            [alert show];
        }];
    }else{
        [QBRequest createObject:object successBlock:^(QBResponse *response, QBCOCustomObject *object) {
            // save new movie to local storage
            [[Storage instance].itemList addObject:object];
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Thành công"
                                                            message:@"Bạn vừa tạo một sản phẩm mới!"
                                                           delegate:weakSelf
                                                  cancelButtonTitle:@"Đồng ý"
                                                  otherButtonTitles:nil];
            [alert show];
        } errorBlock:^(QBResponse *response) {
            NSLog(@"Response error: %@", [response.error description]);
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Có lỗi trong khi tạo sản phẩm"
                                                            message:[response.error description]
                                                           delegate:nil
                                                  cancelButtonTitle:@"Đồng ý"
                                                  otherButtonTitles:nil];
            [alert show];
        }];
    }
}

@end
