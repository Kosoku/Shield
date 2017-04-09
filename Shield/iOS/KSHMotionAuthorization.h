//
//  KSHMotionAuthorization.h
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
#import <CoreMotion/CMError.h>

NS_ASSUME_NONNULL_BEGIN

/**
 Block that is invoked when motion authorization status has been determined.
 
 @param success Whether motion access was granted by the user
 @param error The error describing was motion access was denied
 */
typedef void(^KSHRequestMotionAuthorizationCompletionBlock)(BOOL success, NSError * _Nullable error);

/**
 KSHMotionAuthorization wraps the APIs needed to request motion access from the user.
 */
@interface KSHMotionAuthorization : NSObject

/**
 Get the shared motion authorization.
 */
@property (class,readonly,nonatomic) KSHMotionAuthorization *sharedAuthorization;

/**
 Request motion authorization from the user and invoke *completion* block when authorization status has been determined. The *completion* block is always invoked on the main thread. The client must provide a reason in their info plist using the NSMotionUsageDescription key or an exception will be thrown.
 
 @param completion The completion block that is invoked when authorization status has been determined
 @exception NSException Thrown if *completion* is nil or the NSMotionUsageDescription key is not present in the info plist
 */
- (void)requestMotionAuthorizationWithCompletion:(KSHRequestMotionAuthorizationCompletionBlock)completion;

@end

NS_ASSUME_NONNULL_END
