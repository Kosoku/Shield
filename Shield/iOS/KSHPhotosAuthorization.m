//
//  KSHPhotosAuthorization.m
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

#import "KSHPhotosAuthorization.h"

#import <Stanley/KSTFunctions.h>

#import <Photos/Photos.h>

@implementation KSHPhotosAuthorization

- (void)requestPhotoLibraryAuthorizationWithCompletion:(void (^)(KSHPhotoLibraryAuthorizationStatus status, NSError *error))completion {
    NSParameterAssert(completion != nil);
    NSParameterAssert([NSBundle mainBundle].infoDictionary[@"NSPhotoLibraryUsageDescription"] != nil);
    
    if (self.hasPhotoLibraryAuthorization) {
        KSTDispatchMainAsync(^{
            completion(KSHPhotoLibraryAuthorizationStatusAuthorized,nil);
        });
        return;
    }
    
    [PHPhotoLibrary requestAuthorization:^(PHAuthorizationStatus status) {
        KSTDispatchMainAsync(^{
            completion((KSHPhotoLibraryAuthorizationStatus)status,nil);
        });
    }];
}

+ (KSHPhotosAuthorization *)sharedAuthorization {
    static KSHPhotosAuthorization *kRetval;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        kRetval = [[KSHPhotosAuthorization alloc] init];
    });
    return kRetval;
}

- (BOOL)hasPhotoLibraryAuthorization {
    return self.photoLibraryAuthorizationStatus == KSHPhotoLibraryAuthorizationStatusAuthorized;
}
- (KSHPhotoLibraryAuthorizationStatus)photoLibraryAuthorizationStatus {
    return (KSHPhotoLibraryAuthorizationStatus)[PHPhotoLibrary authorizationStatus];
}

@end
