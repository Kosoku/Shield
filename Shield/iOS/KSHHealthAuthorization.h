//
//  KSHHealthAuthorization.h
//  Shield
//
//  Created by William Towe on 4/8/17.
//  Copyright © 2017 Kosoku Interactive, LLC. All rights reserved.
//
//  Redistribution and use in source and binary forms, with or without modification, are permitted provided that the following conditions are met:
//
//  1. Redistributions of source code must retain the above copyright notice, this list of conditions and the following disclaimer.
//
//  2. Redistributions in binary form must reproduce the above copyright notice, this list of conditions and the following disclaimer in the documentation and/or other materials provided with the distribution.
//
//  THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS "AS IS" AND ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED TO, THE IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE ARE DISCLAIMED. IN NO EVENT SHALL THE COPYRIGHT HOLDER OR CONTRIBUTORS BE LIABLE FOR ANY DIRECT, INDIRECT, INCIDENTAL, SPECIAL, EXEMPLARY, OR CONSEQUENTIAL DAMAGES (INCLUDING, BUT NOT LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS OR SERVICES; LOSS OF USE, DATA, OR PROFITS; OR BUSINESS INTERRUPTION) HOWEVER CAUSED AND ON ANY THEORY OF LIABILITY, WHETHER IN CONTRACT, STRICT LIABILITY, OR TORT (INCLUDING NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY OUT OF THE USE OF THIS SOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.

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

@interface KSHHealthAuthorization : NSObject

/**
 Get the shared media library authorization object.
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
