//
//  KSHNotificationAuthorization.m
//  Shield
//
//  Created by William Towe on 4/10/17.
//  Copyright © 2017 Kosoku Interactive, LLC. All rights reserved.
//
//  Redistribution and use in source and binary forms, with or without modification, are permitted provided that the following conditions are met:
//
//  1. Redistributions of source code must retain the above copyright notice, this list of conditions and the following disclaimer.
//
//  2. Redistributions in binary form must reproduce the above copyright notice, this list of conditions and the following disclaimer in the documentation and/or other materials provided with the distribution.
//
//  THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS "AS IS" AND ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED TO, THE IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE ARE DISCLAIMED. IN NO EVENT SHALL THE COPYRIGHT HOLDER OR CONTRIBUTORS BE LIABLE FOR ANY DIRECT, INDIRECT, INCIDENTAL, SPECIAL, EXEMPLARY, OR CONSEQUENTIAL DAMAGES (INCLUDING, BUT NOT LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS OR SERVICES; LOSS OF USE, DATA, OR PROFITS; OR BUSINESS INTERRUPTION) HOWEVER CAUSED AND ON ANY THEORY OF LIABILITY, WHETHER IN CONTRACT, STRICT LIABILITY, OR TORT (INCLUDING NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY OUT OF THE USE OF THIS SOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.

#import "KSHNotificationAuthorization.h"

#import <Stanley/KSTFunctions.h>

#import <UserNotifications/UserNotifications.h>

@implementation KSHNotificationAuthorization

- (void)requestNotificationAuthorizationForOptions:(KSHNotificationAuthorizationOptions)options completion:(KSHRequestNotificationAuthorizationCompletionBlock)completion {
    NSParameterAssert(options != KSHNotificationAuthorizationOptionsNone);
    NSParameterAssert(completion != nil);
    
    if (self.hasNotificationAuthorization) {
        KSTDispatchMainAsync(^{
            completion(KSHNotificationAuthorizationStatusAuthorized,nil);
        });
        return;
    }
    
    [[UNUserNotificationCenter currentNotificationCenter] requestAuthorizationWithOptions:(UNAuthorizationOptions)options completionHandler:^(BOOL granted, NSError * _Nullable error) {
        KSTDispatchMainAsync(^{
            completion(granted ? KSHNotificationAuthorizationStatusAuthorized : KSHNotificationAuthorizationStatusDenied, error);
        });
    }];
}

+ (KSHNotificationAuthorization *)sharedAuthorization {
    static KSHNotificationAuthorization *kRetval;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        kRetval = [[KSHNotificationAuthorization alloc] init];
    });
    return kRetval;
}

- (BOOL)hasNotificationAuthorization {
    return self.notificationAuthorizationStatus == KSHNotificationAuthorizationStatusAuthorized;
}
- (KSHNotificationAuthorizationStatus)notificationAuthorizationStatus {
    __block KSHNotificationAuthorizationStatus retval = KSHNotificationAuthorizationStatusNotDetermined;
    dispatch_semaphore_t semaphore = dispatch_semaphore_create(0);
    
    dispatch_async(dispatch_get_global_queue(QOS_CLASS_DEFAULT, 0), ^{
        [[UNUserNotificationCenter currentNotificationCenter] getNotificationSettingsWithCompletionHandler:^(UNNotificationSettings * _Nonnull settings) {
            retval = (KSHNotificationAuthorizationStatus)settings.authorizationStatus;
            
            dispatch_semaphore_signal(semaphore);
        }];
    });
    
    dispatch_semaphore_wait(semaphore, DISPATCH_TIME_FOREVER);
    
    return retval;
}
- (KSHNotificationAuthorizationOptions)notificationAuthorizationOptions {
    __block KSHNotificationAuthorizationOptions retval = KSHNotificationAuthorizationOptionsNone;
    dispatch_semaphore_t semaphore = dispatch_semaphore_create(0);
    
    dispatch_async(dispatch_get_global_queue(QOS_CLASS_DEFAULT, 0), ^{
        [[UNUserNotificationCenter currentNotificationCenter] getNotificationSettingsWithCompletionHandler:^(UNNotificationSettings * _Nonnull settings) {
            if (settings.badgeSetting == UNNotificationSettingEnabled) {
                retval |= KSHNotificationAuthorizationOptionsBadge;
            }
#if (TARGET_OS_IOS)
            if (settings.soundSetting == UNNotificationSettingEnabled) {
                retval |= KSHNotificationAuthorizationOptionsSound;
            }
            if (settings.alertSetting == UNNotificationSettingEnabled) {
                retval |= KSHNotificationAuthorizationOptionsAlert;
            }
            if (settings.carPlaySetting == UNNotificationSettingEnabled) {
                retval |= KSHNotificationAuthorizationOptionsCarPlay;
            }
#endif
            
            dispatch_semaphore_signal(semaphore);
        }];
    });
    
    dispatch_semaphore_wait(semaphore, DISPATCH_TIME_FOREVER);
    
    return retval;
}

@end
