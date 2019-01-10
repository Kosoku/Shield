//
//  KSHSecurityRights.h
//  Shield
//
//  Created by William Towe on 4/9/17.
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
#import <Security/Authorization.h>

NS_ASSUME_NONNULL_BEGIN

/**
 KSHSecurityRights represents the rights granted by the user by entering their credentials into the system username/password dialog. The client should retain the instance while performing privileged operations and release it when finished.
 */
@interface KSHSecurityRights : NSObject

/**
 Get the right strings that were granted.
 */
@property (readonly,copy,nonatomic) NSSet<NSString *> *rightStrings;
/**
 Get the authorization item set that was granted.
 */
@property (readonly,assign,nonatomic) AuthorizationItemSet authorizationItemSet;
/**
 Get the authorization ref that represents the elevated privileges granted by the user.
 */
@property (readonly,assign,nonatomic) AuthorizationRef authorizationRef;

/**
 Creates and returns a security rights instance that owns the passed in authorization ref and authorization item set. It will release them when it is released.
 
 @param authorizationRef The authorization ref that represents the elevated privileges
 @param authorizationItemSet The authorization item set that represents the rights that were granted
 @param rightStrings The right strings that were granted
 @return The initialized instance
 */
- (instancetype)initWithAuthorizationRef:(AuthorizationRef)authorizationRef authorizationItemSet:(AuthorizationItemSet)authorizationItemSet rightStrings:(NSSet<NSString *> *)rightStrings NS_DESIGNATED_INITIALIZER;

- (instancetype)init UNAVAILABLE_ATTRIBUTE;

@end

NS_ASSUME_NONNULL_END
