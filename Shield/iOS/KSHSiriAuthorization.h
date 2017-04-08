//
//  KSHSiriAuthorization.h
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
#import <Intents/INPreferences.h>

NS_ASSUME_NONNULL_BEGIN

/**
 Enum defining the possible siri authorization status values. See INSiriAuthorizationStatus for more information.
 */
typedef NS_ENUM(NSInteger, KSHSiriAuthorizationStatus) {
    /**
     See INSiriAuthorizationStatusNotDetermined for more information.
     */
    KSHSiriAuthorizationStatusNotDetermined = INSiriAuthorizationStatusNotDetermined,
    /**
     See INSiriAuthorizationStatusRestricted for more information.
     */
    KSHSiriAuthorizationStatusRestricted = INSiriAuthorizationStatusRestricted,
    /**
     See INSiriAuthorizationStatusDenied for more information.
     */
    KSHSiriAuthorizationStatusDenied = INSiriAuthorizationStatusDenied,
    /**
     See INSiriAuthorizationStatusAuthorized for more information.
     */
    KSHSiriAuthorizationStatusAuthorized = INSiriAuthorizationStatusAuthorized
};
/**
 Completion block that is invoked after requesting siri access.
 
 @param status The current siri authorization status
 @param error The error
 */
typedef void(^KSHRequestSiriAuthorizationCompletionBlock)(KSHSiriAuthorizationStatus status, NSError * _Nullable error);

@interface KSHSiriAuthorization : NSObject

/**
 Get the shared siri authorization object.
 */
@property (class,readonly,nonatomic) KSHSiriAuthorization *sharedAuthorization;

/**
 Get whether the user has authorized siri access.
 */
@property (readonly,nonatomic) BOOL hasSiriAuthorization;
/**
 Get the siri authorization status.
 
 @see KSHSiriAuthorizationStatus
 */
@property (readonly,nonatomic) KSHSiriAuthorizationStatus siriAuthorizationStatus;

/**
 Requst siri authorization from the user and invoke the provided completion block when authorization status has been determined. The completion block is always invoked on the main thread. The client must provide a reason in their plist using NSSiriUsageDescription or an exception will be thrown.
 
 @param completion The completion block to invoke when authorization status has been determined
 */
- (void)requestSiriAuthorizationWithCompletion:(KSHRequestSiriAuthorizationCompletionBlock)completion;

@end

NS_ASSUME_NONNULL_END
