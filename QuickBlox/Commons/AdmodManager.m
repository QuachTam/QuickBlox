//
//  AdmodManager.m
//  QuickBlox
//
//  Created by Tamqn on 3/10/16.
//  Copyright © 2016 Tamqn. All rights reserved.
//
@class GADBannerView;
@import GoogleMobileAds;

static NSString *ClientAppID = @"ca-app-pub-9259023205127043/7494555614";

#import "AdmodManager.h"
#import <PureLayout/PureLayout.h>

@implementation AdmodManager

+ (AdmodManager*)sharedInstance {
    static AdmodManager *_sharedInstance = nil;
    static dispatch_once_t oncePredicate;
    dispatch_once(&oncePredicate, ^{
        _sharedInstance = [[AdmodManager alloc] init];
    });
    return _sharedInstance;
}

- (void)showAdmodInViewController {
    UIViewController *root = [self getCurrentViewController];
    UIView *viewBannerAdMod = [[UIView alloc] initForAutoLayout];
    GADBannerView *bannerView_ = [[GADBannerView alloc] initWithAdSize:kGADAdSizeBanner];
    bannerView_.adUnitID = ClientAppID;
    bannerView_.rootViewController = root;
    GADRequest *request = [GADRequest request];
//    request.testDevices = [NSArray arrayWithObjects:@"Simulator",nil];
    [bannerView_ loadRequest:request];
    [viewBannerAdMod addSubview:bannerView_];
    [root.view addSubview:viewBannerAdMod];
    
    [viewBannerAdMod autoAlignAxisToSuperviewAxis:ALAxisVertical];
    [viewBannerAdMod autoPinEdgeToSuperviewEdge:ALEdgeBottom];
    [viewBannerAdMod autoSetDimension:ALDimensionHeight toSize:kGADAdSizeBanner.size.height];
    [viewBannerAdMod autoSetDimension:ALDimensionWidth toSize:root.view.frame.size.width];
}

#pragma mark getCurrentViewController
- (id)getCurrentViewController {
    id WindowRootVC = [[[[UIApplication sharedApplication] delegate] window] rootViewController];
    id currentViewController = [self findTopViewController:WindowRootVC];
    return currentViewController;
}

- (id)findTopViewController:(id)inController {
    if ([inController isKindOfClass:[UITabBarController class]]) {
        return [self findTopViewController:[inController selectedViewController]];
    } else if ([inController isKindOfClass:[UINavigationController class]]) {
        return [self findTopViewController:[inController visibleViewController]];
    } else if ([inController isKindOfClass:[UIViewController class]]) {
        return inController;
    } else {
        NSLog(@"Unhandled ViewController class : %@",inController);
        return nil;
    }
}

@end
