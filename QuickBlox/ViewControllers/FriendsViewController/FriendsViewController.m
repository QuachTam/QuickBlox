//
//  FriendsViewController.m
//  QuickBlox
//
//  Created by Tamqn on 3/18/16.
//  Copyright © 2016 Tamqn. All rights reserved.
//

#import "FriendsViewController.h"
#import "CustomCellMember.h"
#import <QuickLook/QuickLook.h>
#import "ServiceFriends.h"
#import "UserModel.h"
#import <SDWebImage/UIImageView+WebCache.h>

@interface FriendsViewController ()
@property (nonatomic, strong) NSArray *friendsList;
@property (nonatomic, strong) ServiceFriends *services;
@end

@implementation FriendsViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.navigationItem.hidesBackButton = YES;
    SWRevealViewController *revealViewController = self.revealViewController;
    if ( revealViewController )
    {
        [self.buttonMenu addTarget:self.revealViewController action:@selector(revealToggle:) forControlEvents:UIControlEventTouchUpInside];
        [self.view addGestureRecognizer:self.revealViewController.panGestureRecognizer];
    }
    self.friendsList = [NSArray new];
    self.services = [[ServiceFriends alloc] init];
    [self.services getListFriendsSuccess:^(NSArray *listFriends) {
        self.friendsList = listFriends;
        [self.tbView reloadData];
    }];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.friendsList.count;
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
    UserModel *model = [self.friendsList objectAtIndex:indexPath.row];
    
    cell.nameLabel.text = model.fullName;
    cell.descriptionLabel.text = model.descriptions;
    cell.constraintWidthButtonAddfriend.constant = 0;
    cell.friendButton.hidden = YES;
    if (model.privateUrl.length) {
        cell.indicator.hidden = NO;
        [cell.indicator startAnimating];
        NSURL* url = [NSURL URLWithString:model.privateUrl];
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


/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
