//
//  KSHMediaLibraryAuthorization.m
//  Shield
//
//  Created by William Towe on 4/7/17.
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

#import "KSHMediaLibraryAuthorization.h"

#import <Stanley/KSTFunctions.h>

#import <MediaPlayer/MediaPlayer.h>

@implementation KSHMediaLibraryAuthorization

- (void)requestMediaLibraryAuthorizationWithCompletion:(KSHRequestMediaLibraryAuthorizationCompletionBlock)completion; {
    NSParameterAssert(completion != nil);
    NSParameterAssert([NSBundle mainBundle].infoDictionary[@"NSAppleMusicUsageDescription"] != nil);
    
    if (self.hasMediaLibraryAuthorization) {
        KSTDispatchMainAsync(^{
            completion(KSHMediaLibraryAuthorizationStatusAuthorized,nil);
        });
        return;
    }
    
    [MPMediaLibrary requestAuthorization:^(MPMediaLibraryAuthorizationStatus status) {
        KSTDispatchMainAsync(^{
            completion(self.mediaLibraryAuthorizationStatus,nil);
        });
    }];
}

+ (KSHMediaLibraryAuthorization *)sharedAuthorization {
    static KSHMediaLibraryAuthorization *kRetval;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        kRetval = [[KSHMediaLibraryAuthorization alloc] init];
    });
    return kRetval;
}

- (BOOL)hasMediaLibraryAuthorization {
    return self.mediaLibraryAuthorizationStatus == KSHMediaLibraryAuthorizationStatusAuthorized;
}
- (KSHMediaLibraryAuthorizationStatus)mediaLibraryAuthorizationStatus {
    return (KSHMediaLibraryAuthorizationStatus)[MPMediaLibrary authorizationStatus];
}

@end
