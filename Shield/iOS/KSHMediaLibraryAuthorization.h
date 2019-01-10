//
//  KSHMediaLibraryAuthorization.h
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

#import <Foundation/Foundation.h>
#import <MediaPlayer/MPMediaLibrary.h>

NS_ASSUME_NONNULL_BEGIN

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

/**
 KSHMediaLibraryAuthorization wraps the APIs needed to request media library access from the user.
 */
@interface KSHMediaLibraryAuthorization : NSObject

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

@end

NS_ASSUME_NONNULL_END
