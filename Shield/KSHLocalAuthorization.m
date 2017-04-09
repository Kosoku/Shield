//
//  KSHLocalAuthorization.m
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

#import "KSHLocalAuthorization.h"
#import "NSBundle+KSHPrivateExtensions.h"

#import <Stanley/KSTFunctions.h>

#import <LocalAuthentication/LocalAuthentication.h>

NSString *const KSHLocalAuthorizationErrorDomain = @"com.kosoku.shield.local.error";

NSInteger const KSHLocalAuthorizationErrorCodeFailed = LAErrorAuthenticationFailed;
NSInteger const KSHLocalAuthorizationErrorCodeUserCancel = LAErrorUserCancel;
NSInteger const KSHLocalAuthorizationErrorCodeUserFallback = LAErrorUserFallback;
NSInteger const KSHLocalAuthorizationErrorCodeSystemCancel = LAErrorSystemCancel;
NSInteger const KSHLocalAuthorizationErrorCodePasscodeNotSet = LAErrorPasscodeNotSet;
NSInteger const KSHLocalAuthorizationErrorCodeTouchIDNotAvailable = LAErrorTouchIDNotAvailable;
NSInteger const KSHLocalAuthorizationErrorCodeTouchIDNotEnrolled = LAErrorTouchIDNotEnrolled;
NSInteger const KSHLocalAuthorizationErrorCodeTouchIDLockout = LAErrorTouchIDLockout;

@interface KSHLocalAuthorization ()
- (NSString *)_localizedStringForErrorCode:(NSInteger)errorCode;
@end

@implementation KSHLocalAuthorization

- (void)requestLocalAuthorizationForPolicy:(KSHLocalAuthorizationPolicy)policy localizedReason:(NSString *)localizedReason completion:(KSHRequestLocalAuthorizationCompletionBlock)completion {
    [self requestLocalAuthorizationForPolicy:policy localizedReason:localizedReason localizedCancelTitle:nil localizedFallbackTitle:nil completion:completion];
}
- (void)requestLocalAuthorizationForPolicy:(KSHLocalAuthorizationPolicy)policy localizedReason:(NSString *)localizedReason localizedCancelTitle:(NSString *)localizedCancelTitle localizedFallbackTitle:(NSString *)localizedFallbackTitle completion:(KSHRequestLocalAuthorizationCompletionBlock)completion {
    NSParameterAssert(localizedReason != nil);
    NSParameterAssert(completion != nil);
    
    dispatch_async(dispatch_get_global_queue(QOS_CLASS_USER_INTERACTIVE, 0), ^{
        LAContext *context = [[LAContext alloc] init];
        
        [context setLocalizedCancelTitle:localizedCancelTitle];
        [context setLocalizedFallbackTitle:localizedFallbackTitle];
        
        NSError *outError;
        if ([context canEvaluatePolicy:(LAPolicy)policy error:&outError]) {
            [context evaluatePolicy:(LAPolicy)policy localizedReason:localizedReason reply:^(BOOL success, NSError * _Nullable error) {
                if (success) {
                    KSTDispatchMainAsync(^{
                        completion(YES,nil);
                    });
                }
                else {
                    NSMutableDictionary *userInfo = [[NSMutableDictionary alloc] init];
                    NSString *localizedDesc = [self _localizedStringForErrorCode:error.code];
                    
                    if (localizedDesc != nil) {
                        [userInfo setObject:localizedDesc forKey:NSLocalizedDescriptionKey];
                    }
                    
                    if (error != nil) {
                        [userInfo setObject:error forKey:NSUnderlyingErrorKey];
                    }
                    
                    NSError *retvalError = [NSError errorWithDomain:KSHLocalAuthorizationErrorDomain code:error.code userInfo:userInfo];
                    
                    KSTDispatchMainAsync(^{
                        completion(NO,retvalError);
                    });
                }
            }];
        }
        else {
            NSMutableDictionary *userInfo = [[NSMutableDictionary alloc] init];
            NSString *localizedDesc = [self _localizedStringForErrorCode:outError.code];
            
            if (localizedDesc != nil) {
                [userInfo setObject:localizedDesc forKey:NSLocalizedDescriptionKey];
            }
            
            if (outError != nil) {
                [userInfo setObject:outError forKey:NSUnderlyingErrorKey];
            }
            
            NSError *retvalError = [NSError errorWithDomain:KSHLocalAuthorizationErrorDomain code:outError.code userInfo:userInfo];
            
            KSTDispatchMainAsync(^{
                completion(NO,retvalError);
            });
        }
    });
}

