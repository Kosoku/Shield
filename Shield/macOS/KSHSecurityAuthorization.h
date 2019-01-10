//
//  KSHSecurityAuthorization.h
//  Shield
//
//  Created by William Towe on 4/8/17.
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
 Enum for possible error codes for error with the KSHSecurityAuthorizationErrorDomain domain.
 */
typedef NS_ENUM(NSInteger,KSHSecurityAuthorizationErrorCode) {
    /**
     The user denied security authorization. For example, closing the username/password dialog.
     */
    KSHSecurityAuthorizationErrorCodeDenied = errAuthorizationDenied,
    /**
     The user cancelled security authorization. For example, clicking the close button on the username/password dialog.
     */
    KSHSecurityAuthorizationErrorCodeCancelled = errAuthorizationCanceled
};
/**
 The error domain for security authorization errors.
 */
FOUNDATION_EXPORT NSString *const KSHSecurityAuthorizationErrorDomain;

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
