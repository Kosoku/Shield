//
//  KSHMotionAuthorization.m
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

#import "KSHMotionAuthorization.h"

#import <Stanley/KSTFunctions.h>

#import <CoreMotion/CoreMotion.h>

@interface KSHMotionAuthorization ()
@property (strong,nonatomic) NSOperationQueue *operationQueue;
@end

@implementation KSHMotionAuthorization

- (instancetype)init {
    if (!(self = [super init]))
        return nil;
    
    _operationQueue = [[NSOperationQueue alloc] init];
    [_operationQueue setMaxConcurrentOperationCount:1];
    [_operationQueue setName:[NSString stringWithFormat:@"%@.%p",NSStringFromClass(self.class),self]];
    
    return self;
}

- (void)requestMotionAuthorizationWithCompletion:(KSHRequestMotionAuthorizationCompletionBlock)completion {
    NSParameterAssert(completion != nil);
    NSParameterAssert([NSBundle mainBundle].infoDictionary[@"NSMotionUsageDescription"] != nil);
    
    CMMotionActivityManager *manager = [[CMMotionActivityManager alloc] init];
    NSDate *fromDate = [NSDate date];
    NSDateComponents *comps = [[NSDateComponents alloc] init];
    
    [comps setDay:-1];
    
    NSDate *toDate = [[NSCalendar currentCalendar] dateByAddingComponents:comps toDate:fromDate options:0];
    
    [manager queryActivityStartingFromDate:fromDate toDate:toDate toQueue:self.operationQueue withHandler:^(NSArray<CMMotionActivity *> * _Nullable activities, NSError * _Nullable error) {
        KSTDispatchMainAsync(^{
            completion(error != nil, error);
        });
    }];
}

+ (KSHMotionAuthorization *)sharedAuthorization {
    static KSHMotionAuthorization *kRetval;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        kRetval = [[KSHMotionAuthorization alloc] init];
    });
    return kRetval;
}

@end
