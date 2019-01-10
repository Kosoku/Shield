//
//  KSHMotionAuthorization.h
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
