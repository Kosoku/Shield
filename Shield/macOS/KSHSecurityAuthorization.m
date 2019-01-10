//
//  KSHSecurityAuthorization.m
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

#import "KSHSecurityAuthorization.h"
#import "KSHSecurityRights.h"
#import "NSBundle+KSHPrivateExtensions.h"

#import <Stanley/Stanley.h>

NSString *const KSHSecurityAuthorizationErrorDomain = @"com.kosoku.shield.security.error";

@interface KSHSecurityAuthorization ()
- (NSString *)_localizedStringForErrorCode:(NSInteger)errorCode;
@end

@implementation KSHSecurityAuthorization

- (void)requestSecurityAuthorizationForRightStrings:(NSSet<NSString *> *)rightStrings completion:(KSHRequestSecurityAuthorizationCompletionBlock)completion {
    NSParameterAssert(rightStrings.count > 0);
    NSParameterAssert(completion != nil);
    
    dispatch_async(dispatch_get_global_queue(QOS_CLASS_USER_INTERACTIVE, 0), ^{
        AuthorizationRef authorizationRef;
        OSStatus status = AuthorizationCreate(NULL, kAuthorizationEmptyEnvironment, kAuthorizationFlagDefaults, &authorizationRef);
        
        if (status == errAuthorizationSuccess) {
            NSArray *rightStringsArray = rightStrings.allObjects;
            AuthorizationItem items[rightStringsArray.count];
            
            for (NSUInteger i=0; i<rightStrings.count; i++) {
                items[i].name = [rightStringsArray[i] UTF8String];
                items[i].valueLength = 0;
                items[i].value = NULL;
                items[i].flags = 0;
            }
            
            AuthorizationRights rights;
            
            rights.count = (UInt32)(sizeof(items) / sizeof(items[0]));
            rights.items = items;
            
            AuthorizationFlags flags = kAuthorizationFlagDefaults|kAuthorizationFlagInteractionAllowed|kAuthorizationFlagExtendRights;
            
            status = AuthorizationCopyRights(authorizationRef, &rights, kAuthorizationEmptyEnvironment, flags, NULL);
            
            if (status == errAuthorizationSuccess) {
                KSHSecurityRights *securityRights = [[KSHSecurityRights alloc] initWithAuthorizationRef:authorizationRef authorizationItemSet:rights rightStrings:rightStrings];
                
                KSTDispatchMainAsync(^{
                    completion(securityRights,nil);
                });
            }
            else {
                NSString *localizedDesc = [self _localizedStringForErrorCode:status];
                NSError *error = [NSError errorWithDomain:KSHSecurityAuthorizationErrorDomain code:status userInfo:localizedDesc == nil ? nil : @{NSLocalizedDescriptionKey: localizedDesc}];
                
                KSTDispatchMainAsync(^{
                    completion(nil,error);
                });
            }
        }
        else {
            NSString *localizedDesc = [self _localizedStringForErrorCode:status];
            NSError *error = [NSError errorWithDomain:KSHSecurityAuthorizationErrorDomain code:status userInfo:localizedDesc == nil ? nil : @{NSLocalizedDescriptionKey: localizedDesc}];
            
            KSTDispatchMainAsync(^{
                completion(nil,error);
            });
        }
    });
}

+ (KSHSecurityAuthorization *)sharedAuthorization {
    static KSHSecurityAuthorization *kRetval;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        kRetval = [[KSHSecurityAuthorization alloc] init];
    });
    return kRetval;
}

- (NSString *)_localizedStringForErrorCode:(NSInteger)errorCode; {
    switch (errorCode) {
        case KSHSecurityAuthorizationErrorCodeDenied:
            return NSLocalizedStringWithDefaultValue(@"SECURITY_AUTHORIZATION_ERROR_CODE_DENIED", nil, [NSBundle KSH_frameworkBundle], @"The authorization was denied.", @"security authorization error code denied");
        case KSHSecurityAuthorizationErrorCodeCancelled:
            return NSLocalizedStringWithDefaultValue(@"SECURITY_AUTHORIZATION_ERROR_CODE_CANCELLED", nil, [NSBundle KSH_frameworkBundle], @"The authorization was cancelled by the user.", @"security authorization error code cancelled");
        default:
            return nil;
    }
}

@end
