//
//  KSHAuthorizationManager.h
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

#import <TargetConditionals.h>

#if (TARGET_OS_IPHONE)
#import <AVFoundation/AVCaptureDevice.h>
#import <Photos/PHPhotoLibrary.h>
#endif
#import <CoreLocation/CLLocationManager.h>

NS_ASSUME_NONNULL_BEGIN

#if (TARGET_OS_IPHONE)
/**
 Enum defining the possible camera authorization status values. See AVAuthorizationStatus for more information.
 */
typedef NS_ENUM(NSInteger, KSHCameraAuthorizationStatus) {
    /**
     See AVAuthorizationStatusNotDetermined for more information.
     */
    KSHCameraAuthorizationStatusNotDetermined = AVAuthorizationStatusNotDetermined,
    /**
     See AVAuthorizationStatusRestricted for more information.
     */
    KSHCameraAuthorizationStatusRestricted = AVAuthorizationStatusRestricted,
    /**
     See AVAuthorizationStatusDenied for more information.
     */
    KSHCameraAuthorizationStatusDenied = AVAuthorizationStatusDenied,
    /**
     See AVAuthorizationStatusAuthorized for more information.
     */
    KSHCameraAuthorizationStatusAuthorized = AVAuthorizationStatusAuthorized
};

/**
 Completion block that is invoked after requesting camera access.
 
 @param status The current camera authorization status
 @param error The error
 */
typedef void(^KSHRequestCameraAuthorizationCompletionBlock)(KSHCameraAuthorizationStatus status, NSError * _Nullable error);

/**
 Enum defining the possible photo library authorization status values. See PHAuthorizationStatus for more information.
 */
typedef NS_ENUM(NSInteger, KSHPhotoLibraryAuthorizationStatus) {
    /**
     See PHAuthorizationStatusNotDetermined for more information.
     */
    KSHPhotoLibraryAuthorizationStatusNotDetermined = PHAuthorizationStatusNotDetermined,
    /**
     See PHAuthorizationStatusRestricted for more information.
     */
    KSHPhotoLibraryAuthorizationStatusRestricted = PHAuthorizationStatusRestricted,
    /**
     See PHAuthorizationStatusDenied for more information.
     */
    KSHPhotoLibraryAuthorizationStatusDenied = PHAuthorizationStatusDenied,
    /**
     See PHAuthorizationStatusAuthorized for more information.
     */
    KSHPhotoLibraryAuthorizationStatusAuthorized = PHAuthorizationStatusAuthorized
};

/**
 Completion block that is invoked after requesting photo library access.
 
 @param status The current photo library authorization status
 @param error The error
 */
typedef void(^KSHRequestPhotoLibraryAuthorizationCompletionBlock)(KSHPhotoLibraryAuthorizationStatus status, NSError * _Nullable error);
#endif

/**
 Enum defining the possible location authorization status values. See CLAuthorizationStatus for more information.
 */
typedef NS_ENUM(int, KSHLocationAuthorizationStatus) {
    /**
     See kCLAuthorizationStatusNotDetermined for more information.
     */
    KSHLocationAuthorizationStatusNotDetermined = kCLAuthorizationStatusNotDetermined,
    /**
     See kCLAuthorizationStatusRestricted for more information.
     */
    KSHLocationAuthorizationStatusRestricted = kCLAuthorizationStatusRestricted,
    /**
     See kCLAuthorizationStatusDenied for more information.
     */
    KSHLocationAuthorizationStatusDenied = kCLAuthorizationStatusDenied,
    /**
     See kCLAuthorizationStatusAuthorizedAlways for more information.
     */
    KSHLocationAuthorizationStatusAuthorizedAlways = kCLAuthorizationStatusAuthorizedAlways,
#if (TARGET_OS_IOS || TARGET_OS_TV || TARGET_OS_WATCH)
    /**
     See kCLAuthorizationStatusAuthorizedWhenInUse for more information.
     */
    KSHLocationAuthorizationStatusAuthorizedWhenInUse = kCLAuthorizationStatusAuthorizedWhenInUse
#endif
};

