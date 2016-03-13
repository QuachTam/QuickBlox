//
//  ProfileEditViewController.m
//  QuickBlox
//
//  Created by Quach Tam on 3/13/16.
//  Copyright © 2016 Tamqn. All rights reserved.
//

#import "ProfileEditViewController.h"
#import <QuickBlox/Quickblox.h>
#import "CustomCellEditProfile.h"
#import "CameraObject.h"
#import "UIActionSheet+Blocks.h"

@interface ProfileEditViewController () <CameraObjectDelegate, UITextFieldDelegate, UITextViewDelegate>
@property (nonatomic, strong) QBUUser *user;
@property (nonatomic, strong) NSString *userName;
@property (nonatomic, strong) NSString *userPhone;
@property (nonatomic, strong) NSString *userAddresss;
@property (nonatomic, strong) NSString *userDescription;
@property (nonatomic, readwrite) BOOL isChange;
@end

@implementation ProfileEditViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.isChange = NO;
    // Do any additional setup after loading the view.
    // Upload new avatar to Content module
    self.user = [QBSession currentSession].currentUser;
    self.userName = self.user.fullName;
    self.userPhone = self.user.phone;
}

#pragma mark - Table view data source

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 1;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    CGFloat height = [self heightForBasicCellAtIndexPaths:indexPath tableView:tableView];
    return height;// > 282 ? height : 282;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    CustomCellEditProfile *cell = (CustomCellEditProfile *)[tableView dequeueReusableCellWithIdentifier:@"CustomCellEditProfile"];
    [self configureformTableViewCell:cell atIndexPath:indexPath tableView:tableView];
    return cell;
}

- (void)configureformTableViewCell:(CustomCellEditProfile *)cell atIndexPath:(NSIndexPath *)indexPath tableView:(UITableView*)tableView{
    // some code for initializing cell content
    cell.didClickUpdateAvatar = ^{
        [self actionShowCamera];
    };
    cell.nameTextField.text = self.userName;
    cell.phoneTextField.text = self.userPhone;
    NSUInteger userProfilePictureID = self.user.blobID; // user - an instance of QBUUser class
    // download user profile picture
    cell.activityIndicator.hidden = NO;
    [cell.activityIndicator startAnimating];
    [QBRequest downloadFileWithID:userProfilePictureID successBlock:^(QBResponse * _Nonnull response, NSData * _Nonnull fileData) {
        if (fileData) {
            UIImage *image = [UIImage imageWithData:fileData];
            cell.avatarImageView.image = image;
            [cell.activityIndicator stopAnimating];
            cell.activityIndicator.hidden = YES;
        }
    } statusBlock:^(QBRequest * _Nonnull request, QBRequestStatus * _Nullable status) {
        
    } errorBlock:^(QBResponse * _Nonnull response) {
        cell.avatarImageView.image = [UIImage imageNamed:@"profileDefault"];
        [cell.activityIndicator stopAnimating];
        cell.activityIndicator.hidden = YES;
    }];
}

