//
//  CustomCellStatisticsDetail.h
//  QuickBlox
//
//  Created by Quach Tam on 3/2/16.
//  Copyright © 2016 Tamqn. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface CustomCellStatisticsDetail : UITableViewCell
@property (weak, nonatomic) IBOutlet UILabel *monthLabel;
@property (weak, nonatomic) IBOutlet UILabel *moneyInput;
@property (weak, nonatomic) IBOutlet UILabel *moneyOutput;
@property (weak, nonatomic) IBOutlet UILabel *moneyResult;
@property (weak, nonatomic) IBOutlet UILabel *moneyValueInput;
@property (weak, nonatomic) IBOutlet UILabel *moneyValueOutput;
@property (weak, nonatomic) IBOutlet UILabel *moneyValueResult;

@end
