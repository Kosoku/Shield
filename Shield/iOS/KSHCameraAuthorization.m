//
//  KSHCameraAuthorization.m
//  Shield
//
//  Created by William Towe on 4/7/17.
//  Copyright © 2017 Kosoku Interactive, LLC. All rights reserved.
//
//  Redistribution and use in source and binary forms, with or without modification, are permitted provided that the following conditions are met:
//
//  1. Redistributions of source code must retain the above copyright notice, this list of conditions and the following disclaimer.
//
//  2. Redistributions in binary form must reproduce the above copyright notice, this list of conditions and the following disclaimer in the documentation and/or other materials provided with the distribution.
//
//  THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS "AS IS" AND ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED TO, THE IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE ARE DISCLAIMED. IN NO EVENT SHALL THE COPYRIGHT HOLDER OR CONTRIBUTORS BE LIABLE FOR ANY DIRECT, INDIRECT, INCIDENTAL, SPECIAL, EXEMPLARY, OR CONSEQUENTIAL DAMAGES (INCLUDING, BUT NOT LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS OR SERVICES; LOSS OF USE, DATA, OR PROFITS; OR BUSINESS INTERRUPTION) HOWEVER CAUSED AND ON ANY THEORY OF LIABILITY, WHETHER IN CONTRACT, STRICT LIABILITY, OR TORT (INCLUDING NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY OUT OF THE USE OF THIS SOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.

#import "KSHCameraAuthorization.h"

#if (TARGET_OS_IOS)
#import <Stanley/KSTFunctions.h>

#import <AVFoundation/AVFoundation.h>
#endif

@implementation KSHCameraAuthorization

#if (TARGET_OS_IOS)
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
#endif

@end
