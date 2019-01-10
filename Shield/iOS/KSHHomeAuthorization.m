//
//  KSHHomeAuthorization.m
//  Shield
//
//  Created by William Towe on 4/8/17.
//  Copyright © 2019 Kosoku Interactive, LLC. All rights reserved.
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
