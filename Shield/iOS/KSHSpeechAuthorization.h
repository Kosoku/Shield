//
//  KSHSpeechAuthorization.h
//  Shield
//
//  Created by William Towe on 4/8/17.
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

/**
 KSHSpeechAuthorization wraps the APIs needed to request speech recognizer access from the user.
 */
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
