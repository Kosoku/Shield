//
//  KSHAccessibilityAuthorization.h
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

NS_ASSUME_NONNULL_BEGIN

/**
 KSHAccessibilityAuthorization wraps the APIs needed to request accessibility access from the user.
 */
@interface KSHAccessibilityAuthorization : NSObject

/**
 Get the shared accessibility authorization object.
 */
@property (class,readonly,nonatomic) KSHAccessibilityAuthorization *sharedAuthorization;

/**
 Get whether the user has authorized accessibility access.
 */
@property (readonly,nonatomic) BOOL hasAccessibilityAuthorization;

/**
 Request accessibility authorization from the user and optionally display the system alert. If *openSystemPreferences* is YES and this method returns NO the Security & Privacy -> Privacy pane in System Preferences will be opened automatically.
 
 @param displaySystemAlert Whether to display the system accessibility alert
 @param openSystemPreferences Whether to open the appropriate system preferences pane if this method returns NO
 @return YES if the user has granted accessibility authorization, otherwise NO
 */
- (BOOL)requestAccessibilityAuthorizationDisplayingSystemAlert:(BOOL)displaySystemAlert openSystemPreferencesIfNecessary:(BOOL)openSystemPreferences;

@end

NS_ASSUME_NONNULL_END
