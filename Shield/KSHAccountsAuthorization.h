//
//  KSHAccountsAuthorization.h
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

#import <Foundation/Foundation.h>
#import <Accounts/ACAccountType.h>

NS_ASSUME_NONNULL_BEGIN

/**
 Enum describing the possible types of accounts.
 */
typedef NS_ENUM(NSInteger, KSHAccountsType) {
    /**
     The Twitter accounts.
     */
    KSHAccountsTypeTwitter,
    /**
     The Facebook accounts.
     */
    KSHAccountsTypeFacebook,
    /**
     The Sina Weibo accounts.
     */
    KSHAccountsTypeSinaWeibo,
    /**
     The Tencent Weibo accounts.
     */
    KSHAccountsTypeTencentWeibo,
#if (TARGET_OS_OSX)
    /**
     The LinkedIn accounts.
     */
    KSHAccountsTypeLinkedIn
#endif
};
/**
 Block that is invoked when the authorization status for accounts has been determined.
 
 @param success Whether authorization was successfully granted
 @param error The error if authorization was not granted
 */
typedef void(^KSHRequestAccountsAuthorizationCompletionBlock)(BOOL success, NSError * _Nullable error);

/**
 KSHAccountsAuthorization wraps the APIs needed to request access to social accounts.
 */
@interface KSHAccountsAuthorization : NSObject

/**
 Get the shared accounts authorization object.
 */
@property (class,readonly,nonatomic) KSHAccountsAuthorization *sharedAuthorization;

/**
 Request accounts authorization for the provided *type* with the provided *options* and invokes the provided *completion* block when the authorization status is determined. The *completion* block is always invoked on the main thread.
 
 @param type The accounts type to request authorization for
 @param options The options dictionary
 @param completion The block that is invoked when authorization status has been determined
 */
- (void)requestAccountsAuthorizationForType:(KSHAccountsType)type options:(nullable NSDictionary<NSString *, id> *)options completion:(KSHRequestAccountsAuthorizationCompletionBlock)completion;

@end

NS_ASSUME_NONNULL_END
