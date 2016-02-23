//
//  ItemsTableViewController.m
//  QuickBlox
//
//  Created by Tamqn on 2/1/16.
//  Copyright © 2016 Tamqn. All rights reserved.
//

#import "ItemsTableViewController.h"
#import "ItemsTableViewCell.h"
#import "AddItemViewController.h"
#import "ObjectsPaginator.h"
#import "Storage.h"
#import <Quickblox/Quickblox.h>
#import "ModelItem.h"
#import <SwipeBack/SwipeBack.h>

@interface ItemsTableViewController ()<NMPaginatorDelegate>
@property (nonatomic, strong) ObjectsPaginator *paginator;
@end

@implementation ItemsTableViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.navigationItem.hidesBackButton = YES;
    SWRevealViewController *revealViewController = self.revealViewController;
    if ( revealViewController )
    {
        [self.menuButton addTarget:self.revealViewController action:@selector(revealToggle:) forControlEvents:UIControlEventTouchUpInside];
        [self.view addGestureRecognizer:self.revealViewController.panGestureRecognizer];
    }
    [[Storage instance].itemList removeAllObjects];
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    self.paginator = [[ObjectsPaginator alloc] initWithPageSize:10 delegate:self];
    [self.paginator fetchFirstPage];
    // Disable iOS 7 back gesture
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        self.navigationController.interactivePopGestureRecognizer.enabled = false;
    });
}

- (void)viewWillAppear:(BOOL)animated
{
    self.navigationController.swipeBackEnabled = NO;
}

- (void)paginator:(id)paginator didReceiveResults:(NSArray *)results {
    [MBProgressHUD hideHUDForView:self.view animated:YES];
    [[Storage instance].itemList addObjectsFromArray:results];
    [self.tableView reloadData];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark
#pragma mark Paginator

- (void)fetchNextPage {
    [self.paginator fetchNextPage];
}

#pragma mark
#pragma mark UIScrollViewDelegate

- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    
    // when reaching bottom, load a new page
    if (scrollView.contentOffset.y == scrollView.contentSize.height - scrollView.bounds.size.height) {
        // ask next page only if we haven't reached last page
        if (![self.paginator reachedLastPage]) {
            // fetch next page of results
            [self fetchNextPage];
        }
    }
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [[Storage instance].itemList count];
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 99;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    ItemsTableViewCell *cell = (ItemsTableViewCell *)[tableView dequeueReusableCellWithIdentifier:@"itemCell"];
    QBCOCustomObject *object_custom = [Storage instance].itemList[indexPath.row];
    NSString* name = object_custom.fields[@"name"];
    NSString* moneyOut = object_custom.fields[@"moneyOutput"];
    NSString* info = object_custom.fields[@"info"];

    cell.nameLabel.text = name;
    cell.moneyLabel.text = moneyOut;
    cell.infoLabel.text = info;
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    NSString *stringIdentifier = @"viewInfoItem";
    if (stringIdentifier) {
        QBCOCustomObject *object_custom = [Storage instance].itemList[indexPath.row];
        ModelItem *modelItem = [self convertQBCOCustomToModelItem:object_custom];
        
        AddItemViewController *viewDetail = [self.storyboard instantiateViewControllerWithIdentifier:@"AddItemViewController"];
        viewDetail.titleViewLabel.text = @"Thong tin mat hang";
        viewDetail.modelItem = modelItem;
        [self.navigationController pushViewController:viewDetail animated:YES];
    }
}

- (ModelItem*)convertQBCOCustomToModelItem:(QBCOCustomObject *)customObject {
    ModelItem *model = [[ModelItem alloc] init];
    model.ID = customObject.ID;
    model.name = customObject.fields[@"name"];
    model.dateInput = [NSNumber numberWithInteger:[customObject.fields[@"dateInput"] integerValue]];
    model.dateOutput = [NSNumber numberWithInteger:[customObject.fields[@"dateOutput"] integerValue]];
    model.moneyInput = customObject.fields[@"moneyInput"];
    model.moneyOutput = customObject.fields[@"moneyOutput"];
    model.qrCode = customObject.fields[@"qrCode"];
    model.info = customObject.fields[@"info"];
    return model;
}
/*
// Override to support conditional editing of the table view.
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    // Return NO if you do not want the specified item to be editable.
    return YES;
}
*/

/*
// Override to support editing the table view.
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        // Delete the row from the data source
        [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
    } else if (editingStyle == UITableViewCellEditingStyleInsert) {
        // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
    }   
}
*/

/*
// Override to support rearranging the table view.
- (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)fromIndexPath toIndexPath:(NSIndexPath *)toIndexPath {
}
*/

/*
// Override to support conditional rearranging of the table view.
- (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath {
    // Return NO if you do not want the item to be re-orderable.
    return YES;
}
*/

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

- (IBAction)actionQRCode:(id)sender {
}

- (IBAction)actionAddItem:(id)sender {
}
@end
