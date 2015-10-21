//
//  DMNetworkReachability.h
//  DamaiIphone
//
//  Created by 李德华 on 15/10/21.
//  Copyright © 2015年 damai. All rights reserved.
//

#import <Foundation/Foundation.h>
UIKIT_EXTERN NSString * const DMNetworkReachabilityAccessDidChanged;
UIKIT_EXTERN NSString * const DMNetworkAccessNotReachable;
UIKIT_EXTERN NSString * const DMNetworkAccessViaWiFi;
UIKIT_EXTERN NSString * const DMNetworkAccessVia2G;
UIKIT_EXTERN NSString * const DMNetworkAccessVia3G;
UIKIT_EXTERN NSString * const DMNetworkAccessVia4G;
@interface DMNetworkReachability : NSObject
@property (strong, nonatomic) NSString * currentNetworkState;
- (instancetype)init __attribute__((unavailable("Do not need to initialization")));
@end
