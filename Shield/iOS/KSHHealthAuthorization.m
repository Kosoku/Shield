//
//  KSHHealthAuthorization.m
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

#import "KSHHealthAuthorization.h"

#import <Stanley/KSTFunctions.h>

#import <HealthKit/HealthKit.h>

@implementation KSHHealthAuthorization

- (KSHHealthAuthorizationStatus)healthShareAuthorizationStatusForType:(HKObjectType *)type {
    return (KSHHealthAuthorizationStatus)[[[HKHealthStore alloc] init] authorizationStatusForType:type];
}
- (void)requestHealthAuthorizationToReadTypes:(NSArray<HKObjectType *> *)readTypes writeTypes:(NSArray<HKSampleType *> *)writeTypes completion:(KSHRequestHealthAuthorizationCompletionBlock)completion {
    NSParameterAssert(completion != nil);
    NSParameterAssert(readTypes.count > 0 || writeTypes.count > 0);
    
    if (writeTypes.count > 0) {
        NSParameterAssert([NSBundle mainBundle].infoDictionary[@"NSHealthUpdateUsageDescription"] != nil);
    }
    if (readTypes.count > 0) {
        NSParameterAssert([NSBundle mainBundle].infoDictionary[@"NSHealthShareUsageDescription"] != nil);
    }
    
    HKHealthStore *healthStore = [[HKHealthStore alloc] init];
    
    [healthStore requestAuthorizationToShareTypes:[NSSet setWithArray:writeTypes] readTypes:[NSSet setWithArray:readTypes] completion:^(BOOL success, NSError * _Nullable error) {
        NSMutableDictionary *retval = [[NSMutableDictionary alloc] init];
        
        for (HKObjectType *type in readTypes) {
            [retval setObject:@([healthStore authorizationStatusForType:type]) forKey:type];
        }
        for (HKObjectType *type in writeTypes) {
            [retval setObject:@([healthStore authorizationStatusForType:type]) forKey:type];
        }
        
        KSTDispatchMainAsync(^{
            completion(success,retval,error);
        });
    }];
}

+ (KSHHealthAuthorization *)sharedAuthorization {
    static KSHHealthAuthorization *kRetval;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        kRetval = [[KSHHealthAuthorization alloc] init];
    });
    return kRetval;
}

@end