- (CGFloat)heightForBasicCellAtIndexPaths:(NSIndexPath *)indexPath tableView:(UITableView*)tableView{
    static CustomCellEditProfile *sizingCell = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        sizingCell = [tableView dequeueReusableCellWithIdentifier:@"CustomCellEditProfile"];
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
#pragma mark UITextFieldDelegate
- (void)textFieldDidEndEditing:(UITextField *)textField {
    if (textField.tag==1) {
        self.userName = textField.text;
    }
    if (textField.tag==2) {
        self.userPhone = textField.text;
    }
}

- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string {
    self.isChange = YES;
    return YES;
}

#pragma mark CameraObjectDelegate
- (void)didFinishPickingMediaWithInfo:(UIImage *)image {
    if (image) {
        [self updateAvatar:image];
    }
}

- (void)imagePickerControllerDidCancel {
    
}

- (void)actionShowCamera {
    [UIActionSheet showInView:self.view
                    withTitle:nil
            cancelButtonTitle:@"Huỷ"
       destructiveButtonTitle:nil
            otherButtonTitles:@[@"Chụp ảnh", @"Chọn ảnh"]
                     tapBlock:^(UIActionSheet *actionSheet, NSInteger buttonIndex){
                         NSString *title = [actionSheet buttonTitleAtIndex:buttonIndex];
                         if (![title isEqualToString:@"Huỷ"]) {
                             CameraObject *camera = [CameraObject shareInstance];
                             camera.delegate = self;
                             camera.supperView = self;
                             if([title isEqualToString:@"Chụp ảnh"]){
                                 camera.sourceType = UIImagePickerControllerSourceTypeCamera;
                             }
                             if ([title isEqualToString:@"Chọn ảnh"]) {
                                 camera.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
                             }
                             [camera showCamera];
                         }
                     }];
}

- (IBAction)actionBack:(id)sender {
    [self.navigationController popViewControllerAnimated:YES];
}

- (IBAction)actionDone:(id)sender {
    [self updateInfoCurrentUser];
}

- (void)updateInfoCurrentUser {
    [self.view endEditing:YES];
    if (self.isChange) {
        QBUpdateUserParameters *updateParameters = [QBUpdateUserParameters new];
        updateParameters.website = @"www.mysite.com";
        updateParameters.phone = self.userPhone;
        updateParameters.fullName = self.userName;
        [QBRequest updateCurrentUser:updateParameters successBlock:^(QBResponse *response, QBUUser *user) {
            [CommonFeature showAlertTitle:nil Message:@"Update Profile successfully" duration:2.0 showIn:self blockDismissView:^{
                [[NSNotificationCenter defaultCenter] postNotificationName:@"didCompleteUpdateProfile" object:nil];
            }];
            self.isChange = NO;
        } errorBlock:^(QBResponse *response) {
            [CommonFeature showAlertTitle:nil Message:@"Update Profile error" duration:2.0 showIn:self blockDismissView:nil];
            self.isChange = NO;
        }];
    }
}

- (void)updateAvatar:(UIImage *)image{
    [MBProgressHUD showHUDAddedTo:self.navigationController.view animated:YES];
    UIImage *imageNew = [CommonFeature imageWithImage:image scaledToWidth:200];
    NSData *avatar = UIImagePNGRepresentation(imageNew);
    if (!self.user.blobID) {
        [QBRequest TUploadFile:avatar fileName:@"MyAvatar" contentType:@"image/png" isPublic:YES successBlock:^(QBResponse * _Nonnull response, QBCBlob * _Nonnull blob) {
            QBUpdateUserParameters *params = [QBUpdateUserParameters new];
            params.blobID = [blob ID];
            [QBRequest updateCurrentUser:params successBlock:^(QBResponse * _Nonnull response, QBUUser * _Nullable user) {
                [MBProgressHUD hideHUDForView:self.navigationController.view animated:YES];
                [CommonFeature showAlertTitle:nil Message:@"Upload avatar successfully" duration:2.0 showIn:self blockDismissView:^{
                   [self.tbView reloadData];
                    [[NSNotificationCenter defaultCenter] postNotificationName:@"didCompleteUpdateProfile" object:nil];
                }];
            } errorBlock:^(QBResponse * _Nonnull response) {
                // error block
                NSLog(@"Failed to update user: %@", [response.error reasons]);
                [MBProgressHUD hideHUDForView:self.navigationController.view animated:YES];
                [CommonFeature showAlertTitle:nil Message:@"Upload avatar error" duration:2.0 showIn:self blockDismissView:nil];
            }];
        } statusBlock:^(QBRequest * _Nonnull request, QBRequestStatus * _Nullable status) {
            
        } errorBlock:^(QBResponse * _Nonnull response) {
            [MBProgressHUD hideHUDForView:self.navigationController.view animated:YES];
            [CommonFeature showAlertTitle:nil Message:@"Upload avatar error" duration:2.0 showIn:self blockDismissView:nil];
        }];
        
    }else{
        QBCBlob *blob = [QBCBlob blob];
        blob.ID = self.user.blobID;
        [QBRequest TUpdateFileWithData:avatar file:blob successBlock:^(QBResponse * _Nonnull response) {
            [MBProgressHUD hideHUDForView:self.navigationController.view animated:YES];
            [CommonFeature showAlertTitle:nil Message:@"Upload avatar successfully" duration:2.0 showIn:self blockDismissView:^{
                [self.tbView reloadData];
                [[NSNotificationCenter defaultCenter] postNotificationName:@"didCompleteUpdateProfile" object:nil];
            }];
        } statusBlock:^(QBRequest * _Nonnull request, QBRequestStatus * _Nullable status) {
            
        } errorBlock:^(QBResponse * _Nonnull response) {
            NSLog(@"update fail: %@", response);
            [MBProgressHUD hideHUDForView:self.navigationController.view animated:YES];
            [CommonFeature showAlertTitle:nil Message:@"Upload avatar error" duration:2.0 showIn:self blockDismissView:nil];
        }];
    }
}
@end
