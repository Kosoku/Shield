//
//  KSHVideoSubscriberAuthorization.h
//  Shield
//
//  Created by William Towe on 4/10/17.
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
#import <VideoSubscriberAccount/VSAccountManager.h>

NS_ASSUME_NONNULL_BEGIN

/**
 Enum describing the possible values for video subscriber account authorization status. See VSAccountAccessStatus for more information.
 */
typedef NS_ENUM(NSInteger, KSHVideoSubscriberAccountAuthorizationStatus) {
    /**
     See VSAccountAccessStatusNotDetermined for more information.
     */
    KSHVideoSubscriberAccountAuthorizationStatusNotDetermined = VSAccountAccessStatusNotDetermined,
    /**
     See VSAccountAccessStatusRestricted for more information.
     */
    KSHVideoSubscriberAccountAuthorizationStatusRestricted = VSAccountAccessStatusRestricted,
    /**
     See VSAccountAccessStatusDenied for more information.
     */
    KSHVideoSubscriberAccountAuthorizationStatusDenied = VSAccountAccessStatusDenied,
    /**
     See VSAccountAccessStatusGranted for more information.
     */
    KSHVideoSubscriberAccountAuthorizationStatusAuthorized = VSAccountAccessStatusGranted
};
/**
 Block that is invoked when video subscriber account authorization status has been determined.
 
 @param status The video subscriber account authorization status
 @param error The error
 */
typedef void(^KSHRequestVideoSubscriberAccountCompletionBlock)(KSHVideoSubscriberAccountAuthorizationStatus status, NSError * _Nullable error);

/**
 KSHVideoSubscriberAccountAuthorization wraps the APIs needed to request video subscriber account information from the user.
 */
@interface KSHVideoSubscriberAccountAuthorization : NSObject

/**
 Get the shared local authorization object.
 */
@property (class,readonly,nonatomic) KSHVideoSubscriberAccountAuthorization *sharedAuthorization;

/**
 Get whether the user has authorized video subscriber account access.
 */
@property (readonly,nonatomic) BOOL hasVideoSubscriberAccountAuthorization;
/**
 Get the current video subscriber account authorization status.
 */
@property (readonly,nonatomic) KSHVideoSubscriberAccountAuthorizationStatus videoSubscriberAccountAuthorizationStatus;

/**
 Request video subscriber account authorization from the user and invoke the *completion* block when the authorization status has been determined. The *completion* block is always invoked on the main thread. The client must provide a reason in their info plist using the NSVideoSubscriberAccountUsageDescription key or an exception will be thrown.
 
 @param completion The completion block to invoke when authorization status has been determined
 @exception NSException Thrown if *completion* is nil or the NSVideoSubscriberAccountUsageDescription key is missing from the info plist
 */
- (void)requestVideoSubscriberAccountAuthorizationWithCompletion:(KSHRequestVideoSubscriberAccountCompletionBlock)completion;

@end

NS_ASSUME_NONNULL_END
