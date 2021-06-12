//
//  KSHPhotosAuthorization.h
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
#import <Photos/PHPhotoLibrary.h>

NS_ASSUME_NONNULL_BEGIN

/**
 Enum defining the possible photo library authorization status values. See PHAuthorizationStatus for more information.
 */
typedef NS_ENUM(NSInteger, KSHPhotosAuthorizationStatus) {
    /**
     See PHAuthorizationStatusNotDetermined for more information.
     */
    KSHPhotosAuthorizationStatusNotDetermined = PHAuthorizationStatusNotDetermined,
    /**
     See PHAuthorizationStatusRestricted for more information.
     */
    KSHPhotosAuthorizationStatusRestricted = PHAuthorizationStatusRestricted,
    /**
     See PHAuthorizationStatusDenied for more information.
     */
    KSHPhotosAuthorizationStatusDenied = PHAuthorizationStatusDenied,
    /**
     See PHAuthorizationStatusAuthorized for more information.
     */
    KSHPhotosAuthorizationStatusAuthorized = PHAuthorizationStatusAuthorized
};
/**
 Completion block that is invoked after requesting photo library access.
 
 @param status The current photo library authorization status
 @param error The error
 */
typedef void(^KSHRequestPhotoLibraryAuthorizationCompletionBlock)(KSHPhotosAuthorizationStatus status, NSError * _Nullable error);

/**
 KSHPhotosAuthorization wraps the APIs needed to request Photos access from the user.
 */
@interface KSHPhotosAuthorization : NSObject

/**
 Get the shared media library authorization object.
 */
@property (class,readonly,nonatomic) KSHPhotosAuthorization *sharedAuthorization;

/**
 Get whether the user has authorized photo library access.
 */
@property (readonly,nonatomic) BOOL hasPhotoLibraryAuthorization;
/**
 Get the photo library authorization status.
 
 @see KSHPhotosAuthorizationStatus
 */
@property (readonly,nonatomic) KSHPhotosAuthorizationStatus photoLibraryAuthorizationStatus;

/**
 Request photo library authorization from the user and invoke the provided completion block when authorization status has been determined. The completion block is always invoked on the main thread. The client must provide a reason in their plist using NSPhotoLibraryUsageDescription or an exception will be thrown.
 
 @param completion The completion block to invoke when authorization status has been determined
 */
- (void)requestPhotoLibraryAuthorizationWithCompletion:(KSHRequestPhotoLibraryAuthorizationCompletionBlock)completion;

@end

NS_ASSUME_NONNULL_END