/**
 Completion block that is invoked after requesting location access.
 
 @param status The current location authorization access
 @param error The error
 */
typedef void(^KSHRequestLocationAuthorizationCompletionBlock)(KSHLocationAuthorizationStatus status, NSError * _Nullable error);

/**
 KSHAuthorizationManager is an NSObject subclass that combines all the authorization methods into a consistent interface.
 */
@interface KSHAuthorizationManager : NSObject

/**
 Get the shared manager instance.
 */
@property (class,readonly,nonatomic) KSHAuthorizationManager *sharedManager;

#if (TARGET_OS_IPHONE)
/**
 Get whether the user has authorized camera access.
 */
@property (readonly,nonatomic) BOOL hasCameraAuthorization;
/**
 Get the camera authorization status.
 
 @see KSHCameraAuthorizationStatus
 */
@property (readonly,nonatomic) KSHCameraAuthorizationStatus cameraAuthorizationStatus;

/**
 Get whether the user has authorized photo library access.
 */
@property (readonly,nonatomic) BOOL hasPhotoLibraryAuthorization;
/**
 Get the photo library authorization status.
 
 @see KSHPhotoLibraryAuthorizationStatus
 */
@property (readonly,nonatomic) KSHPhotoLibraryAuthorizationStatus photoLibraryAuthorizationStatus;
#endif

/**
 Get whether the user has authorized location access.
 */
@property (readonly,nonatomic) BOOL hasLocationAuthorization;
/**
 Get whether the user has authorized location always access.
 */
@property (readonly,nonatomic) BOOL hasLocationAuthorizationAlways;
#if (TARGET_OS_IOS || TARGET_OS_TV || TARGET_OS_WATCH)
/**
 Get whether the user has authorized location when in use access.
 */
@property (readonly,nonatomic) BOOL hasLocationAuthorizationWhenInUse;
#endif
/**
 Get the location authorization status.
 
 @see KSHLocationAuthorizationStatus
 */
@property (readonly,nonatomic) KSHLocationAuthorizationStatus locationAuthorizationStatus;

#if (TARGET_OS_IPHONE)
/**
 Request camera authorization from the user and invoke the provided completion block when authorization status has been determined. The completion block is always invoked on the main thread. The client must provide a reason in their plist using NSCameraUsageDescription or an exception will be thrown.
 
 @param completion The completion block to invoke when authorization status has been determined
 */
- (void)requestCameraAuthorizationWithCompletion:(KSHRequestCameraAuthorizationCompletionBlock)completion;

/**
 Request photo library authorization from the user and invoke the provided completion block when authorization status has been determined. The completion block is always invoked on the main thread. The client must provide a reason in their plist using NSPhotoLibraryUsageDescription or an exception will be thrown.
 
 @param completion The completion block to invoke when authorization status has been determined
 */
- (void)requestPhotoLibraryAuthorizationWithCompletion:(KSHRequestPhotoLibraryAuthorizationCompletionBlock)completion;
#endif
/**
 Request location authorization from the user and invoke the provided completion block when authorization status has been determined. The client should pass KSHLocationAuthorizationStatusAuthorizedAlways or KSHLocationAuthorizationStatusAuthorizedWhenInUse for authorization. The completion block is always invoked on the main thread. The client must provide a reason in their plist using NSLocationWhenInUseUsageDescription or NSLocationAlwaysUsageDescription or an exception will be thrown.
 
 @param authorization The location authorization to request
 @param completion The completion block to invoke when authorization status has been determined
 */
- (void)requestLocationAuthorization:(KSHLocationAuthorizationStatus)authorization completion:(KSHRequestLocationAuthorizationCompletionBlock)completion;

@end

NS_ASSUME_NONNULL_END
