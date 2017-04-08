//
//  KSHMicrophoneAuthorization.h
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
