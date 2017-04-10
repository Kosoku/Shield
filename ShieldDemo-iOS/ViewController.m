//
//  ViewController.m
//  ShieldDemo-iOS
//
//  Created by William Towe on 3/13/17.
//  Copyright © 2017 Kosoku Interactive, LLC. All rights reserved.
//
//  Redistribution and use in source and binary forms, with or without modification, are permitted provided that the following conditions are met:
//
//  1. Redistributions of source code must retain the above copyright notice, this list of conditions and the following disclaimer.
//
//  2. Redistributions in binary form must reproduce the above copyright notice, this list of conditions and the following disclaimer in the documentation and/or other materials provided with the distribution.
//
//  THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS "AS IS" AND ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED TO, THE IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE ARE DISCLAIMED. IN NO EVENT SHALL THE COPYRIGHT HOLDER OR CONTRIBUTORS BE LIABLE FOR ANY DIRECT, INDIRECT, INCIDENTAL, SPECIAL, EXEMPLARY, OR CONSEQUENTIAL DAMAGES (INCLUDING, BUT NOT LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS OR SERVICES; LOSS OF USE, DATA, OR PROFITS; OR BUSINESS INTERRUPTION) HOWEVER CAUSED AND ON ANY THEORY OF LIABILITY, WHETHER IN CONTRACT, STRICT LIABILITY, OR TORT (INCLUDING NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY OUT OF THE USE OF THIS SOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.

#import "ViewController.h"

#import <Shield/Shield.h>

#import <HealthKit/HealthKit.h>
#import <UserNotifications/UserNotifications.h>

typedef NS_ENUM(NSInteger, AuthorizationType) {
    AuthorizationTypePhotoLibrary,
    AuthorizationTypeLocation,
    AuthorizationTypeCamera,
    AuthorizationTypeMicrophone,
    AuthorizationTypeCalendars,
    AuthorizationTypeReminders,
    AuthorizationTypeBluetoothPeripheral,
    AuthorizationTypeContacts,
    AuthorizationTypeHealthShare,
    AuthorizationTypeSiri,
    AuthorizationTypeSpeechRecognition,
    AuthorizationTypeMediaLibrary,
    AuthorizationTypeTwitter,
    AuthorizationTypeHome,
    AuthorizationTypeMotion,
    AuthorizationTypeLocal,
    AuthorizationTypeNotification
};

@interface ViewController () <UITableViewDataSource,UITableViewDelegate>
@property (strong,nonatomic) UITableView *tableView;

