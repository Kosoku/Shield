//
//  KSHMotionAuthorization.m
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
