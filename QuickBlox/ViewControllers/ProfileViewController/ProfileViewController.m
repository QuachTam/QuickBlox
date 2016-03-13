//
//  ProfileViewController.m
//  QuickBlox
//
//  Created by Quach Tam on 3/13/16.
//  Copyright © 2016 Tamqn. All rights reserved.
//

#import "ProfileViewController.h"
#import "CustomCellProfile.h"
#import <Quickblox/Quickblox.h>

@interface ProfileViewController ()
@property (nonatomic, strong) QBUUser *user;
@end

@implementation ProfileViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.user = [QBSession currentSession].currentUser;
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
    return [self heightForBasicCellAtIndexPaths:indexPath tableView:tableView];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    CustomCellProfile *cell = (CustomCellProfile *)[tableView dequeueReusableCellWithIdentifier:@"CustomCellProfile"];
    [self configureformTableViewCell:cell atIndexPath:indexPath tableView:tableView];
    return cell;
}

- (void)configureformTableViewCell:(CustomCellProfile *)cell atIndexPath:(NSIndexPath *)indexPath tableView:(UITableView*)tableView{
    // some code for initializing cell content
   
}

- (CGFloat)heightForBasicCellAtIndexPaths:(NSIndexPath *)indexPath tableView:(UITableView*)tableView{
    static CustomCellProfile *sizingCell = nil;
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

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
