//
//  KSHAuthorizationManager.m
//  Shield
//
//  Created by William Towe on 3/13/17.
//  Copyright © 2017 Kosoku Interactive, LLC. All rights reserved.
//
//  Redistribution and use in source and binary forms, with or without modification, are permitted provided that the following conditions are met:
//
//  1. Redistributions of source code must retain the above copyright notice, this list of conditions and the following disclaimer.
//
//  2. Redistributions in binary form must reproduce the above copyright notice, this list of conditions and the following disclaimer in the documentation and/or other materials provided with the distribution.
//
//  THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS "AS IS" AND ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED TO, THE IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE ARE DISCLAIMED. IN NO EVENT SHALL THE COPYRIGHT HOLDER OR CONTRIBUTORS BE LIABLE FOR ANY DIRECT, INDIRECT, INCIDENTAL, SPECIAL, EXEMPLARY, OR CONSEQUENTIAL DAMAGES (INCLUDING, BUT NOT LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS OR SERVICES; LOSS OF USE, DATA, OR PROFITS; OR BUSINESS INTERRUPTION) HOWEVER CAUSED AND ON ANY THEORY OF LIABILITY, WHETHER IN CONTRACT, STRICT LIABILITY, OR TORT (INCLUDING NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY OUT OF THE USE OF THIS SOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.

#import "KSHAuthorizationManager.h"

#import <Stanley/KSTScopeMacros.h>
#import <Stanley/KSTFunctions.h>

#if (TARGET_OS_IOS || TARGET_OS_OSX)
#import <EventKit/EKEventStore.h>
#endif
#if (TARGET_OS_IPHONE)
#import <AVFoundation/AVMediaFormat.h>
#else
#import <AppKit/AppKit.h>
#endif

#if (TARGET_OS_IOS)
@interface KSHAuthorizationManager () <CBPeripheralManagerDelegate>
#else
@interface KSHAuthorizationManager ()
#endif

@end

@implementation KSHAuthorizationManager

#if (TARGET_OS_IPHONE)

#else
- (BOOL)requestAccessibilityAuthorizationDisplayingSystemAlert:(BOOL)displaySystemAlert openSystemPreferencesIfNecessary:(BOOL)openSystemPreferences; {
    NSDictionary *options = @{(__bridge id)kAXTrustedCheckOptionPrompt: @(displaySystemAlert)};
    BOOL retval = AXIsProcessTrustedWithOptions((CFDictionaryRef)options);
    
    if (!retval &&
        openSystemPreferences) {
        
        [[NSWorkspace sharedWorkspace] openURL:[NSURL URLWithString:@"x-apple.systempreferences:com.apple.preference.security?Privacy_Accessibility"]];
    }
    
    return retval;
}
#endif

#if (TARGET_OS_IOS || TARGET_OS_OSX)
- (void)requestContactsAuthorizationWithCompletion:(KSHRequestContactsAuthorizationCompletionBlock)completion {
    NSParameterAssert(completion != nil);
    NSParameterAssert([NSBundle mainBundle].infoDictionary[@"NSContactsUsageDescription"] != nil);
    
    if (self.hasContactsAuthorization) {
        KSTDispatchMainAsync(^{
            completion(KSHContactsAuthorizationStatusAuthorized,nil);
        });
        return;
    }
    
    CNContactStore *contactStore = [[CNContactStore alloc] init];
    
    [contactStore requestAccessForEntityType:CNEntityTypeContacts completionHandler:^(BOOL granted, NSError * _Nullable error) {
        KSTDispatchMainAsync(^{
            completion(self.contactsAuthorizationStatus,error);
        });
    }];
}
#endif

+ (KSHAuthorizationManager *)sharedManager {
    static dispatch_once_t onceToken;
    static KSHAuthorizationManager *kRetval;
    dispatch_once(&onceToken, ^{
        kRetval = [[KSHAuthorizationManager alloc] init];
    });
    return kRetval;
}

#if (TARGET_OS_IPHONE)

#else
- (BOOL)hasAccessibilityAuthorization {
    NSDictionary *options = @{(__bridge id)kAXTrustedCheckOptionPrompt: @NO};
    BOOL retval = AXIsProcessTrustedWithOptions((CFDictionaryRef)options);
    
    return retval;
}
#endif

#if (TARGET_OS_IOS || TARGET_OS_OSX)
- (BOOL)hasContactsAuthorization {
    return self.contactsAuthorizationStatus == KSHContactsAuthorizationStatusAuthorized;
}
- (KSHContactsAuthorizationStatus)contactsAuthorizationStatus {
    return (KSHContactsAuthorizationStatus)[CNContactStore authorizationStatusForEntityType:CNEntityTypeContacts];
}
#endif

@end
