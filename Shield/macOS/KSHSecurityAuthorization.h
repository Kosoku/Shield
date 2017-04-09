//
//  KSHSecurityAuthorization.h
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

NS_ASSUME_NONNULL_BEGIN

@class KSHSecurityRights;

/**
 Block that is invoked when the security authorization status has been determined. The returned *securityRights* object should be retained as long as the application needs to perform privileged operations.
 
 @param securityRights The object representing the elevated security privileges
 @param error If *securityRights* is nil, the error describing the reason for failure
 @see KSHSecurityRights
 */
typedef void(^KSHRequestSecurityAuthorizationCompletionBlock)(KSHSecurityRights * _Nullable securityRights, NSError * _Nullable error);

/**
 The error domain for security authorization errors.
 */
FOUNDATION_EXPORT NSString *const KSHSecurityAuthorizationErrorDomain;

/**
 The user denied security authorization. For example, closing the username/password dialog.
 */
FOUNDATION_EXPORT NSInteger const KSHSecurityAuthorizationErrorCodeDenied;
/**
 The user cancelled security authorization. For example, clicking the close button on the username/password dialog.
 */
FOUNDATION_EXPORT NSInteger const KSHSecurityAuthorizationErrorCodeCancelled;

/**
 KSHSecurityAuthorization wraps the APIs necessary for requesting elevated privileges from the user for a set of rights. Note that these methods will not work if the client app is sandboxed.
 */
@interface KSHSecurityAuthorization : NSObject

/**
 Get the shared security authorization.
 */
@property (class,readonly,nonatomic) KSHSecurityAuthorization *sharedAuthorization;

/**
 Request security authorization from the user for the set of *rightStrings* and invoke the *completion* block when the authorization status is determined. The *completion* block is always invoked on the main thread.
 
 @param rightStrings The set of rights for which to request authorization
 @param completion The completion block to invoke when the authorization has been determined
 @exception NSException Thrown if *rightStrings* or *completion* are nil
 */
- (void)requestSecurityAuthorizationForRightStrings:(NSSet<NSString *> *)rightStrings completion:(KSHRequestSecurityAuthorizationCompletionBlock)completion;

@end

NS_ASSUME_NONNULL_END
