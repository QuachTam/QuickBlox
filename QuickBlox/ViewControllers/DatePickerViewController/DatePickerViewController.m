//
//  DatePickerViewController.m
//  QuickBlox
//
//  Created by Tamqn on 2/2/16.
//  Copyright © 2016 Tamqn. All rights reserved.
//

#import "DatePickerViewController.h"
#import <PureLayout/PureLayout.h>

@interface DatePickerViewController ()<CKCalendarViewDelegate>

@end

@implementation DatePickerViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.calendar = [[CKCalendarView alloc] initWithFrame:CGRectMake(0, self.navigationController.navigationBar.frame.size.height+20, self.view.frame.size.width, self.view.frame.size.height)];
    [self.calendar setDelegate:self];
    [[self view] addSubview:self.calendar];
}

- (void)calendarView:(CKCalendarView *)CalendarView didSelectDate:(NSDate *)date {
    if (self.didSelectedDate) {
        self.didSelectedDate(date);
    }
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

- (IBAction)actionBackButton:(id)sender {
    [self.navigationController popViewControllerAnimated:YES];
}
@end
