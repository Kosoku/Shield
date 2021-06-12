//
//  KSHHealthAuthorization.h
//  Shield
//
//  Created by William Towe on 4/8/17.
//  Copyright © 2021 Kosoku Interactive, LLC. All rights reserved.
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
#import <HealthKit/HKHealthStore.h>

NS_ASSUME_NONNULL_BEGIN

/**
 Enum defining the possible health share authorization status values. See HKAuthorizationStatus for more information.
 */
typedef NS_ENUM(NSInteger, KSHHealthAuthorizationStatus) {
    /**
     See HKAuthorizationStatusNotDetermined for more information.
     */
    KSHHealthAuthorizationStatusNotDetermined = HKAuthorizationStatusNotDetermined,
    /**
     See HKAuthorizationStatusSharingDenied for more information.
     */
    KSHHealthAuthorizationStatusDenied = HKAuthorizationStatusSharingDenied,
    /**
     See HKAuthorizationStatusSharingAuthorized for more information.
     */
    KSHHealthAuthorizationStatusAuthorized = HKAuthorizationStatusSharingAuthorized
};
/**
 Completion block that is invoked after requesting health share access.
 
 @param success Whether access was granted
 @param objectsToAuthorizationStatus A dictionary of the object types that were passed in to the authorization status for each type
 @param error The error
 */
typedef void(^KSHRequestHealthAuthorizationCompletionBlock)(BOOL success, NSDictionary<HKObjectType *, NSNumber *> *objectsToAuthorizationStatus, NSError * _Nullable error);

/**
 KSHHealthAuthorization wraps the APIs needed to request health access from the user.
 */
@interface KSHHealthAuthorization : NSObject

/**
 Get the shared health library authorization object.
 */
@property (class,readonly,nonatomic) KSHHealthAuthorization *sharedAuthorization;

/**
 Returns the health share authorization status for the provided type.
 
 @param type The type for which to return health share authorization status
 @return The health share authorization status
 */
- (KSHHealthAuthorizationStatus)healthShareAuthorizationStatusForType:(HKObjectType *)type;
/**
 Request health share authorization to read for *readTypes* and to write for *writeTypes* and invoke the provided completion block when authorization has been determined. The completion block is always invoked on the main thread. The client must provide a reason in their plist using NSHealthShareUsageDescription if *readTypes* is non-null and NSHealthUpdateUsageDescription if *writeTypes* is non-null, otherwise an exception will be thrown.
 
 @param readTypes The types to read from
 @param writeTypes The types to write to
 @param completion The completion block to invoke when authorization status has been determined
 */
- (void)requestHealthAuthorizationToReadTypes:(nullable NSArray<HKObjectType *> *)readTypes writeTypes:(nullable NSArray<HKSampleType *> *)writeTypes completion:(KSHRequestHealthAuthorizationCompletionBlock)completion;

@end

NS_ASSUME_NONNULL_END
