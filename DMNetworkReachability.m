//
//  DMNetworkReachability.m
//  DamaiIphone
//
//  Created by 李德华 on 15/10/21.
//  Copyright © 2015年 damai. All rights reserved.
//

#import "DMNetworkReachability.h"

#if (defined(__IPHONE_OS_VERSION_MAX_ALLOWED) && __IPHONE_OS_VERSION_MAX_ALLOWED >= 70000)

#import "Reachability.h"
#import <CoreTelephony/CTTelephonyNetworkInfo.h>
NSString * const DMNetworkReachabilityAccessDidChanged = @"DMNetworkReachabilityAccessDidChanged";
NSString * const DMNetworkAccessNotReachable = @"DMNetworkAccessNotReachable";
NSString * const DMNetworkAccessViaWiFi = @"DMNetworkAccessViaWiFi";
NSString * const DMNetworkAccessVia2G = @"DMNetworkAccessVia2G";
NSString * const DMNetworkAccessVia3G = @"DMNetworkAccessVia3G";
NSString * const DMNetworkAccessVia4G = @"DMNetworkAccessVia4G";

@interface DMNetworkReachability()
@property (strong, nonatomic) Reachability * reach;
@property (strong, nonatomic) CTTelephonyNetworkInfo * networkInfo;
@end
@implementation DMNetworkReachability
static DMNetworkReachability * networkReachability;

+ (void)load {
    networkReachability = [[DMNetworkReachability alloc] initWithHostname:@"m.damai.cn"];
}
-(instancetype)initWithHostname:(NSString *)hostname {
    if (self = [super init]) {
        self.reach = [Reachability reachabilityWithHostname:hostname];
        [self.reach startNotifier];
        self.networkInfo = [[CTTelephonyNetworkInfo alloc] init];
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(reachabilityChanged:) name:kReachabilityChangedNotification object:nil];
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(technologyChanged:) name:CTRadioAccessTechnologyDidChangeNotification object:nil];
    }
    return self;
}
- (void)reachabilityChanged:(NSNotification *)note {
    switch (self.reach.currentReachabilityStatus) {
        case NotReachable:
            _currentNetworkState = DMNetworkAccessNotReachable;
            [[NSNotificationCenter defaultCenter] postNotificationName:DMNetworkReachabilityAccessDidChanged object:self];
            break;
        case ReachableViaWWAN:
            _currentNetworkState = [self getStateString];
            [[NSNotificationCenter defaultCenter] postNotificationName:DMNetworkReachabilityAccessDidChanged object:self];
            break;
        case ReachableViaWiFi:
            _currentNetworkState = DMNetworkAccessViaWiFi;
            [[NSNotificationCenter defaultCenter] postNotificationName:DMNetworkReachabilityAccessDidChanged object:self];
            break;
        default:
            break;
    }
}
- (void)technologyChanged:(NSNotification *)note {
    if (self.reach.currentReachabilityStatus == ReachableViaWWAN) {
        _currentNetworkState = [self getStateString];
        [[NSNotificationCenter defaultCenter] postNotificationName:DMNetworkReachabilityAccessDidChanged object:self];
    }
}
- (NSString *)getStateString {
    if ([self.networkInfo.currentRadioAccessTechnology isEqualToString:CTRadioAccessTechnologyGPRS]) {  //2g
        return DMNetworkAccessVia2G;
    } else if ([self.networkInfo.currentRadioAccessTechnology isEqualToString:CTRadioAccessTechnologyEdge]) { //2.75g
        return DMNetworkAccessVia2G;
    } else if ([self.networkInfo.currentRadioAccessTechnology isEqualToString:CTRadioAccessTechnologyWCDMA]) {//3g
        return DMNetworkAccessVia3G;
    } else if ([self.networkInfo.currentRadioAccessTechnology isEqualToString:CTRadioAccessTechnologyHSDPA]) {//3.5g
        return DMNetworkAccessVia3G;
    } else if ([self.networkInfo.currentRadioAccessTechnology isEqualToString:CTRadioAccessTechnologyHSUPA]) {//3.5g
        return DMNetworkAccessVia3G;
    } else if ([self.networkInfo.currentRadioAccessTechnology isEqualToString:CTRadioAccessTechnologyCDMA1x]) {//3g
        return DMNetworkAccessVia3G;
    } else if ([self.networkInfo.currentRadioAccessTechnology isEqualToString:CTRadioAccessTechnologyCDMAEVDORev0]) {//3g
        return DMNetworkAccessVia3G;
    } else if ([self.networkInfo.currentRadioAccessTechnology isEqualToString:CTRadioAccessTechnologyCDMAEVDORevA]) {//3g
        return DMNetworkAccessVia3G;
    } else if ([self.networkInfo.currentRadioAccessTechnology isEqualToString:CTRadioAccessTechnologyCDMAEVDORevB]) {//3g
        return DMNetworkAccessVia3G;
    } else if ([self.networkInfo.currentRadioAccessTechnology isEqualToString:CTRadioAccessTechnologyeHRPD]) {//3.75g
        return DMNetworkAccessVia3G;
    } else if ([self.networkInfo.currentRadioAccessTechnology isEqualToString:CTRadioAccessTechnologyLTE]) {//4g
        return DMNetworkAccessVia4G;
    }
    return nil;
}
@end
#endif