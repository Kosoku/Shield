//
//  KSHVideoSubscriberAuthorization.m
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
