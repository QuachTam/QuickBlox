//
//  CommonFeature.h
//  QuickBlox
//
//  Created by Tamqn on 2/2/16.
//  Copyright © 2016 Tamqn. All rights reserved.
//

#import <Foundation/Foundation.h>

static NSString *format_date_type_yyyy_mm_dd_hh_mm = @"dd-MM-yyyy HH:mm";

@interface CommonFeature : NSObject
+ (CommonFeature*)shareInstance;
+ (void)setShadownWithBoderWidth:(NSInteger)width view:(UIView*)view;
+ (NSString*)convertDateToString:(NSDate *)date withFormat:(NSString*)formatDate;
+ (NSTimeInterval)convertDateToLongtime:(NSDate*)date;
+ (NSDate*)convertLongtimeToDate:(NSTimeInterval)timeInMiliseconds;
+ (NSInteger)getYearFormDate:(NSDate *)date;
+ (NSInteger)getMonthFormDate:(NSDate *)date;
@end
