//
//  MemberViewController.m
//  QuickBlox
//
//  Created by Tamqn on 3/14/16.
//  Copyright © 2016 Tamqn. All rights reserved.
//

#import "MemberViewController.h"
#import "CustomCellMember.h"
#import "UsersPaginator.h"
#import "StorageUser.h"
#import <QuickBlox/Quickblox.h>
#import <SDWebImage/UIImageView+WebCache.h>
#import "UserModel.h"

@interface MemberViewController ()<NMPaginatorDelegate>
@property (nonatomic, strong) UsersPaginator *paginator;
@property (nonatomic, strong) NSMutableArray *arrayTemp;
@end

@implementation MemberViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.navigationItem.hidesBackButton = YES;
    SWRevealViewController *revealViewController = self.revealViewController;
    if ( revealViewController )
    {
        [self.menuButton addTarget:self.revealViewController action:@selector(revealToggle:) forControlEvents:UIControlEventTouchUpInside];
        [self.view addGestureRecognizer:self.revealViewController.panGestureRecognizer];
    }
    self.arrayTemp = [NSMutableArray new];
    
    self.paginator = [[UsersPaginator alloc] initWithPageSize:10 delegate:self];
    [MBProgressHUD showHUDAddedTo:self.navigationController.view animated:YES];
    [self.paginator fetchFirstPage];
}

#pragma mark
#pragma mark Paginator

- (void)fetchNextPage {
    [MBProgressHUD showHUDAddedTo:self.navigationController.view animated:YES];
    [self.paginator fetchNextPage];
}

#pragma mark
#pragma mark UIScrollViewDelegate

- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    
    // when reaching bottom, load a new page
    if (scrollView.contentOffset.y == scrollView.contentSize.height - scrollView.bounds.size.height){
        // ask next page only if we haven't reached last page
        if(![self.paginator reachedLastPage]){
            // fetch next page of results
            [self fetchNextPage];
        }
    }
}

#pragma mark
#pragma mark NMPaginatorDelegate

- (void)paginator:(id)paginator didReceiveResults:(NSArray *)results {
    [self.arrayTemp removeAllObjects];
    for (NSInteger index = 0; index < results.count; index++) {
        QBUUser *user = [results objectAtIndex:index];
        if (user.blobID>0) {
            [QBRequest blobWithID:user.blobID successBlock:^(QBResponse * _Nonnull response, QBCBlob * _Nullable blob) {
                UserModel *userModel;
                if (blob) {
                    userModel = [[UserModel alloc] initWithUser:user blob:blob];
                }else{
                    userModel = [[UserModel alloc] initWithUser:user blob:[QBCBlob new]];
                }
                [[StorageUser instance].users addObject:userModel];
                if (index == results.count-1) {
                    [MBProgressHUD hideHUDForView:self.navigationController.view animated:YES];
                    [self.tbView reloadData];
                }
            } errorBlock:^(QBResponse * _Nonnull response) {
                if (index == results.count-1) {
                    [MBProgressHUD hideHUDForView:self.navigationController.view animated:YES];
                    [self.tbView reloadData];
                }
            }];
        }else{
            UserModel *userModel = [[UserModel alloc] initWithUser:user blob:[QBCBlob new]];
            [[StorageUser instance].users addObject:userModel];
            if (index == results.count-1) {
                [MBProgressHUD hideHUDForView:self.navigationController.view animated:YES];
                [self.tbView reloadData];
            }
        }
    }
}



- (void)addUser:(QBUUser*)user blob:(QBCBlob*)blob {
    
}

#pragma mark - Table view data source

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [[StorageUser instance].users count];
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    CGFloat height = [self heightForBasicCellAtIndexPaths:indexPath tableView:tableView];
    return height ;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    CustomCellMember *cell = (CustomCellMember *)[tableView dequeueReusableCellWithIdentifier:@"CustomCellMember"];
    [self configureformTableViewCell:cell atIndexPath:indexPath tableView:tableView];
    return cell;
}

- (void)configureformTableViewCell:(CustomCellMember *)cell atIndexPath:(NSIndexPath *)indexPath tableView:(UITableView*)tableView{
    // some code for initializing cell content
    UserModel *userModel = [StorageUser instance].users[indexPath.row];
    cell.nameLabel.text = userModel.fullName;
    cell.descriptionLabel.text = userModel.descriptions;
    
    NSURL* url = [NSURL URLWithString:userModel.privateUrl];
    [cell.avatarImageView sd_setImageWithURL:url completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL) {
        
    }];
}

- (CGFloat)heightForBasicCellAtIndexPaths:(NSIndexPath *)indexPath tableView:(UITableView*)tableView{
    static CustomCellMember *sizingCell = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        sizingCell = [tableView dequeueReusableCellWithIdentifier:@"CustomCellMember"];
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


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
