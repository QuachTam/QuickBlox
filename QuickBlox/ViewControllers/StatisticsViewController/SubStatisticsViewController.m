//
//  SubStatisticsViewController.m
//  QuickBlox
//
//  Created by Quach Tam on 3/2/16.
//  Copyright © 2016 Tamqn. All rights reserved.
//

#import "SubStatisticsViewController.h"
#import "CustomCellStatisticsDetail.h"
#import <Quickblox/Quickblox.h>

@interface SubStatisticsViewController ()
@property (nonatomic, strong) NSMutableDictionary *dictData;
@property (nonatomic, strong) NSArray *arraykeys;
@end

@implementation SubStatisticsViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.dictData = [NSMutableDictionary new];
    self.arraykeys = [NSArray new];
    [self handleData:self.arrayData];
}

- (void)handleData:(NSArray *)arrayData {
    for (NSInteger index=0; index<arrayData.count; index++) {
        QBCOCustomObject *object = [arrayData objectAtIndex:index];
        NSDate *dateOutObject = [CommonFeature convertLongtimeToDate:[object.fields[@"dateOutput"] doubleValue]];
        NSInteger month = [CommonFeature getMonthFormDate:dateOutObject];
        NSMutableArray *array = [self.dictData objectForKey:[NSString stringWithFormat:@"%ld", month]];
        if (!array) {
            array =[NSMutableArray new];
            [self.dictData setObject:array forKey:[NSString stringWithFormat:@"%ld", month]];
        }
        [array addObject:object];
    }
    self.arraykeys = [self.dictData allKeys];
    [self.tbView reloadData];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 105;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.arraykeys.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    CustomCellStatisticsDetail *cell = (CustomCellStatisticsDetail *)[tableView dequeueReusableCellWithIdentifier:@"CustomCellStatisticsDetail" forIndexPath:indexPath];
    cell.monthLabel.text = [NSString stringWithFormat:@"Thang %@", [[self.dictData allKeys] objectAtIndex:indexPath.row]];
    CGFloat moneyInput = [self getMoneyInputInMonth:[self.dictData valueForKey:[self.arraykeys objectAtIndex:indexPath.row]]];
    CGFloat moneyOutput = [self getMoneyOutputInMonth:[self.dictData valueForKey:[self.arraykeys objectAtIndex:indexPath.row]]];
    CGFloat moneyResult = moneyOutput - moneyInput;
    cell.moneyInput.text = [NSString localizedStringWithFormat:@"So tien nhap: %.2f", moneyInput];
    cell.moneyOutput.text = [NSString localizedStringWithFormat:@"So tien ban: %.2f", moneyOutput];
    cell.moneyResult.text = [NSString localizedStringWithFormat:@"So tien lai: %.2f", moneyResult];
    return cell;
}

- (CGFloat)getMoneyOutputInMonth:(NSArray *)array {
    CGFloat total=0;
    for (NSInteger index=0; index<array.count; index++) {
        QBCOCustomObject *object = [array objectAtIndex:index];
        total += [object.fields[@"moneyOutput"] floatValue];
    }
    return total;
}

- (CGFloat)getMoneyInputInMonth:(NSArray *)array {
    CGFloat total=0;
    for (NSInteger index=0; index<array.count; index++) {
        QBCOCustomObject *object = [array objectAtIndex:index];
        total += [object.fields[@"moneyInput"] floatValue];
    }
    return total;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    NSMutableArray *arrayData = [self.dictData valueForKey:[[self.dictData allKeys] objectAtIndex:indexPath.row]];
    NSLog(@"%@", arrayData);
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