@property (copy,nonatomic) NSArray<NSNumber *> *authorizationTypes;
@property (copy,nonatomic) NSArray<NSString *> *authorizationTitles;
@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self setAuthorizationTypes:@[@(AuthorizationTypePhotoLibrary),
                                  @(AuthorizationTypeLocation),
                                  @(AuthorizationTypeCamera),
                                  @(AuthorizationTypeMicrophone),
                                  @(AuthorizationTypeCalendars),
                                  @(AuthorizationTypeReminders),
                                  @(AuthorizationTypeBluetoothPeripheral),
                                  @(AuthorizationTypeContacts),
                                  @(AuthorizationTypeHealthShare),
                                  @(AuthorizationTypeSiri),
                                  @(AuthorizationTypeSpeechRecognition),
                                  @(AuthorizationTypeMediaLibrary),
                                  @(AuthorizationTypeTwitter),
                                  @(AuthorizationTypeHome),
                                  @(AuthorizationTypeMotion),
                                  @(AuthorizationTypeLocal),
                                  @(AuthorizationTypeNotification)]];
    [self setAuthorizationTitles:@[@"Photos",
                                   @"Location",
                                   @"Camera",
                                   @"Microphone",
                                   @"Calendars",
                                   @"Reminders",
                                   @"Bluetooth",
                                   @"Contacts",
                                   @"Health",
                                   @"Siri",
                                   @"Speech Recognition",
                                   @"Media Library",
                                   @"Twitter",
                                   @"Home",
                                   @"Motion",
                                   @"Local",
                                   @"Notification"]];
    
    [self setTableView:[[UITableView alloc] initWithFrame:CGRectZero style:UITableViewStylePlain]];
    [self.tableView setTranslatesAutoresizingMaskIntoConstraints:NO];
    [self.tableView setDataSource:self];
    [self.tableView setDelegate:self];
    [self.view addSubview:self.tableView];
    
    [self.view addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|[view]|" options:0 metrics:nil views:@{@"view": self.tableView}]];
    [self.view addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:[top][view]|" options:0 metrics:nil views:@{@"view": self.tableView, @"top": self.topLayoutGuide}]];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.authorizationTypes.count;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@""];
    
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@""];
    }
    
    [cell.textLabel setText:self.authorizationTitles[indexPath.row]];
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    switch ((AuthorizationType)self.authorizationTypes[indexPath.row].integerValue) {
        case AuthorizationTypePhotoLibrary: {
            [KSHPhotosAuthorization.sharedAuthorization requestPhotoLibraryAuthorizationWithCompletion:^(KSHPhotoLibraryAuthorizationStatus status, NSError * _Nullable error) {
                NSLog(@"%@ %@",@(status),error);
            }];
        }
            break;
        case AuthorizationTypeLocation: {
            [KSHLocationAuthorization.sharedAuthorization requestLocationAuthorization:KSHLocationAuthorizationStatusAuthorizedAlways completion:^(KSHLocationAuthorizationStatus status, NSError * _Nullable error) {
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
        case AuthorizationTypeCalendars: {
            [KSHEventAuthorization.sharedAuthorization requestCalendarsAuthorizationWithCompletion:^(KSHCalendarsAuthorizationStatus status, NSError * _Nullable error) {
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
        case AuthorizationTypeBluetoothPeripheral: {
            [KSHBluetoothAuthorization.sharedAuthorization requestBluetoothPeripheralAuthorizationWithCompletion:^(KSHBluetoothPeripheralAuthorizationStatus status, NSError * _Nullable error) {
                NSLog(@"%@ %@",@(status),error);
            }];
        }
            break;
        case AuthorizationTypeContacts: {
            [KSHContactsAuthorization.sharedAuthorization requestContactsAuthorizationWithCompletion:^(KSHContactsAuthorizationStatus status, NSError * _Nullable error) {
                NSLog(@"%@ %@",@(status),error);
            }];
        }
            break;
        case AuthorizationTypeHealthShare: {
            [KSHHealthAuthorization.sharedAuthorization requestHealthAuthorizationToReadTypes:@[[HKObjectType quantityTypeForIdentifier:HKQuantityTypeIdentifierBodyMassIndex]] writeTypes:@[[HKObjectType categoryTypeForIdentifier:HKCategoryTypeIdentifierSleepAnalysis]] completion:^(BOOL success, NSDictionary<HKObjectType *,NSNumber *> * _Nonnull objectsToAuthorizationStatus, NSError * _Nullable error) {
                NSLog(@"%@ %@ %@",@(success),objectsToAuthorizationStatus,error);
            }];
        }
            break;
        case AuthorizationTypeSiri: {
            [KSHSiriAuthorization.sharedAuthorization requestSiriAuthorizationWithCompletion:^(KSHSiriAuthorizationStatus status, NSError * _Nullable error) {
                NSLog(@"%@ %@",@(status),error);
            }];
        }
            break;
        case AuthorizationTypeSpeechRecognition: {
            [KSHSpeechAuthorization.sharedAuthorization requestSpeechRecognitionAuthorizationWithCompletion:^(KSHSpeechRecognitionAuthorizationStatus status, NSError * _Nullable error) {
                NSLog(@"%@ %@",@(status),error);
            }];
        }
            break;
        case AuthorizationTypeMediaLibrary: {
            [KSHMediaLibraryAuthorization.sharedAuthorization requestMediaLibraryAuthorizationWithCompletion:^(KSHMediaLibraryAuthorizationStatus status, NSError * _Nullable error) {
                NSLog(@"%@ %@",@(status),error);
            }];
        }
            break;
        case AuthorizationTypeTwitter: {
            [KSHAccountsAuthorization.sharedAuthorization requestAccountsAuthorizationForType:KSHAccountsTypeTwitter options:nil completion:^(BOOL success, NSError * _Nullable error) {
                NSLog(@"%@ %@",@(success),error);
            }];
        }
            break;
        case AuthorizationTypeHome: {
            [KSHHomeAuthorization.sharedAuthorization requestHomeAuthorizationWithCompletion:^(BOOL success, NSError * _Nullable error) {
                NSLog(@"%@ %@",@(success),error);
            }];
        }
            break;
        case AuthorizationTypeMotion: {
            [KSHMotionAuthorization.sharedAuthorization requestMotionAuthorizationWithCompletion:^(BOOL success, NSError * _Nullable error) {
                NSLog(@"%@ %@",@(success),error);
            }];
        }
            break;
        case AuthorizationTypeLocal: {
            [KSHLocalAuthorization.sharedAuthorization requestLocalAuthorizationForPolicy:KSHLocalAuthorizationPolicyBiometrics localizedReason:@"wants to do stuff and things." completion:^(BOOL success, NSError * _Nullable error) {
                NSLog(@"%@ %@",@(success),error);
            }];
        }
            break;
        case AuthorizationTypeNotification: {
            [KSHNotificationAuthorization.sharedAuthorization requestNotificationAuthorizationForOptions:KSHNotificationAuthorizationOptionsBadge completion:^(KSHNotificationAuthorizationStatus status, NSError * _Nullable error) {
                NSLog(@"%@ %@",@(status),error);
            }];
        }
            break;
        default:
            break;
    }
}

@end
