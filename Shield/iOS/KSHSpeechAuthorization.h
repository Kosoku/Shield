//
//  KSHSpeechAuthorization.h
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
#import <Speech/SFSpeechRecognizer.h>

NS_ASSUME_NONNULL_BEGIN

/**
 Enum defining the possible speech recognition authorization status values. See SFSpeechRecognizerAuthorizationStatus for more information.
 */
typedef NS_ENUM(NSInteger, KSHSpeechRecognitionAuthorizationStatus) {
    /**
     See SFSpeechRecognizerAuthorizationStatusNotDetermined for more information.
     */
    KSHSpeechRecognitionAuthorizationStatusNotDetermined = SFSpeechRecognizerAuthorizationStatusNotDetermined,
    /**
     See SFSpeechRecognizerAuthorizationStatusRestricted for more information.
     */
    KSHSpeechRecognitionAuthorizationStatusRestricted = SFSpeechRecognizerAuthorizationStatusRestricted,
    /**
     See SFSpeechRecognizerAuthorizationStatusDenied for more information.
     */
    KSHSpeechRecognitionAuthorizationStatusDenied = SFSpeechRecognizerAuthorizationStatusDenied,
    /**
     See SFSpeechRecognizerAuthorizationStatusAuthorized for more information.
     */
    KSHSpeechRecognitionAuthorizationStatusAuthorized = SFSpeechRecognizerAuthorizationStatusAuthorized
};
/**
 Completion block that is invoked after requesting speech recognition access.
 
 @param status The current speech recognition authorization status
 @param error The error
 */
typedef void(^KSHRequestSpeechRecognitionAuthorizationCompletionBlock)(KSHSpeechRecognitionAuthorizationStatus status, NSError * _Nullable error);

@interface KSHSpeechAuthorization : NSObject

/**
 Get the shared speech authorization object.
 */
@property (class,readonly,nonatomic) KSHSpeechAuthorization *sharedAuthorization;

/**
 Get whether the user has authorized speech recognition access.
 */
@property (readonly,nonatomic) BOOL hasSpeechRecognitionAuthorization;
/**
 Get the speech recognition authorization status.
 
 @see KSHSpeechRecognitionAuthorizationStatus
 */
@property (readonly,nonatomic) KSHSpeechRecognitionAuthorizationStatus speechRecognitionAuthorizationStatus;

/**
 Request speech recognition authorization from the user and invoke the provided completion block when authorization status has been determined. The completion block is always invoked on the main thread. The client must provide a reason in their plist using NSSpeechRecognitionUsageDescription or an exception will be thrown.
 
 @param completion The completion block to invoke when authorization status has been determined
 */
- (void)requestSpeechRecognitionAuthorizationWithCompletion:(KSHRequestSpeechRecognitionAuthorizationCompletionBlock)completion;

@end

NS_ASSUME_NONNULL_END
