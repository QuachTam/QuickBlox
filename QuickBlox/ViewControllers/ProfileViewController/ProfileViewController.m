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
#import <SDWebImage/UIImageView+WebCache.h>

@interface ProfileViewController ()
@property (nonatomic, strong) QBUUser *user;
@end

@implementation ProfileViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.user = [QBSession currentSession].currentUser;
    self.navigationItem.hidesBackButton = YES;
    SWRevealViewController *revealViewController = self.revealViewController;
    if ( revealViewController )
    {
        [self.menuButton addTarget:self.revealViewController action:@selector(revealToggle:) forControlEvents:UIControlEventTouchUpInside];
        [self.view addGestureRecognizer:self.revealViewController.panGestureRecognizer];
    }
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(updateProfile) name:@"didCompleteUpdateProfile" object:nil];
}

- (void)updateProfile {
    self.user = [QBSession currentSession].currentUser;
    [self.tbView reloadData];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 1;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    CGFloat height = [self heightForBasicCellAtIndexPaths:indexPath tableView:tableView];
    return height ;//> 202 ? height : 202;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    CustomCellProfile *cell = (CustomCellProfile *)[tableView dequeueReusableCellWithIdentifier:@"CustomCellProfile"];
    [self configureformTableViewCell:cell atIndexPath:indexPath tableView:tableView];
    return cell;
}

- (void)configureformTableViewCell:(CustomCellProfile *)cell atIndexPath:(NSIndexPath *)indexPath tableView:(UITableView*)tableView{
    // some code for initializing cell content
    cell.nameLabel.text = self.user.fullName;
    cell.phoneLabel.text = self.user.phone;
    
    if (self.user.customData) {
        NSData *data = [self.user.customData dataUsingEncoding:NSUTF8StringEncoding];
        NSDictionary *jsonResponse = [NSJSONSerialization JSONObjectWithData:data
                                                                     options:kNilOptions
                                                                       error:nil];
        if (jsonResponse) {
            cell.addressLabel.text = [jsonResponse valueForKey:@"address"];
            cell.descriptionLabel.text = [jsonResponse valueForKey:@"description"];
        }
        cell.activityIndicator.hidden = NO;
        [cell.activityIndicator startAnimating];
        NSURL* url = [NSURL URLWithString:[jsonResponse valueForKey:@"privateUrl"]];
        [cell.avatarImage sd_setImageWithURL:url placeholderImage:[UIImage imageNamed:@"IconDefault"] options:SDWebImageCacheMemoryOnly completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL) {
            [cell.activityIndicator stopAnimating];
            cell.activityIndicator.hidden = YES;
        }];
    }else{
        [cell.activityIndicator stopAnimating];
        cell.activityIndicator.hidden = YES;
    }
}

- (CGFloat)heightForBasicCellAtIndexPaths:(NSIndexPath *)indexPath tableView:(UITableView*)tableView{
    static CustomCellProfile *sizingCell = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        sizingCell = [tableView dequeueReusableCellWithIdentifier:@"CustomCellProfile"];
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
