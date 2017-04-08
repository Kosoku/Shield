//
//  KSHAccessibilityAuthorization.m
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

#import "KSHAccessibilityAuthorization.h"

#import <ApplicationServices/ApplicationServices.h>
#import <AppKit/AppKit.h>

@implementation KSHAccessibilityAuthorization

- (BOOL)requestAccessibilityAuthorizationDisplayingSystemAlert:(BOOL)displaySystemAlert openSystemPreferencesIfNecessary:(BOOL)openSystemPreferences; {
    NSDictionary *options = @{(__bridge id)kAXTrustedCheckOptionPrompt: @(displaySystemAlert)};
    BOOL retval = AXIsProcessTrustedWithOptions((CFDictionaryRef)options);
    
    if (!retval &&
        openSystemPreferences) {
        
        [[NSWorkspace sharedWorkspace] openURL:[NSURL URLWithString:@"x-apple.systempreferences:com.apple.preference.security?Privacy_Accessibility"]];
    }
    
    return retval;
}

+ (KSHAccessibilityAuthorization *)sharedAuthorization {
    static KSHAccessibilityAuthorization *kRetval;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        kRetval = [[KSHAccessibilityAuthorization alloc] init];
    });
    return kRetval;
}

- (BOOL)hasAccessibilityAuthorization {
    NSDictionary *options = @{(__bridge id)kAXTrustedCheckOptionPrompt: @NO};
    BOOL retval = AXIsProcessTrustedWithOptions((CFDictionaryRef)options);
    
    return retval;
}

@end
