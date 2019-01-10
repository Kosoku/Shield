//
//  KSHVideoSubscriberAuthorization.m
//  Shield
//
//  Created by William Towe on 4/10/17.
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

#import "KSHVideoSubscriberAccountAuthorization.h"

#import <Stanley/KSTFunctions.h>

#import <VideoSubscriberAccount/VideoSubscriberAccount.h>
#import <UIKit/UIKit.h>

@interface KSHVideoSubscriberAccountAuthorization () <VSAccountManagerDelegate>

@end

@implementation KSHVideoSubscriberAccountAuthorization

- (void)accountManager:(VSAccountManager *)accountManager presentViewController:(UIViewController *)viewController {
    [[UIApplication sharedApplication].keyWindow.rootViewController presentViewController:viewController animated:YES completion:nil];
}
- (void)accountManager:(VSAccountManager *)accountManager dismissViewController:(UIViewController *)viewController {
    [viewController.presentingViewController dismissViewControllerAnimated:YES completion:nil];
}

- (void)requestVideoSubscriberAccountAuthorizationWithCompletion:(KSHRequestVideoSubscriberAccountCompletionBlock)completion {
    NSParameterAssert(completion != nil);
    NSParameterAssert([NSBundle mainBundle].infoDictionary[@"NSVideoSubscriberAccountUsageDescription"] != nil);
    
    if (self.hasVideoSubscriberAccountAuthorization) {
        KSTDispatchMainAsync(^{
            completion(KSHVideoSubscriberAccountAuthorizationStatusAuthorized,nil);
        });
        return;
    }
    
    VSAccountManager *manager = [[VSAccountManager alloc] init];
    
    [manager setDelegate:self];
    
    [manager checkAccessStatusWithOptions:@{VSCheckAccessOptionPrompt: @YES} completionHandler:^(VSAccountAccessStatus accessStatus, NSError * _Nullable error) {
        KSTDispatchMainAsync(^{
            completion((KSHVideoSubscriberAccountAuthorizationStatus)accessStatus,error);
        });
    }];
}

+ (KSHVideoSubscriberAccountAuthorization *)sharedAuthorization {
    static KSHVideoSubscriberAccountAuthorization *kRetval;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        kRetval = [[KSHVideoSubscriberAccountAuthorization alloc] init];
    });
    return kRetval;
}

- (BOOL)hasVideoSubscriberAccountAuthorization {
    return self.videoSubscriberAccountAuthorizationStatus == KSHVideoSubscriberAccountAuthorizationStatusAuthorized;
}
- (KSHVideoSubscriberAccountAuthorizationStatus)videoSubscriberAccountAuthorizationStatus {
    NSParameterAssert([NSBundle mainBundle].infoDictionary[@"NSVideoSubscriberAccountUsageDescription"] != nil);
    
    __block KSHVideoSubscriberAccountAuthorizationStatus retval = KSHVideoSubscriberAccountAuthorizationStatusNotDetermined;
    dispatch_semaphore_t semaphore = dispatch_semaphore_create(0);
    
    dispatch_async(dispatch_get_global_queue(QOS_CLASS_DEFAULT, 0), ^{
        VSAccountManager *manager = [[VSAccountManager alloc] init];
        
        [manager checkAccessStatusWithOptions:@{VSCheckAccessOptionPrompt: @NO} completionHandler:^(VSAccountAccessStatus accessStatus, NSError * _Nullable error) {
            retval = (KSHVideoSubscriberAccountAuthorizationStatus)accessStatus;
            
            dispatch_semaphore_signal(semaphore);
        }];
    });
    
    dispatch_semaphore_wait(semaphore, DISPATCH_TIME_FOREVER);
    
    return retval;
}

@end
