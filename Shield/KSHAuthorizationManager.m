//
//  KSHAuthorizationManager.m
//  Shield
//
//  Created by William Towe on 3/13/17.
//  Copyright © 2017 Kosoku Interactive, LLC. All rights reserved.
//
//  Redistribution and use in source and binary forms, with or without modification, are permitted provided that the following conditions are met:
//
//  1. Redistributions of source code must retain the above copyright notice, this list of conditions and the following disclaimer.
//
//  2. Redistributions in binary form must reproduce the above copyright notice, this list of conditions and the following disclaimer in the documentation and/or other materials provided with the distribution.
//
//  THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS "AS IS" AND ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED TO, THE IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE ARE DISCLAIMED. IN NO EVENT SHALL THE COPYRIGHT HOLDER OR CONTRIBUTORS BE LIABLE FOR ANY DIRECT, INDIRECT, INCIDENTAL, SPECIAL, EXEMPLARY, OR CONSEQUENTIAL DAMAGES (INCLUDING, BUT NOT LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS OR SERVICES; LOSS OF USE, DATA, OR PROFITS; OR BUSINESS INTERRUPTION) HOWEVER CAUSED AND ON ANY THEORY OF LIABILITY, WHETHER IN CONTRACT, STRICT LIABILITY, OR TORT (INCLUDING NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY OUT OF THE USE OF THIS SOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.

#import "KSHAuthorizationManager.h"

#import <Stanley/KSTScopeMacros.h>
#import <Stanley/KSTFunctions.h>

#import <CoreLocation/CLLocationManagerDelegate.h>
#if (TARGET_OS_IPHONE)
#import <AVFoundation/AVMediaFormat.h>
#endif

@interface KSHAuthorizationManager () <CLLocationManagerDelegate>
@property (strong,nonatomic) CLLocationManager *locationManager;
@property (copy,nonatomic) KSHRequestLocationAuthorizationCompletionBlock requestLocationAuthorizationCompletionBlock;
@end

@implementation KSHAuthorizationManager

- (void)locationManager:(CLLocationManager *)manager didChangeAuthorizationStatus:(CLAuthorizationStatus)status {
    if (status == kCLAuthorizationStatusNotDetermined) {
        return;
    }
    
#if (TARGET_OS_IPHONE)
    if (status == kCLAuthorizationStatusAuthorizedAlways ||
        status == kCLAuthorizationStatusAuthorizedWhenInUse) {
        KSTDispatchMainAsync(^{
            self.requestLocationAuthorizationCompletionBlock((KSHLocationAuthorizationStatus)status,nil);
        });
    }
#else
    if (status == kCLAuthorizationStatusAuthorizedAlways) {
        KSTDispatchMainAsync(^{
            self.requestLocationAuthorizationCompletionBlock((KSHLocationAuthorizationStatus)status,nil);
        });
    }
#endif
    else {
        KSTDispatchMainAsync(^{
            self.requestLocationAuthorizationCompletionBlock(self.locationAuthorizationStatus,nil);
        });
    }
    
    [self setLocationManager:nil];
    [self setRequestLocationAuthorizationCompletionBlock:nil];
}

#if (TARGET_OS_IPHONE)
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
#endif
- (void)requestLocationAuthorization:(KSHLocationAuthorizationStatus)authorization completion:(void(^)(KSHLocationAuthorizationStatus status, NSError *error))completion; {
#if (TARGET_OS_IPHONE)
    NSParameterAssert(authorization == KSHLocationAuthorizationStatusAuthorizedAlways || authorization == KSHLocationAuthorizationStatusAuthorizedWhenInUse);
    if (authorization == KSHLocationAuthorizationStatusAuthorizedAlways) {
        NSParameterAssert([NSBundle mainBundle].infoDictionary[@"NSLocationAlwaysUsageDescription"] != nil);
    }
    else {
        NSParameterAssert([NSBundle mainBundle].infoDictionary[@"NSLocationWhenInUseUsageDescription"] != nil);
    }
#else
    NSParameterAssert(authorization == KSHLocationAuthorizationStatusAuthorizedAlways);
    NSParameterAssert([NSBundle mainBundle].infoDictionary[@"NSLocationAlwaysUsageDescription"] != nil);
#endif
    NSParameterAssert(completion != nil);
    
    if (self.locationAuthorizationStatus == authorization) {
        KSTDispatchMainAsync(^{
            completion(authorization,nil);
        });
        return;
    }
    
    [self setRequestLocationAuthorizationCompletionBlock:completion];
    
    [self setLocationManager:[[CLLocationManager alloc] init]];
    [self.locationManager setDelegate:self];
    
#if (TARGET_OS_IPHONE)
    if (authorization == KSHLocationAuthorizationStatusAuthorizedAlways) {
        [self.locationManager requestAlwaysAuthorization];
    }
    else {
        [self.locationManager requestWhenInUseAuthorization];
    }
#else
    [self.locationManager requestAlwaysAuthorization];
#endif
}

+ (KSHAuthorizationManager *)sharedManager {
    static dispatch_once_t onceToken;
    static KSHAuthorizationManager *kRetval;
    dispatch_once(&onceToken, ^{
        kRetval = [[KSHAuthorizationManager alloc] init];
    });
    return kRetval;
}

#if (TARGET_OS_IPHONE)
- (BOOL)hasCameraAuthorization {
    return self.cameraAuthorizationStatus == KSHCameraAuthorizationStatusAuthorized;
}
- (KSHCameraAuthorizationStatus)cameraAuthorizationStatus {
    return (KSHCameraAuthorizationStatus)[AVCaptureDevice authorizationStatusForMediaType:AVMediaTypeVideo];
}

- (BOOL)hasMicrophoneAuthorization {
    return self.microphoneAuthorizationStatus == KSHMicrophoneAuthorizationStatusAuthorized;
}
- (KSHMicrophoneAuthorizationStatus)microphoneAuthorizationStatus {
    return (KSHMicrophoneAuthorizationStatus)[AVCaptureDevice authorizationStatusForMediaType:AVMediaTypeAudio];
}

- (BOOL)hasPhotoLibraryAuthorization {
    return self.photoLibraryAuthorizationStatus == KSHPhotoLibraryAuthorizationStatusAuthorized;
}
- (KSHPhotoLibraryAuthorizationStatus)photoLibraryAuthorizationStatus {
    return (KSHPhotoLibraryAuthorizationStatus)[PHPhotoLibrary authorizationStatus];
}
#endif

- (BOOL)hasLocationAuthorization {
#if (TARGET_OS_IPHONE)
    return self.hasLocationAuthorizationAlways || self.hasLocationAuthorizationWhenInUse;
#else 
    return self.hasLocationAuthorizationAlways;
#endif
}
- (BOOL)hasLocationAuthorizationAlways {
    return self.locationAuthorizationStatus == KSHLocationAuthorizationStatusAuthorizedAlways;
}
#if (TARGET_OS_IPHONE)
- (BOOL)hasLocationAuthorizationWhenInUse {
    return self.locationAuthorizationStatus == KSHLocationAuthorizationStatusAuthorizedWhenInUse;
}
#endif
- (KSHLocationAuthorizationStatus)locationAuthorizationStatus {
    return (KSHLocationAuthorizationStatus)[CLLocationManager authorizationStatus];
}

@end
