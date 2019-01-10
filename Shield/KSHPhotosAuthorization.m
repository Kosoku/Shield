//
//  KSHPhotosAuthorization.m
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

#import "KSHPhotosAuthorization.h"

#import <Stanley/KSTFunctions.h>

#import <Photos/Photos.h>

@implementation KSHPhotosAuthorization

- (void)requestPhotoLibraryAuthorizationWithCompletion:(void (^)(KSHPhotosAuthorizationStatus status, NSError *error))completion {
    NSParameterAssert(completion != nil);
    NSParameterAssert([NSBundle mainBundle].infoDictionary[@"NSPhotoLibraryUsageDescription"] != nil);
    
    if (self.hasPhotoLibraryAuthorization) {
        KSTDispatchMainAsync(^{
            completion(KSHPhotosAuthorizationStatusAuthorized,nil);
        });
        return;
    }
    
    [PHPhotoLibrary requestAuthorization:^(PHAuthorizationStatus status) {
        KSTDispatchMainAsync(^{
            completion((KSHPhotosAuthorizationStatus)status,nil);
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
    return self.photoLibraryAuthorizationStatus == KSHPhotosAuthorizationStatusAuthorized;
}
- (KSHPhotosAuthorizationStatus)photoLibraryAuthorizationStatus {
    return (KSHPhotosAuthorizationStatus)[PHPhotoLibrary authorizationStatus];
}

@end
