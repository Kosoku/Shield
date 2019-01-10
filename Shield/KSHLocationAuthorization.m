//
//  KSHLocationAuthorization.m
//  Shield
//
//  Created by William Towe on 4/7/17.
//  Copyright © 2019 Kosoku Interactive, LLC. All rights reserved.
//
//  Licensed under the Apache License, Version 2.0 (the "License");
//  you may not use this file except in compliance with the License.
//  You may obtain a copy of the License at
//
//  http://www.apache.org/licenses/LICENSE-2.0
//
//  Unless required by applicable law or agreed to in writing, software
//  distributed under the License is distributed on an "AS IS" BASIS,
//  WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
//  See the License for the specific language governing permissions and
//  limitations under the License.

#import "KSHLocationAuthorization.h"

#import <Stanley/KSTFunctions.h>

#import <CoreLocation/CoreLocation.h>

@interface KSHLocationAuthorization () <CLLocationManagerDelegate>
@property (strong,nonatomic) CLLocationManager *locationManager;
@property (copy,nonatomic) KSHRequestLocationAuthorizationCompletionBlock requestLocationAuthorizationCompletionBlock;
@end

@implementation KSHLocationAuthorization

- (void)locationManager:(CLLocationManager *)manager didChangeAuthorizationStatus:(CLAuthorizationStatus)status {
    if (status == kCLAuthorizationStatusNotDetermined) {
#if (TARGET_OS_OSX)
        [self.locationManager startUpdatingLocation];
#endif
        return;
    }
    
#if (TARGET_OS_IOS)
    if (status == kCLAuthorizationStatusAuthorizedAlways ||
        status == kCLAuthorizationStatusAuthorizedWhenInUse) {
#elif (TARGET_OS_TV)
    if (status == kCLAuthorizationStatusAuthorizedWhenInUse) {
#else
    if (status == kCLAuthorizationStatusAuthorizedAlways) {
#endif
        KSTDispatchMainAsync(^{
            self.requestLocationAuthorizationCompletionBlock((KSHLocationAuthorizationStatus)status,nil);
        });
    }
    else {
        KSTDispatchMainAsync(^{
            self.requestLocationAuthorizationCompletionBlock(self.locationAuthorizationStatus,nil);
        });
    }
    
    [self setLocationManager:nil];
    [self setRequestLocationAuthorizationCompletionBlock:nil];
}

- (void)requestLocationAuthorization:(KSHLocationAuthorizationStatus)authorization completion:(void(^)(KSHLocationAuthorizationStatus status, NSError *error))completion; {
#if (TARGET_OS_IOS)
    NSParameterAssert(authorization == KSHLocationAuthorizationStatusAuthorizedAlways || authorization == KSHLocationAuthorizationStatusAuthorizedWhenInUse);
    if (authorization == KSHLocationAuthorizationStatusAuthorizedAlways) {
        NSParameterAssert([NSBundle mainBundle].infoDictionary[@"NSLocationAlwaysUsageDescription"] != nil);
    }
    else {
        NSParameterAssert([NSBundle mainBundle].infoDictionary[@"NSLocationWhenInUseUsageDescription"] != nil);
    }
#elif (TARGET_OS_TV)
    NSParameterAssert(authorization == KSHLocationAuthorizationStatusAuthorizedWhenInUse);
    NSParameterAssert([NSBundle mainBundle].infoDictionary[@"NSLocationWhenInUseUsageDescription"] != nil);
#else
    NSParameterAssert(authorization == KSHLocationAuthorizationStatusAuthorizedAlways);
    NSParameterAssert([NSBundle mainBundle].infoDictionary[@"NSLocationUsageDescription"] != nil);
#endif
    NSParameterAssert(completion != nil);
    
    if (self.locationAuthorizationStatus == authorization) {
        KSTDispatchMainAsync(^{
            completion(authorization,nil);
        });
        return;
    }
    
    [self setRequestLocationAuthorizationCompletionBlock:completion];
    
    [self setLocationManager:[[CLLocationManager alloc] init]];
    [self.locationManager setDelegate:self];
    
#if (TARGET_OS_IOS)
    if (authorization == KSHLocationAuthorizationStatusAuthorizedAlways) {
        [self.locationManager requestAlwaysAuthorization];
    }
    else {
        [self.locationManager requestWhenInUseAuthorization];
    }
#elif (TARGET_OS_TV)
    [self.locationManager requestWhenInUseAuthorization];
#else
    [self.locationManager startUpdatingLocation];
#endif
}
        
+ (KSHLocationAuthorization *)sharedAuthorization {
    static KSHLocationAuthorization *kRetval;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        kRetval = [[KSHLocationAuthorization alloc] init];
    });
    return kRetval;
}
        
- (BOOL)locationServicesEnabled {
    return [CLLocationManager locationServicesEnabled];
}
        
- (BOOL)hasLocationAuthorization {
#if (TARGET_OS_IOS)
    return self.hasLocationAuthorizationAlways || self.hasLocationAuthorizationWhenInUse;
#elif (TARGET_OS_TV)
    return self.hasLocationAuthorizationWhenInUse;
#else
    return self.hasLocationAuthorizationAlways;
#endif
}
#if (TARGET_OS_IOS || TARGET_OS_OSX)
- (BOOL)hasLocationAuthorizationAlways {
    return self.locationAuthorizationStatus == KSHLocationAuthorizationStatusAuthorizedAlways;
}
#endif
#if (TARGET_OS_IPHONE)
- (BOOL)hasLocationAuthorizationWhenInUse {
    return self.locationAuthorizationStatus == KSHLocationAuthorizationStatusAuthorizedWhenInUse;
}
#endif
- (KSHLocationAuthorizationStatus)locationAuthorizationStatus {
    return (KSHLocationAuthorizationStatus)[CLLocationManager authorizationStatus];
}

@end
