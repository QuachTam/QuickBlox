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
@property (nonatomic, strong) QBUUser *currentUser;
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
    self.currentUser = [QBSession currentSession].currentUser;
    self.arrayTemp = [NSMutableArray new];
    self.paginator = [[UsersPaginator alloc] initWithPageSize:10 delegate:self];
    [MBProgressHUD showHUDAddedTo:self.navigationController.view animated:YES];
    [self.paginator fetchFirstPage];
    
    NSArray *array = [QBChat instance].contactList.pendingApproval;
    NSLog(@"pendingApproval");
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
    self.arrayTemp = [NSMutableArray arrayWithArray:results];
    [self startInstance];
}

- (void)startInstance {
    if (self.arrayTemp.count>0) {
        QBUUser *user = [self.arrayTemp objectAtIndex:0];
        __weak __typeof(self)strong = self;
        [self addUser:user success:^(QBUUser *user, QBCBlob *blob) {
            UserModel *model = [[UserModel alloc] initWithUser:user blob:blob];
            [[StorageUser instance].users addObject:model];
            [strong startInstance];
        }];
    }else{
        [MBProgressHUD hideHUDForView:self.navigationController.view animated:YES];
        [self.tbView reloadData];
    }
}

- (void)addUser:(QBUUser*)user success:(void(^)(QBUUser *user, QBCBlob *blob))success{
    if (user.blobID>0) {
        [QBRequest blobWithID:user.blobID successBlock:^(QBResponse * _Nonnull response, QBCBlob * _Nullable blob) {
            [self.arrayTemp removeObjectAtIndex:0];
            if (success) {
                success (user, blob);
            }
        } errorBlock:^(QBResponse * _Nonnull response) {
            [self.arrayTemp removeObjectAtIndex:0];
            if (success) {
                success (user, [QBCBlob new]);
            }
        }];
    } else {
        [self.arrayTemp removeObjectAtIndex:0];
        if (success) {
            success (user, [QBCBlob new]);
        }
    }
}

#pragma mark - Table view data source

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [[StorageUser instance].users count];
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    CGFloat height = [self heightForBasicCellAtIndexPaths:indexPath tableView:tableView];
    return height >69 ? height:69;
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
    if (self.currentUser.ID == userModel.ID) {
        cell.friendButton.hidden = YES;
    }else{
        cell.friendButton.hidden = NO;
    }
    cell.friendButton.tag = indexPath.row;
    [cell.friendButton addTarget:self action:@selector(actionAddFriend:) forControlEvents:UIControlEventTouchUpInside];
    if (userModel.privateUrl.length) {
        cell.indicator.hidden = NO;
        [cell.indicator startAnimating];
        
        NSURL* url = [NSURL URLWithString:userModel.privateUrl];
        [cell.avatarImageView sd_setImageWithURL:url placeholderImage:[UIImage imageNamed:@"IconDefault"] options:SDWebImageCacheMemoryOnly completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL) {
            [cell.indicator stopAnimating];
            cell.indicator.hidden = YES;
        }];
    }else{
        [cell.indicator stopAnimating];
        cell.indicator.hidden = YES;
    }
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

- (void)actionAddFriend:(id)sender {
    [MBProgressHUD showHUDAddedTo:self.navigationController.view animated:YES];
    UserModel *userModel = [StorageUser instance].users[[sender tag]];
    // connect to Chat
    QuickBloxCommon* qbCommon =  [QuickBloxCommon shareInstance];
    [qbCommon addUserToContactListRequestWithID:userModel.user.ID success:^(NSError *error) {
        [MBProgressHUD hideHUDForView:self.navigationController.view animated:YES];
    }];
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
