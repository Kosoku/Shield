//
//  KSHLocalAuthorization.m
//  Shield
//
//  Created by William Towe on 4/9/17.
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

#import "KSHLocalAuthorization.h"
#import "NSBundle+KSHPrivateExtensions.h"

#import <Stanley/Stanley.h>

#import <LocalAuthentication/LocalAuthentication.h>

NSString *const KSHLocalAuthorizationErrorDomain = @"com.kosoku.shield.local.error";

@interface KSHLocalAuthorization ()
- (NSString *)_localizedStringForErrorCode:(NSInteger)errorCode;
@end

@implementation KSHLocalAuthorization

- (BOOL)canRequestLocalAuthorizationForPolicy:(KSHLocalAuthorizationPolicy)policy error:(NSError **)error; {
    LAContext *context = [[LAContext alloc] init];
    
    return [context canEvaluatePolicy:(LAPolicy)policy error:error];
}
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
        case KSHLocalAuthorizationErrorCodeBiometryNotAvailable:
        return NSLocalizedStringWithDefaultValue(@"LOCAL_AUTHORIZATION_ERROR_CODE_TOUCH_ID_NOT_AVAILABLE", nil, [NSBundle KSH_frameworkBundle], @"Touch ID or Face ID is not available on the device.", @"local authorization error code touch id not available");
        case KSHLocalAuthorizationErrorCodeBiometryNotEnrolled:
        return NSLocalizedStringWithDefaultValue(@"LOCAL_AUTHORIZATION_ERROR_CODE_TOUCH_ID_NOT_ENROLLED", nil, [NSBundle KSH_frameworkBundle], @"The user has not enrolled in Touch ID or Face ID.", @"local authorization error code touch id not enrolled");
        case KSHLocalAuthorizationErrorCodeBiometryLockout:
        return NSLocalizedStringWithDefaultValue(@"LOCAL_AUTHORIZATION_ERROR_CODE_TOUCH_ID_LOCKOUT", nil, [NSBundle KSH_frameworkBundle], @"The user has been locked out of Touch ID or Face ID.", @"local authorization error code touch id lockout");
        default:
            return nil;
    }
}

@end
