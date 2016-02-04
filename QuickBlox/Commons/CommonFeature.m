//
//  CommonFeature.m
//  QuickBlox
//
//  Created by Tamqn on 2/2/16.
//  Copyright © 2016 Tamqn. All rights reserved.
//

#import "CommonFeature.h"

@implementation CommonFeature

+ (CommonFeature*)shareInstance {
    static CommonFeature *_shareInstance = nil;
    static dispatch_once_t oncePredicate;
    dispatch_once(&oncePredicate, ^{
        _shareInstance = [[CommonFeature alloc] init];
    });
    return _shareInstance;
}

+ (void)setShadownWithBoderWidth:(NSInteger)width view:(UIView*)view{
    CGRect frames = view.bounds;
    frames.origin.x -=width;
    frames.origin.y -=width;
    frames.size.width = frames.size.width + width*2;
    frames.size.height = frames.size.height + width*2;
    
    UIBezierPath *shadowPath = [UIBezierPath bezierPathWithRect:frames];
    view.layer.masksToBounds = NO;
    view.layer.shadowColor = [UIColor blackColor].CGColor;
    view.layer.shadowOffset = CGSizeMake(0.0f, 0.0f);
    view.layer.shadowOpacity = 0.2f;
    view.layer.shadowPath = shadowPath.CGPath;
}

+ (NSTimeInterval)convertDateToLongtime:(NSDate*)date {
    NSTimeInterval timeInMiliseconds = [date timeIntervalSince1970];
    return timeInMiliseconds;
}

+ (NSDate*)convertLongtimeToDate:(NSTimeInterval)timeInMiliseconds {
    NSDate* date = [NSDate dateWithTimeIntervalSince1970:timeInMiliseconds];
    return date;
}

+ (NSString*)convertDateToString:(NSDate *)date withFormat:(NSString*)formatDate{
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat:formatDate];
    //Optionally for time zone converstions
    [formatter setTimeZone:[NSTimeZone localTimeZone]];
    NSString *stringFromDate = [formatter stringFromDate:date];
    return stringFromDate;
}
@end
