//
//  ItemsTableViewController.m
//  QuickBlox
//
//  Created by Tamqn on 2/1/16.
//  Copyright © 2016 Tamqn. All rights reserved.
//
@import GoogleMobileAds;

#import "ItemsTableViewController.h"
#import "ItemsTableViewCell.h"
#import "AddItemViewController.h"
#import "ObjectsPaginator.h"
#import "Storage.h"
#import <Quickblox/Quickblox.h>
#import "ModelItem.h"
#import <SwipeBack/SwipeBack.h>
#import "QRCodeReaderViewController.h"
#import "QRCodeReader.h"
#import "ProfileEditViewController.h"

@interface ItemsTableViewController ()<NMPaginatorDelegate, QRCodeReaderDelegate>
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
    [MBProgressHUD showHUDAddedTo:self.navigationController.view animated:YES];
    self.paginator = [[ObjectsPaginator alloc] initWithPageSize:10 delegate:self];
    [self.paginator fetchFirstPage];
    // Disable iOS 7 back gesture
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        self.navigationController.interactivePopGestureRecognizer.enabled = false;
    });
    
    AdmodManager *managerAd = [AdmodManager sharedInstance];
    [managerAd showAdmodInViewController];
    [self footerView];
    
    QBUUser *currentUser = [QBSession currentSession].currentUser;
    if (!currentUser.customData || currentUser.blobID<1) {
        ProfileEditViewController *rootView = [self.storyboard instantiateViewControllerWithIdentifier:@"ProfileEditViewController"];
        [self.navigationController pushViewController:rootView animated:YES];
    }
}

- (void)footerView {
    UIView *header = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 320, 44)];
    self.tableView.tableFooterView = header;
    
    //update the header's frame and set it again
    CGRect newFrame = self.tableView.tableFooterView.frame;
    newFrame.size.height = newFrame.size.height;
    self.tableView.tableFooterView.frame = newFrame;
}


- (void)viewWillAppear:(BOOL)animated
{
    self.navigationController.swipeBackEnabled = NO;
    [self.tableView reloadData];
}

- (void)paginator:(id)paginator didReceiveResults:(NSArray *)results {
    [[Storage instance].itemList addObjectsFromArray:results];
    [self.tableView reloadData];
    [MBProgressHUD hideHUDForView:self.navigationController.view animated:YES];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark
#pragma mark Paginator

- (void)fetchNextPage {
    [MBProgressHUD showHUDAddedTo:self.navigationController.view animated:YES];
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [self.paginator fetchNextPage];
    });
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
    return [self heightForBasicCellAtIndexPaths:indexPath tableView:tableView];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    ItemsTableViewCell *cell = (ItemsTableViewCell *)[tableView dequeueReusableCellWithIdentifier:@"itemCell"];
    [self configureformTableViewCell:cell atIndexPath:indexPath tableView:tableView];
    return cell;
}

- (void)configureformTableViewCell:(ItemsTableViewCell *)cell atIndexPath:(NSIndexPath *)indexPath tableView:(UITableView*)tableView{
    // some code for initializing cell content
    QBCOCustomObject *object_custom = [Storage instance].itemList[indexPath.row];
    NSString* name = object_custom.fields[@"name"];
    NSString* moneyOut = object_custom.fields[@"moneyOutput"];
    NSString* info = object_custom.fields[@"info"];
    
    cell.nameLabel.text = name;
    cell.moneyLabel.text = [NSString localizedStringWithFormat:@"%.2f", [moneyOut doubleValue]];
    cell.infoLabel.text = info;
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

- (CGFloat)heightForBasicCellAtIndexPaths:(NSIndexPath *)indexPath tableView:(UITableView*)tableView{
    static ItemsTableViewCell *sizingCell = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        sizingCell = [tableView dequeueReusableCellWithIdentifier:@"itemCell"];
    });
    
    [self configureformTableViewCell:sizingCell atIndexPath:indexPath tableView:tableView];
    return [self calculateHeightForConfiguredSizingCells:sizingCell];
}

- (CGFloat)calculateHeightForConfiguredSizingCells:(UITableViewCell *)sizingCell {
    [sizingCell setNeedsLayout];
    [sizingCell layoutIfNeeded];
    CGSize size = [sizingCell.contentView systemLayoutSizeFittingSize:UILayoutFittingCompressedSize];
    return size.height + 1.0f; // Add 1.0f for the cell separator height
}

#pragma mark QRCodeReader
- (IBAction)actionQRCode:(id)sender {
    if ([QRCodeReader supportsMetadataObjectTypes:@[AVMetadataObjectTypeQRCode]]) {
        static QRCodeReaderViewController *vc = nil;
        static dispatch_once_t onceToken;
        
        dispatch_once(&onceToken, ^{
            QRCodeReader *reader = [QRCodeReader readerWithMetadataObjectTypes:@[AVMetadataObjectTypeQRCode]];
            vc                   = [QRCodeReaderViewController readerWithCancelButtonTitle:@"Cancel" codeReader:reader startScanningAtLoad:YES showSwitchCameraButton:YES showTorchButton:YES];
            vc.modalPresentationStyle = UIModalPresentationFormSheet;
        });
        vc.delegate = self;
        
        [vc setCompletionWithBlock:^(NSString *resultAsString) {
            NSLog(@"Completion with result: %@", resultAsString);
        }];
        
        [self presentViewController:vc animated:YES completion:NULL];
    }
    else {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Error" message:@"Reader not supported by the current device" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
        
        [alert show];
    }
}

#pragma mark - QRCodeReader Delegate Methods

- (void)reader:(QRCodeReaderViewController *)reader didScanResult:(NSString *)result {
    [self dismissViewControllerAnimated:YES completion:^{
        
    }];
}

- (void)readerDidCancel:(QRCodeReaderViewController *)reader {
    [self dismissViewControllerAnimated:YES completion:NULL];
}

@end
