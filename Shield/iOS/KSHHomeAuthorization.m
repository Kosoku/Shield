//
//  KSHHomeAuthorization.m
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

#import "KSHHomeAuthorization.h"

#import <Stanley/KSTFunctions.h>
#import <Stanley/KSTScopeMacros.h>

#import <HomeKit/HomeKit.h>

@interface KSHHomeAuthorization () <HMHomeManagerDelegate>
@property (strong,nonatomic) HMHomeManager *homeManager;
@property (copy,nonatomic) KSHRequestHomeAuthorizationCompletionBlock requestHomeAuthorizationCompletionBlock;
@end

@implementation KSHHomeAuthorization

- (void)homeManagerDidUpdateHomes:(HMHomeManager *)manager {
    if (self.homeManager.homes.count > 0) {
        KSTDispatchMainAsync(^{
            self.requestHomeAuthorizationCompletionBlock(YES, nil);
        });
    }
    else {
        kstWeakify(self);
        [self.homeManager addHomeWithName:[NSString stringWithFormat:@"%@%p",NSStringFromClass(self.class),self] completionHandler:^(HMHome * _Nullable home, NSError * _Nullable error) {
            kstStrongify(self);
            if (home == nil ||
                error != nil) {
                
                KSTDispatchMainAsync(^{
                    self.requestHomeAuthorizationCompletionBlock(NO, error);
                });
                
                [self.homeManager setDelegate:nil];
                [self setHomeManager:nil];
            }
            else {
                [self.homeManager setDelegate:nil];
                
                [self.homeManager removeHome:home completionHandler:^(NSError * _Nullable error) {
                    KSTDispatchMainAsync(^{
                        self.requestHomeAuthorizationCompletionBlock(YES, nil);
                    });
                    
                    [self setHomeManager:nil];
                }];
            }
        }];
    }
}

- (void)requestHomeAuthorizationWithCompletion:(KSHRequestHomeAuthorizationCompletionBlock)completion {
    NSParameterAssert(completion != nil);
    NSParameterAssert([NSBundle mainBundle].infoDictionary[@"NSHomeKitUsageDescription"] != nil);
    
    [self setRequestHomeAuthorizationCompletionBlock:completion];
    
    [self setHomeManager:[[HMHomeManager alloc] init]];
    [self.homeManager setDelegate:self];
}

+ (KSHHomeAuthorization *)sharedAuthorization {
    static KSHHomeAuthorization *kRetval;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        kRetval = [[KSHHomeAuthorization alloc] init];
    });
    return kRetval;
}

@end
