//
//  KSHLocalAuthorization.h
//  Shield
//
//  Created by William Towe on 4/9/17.
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
#import <LocalAuthentication/LAContext.h>
#import <LocalAuthentication/LAError.h>

NS_ASSUME_NONNULL_BEGIN

/**
 Enum describing the possible policy types for local authorization.
 */
typedef NS_ENUM(NSInteger, KSHLocalAuthorizationPolicy) {
    /**
     Either password or biometric authorization is allowed.
     */
    KSHLocalAuthorizationPolicyDefault = LAPolicyDeviceOwnerAuthentication,
    /**
     Biometric authorization is required.
     */
    KSHLocalAuthorizationPolicyBiometrics = LAPolicyDeviceOwnerAuthenticationWithBiometrics
};
/**
 Block that is invoked when local authorization status has been determined.
 
 @param success Whether local authorization was successful
 @param error If *success* is NO, the error describing why the operation failed
 */
typedef void(^KSHRequestLocalAuthorizationCompletionBlock)(BOOL success, NSError * _Nullable error);

/**
 Enum for possible error codes for errors with the KSHLocalAuthorizationErrorDomain domain.
 */
typedef NS_ENUM(NSInteger, KSHLocalAuthorizationErrorCode) {
    /**
     The user entered credentials but they were invalid.
     */
    KSHLocalAuthorizationErrorCodeFailed = LAErrorAuthenticationFailed,
    /**
     The user tapped the cancel button.
     */
    KSHLocalAuthorizationErrorCodeUserCancel = LAErrorUserCancel,
    /**
     The user tapped the fallback button.
     */
    KSHLocalAuthorizationErrorCodeUserFallback = LAErrorUserFallback,
    /**
     The system cancelled the request (e.g. another application was brought to the foreground).
     */
    KSHLocalAuthorizationErrorCodeSystemCancel = LAErrorSystemCancel,
    /**
     The user has not set a passcode.
     */
    KSHLocalAuthorizationErrorCodePasscodeNotSet = LAErrorPasscodeNotSet,
    /**
     Touch ID is not available on the device.
     */
    KSHLocalAuthorizationErrorCodeTouchIDNotAvailable = LAErrorTouchIDNotAvailable,
    /**
     The user has not registered any fingers with Touch ID.
     */
    KSHLocalAuthorizationErrorCodeTouchIDNotEnrolled = LAErrorTouchIDNotEnrolled,
    /**
     The user failed to authenticate too many times using Touch ID.
     */
    KSHLocalAuthorizationErrorCodeTouchIDLockout = LAErrorTouchIDLockout
};
/**
 The error domain for local authorization errors.
 */
FOUNDATION_EXPORT NSString *const KSHLocalAuthorizationErrorDomain;

/**
 KSHLocalAuthorization wraps the APIs needed to request local authentication from the user using Touch ID (if available) or username/password.
 */
@interface KSHLocalAuthorization : NSObject

/**
 Get the shared local authorization object.
 */
@property (class,readonly,nonatomic) KSHLocalAuthorization *sharedAuthorization;

/**
 Returns whether the policy can be evaluated or would always evaluate to NO. For example, passing KSHLocalAuthorizationPolicyBiometrics when touch ID hardware is not available would return NO with an appropriate error.
 
 @param policy The policy to test for possible evaluation
 @param error If the method returns NO, contains more information about the reason for failure
 @return YES if the policy can be evaluated, otherwise NO
 */
- (BOOL)canRequestLocalAuthorizationForPolicy:(KSHLocalAuthorizationPolicy)policy error:(NSError **)error;
/**
 Calls `[self requestLocalAuthorizationForPolicy:policy localizedReason:localizedReason localizedCancelTitle:nil localizedFallbackTitle:nil completion:completion]`.
 
 @param policy The policy to request
 @param localizedReason The localized reason for requesting authorization
 @param completion The completion block that will be invoked when authorization status has been determined
 @exception NSException Thrown if *localizedReason* or *completion* are nil
 */
- (void)requestLocalAuthorizationForPolicy:(KSHLocalAuthorizationPolicy)policy localizedReason:(NSString *)localizedReason completion:(KSHRequestLocalAuthorizationCompletionBlock)completion;
/**
 Request local authorization from the user for *policy* using *localizedReason* and invokes *completion* when authorization status has been determined. The *completion* block is always invoked on the main thread.
 
 @param policy The policy to request
 @param localizedReason The localized reason for requesting authorization
 @param localizedCancelTitle The localized cancel button title, @"Cancel" is the default
 @param localizedFallbackTitle The localized fallback button title, @"Use Password" is the default
 @param completion The completion block that will be invoked when authorization status has been determined
 @exception NSException Thrown if *localizedReason* or *completion* are nil
 */
- (void)requestLocalAuthorizationForPolicy:(KSHLocalAuthorizationPolicy)policy localizedReason:(NSString *)localizedReason localizedCancelTitle:(nullable NSString *)localizedCancelTitle localizedFallbackTitle:(nullable NSString *)localizedFallbackTitle completion:(KSHRequestLocalAuthorizationCompletionBlock)completion;

@end

NS_ASSUME_NONNULL_END