+ (KSHLocalAuthorization *)sharedAuthorization {
    static KSHLocalAuthorization *kRetval;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        kRetval = [[KSHLocalAuthorization alloc] init];
    });
    return kRetval;
}

- (NSString *)_localizedStringForErrorCode:(NSInteger)errorCode; {
    switch (errorCode) {
        case KSHLocalAuthorizationErrorCodeFailed:
        return NSLocalizedStringWithDefaultValue(@"LOCAL_AUTHORIZATION_ERROR_CODE_FAILED", nil, [NSBundle KSH_frameworkBundle], @"The user failed to provide valid credentials.", @"local authorization error code failed");
        case KSHLocalAuthorizationErrorCodeUserCancel:
        return NSLocalizedStringWithDefaultValue(@"LOCAL_AUTHORIZATION_ERROR_CODE_USER_CANCEL", nil, [NSBundle KSH_frameworkBundle], @"The user tapped the cancel button.", @"local authorization error code user cancel");
        case KSHLocalAuthorizationErrorCodeUserFallback:
        return NSLocalizedStringWithDefaultValue(@"LOCAL_AUTHORIZATION_ERROR_CODE_USER_FALLBACK", nil, [NSBundle KSH_frameworkBundle], @"The user tapped the fallback button.", @"local authorization error code user fallback");
        case KSHLocalAuthorizationErrorCodeSystemCancel:
        return NSLocalizedStringWithDefaultValue(@"LOCAL_AUTHORIZATION_ERROR_CODE_SYSTEM_CANCEL", nil, [NSBundle KSH_frameworkBundle], @"The system cancelled the operation.", @"local authorization error code system cancel");
        case KSHLocalAuthorizationErrorCodePasscodeNotSet:
        return NSLocalizedStringWithDefaultValue(@"LOCAL_AUTHORIZATION_ERROR_CODE_PASSCODE_NOT_SET", nil, [NSBundle KSH_frameworkBundle], @"The user has not set a passcode.", @"local authorization error code passcode not set");
        case KSHLocalAuthorizationErrorCodeTouchIDNotAvailable:
        return NSLocalizedStringWithDefaultValue(@"LOCAL_AUTHORIZATION_ERROR_CODE_TOUCH_ID_NOT_AVAILABLE", nil, [NSBundle KSH_frameworkBundle], @"Touch ID is not available on the device.", @"local authorization error code touch id not available");
        case KSHLocalAuthorizationErrorCodeTouchIDNotEnrolled:
        return NSLocalizedStringWithDefaultValue(@"LOCAL_AUTHORIZATION_ERROR_CODE_TOUCH_ID_NOT_ENROLLED", nil, [NSBundle KSH_frameworkBundle], @"The user has not enrolled in Touch ID.", @"local authorization error code touch id not enrolled");
        case KSHLocalAuthorizationErrorCodeTouchIDLockout:
        return NSLocalizedStringWithDefaultValue(@"LOCAL_AUTHORIZATION_ERROR_CODE_TOUCH_ID_LOCKOUT", nil, [NSBundle KSH_frameworkBundle], @"The user has been locked out of Touch ID.", @"local authorization error code touch id lockout");
        default:
            return nil;
    }
}

@end
