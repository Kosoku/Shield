//
//  KSHEventAuthorization.m
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
