//
//  KSHMicrophoneAuthorization.m
//  Shield
//
//  Created by William Towe on 4/7/17.
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

#import "KSHMicrophoneAuthorization.h"

#import <Stanley/KSTFunctions.h>

#import <AVFoundation/AVFoundation.h>

@implementation KSHMicrophoneAuthorization

- (void)requestMicrophoneAuthorizationWithCompletion:(KSHRequestMicrophoneAuthorizationCompletionBlock)completion {
    NSParameterAssert(completion != nil);
    NSParameterAssert([NSBundle mainBundle].infoDictionary[@"NSMicrophoneUsageDescription"] != nil);
    
    if (self.hasMicrophoneAuthorization) {
        KSTDispatchMainAsync(^{
            completion(KSHMicrophoneAuthorizationStatusAuthorized,nil);
        });
        return;
    }
    
    [AVCaptureDevice requestAccessForMediaType:AVMediaTypeAudio completionHandler:^(BOOL granted) {
        KSTDispatchMainAsync(^{
            completion(self.microphoneAuthorizationStatus,nil);
        });
    }];
}

+ (KSHMicrophoneAuthorization *)sharedAuthorization {
    static KSHMicrophoneAuthorization *kRetval;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        kRetval = [[KSHMicrophoneAuthorization alloc] init];
    });
    return kRetval;
}

- (BOOL)hasMicrophoneAuthorization {
    return self.microphoneAuthorizationStatus == KSHMicrophoneAuthorizationStatusAuthorized;
}
- (KSHMicrophoneAuthorizationStatus)microphoneAuthorizationStatus {
    return (KSHMicrophoneAuthorizationStatus)[AVCaptureDevice authorizationStatusForMediaType:AVMediaTypeAudio];
}

@end
