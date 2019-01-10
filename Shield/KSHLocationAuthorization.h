//
//  KSHLocationAuthorization.h
//  Shield
//
//  Created by William Towe on 4/7/17.
//  Copyright © 2017 Kosoku Interactive, LLC. All rights reserved.
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

#import <Foundation/Foundation.h>
#import <CoreLocation/CLLocationManager.h>

NS_ASSUME_NONNULL_BEGIN

/**
 Enum defining the possible location authorization status values. See CLAuthorizationStatus for more information.
 */
typedef NS_ENUM(int, KSHLocationAuthorizationStatus) {
    /**
     See kCLAuthorizationStatusNotDetermined for more information.
     */
    KSHLocationAuthorizationStatusNotDetermined = kCLAuthorizationStatusNotDetermined,
    /**
     See kCLAuthorizationStatusRestricted for more information.
     */
    KSHLocationAuthorizationStatusRestricted = kCLAuthorizationStatusRestricted,
    /**
     See kCLAuthorizationStatusDenied for more information.
     */
    KSHLocationAuthorizationStatusDenied = kCLAuthorizationStatusDenied,
#if (TARGET_OS_IOS || TARGET_OS_OSX)
    /**
     See kCLAuthorizationStatusAuthorizedAlways for more information.
     */
    KSHLocationAuthorizationStatusAuthorizedAlways = kCLAuthorizationStatusAuthorizedAlways,
#endif
#if (TARGET_OS_IPHONE)
    /**
     See kCLAuthorizationStatusAuthorizedWhenInUse for more information.
     */
    KSHLocationAuthorizationStatusAuthorizedWhenInUse = kCLAuthorizationStatusAuthorizedWhenInUse
#endif
};
/**
 Completion block that is invoked after requesting location access.
 
 @param status The current location authorization status
 @param error The error
 */
typedef void(^KSHRequestLocationAuthorizationCompletionBlock)(KSHLocationAuthorizationStatus status, NSError * _Nullable error);

/**
 KSHLocationAuthorization wraps the APIs needed to request location access from the user.
 */
@interface KSHLocationAuthorization : NSObject

/**
 Get the shared location authorization.
 */
@property (class,readonly,nonatomic) KSHLocationAuthorization *sharedAuthorization;

/**
 Get whether location services are enabled. This will be NO if the user has disabled location services entirely within the Settings app.
 */
@property (readonly,nonatomic) BOOL locationServicesEnabled;

/**
 Get whether the user has authorized location access.
 */
@property (readonly,nonatomic) BOOL hasLocationAuthorization;
#if (TARGET_OS_IOS || TARGET_OS_OSX)
/**
 Get whether the user has authorized location always access.
 */
@property (readonly,nonatomic) BOOL hasLocationAuthorizationAlways;
#endif
#if (TARGET_OS_IPHONE)
/**
 Get whether the user has authorized location when in use access.
 */
@property (readonly,nonatomic) BOOL hasLocationAuthorizationWhenInUse;
#endif
/**
 Get the location authorization status.
 
 @see KSHLocationAuthorizationStatus
 */
@property (readonly,nonatomic) KSHLocationAuthorizationStatus locationAuthorizationStatus;

/**
 Request location authorization from the user and invoke the provided completion block when authorization status has been determined. The client should pass KSHLocationAuthorizationStatusAuthorizedAlways or KSHLocationAuthorizationStatusAuthorizedWhenInUse for authorization. The completion block is always invoked on the main thread. The client must provide a reason in their plist using NSLocationWhenInUseUsageDescription or NSLocationAlwaysUsageDescription on iOS, NSLocationWhenInUseUsageDescription on tvOS or NSLocationUsageDescription on macOS, otherwise an exception will be thrown.
 
 @param authorization The location authorization to request
 @param completion The completion block to invoke when authorization status has been determined
 */
- (void)requestLocationAuthorization:(KSHLocationAuthorizationStatus)authorization completion:(KSHRequestLocationAuthorizationCompletionBlock)completion;

@end

NS_ASSUME_NONNULL_END
