//
//  KSHMediaLibraryAuthorization.h
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

#import <Foundation/Foundation.h>
#if (TARGET_OS_IOS)
#import <MediaPlayer/MPMediaLibrary.h>
#endif

NS_ASSUME_NONNULL_BEGIN

#if (TARGET_OS_IOS)
/**
 Enum defining the possible media library authorization status values. See MPMediaLibraryAuthorizationStatus for more information.
 */
typedef NS_ENUM(NSInteger, KSHMediaLibraryAuthorizationStatus) {
    /**
     See MPMediaLibraryAuthorizationStatusNotDetermined for more information.
     */
    KSHMediaLibraryAuthorizationStatusNotDetermined = MPMediaLibraryAuthorizationStatusNotDetermined,
    /**
     See MPMediaLibraryAuthorizationStatusDenied for more information.
     */
    KSHMediaLibraryAuthorizationStatusDenied = MPMediaLibraryAuthorizationStatusDenied,
    /**
     See MPMediaLibraryAuthorizationStatusRestricted for more information.
     */
    KSHMediaLibraryAuthorizationStatusRestricted = MPMediaLibraryAuthorizationStatusRestricted,
    /**
     See MPMediaLibraryAuthorizationStatusAuthorized for more information.
     */
    KSHMediaLibraryAuthorizationStatusAuthorized = MPMediaLibraryAuthorizationStatusAuthorized
};
/**
 Completion block that is invoked after requesting media library access.
 
 @param status The current media library authorization status
 @param error The error
 */
typedef void(^KSHRequestMediaLibraryAuthorizationCompletionBlock)(KSHMediaLibraryAuthorizationStatus status, NSError * _Nullable error);
#endif

@interface KSHMediaLibraryAuthorization : NSObject

#if (TARGET_OS_IOS)
/**
 Get the shared media library authorization object.
 */
@property (class,readonly,nonatomic) KSHMediaLibraryAuthorization *sharedAuthorization;

/**
 Get whether the user has authorized media library access.
 */
@property (readonly,nonatomic) BOOL hasMediaLibraryAuthorization;
/**
 Get the media library authorization status.
 
 @see KSHMediaLibraryAuthorizationStatus
 */
@property (readonly,nonatomic) KSHMediaLibraryAuthorizationStatus mediaLibraryAuthorizationStatus;

/**
 Request media library authorization from the user and invoke the provided completion block when authorization status has been determined. The completion block is always invoked on the main thread. The client must provide a reason in their plist using NSAppleMusicUsageDescription or an exception will be thrown.
 
 @param completion The completion block to invoke when authorization status has been determined
 @exception NSException Thrown if the NSAppleMusicUsageDescription key is not present in the info plist
 */
- (void)requestMediaLibraryAuthorizationWithCompletion:(KSHRequestMediaLibraryAuthorizationCompletionBlock)completion;
#endif

@end

NS_ASSUME_NONNULL_END
