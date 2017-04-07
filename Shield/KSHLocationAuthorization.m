//
//  KSHLocationAuthorization.m
//  Shield
//
//  Created by William Towe on 4/7/17.
//  Copyright © 2017 Kosoku Interactive, LLC. All rights reserved.
//
//  Redistribution and use in source and binary forms, with or without modification, are permitted provided that the following conditions are met:
//
//  1. Redistributions of source code must retain the above copyright notice, this list of conditions and the following disclaimer.
//
//  2. Redistributions in binary form must reproduce the above copyright notice, this list of conditions and the following disclaimer in the documentation and/or other materials provided with the distribution.
//
//  THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS "AS IS" AND ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED TO, THE IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE ARE DISCLAIMED. IN NO EVENT SHALL THE COPYRIGHT HOLDER OR CONTRIBUTORS BE LIABLE FOR ANY DIRECT, INDIRECT, INCIDENTAL, SPECIAL, EXEMPLARY, OR CONSEQUENTIAL DAMAGES (INCLUDING, BUT NOT LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS OR SERVICES; LOSS OF USE, DATA, OR PROFITS; OR BUSINESS INTERRUPTION) HOWEVER CAUSED AND ON ANY THEORY OF LIABILITY, WHETHER IN CONTRACT, STRICT LIABILITY, OR TORT (INCLUDING NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY OUT OF THE USE OF THIS SOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.

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
