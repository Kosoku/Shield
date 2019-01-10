//
//  KSHCameraAuthorization.h
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

#import <Foundation/Foundation.h>
#import <AVFoundation/AVCaptureDevice.h>

NS_ASSUME_NONNULL_BEGIN

/**
 Enum defining the possible camera authorization status values. See AVAuthorizationStatus for more information.
 */
typedef NS_ENUM(NSInteger, KSHCameraAuthorizationStatus) {
    /**
     See AVAuthorizationStatusNotDetermined for more information.
     */
    KSHCameraAuthorizationStatusNotDetermined = AVAuthorizationStatusNotDetermined,
    /**
     See AVAuthorizationStatusRestricted for more information.
     */
    KSHCameraAuthorizationStatusRestricted = AVAuthorizationStatusRestricted,
    /**
     See AVAuthorizationStatusDenied for more information.
     */
    KSHCameraAuthorizationStatusDenied = AVAuthorizationStatusDenied,
    /**
     See AVAuthorizationStatusAuthorized for more information.
     */
    KSHCameraAuthorizationStatusAuthorized = AVAuthorizationStatusAuthorized
};
/**
 Completion block that is invoked after requesting camera access.
 
 @param status The current camera authorization status
 @param error The error
 */
typedef void(^KSHRequestCameraAuthorizationCompletionBlock)(KSHCameraAuthorizationStatus status, NSError * _Nullable error);

/**
 KSHCameraAuthorization wraps APIs needed to request camera access from the user.
 */
@interface KSHCameraAuthorization : NSObject

/**
 Get the shared camera authorization object.
 */
@property (class,readonly,nonatomic) KSHCameraAuthorization *sharedAuthorization;

/**
 Get whether the user has authorized camera access.
 */
@property (readonly,nonatomic) BOOL hasCameraAuthorization;
/**
 Get the camera authorization status.
 
 @see KSHCameraAuthorizationStatus
 */
@property (readonly,nonatomic) KSHCameraAuthorizationStatus cameraAuthorizationStatus;

/**
 Request camera authorization from the user and invoke the provided completion block when authorization status has been determined. The completion block is always invoked on the main thread. The client must provide a reason in their plist using NSCameraUsageDescription or an exception will be thrown.
 
 @param completion The completion block to invoke when authorization status has been determined
 */
- (void)requestCameraAuthorizationWithCompletion:(KSHRequestCameraAuthorizationCompletionBlock)completion;

@end

NS_ASSUME_NONNULL_END
