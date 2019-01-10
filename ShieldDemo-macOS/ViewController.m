//
//  ViewController.m
//  ShieldDemo-macOS
//
//  Created by William Towe on 3/16/17.
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

#import "ViewController.h"

#import <Shield/Shield.h>

typedef NS_ENUM(NSInteger, AuthorizationType) {
    AuthorizationTypeLocation = 0,
    AuthorizationTypeContacts,
    AuthorizationTypeAccessibility,
    AuthorizationTypeCalendars,
    AuthorizationTypeReminders,
    AuthorizationTypeTwitter,
    AuthorizationTypeSecurity,
    AuthorizationTypeLocal,
    AuthorizationTypePhotos,
    AuthorizationTypeCamera,
    AuthorizationTypeMicrophone
};

@interface ViewController ()

@end

@implementation ViewController

- (IBAction)_buttonAction:(NSButton *)sender {
    switch ((AuthorizationType)sender.tag) {
        case AuthorizationTypeLocation: {
            [KSHLocationAuthorization.sharedAuthorization requestLocationAuthorization:KSHLocationAuthorizationStatusAuthorizedAlways completion:^(KSHLocationAuthorizationStatus status, NSError * _Nullable error) {
                NSLog(@"%@ %@",@(status),error);
            }];
        }
            break;
        case AuthorizationTypeAccessibility: {
            [KSHAccessibilityAuthorization.sharedAuthorization requestAccessibilityAuthorizationDisplayingSystemAlert:YES openSystemPreferencesIfNecessary:NO];
        }
            break;
        case AuthorizationTypeContacts: {
            [KSHContactsAuthorization.sharedAuthorization requestContactsAuthorizationWithCompletion:^(KSHContactsAuthorizationStatus status, NSError * _Nullable error) {
                NSLog(@"%@ %@",@(status),error);
            }];
        }
            break;
        case AuthorizationTypeReminders: {
            [KSHEventAuthorization.sharedAuthorization requestRemindersAuthorizationWithCompletion:^(KSHRemindersAuthorizationStatus status, NSError * _Nullable error) {
                NSLog(@"%@ %@",@(status),error);
            }];
        }
            break;
        case AuthorizationTypeCalendars: {
            [KSHEventAuthorization.sharedAuthorization requestCalendarsAuthorizationWithCompletion:^(KSHCalendarsAuthorizationStatus status, NSError * _Nullable error) {
                NSLog(@"%@ %@",@(status),error);
            }];
        }
            break;
        case AuthorizationTypeSecurity: {
            [KSHSecurityAuthorization.sharedAuthorization requestSecurityAuthorizationForRightStrings:[NSSet setWithArray:@[[NSString stringWithFormat:@"%@.right",[NSBundle mainBundle].infoDictionary[@"CFBundleIdentifier"]]]] completion:^(KSHSecurityRights * _Nullable securityRights, NSError * _Nullable error) {
                NSLog(@"%@ %@",securityRights,error);
            }];
        }
            break;
        case AuthorizationTypeLocal: {
            [KSHLocalAuthorization.sharedAuthorization requestLocalAuthorizationForPolicy:KSHLocalAuthorizationPolicyBiometrics localizedReason:@"do stuff and things" completion:^(BOOL success, NSError * _Nullable error) {
                NSLog(@"%@ %@",@(success),error);
            }];
        }
            break;
        case AuthorizationTypePhotos: {
            [KSHPhotosAuthorization.sharedAuthorization requestPhotoLibraryAuthorizationWithCompletion:^(KSHPhotosAuthorizationStatus status, NSError * _Nullable error) {
                NSLog(@"%@ %@",@(status),error);
            }];
        }
            break;
        case AuthorizationTypeCamera: {
            [KSHCameraAuthorization.sharedAuthorization requestCameraAuthorizationWithCompletion:^(KSHCameraAuthorizationStatus status, NSError * _Nullable error) {
                NSLog(@"%@ %@",@(status),error);
            }];
        }
            break;
        case AuthorizationTypeMicrophone: {
            [KSHMicrophoneAuthorization.sharedAuthorization requestMicrophoneAuthorizationWithCompletion:^(KSHMicrophoneAuthorizationStatus status, NSError * _Nullable error) {
                NSLog(@"%@ %@",@(status),error);
            }];
        }
            break;
        default:
            break;
    }
}

@end
