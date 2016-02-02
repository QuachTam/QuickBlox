//
//  DatePickerViewController.h
//  QuickBlox
//
//  Created by Tamqn on 2/2/16.
//  Copyright © 2016 Tamqn. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <CalendarKit.h>

@interface DatePickerViewController : UIViewController
@property (strong, nonatomic) CKCalendarView *calendar;
@property (nonatomic, copy, readwrite) void(^didSelectedDate)(NSDate *dateSelected);
- (IBAction)actionBackButton:(id)sender;


@end
