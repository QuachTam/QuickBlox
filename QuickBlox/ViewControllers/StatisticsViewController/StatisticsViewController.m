//
//  StatisticsViewController.m
//  QuickBlox
//
//  Created by Tamqn on 2/1/16.
//  Copyright © 2016 Tamqn. All rights reserved.
//

#import "StatisticsViewController.h"
#import <Quickblox/Quickblox.h>
#import "Storage.h"
#import "CustomCellOnlyText.h"
#import "SubStatisticsViewController.h"

@interface StatisticsViewController ()
@property (nonatomic, strong) NSMutableDictionary *dictData;
@end

@implementation StatisticsViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    SWRevealViewController *revealViewController = self.revealViewController;
    if ( revealViewController )
    {
        [self.menuButton addTarget:self.revealViewController action:@selector(revealToggle:) forControlEvents:UIControlEventTouchUpInside];
        [self.view addGestureRecognizer:self.revealViewController.panGestureRecognizer];
    }
    self.dictData = [NSMutableDictionary new];
    NSMutableDictionary *getRequest = [NSMutableDictionary dictionary];
//    [getRequest setObject:@(0) forKey:@"isSell"];
    [QBRequest objectsWithClassName:kItemClassName extendedRequest:getRequest successBlock:^(QBResponse *response, NSArray *objects, QBResponsePage *page) {
        [self handleData:objects];
    } errorBlock:^(QBResponse *response) {
        NSLog(@"Response error: %@", [response.error description]);
    }];
}

- (void)handleData:(NSArray *)arrayData {
    for (NSInteger index=0; index<arrayData.count; index++) {
        QBCOCustomObject *object = [arrayData objectAtIndex:index];
        NSDate *dateOutObject = [CommonFeature convertLongtimeToDate:[object.fields[@"dateOutput"] doubleValue]];
        NSInteger year = [CommonFeature getYearFormDate:dateOutObject];
        NSMutableArray *array = [self.dictData objectForKey:[NSString stringWithFormat:@"%ld", year]];
        if (!array) {
            array =[NSMutableArray new];
            [self.dictData setObject:array forKey:[NSString stringWithFormat:@"%ld", year]];
        }
        [array addObject:object];
    }
    [self.tbView reloadData];
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [self.dictData allKeys].count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    CustomCellOnlyText *cell = (CustomCellOnlyText *)[tableView dequeueReusableCellWithIdentifier:@"CustomCellOnlyText" forIndexPath:indexPath];
    cell.textLabel.text = [NSString stringWithFormat:@"Nam %@", [[self.dictData allKeys] objectAtIndex:indexPath.row]];
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    NSMutableArray *arrayData = [self.dictData valueForKey:[[self.dictData allKeys] objectAtIndex:indexPath.row]];
    SubStatisticsViewController *rootView = [self.storyboard instantiateViewControllerWithIdentifier:@"SubStatisticsViewController"];
    rootView.arrayData = [arrayData copy];
    [self.navigationController pushViewController:rootView animated:YES];
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
