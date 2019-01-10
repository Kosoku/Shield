//
//  KSHContactsAuthorization.h
//  Shield
//
//  Created by William Towe on 4/8/17.
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

#import <Foundation/Foundation.h>
#import <Contacts/CNContactStore.h>

NS_ASSUME_NONNULL_BEGIN

/**
 Enum defining possible contacts authorization status values. See CNAuthorizationStatus for more information.
 */
typedef NS_ENUM(NSInteger, KSHContactsAuthorizationStatus) {
    /**
     See CNAuthorizationStatusNotDetermined for more information.
     */
    KSHContactsAuthorizationStatusNotDetermined = CNAuthorizationStatusNotDetermined,
    /**
     See CNAuthorizationStatusRestricted for more information.
     */
    KSHContactsAuthorizationStatusRestricted = CNAuthorizationStatusRestricted,
    /**
     See CNAuthorizationStatusDenied for more information.
     */
    KSHContactsAuthorizationStatusDenied = CNAuthorizationStatusDenied,
    /**
     See CNAuthorizationStatusAuthorized for more information.
     */
    KSHContactsAuthorizationStatusAuthorized = CNAuthorizationStatusAuthorized
};
/**
 Completion block that is invoked after requesting contacts access.
 
 @param status The current contacts authorization status
 @param error The error
 */
typedef void(^KSHRequestContactsAuthorizationCompletionBlock)(KSHContactsAuthorizationStatus status, NSError * _Nullable error);

/**
 KSHContactsAuthorization wraps the APIs needed to request contacts access from the user.
 */
@interface KSHContactsAuthorization : NSObject

/**
 Get the shared contacts authorization object.
 */
@property (class,readonly,nonatomic) KSHContactsAuthorization *sharedAuthorization;

/**
 Get whether the user has authorized contacts access.
 */
@property (readonly,nonatomic) BOOL hasContactsAuthorization;
/**
 Get the contacts authorization status.
 
 @see KSHContactsAuthorizationStatus
 */
@property (readonly,nonatomic) KSHContactsAuthorizationStatus contactsAuthorizationStatus;

/**
 Request contacts authorization from the user and invoke the provided completion block when authorization status has been determined. The completion block is always invoked on the main thread. The client must provide a reason in their plist using NSContactsUsageDescription or an exception will be thrown.
 
 @param completion The completion block to invoke when authorization status has been determined
 @exception NSException Thrown if *completion* is nil or the NSContactsUsageDescription key is not present in the info plist
 */
- (void)requestContactsAuthorizationWithCompletion:(KSHRequestContactsAuthorizationCompletionBlock)completion;

@end

NS_ASSUME_NONNULL_END
