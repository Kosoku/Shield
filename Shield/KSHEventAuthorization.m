//
//  KSHEventAuthorization.m
//  Shield
//
//  Created by William Towe on 4/8/17.
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

#import "KSHEventAuthorization.h"

#import <Stanley/KSTFunctions.h>

#import <EventKit/EventKit.h>

@implementation KSHEventAuthorization

- (void)requestCalendarsAuthorizationWithCompletion:(KSHRequestCalendarsAuthorizationCompletionBlock)completion {
    NSParameterAssert(completion != nil);
    NSParameterAssert([NSBundle mainBundle].infoDictionary[@"NSCalendarsUsageDescription"] != nil);
    
    EKEventStore *eventStore = [[EKEventStore alloc] init];
    
    [eventStore requestAccessToEntityType:EKEntityTypeEvent completion:^(BOOL granted, NSError * _Nullable error) {
        KSTDispatchMainAsync(^{
            completion(self.calendarsAuthorizationStatus,error);
        });
    }];
}
- (void)requestRemindersAuthorizationWithCompletion:(KSHRequestRemindersAuthorizationCompletionBlock)completion {
    NSParameterAssert(completion != nil);
    NSParameterAssert([NSBundle mainBundle].infoDictionary[@"NSRemindersUsageDescription"] != nil);
    
    EKEventStore *eventStore = [[EKEventStore alloc] init];
    
    [eventStore requestAccessToEntityType:EKEntityTypeReminder completion:^(BOOL granted, NSError * _Nullable error) {
        KSTDispatchMainAsync(^{
            completion(self.remindersAuthorizationStatus,error);
        });
    }];
}

+ (KSHEventAuthorization *)sharedAuthorization {
    static KSHEventAuthorization *kRetval;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        kRetval = [[KSHEventAuthorization alloc] init];
    });
    return kRetval;
}

- (BOOL)hasCalendarsAuthorization {
    return self.calendarsAuthorizationStatus == KSHCalendarsAuthorizationStatusAuthorized;
}
- (KSHCalendarsAuthorizationStatus)calendarsAuthorizationStatus {
    return (KSHCalendarsAuthorizationStatus)[EKEventStore authorizationStatusForEntityType:EKEntityTypeEvent];
}

- (BOOL)hasRemindersAuthorization {
    return self.remindersAuthorizationStatus == KSHRemindersAuthorizationStatusAuthorized;
}
- (KSHRemindersAuthorizationStatus)remindersAuthorizationStatus {
    return (KSHRemindersAuthorizationStatus)[EKEventStore authorizationStatusForEntityType:EKEntityTypeReminder];
}

@end
