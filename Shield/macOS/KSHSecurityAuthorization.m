//
//  KSHSecurityAuthorization.m
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
