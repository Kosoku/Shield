//
//  KSHNotificationAuthorization.m
//  Shield
//
//  Created by William Towe on 4/10/17.
//  Copyright © 2021 Kosoku Interactive, LLC. All rights reserved.
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
