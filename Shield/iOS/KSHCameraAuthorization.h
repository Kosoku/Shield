//
//  KSHCameraAuthorization.h
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
