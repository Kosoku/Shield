//
//  KSHSecurityRights.m
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

#import "KSHSecurityRights.h"

@interface KSHSecurityRights ()
@property (readwrite,copy,nonatomic) NSSet<NSString *> *rightStrings;
@property (readwrite,assign,nonatomic) AuthorizationItemSet authorizationItemSet;
@property (readwrite,assign,nonatomic) AuthorizationRef authorizationRef;
@end

@implementation KSHSecurityRights

- (void)dealloc {
    if (_authorizationRef != NULL) {
        AuthorizationFree(_authorizationRef, kAuthorizationFlagDestroyRights);
    }
}

- (instancetype)initWithAuthorizationRef:(AuthorizationRef)authorizationRef authorizationItemSet:(AuthorizationItemSet)authorizationItemSet rightStrings:(NSSet<NSString *> *)rightStrings {
    if (!(self = [super init]))
        return nil;
    
    _authorizationRef = authorizationRef;
    _authorizationItemSet = authorizationItemSet;
    _rightStrings = [rightStrings copy];
    
    return self;
}

@end
