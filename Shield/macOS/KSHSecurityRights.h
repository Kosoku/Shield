//
//  KSHSecurityRights.h
//  Shield
//
//  Created by William Towe on 4/9/17.
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
