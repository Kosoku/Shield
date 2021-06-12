//
//  KSHCameraAuthorization.m
//  Shield
//
//  Created by William Towe on 4/7/17.
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

#import "KSHCameraAuthorization.h"

#import <Stanley/KSTFunctions.h>

#import <AVFoundation/AVFoundation.h>

@implementation KSHCameraAuthorization

- (void)requestCameraAuthorizationWithCompletion:(KSHRequestCameraAuthorizationCompletionBlock)completion; {
    NSParameterAssert(completion != nil);
    NSParameterAssert([NSBundle mainBundle].infoDictionary[@"NSCameraUsageDescription"] != nil);
    
    if (self.hasCameraAuthorization) {
        KSTDispatchMainAsync(^{
            completion(KSHCameraAuthorizationStatusAuthorized,nil);
        });
        return;
    }
    
    [AVCaptureDevice requestAccessForMediaType:AVMediaTypeVideo completionHandler:^(BOOL granted) {
        KSTDispatchMainAsync(^{
            completion(self.cameraAuthorizationStatus,nil);
        });
    }];
}

+ (KSHCameraAuthorization *)sharedAuthorization {
    static KSHCameraAuthorization *kRetval;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        kRetval = [[KSHCameraAuthorization alloc] init];
    });
    return kRetval;
}

- (BOOL)hasCameraAuthorization {
    return self.cameraAuthorizationStatus == KSHCameraAuthorizationStatusAuthorized;
}
- (KSHCameraAuthorizationStatus)cameraAuthorizationStatus {
    return (KSHCameraAuthorizationStatus)[AVCaptureDevice authorizationStatusForMediaType:AVMediaTypeVideo];
}

@end
