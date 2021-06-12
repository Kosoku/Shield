//
//  KSHMicrophoneAuthorization.h
//  Shield
//
//  Created by William Towe on 4/7/17.
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
#import <AVFoundation/AVCaptureDevice.h>

NS_ASSUME_NONNULL_BEGIN

/**
 Enum defining the possible microphone authorization status values. See AVAuthorizationStatus for more information.
 */
typedef NS_ENUM(NSInteger, KSHMicrophoneAuthorizationStatus) {
    /**
     See AVAuthorizationStatusNotDetermined for more information.
     */
    KSHMicrophoneAuthorizationStatusNotDetermined = AVAuthorizationStatusNotDetermined,
    /**
     See AVAuthorizationStatusRestricted for more information.
     */
    KSHMicrophoneAuthorizationStatusRestricted = AVAuthorizationStatusRestricted,
    /**
     See AVAuthorizationStatusDenied for more information.
     */
    KSHMicrophoneAuthorizationStatusDenied = AVAuthorizationStatusDenied,
    /**
     See AVAuthorizationStatusAuthorized for more information.
     */
    KSHMicrophoneAuthorizationStatusAuthorized = AVAuthorizationStatusAuthorized
};
/**
 Completion block that is invoked after requesting microphone access.
 
 @param status The current microphone authorization status
 @param error The error
 */
typedef void(^KSHRequestMicrophoneAuthorizationCompletionBlock)(KSHMicrophoneAuthorizationStatus status, NSError * _Nullable error);

/**
 KSHMicrophoneAuthorization wraps APIs needed to request microphone access from the user.
 */
@interface KSHMicrophoneAuthorization : NSObject

/**
 Get the shared microphone authorization object.
 */
@property (class,readonly,nonatomic) KSHMicrophoneAuthorization *sharedAuthorization;

/**
 Get whether the user has authorized microphone access.
 */
@property (readonly,nonatomic) BOOL hasMicrophoneAuthorization;
/**
 Get the microphone authorization status.
 
 @see KSHMicrophoneAuthorizationStatus
 */
@property (readonly,nonatomic) KSHMicrophoneAuthorizationStatus microphoneAuthorizationStatus;

/**
 Request microphone authorization from the user and invoke the provided completion block when authorization status has been determined. The completion block is always invoked on the main thread. The client must provide a reason in their plist using NSMicrophoneUsageDescription or an exception will be thrown.
 
 @param completion The completion block to invoke when authorization status has been determined
 */
- (void)requestMicrophoneAuthorizationWithCompletion:(KSHRequestMicrophoneAuthorizationCompletionBlock)completion;

@end

NS_ASSUME_NONNULL_END
