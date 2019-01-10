//
//  KSHAccessibilityAuthorization.m
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
