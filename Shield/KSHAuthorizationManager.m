//
//  KSHAuthorizationManager.m
//  Shield
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

#import "KSHAuthorizationManager.h"

#import <Stanley/KSTScopeMacros.h>
#import <Stanley/KSTFunctions.h>

#import <CoreLocation/CLLocationManagerDelegate.h>
#import <EventKit/EKEventStore.h>
#if (TARGET_OS_IPHONE)
#import <AVFoundation/AVMediaFormat.h>
#else
#import <AppKit/AppKit.h>
#endif

#if (TARGET_OS_IPHONE)
@interface KSHAuthorizationManager () <CLLocationManagerDelegate,CBPeripheralManagerDelegate>
#else
@interface KSHAuthorizationManager () <CLLocationManagerDelegate>
#endif
@property (strong,nonatomic) CLLocationManager *locationManager;
@property (copy,nonatomic) KSHRequestLocationAuthorizationCompletionBlock requestLocationAuthorizationCompletionBlock;

#if (TARGET_OS_IPHONE)
@property (strong,nonatomic) CBPeripheralManager *peripheralManager;
@property (copy,nonatomic) KSHRequestBluetoothPeripheralAuthorizationCompletionBlock requestBluetoothPeripheralAuthorizationCompletionBlock;
#endif
@end

@implementation KSHAuthorizationManager

- (void)locationManager:(CLLocationManager *)manager didChangeAuthorizationStatus:(CLAuthorizationStatus)status {
    if (status == kCLAuthorizationStatusNotDetermined) {
#if (TARGET_OS_OSX)
        [self.locationManager startUpdatingLocation];
#endif
        return;
    }
    
#if (TARGET_OS_IPHONE)
    if (status == kCLAuthorizationStatusAuthorizedAlways ||
        status == kCLAuthorizationStatusAuthorizedWhenInUse) {
        KSTDispatchMainAsync(^{
            self.requestLocationAuthorizationCompletionBlock((KSHLocationAuthorizationStatus)status,nil);
        });
    }
#else
    if (status == kCLAuthorizationStatusAuthorizedAlways) {
        KSTDispatchMainAsync(^{
            self.requestLocationAuthorizationCompletionBlock((KSHLocationAuthorizationStatus)status,nil);
        });
    }
#endif
    else {
        KSTDispatchMainAsync(^{
            self.requestLocationAuthorizationCompletionBlock(self.locationAuthorizationStatus,nil);
        });
    }
    
    [self setLocationManager:nil];
    [self setRequestLocationAuthorizationCompletionBlock:nil];
}

#if (TARGET_OS_IPHONE)
- (void)peripheralManagerDidUpdateState:(CBPeripheralManager *)peripheral {
    if (peripheral.state == CBManagerStateUnknown ||
        peripheral.state == CBManagerStateResetting) {
        
        return;
    }
    
    if (peripheral.state == CBManagerStatePoweredOn ||
        peripheral.state == CBManagerStatePoweredOff) {
        
        KSTDispatchMainAsync(^{
            self.requestBluetoothPeripheralAuthorizationCompletionBlock(KSHBluetoothPeripheralAuthorizationStatusAuthorized,nil);
        });
    }
    else {
        KSTDispatchMainAsync(^{
            self.requestBluetoothPeripheralAuthorizationCompletionBlock((KSHBluetoothPeripheralAuthorizationStatus)[CBPeripheralManager authorizationStatus],nil);
        });
    }
    
    [self setPeripheralManager:nil];
    [self setRequestBluetoothPeripheralAuthorizationCompletionBlock:nil];
}
#endif

#if (TARGET_OS_IPHONE)
- (void)requestCameraAuthorizationWithCompletion:(KSHRequestCameraAuthorizationCompletionBlock)completion; {
    NSParameterAssert(completion != nil);
    NSParameterAssert([NSBundle mainBundle].infoDictionary[@"NSCameraUsageDescription"] != nil);
    
    if (self.hasCameraAuthorization) {
        KSTDispatchMainAsync(^{
            completion(KSHCameraAuthorizationStatusAuthorized,nil);
        });
        return;
    }
    
    [AVCaptureDevice requestAccessForMediaType:AVMediaTypeVideo completionHandler:^(BOOL granted) {
        KSTDispatchMainAsync(^{
            completion(self.cameraAuthorizationStatus,nil);
        });
    }];
}
- (void)requestMicrophoneAuthorizationWithCompletion:(KSHRequestMicrophoneAuthorizationCompletionBlock)completion {
    NSParameterAssert(completion != nil);
    NSParameterAssert([NSBundle mainBundle].infoDictionary[@"NSMicrophoneUsageDescription"] != nil);
    
    if (self.hasMicrophoneAuthorization) {
        KSTDispatchMainAsync(^{
            completion(KSHMicrophoneAuthorizationStatusAuthorized,nil);
        });
        return;
    }
    
    [AVCaptureDevice requestAccessForMediaType:AVMediaTypeAudio completionHandler:^(BOOL granted) {
        KSTDispatchMainAsync(^{
            completion(self.microphoneAuthorizationStatus,nil);
        });
    }];
}
- (void)requestPhotoLibraryAuthorizationWithCompletion:(void (^)(KSHPhotoLibraryAuthorizationStatus status, NSError *error))completion {
    NSParameterAssert(completion != nil);
    NSParameterAssert([NSBundle mainBundle].infoDictionary[@"NSPhotoLibraryUsageDescription"] != nil);
    
    if (self.hasPhotoLibraryAuthorization) {
        KSTDispatchMainAsync(^{
            completion(KSHPhotoLibraryAuthorizationStatusAuthorized,nil);
        });
        return;
    }
    
    [PHPhotoLibrary requestAuthorization:^(PHAuthorizationStatus status) {
        KSTDispatchMainAsync(^{
            completion((KSHPhotoLibraryAuthorizationStatus)status,nil);
        });
    }];
}
- (KSHHealthShareAuthorizationStatus)healthShareAuthorizationStatusForType:(HKObjectType *)type {
    return (KSHHealthShareAuthorizationStatus)[[[HKHealthStore alloc] init] authorizationStatusForType:type];
}
- (void)requestHealthShareAuthorizationToReadTypes:(NSArray<HKObjectType *> *)readTypes writeTypes:(NSArray<HKSampleType *> *)writeTypes completion:(KSHRequestHealthShareAuthorizationCompletionBlock)completion {
    NSParameterAssert(completion != nil);
    NSParameterAssert(readTypes.count > 0 || writeTypes.count > 0);
    
    if (writeTypes.count > 0) {
        NSParameterAssert([NSBundle mainBundle].infoDictionary[@"NSHealthUpdateUsageDescription"] != nil);
    }
    if (readTypes.count > 0) {
        NSParameterAssert([NSBundle mainBundle].infoDictionary[@"NSHealthShareUsageDescription"] != nil);
    }
    
    HKHealthStore *healthStore = [[HKHealthStore alloc] init];
    
    [healthStore requestAuthorizationToShareTypes:[NSSet setWithArray:writeTypes] readTypes:[NSSet setWithArray:readTypes] completion:^(BOOL success, NSError * _Nullable error) {
        NSMutableDictionary *retval = [[NSMutableDictionary alloc] init];
        
        for (HKObjectType *type in readTypes) {
            [retval setObject:@([healthStore authorizationStatusForType:type]) forKey:type];
        }
        for (HKObjectType *type in writeTypes) {
            [retval setObject:@([healthStore authorizationStatusForType:type]) forKey:type];
        }
        
        KSTDispatchMainAsync(^{
            completion(success,retval,error);
        });
    }];
}
- (void)requestSiriAuthorizationWithCompletion:(KSHRequestSiriAuthorizationCompletionBlock)completion {
    NSParameterAssert(completion != nil);
    NSParameterAssert([NSBundle mainBundle].infoDictionary[@"NSSiriUsageDescription"] != nil);
    
    if (self.hasSiriAuthorization) {
        KSTDispatchMainAsync(^{
            completion(KSHSiriAuthorizationStatusAuthorized,nil);
        });
        return;
    }
    
    [INPreferences requestSiriAuthorization:^(INSiriAuthorizationStatus status) {
        KSTDispatchMainAsync(^{
            completion((KSHSiriAuthorizationStatus)status,nil);
        });
    }];
}
- (void)requestSpeechRecognitionAuthorizationWithCompletion:(KSHRequestSpeechRecognitionAuthorizationCompletionBlock)completion {
    NSParameterAssert(completion != nil);
    NSParameterAssert([NSBundle mainBundle].infoDictionary[@"NSSpeechRecognitionUsageDescription"] != nil);
    
    if (self.hasSpeechRecognitionAuthorization) {
        KSTDispatchMainAsync(^{
            completion(KSHSpeechRecognitionAuthorizationStatusAuthorized,nil);
        });
        return;
    }
    
    [SFSpeechRecognizer requestAuthorization:^(SFSpeechRecognizerAuthorizationStatus status) {
        KSTDispatchMainAsync(^{
            completion((KSHSpeechRecognitionAuthorizationStatus)status,nil);
        });
    }];
}
- (void)requestBluetoothPeripheralAuthorizationWithCompletion:(KSHRequestBluetoothPeripheralAuthorizationCompletionBlock)completion {
    NSParameterAssert(completion != nil);
    NSParameterAssert([NSBundle mainBundle].infoDictionary[@"NSBluetoothPeripheralUsageDescription"] != nil);
    NSParameterAssert([[NSBundle mainBundle].infoDictionary[@"UIBackgroundModes"] containsObject:@"bluetooth-peripheral"]);
    
    if (self.hasBluetoothPeripheralAuthorization) {
        KSTDispatchMainAsync(^{
            completion(KSHBluetoothPeripheralAuthorizationStatusAuthorized,nil);
        });
        return;
    }
    
    [self setRequestBluetoothPeripheralAuthorizationCompletionBlock:completion];
    [self setPeripheralManager:[[CBPeripheralManager alloc] initWithDelegate:self queue:nil]];
}
#else
- (BOOL)requestAccessibilityAuthorizationDisplayingSystemAlert:(BOOL)displaySystemAlert openSystemPreferencesIfNecessary:(BOOL)openSystemPreferences; {
    NSDictionary *options = @{(__bridge id)kAXTrustedCheckOptionPrompt: @(displaySystemAlert)};
    BOOL retval = AXIsProcessTrustedWithOptions((CFDictionaryRef)options);
    
    if (!retval &&
        openSystemPreferences) {
        
        [[NSWorkspace sharedWorkspace] openURL:[NSURL URLWithString:@"x-apple.systempreferences:com.apple.preference.security?Privacy_Accessibility"]];
    }
    
    return retval;
}
#endif
- (void)requestLocationAuthorization:(KSHLocationAuthorizationStatus)authorization completion:(void(^)(KSHLocationAuthorizationStatus status, NSError *error))completion; {
#if (TARGET_OS_IPHONE)
    NSParameterAssert(authorization == KSHLocationAuthorizationStatusAuthorizedAlways || authorization == KSHLocationAuthorizationStatusAuthorizedWhenInUse);
    if (authorization == KSHLocationAuthorizationStatusAuthorizedAlways) {
        NSParameterAssert([NSBundle mainBundle].infoDictionary[@"NSLocationAlwaysUsageDescription"] != nil);
    }
    else {
        NSParameterAssert([NSBundle mainBundle].infoDictionary[@"NSLocationWhenInUseUsageDescription"] != nil);
    }
#else
    NSParameterAssert(authorization == KSHLocationAuthorizationStatusAuthorizedAlways);
    NSParameterAssert([NSBundle mainBundle].infoDictionary[@"NSLocationUsageDescription"] != nil);
#endif
    NSParameterAssert(completion != nil);
    
    if (self.locationAuthorizationStatus == authorization) {
        KSTDispatchMainAsync(^{
            completion(authorization,nil);
        });
        return;
    }
    
    [self setRequestLocationAuthorizationCompletionBlock:completion];
    
    [self setLocationManager:[[CLLocationManager alloc] init]];
    [self.locationManager setDelegate:self];
    
#if (TARGET_OS_IPHONE)
    if (authorization == KSHLocationAuthorizationStatusAuthorizedAlways) {
        [self.locationManager requestAlwaysAuthorization];
    }
    else {
        [self.locationManager requestWhenInUseAuthorization];
    }
#else
    [self.locationManager startUpdatingLocation];
#endif
}
- (void)requestCalendarsAuthorizationWithCompletion:(KSHRequestCalendarsAuthorizationCompletionBlock)completion {
    NSParameterAssert(completion != nil);
    NSParameterAssert([NSBundle mainBundle].infoDictionary[@"NSCalendarsUsageDescription"] != nil);
    
    EKEventStore *eventStore = [[EKEventStore alloc] init];
    
    [eventStore requestAccessToEntityType:EKEntityTypeEvent completion:^(BOOL granted, NSError * _Nullable error) {
        KSTDispatchMainAsync(^{
            completion(self.calendarsAuthorizationStatus,error);
        });
    }];
}
- (void)requestRemindersAuthorizationWithCompletion:(KSHRequestRemindersAuthorizationCompletionBlock)completion {
    NSParameterAssert(completion != nil);
    NSParameterAssert([NSBundle mainBundle].infoDictionary[@"NSRemindersUsageDescription"] != nil);
    
    EKEventStore *eventStore = [[EKEventStore alloc] init];
    
    [eventStore requestAccessToEntityType:EKEntityTypeReminder completion:^(BOOL granted, NSError * _Nullable error) {
        KSTDispatchMainAsync(^{
            completion(self.remindersAuthorizationStatus,error);
        });
    }];
}
- (void)requestContactsAuthorizationWithCompletion:(KSHRequestContactsAuthorizationCompletionBlock)completion {
    NSParameterAssert(completion != nil);
    NSParameterAssert([NSBundle mainBundle].infoDictionary[@"NSContactsUsageDescription"] != nil);
    
    if (self.hasContactsAuthorization) {
        KSTDispatchMainAsync(^{
            completion(KSHContactsAuthorizationStatusAuthorized,nil);
        });
        return;
    }
    
    CNContactStore *contactStore = [[CNContactStore alloc] init];
    
    [contactStore requestAccessForEntityType:CNEntityTypeContacts completionHandler:^(BOOL granted, NSError * _Nullable error) {
        KSTDispatchMainAsync(^{
            completion(self.contactsAuthorizationStatus,error);
        });
    }];
}

+ (KSHAuthorizationManager *)sharedManager {
    static dispatch_once_t onceToken;
    static KSHAuthorizationManager *kRetval;
    dispatch_once(&onceToken, ^{
        kRetval = [[KSHAuthorizationManager alloc] init];
    });
    return kRetval;
}

#if (TARGET_OS_IPHONE)
- (BOOL)hasCameraAuthorization {
    return self.cameraAuthorizationStatus == KSHCameraAuthorizationStatusAuthorized;
}
- (KSHCameraAuthorizationStatus)cameraAuthorizationStatus {
    return (KSHCameraAuthorizationStatus)[AVCaptureDevice authorizationStatusForMediaType:AVMediaTypeVideo];
}

- (BOOL)hasMicrophoneAuthorization {
    return self.microphoneAuthorizationStatus == KSHMicrophoneAuthorizationStatusAuthorized;
}
- (KSHMicrophoneAuthorizationStatus)microphoneAuthorizationStatus {
    return (KSHMicrophoneAuthorizationStatus)[AVCaptureDevice authorizationStatusForMediaType:AVMediaTypeAudio];
}

- (BOOL)hasPhotoLibraryAuthorization {
    return self.photoLibraryAuthorizationStatus == KSHPhotoLibraryAuthorizationStatusAuthorized;
}
- (KSHPhotoLibraryAuthorizationStatus)photoLibraryAuthorizationStatus {
    return (KSHPhotoLibraryAuthorizationStatus)[PHPhotoLibrary authorizationStatus];
}

- (BOOL)hasSiriAuthorization {
    return self.siriAuthorizationStatus == KSHSiriAuthorizationStatusAuthorized;
}
- (KSHSiriAuthorizationStatus)siriAuthorizationStatus {
    return (KSHSiriAuthorizationStatus)[INPreferences siriAuthorizationStatus];
}

- (BOOL)hasSpeechRecognitionAuthorization {
    return self.speechRecognitionAuthorizationStatus == KSHSpeechRecognitionAuthorizationStatusAuthorized;
}
- (KSHSpeechRecognitionAuthorizationStatus)speechRecognitionAuthorizationStatus {
    return (KSHSpeechRecognitionAuthorizationStatus)[SFSpeechRecognizer authorizationStatus];
}

- (BOOL)hasBluetoothPeripheralAuthorization {
    return self.bluetoothPeripheralAuthorizationStatus == KSHBluetoothPeripheralAuthorizationStatusAuthorized;
}
- (KSHBluetoothPeripheralAuthorizationStatus)bluetoothPeripheralAuthorizationStatus {
    return (KSHBluetoothPeripheralAuthorizationStatus)[CBPeripheralManager authorizationStatus];
}
#else
- (BOOL)hasAccessibilityAuthorization {
    NSDictionary *options = @{(__bridge id)kAXTrustedCheckOptionPrompt: @NO};
    BOOL retval = AXIsProcessTrustedWithOptions((CFDictionaryRef)options);
    
    return retval;
}
#endif

- (BOOL)hasLocationAuthorization {
#if (TARGET_OS_IPHONE)
    return self.hasLocationAuthorizationAlways || self.hasLocationAuthorizationWhenInUse;
#else 
    return self.hasLocationAuthorizationAlways;
#endif
}
- (BOOL)hasLocationAuthorizationAlways {
    return self.locationAuthorizationStatus == KSHLocationAuthorizationStatusAuthorizedAlways;
}
#if (TARGET_OS_IPHONE)
- (BOOL)hasLocationAuthorizationWhenInUse {
    return self.locationAuthorizationStatus == KSHLocationAuthorizationStatusAuthorizedWhenInUse;
}
#endif
- (KSHLocationAuthorizationStatus)locationAuthorizationStatus {
    return (KSHLocationAuthorizationStatus)[CLLocationManager authorizationStatus];
}

- (BOOL)hasCalendarsAuthorization {
    return self.calendarsAuthorizationStatus == KSHCalendarsAuthorizationStatusAuthorized;
}
- (KSHCalendarsAuthorizationStatus)calendarsAuthorizationStatus {
    return (KSHCalendarsAuthorizationStatus)[EKEventStore authorizationStatusForEntityType:EKEntityTypeEvent];
}

- (BOOL)hasRemindersAuthorization {
    return self.remindersAuthorizationStatus == KSHRemindersAuthorizationStatusAuthorized;
}
- (KSHRemindersAuthorizationStatus)remindersAuthorizationStatus {
    return (KSHRemindersAuthorizationStatus)[EKEventStore authorizationStatusForEntityType:EKEntityTypeReminder];
}

- (BOOL)hasContactsAuthorization {
    return self.contactsAuthorizationStatus == KSHContactsAuthorizationStatusAuthorized;
}
- (KSHContactsAuthorizationStatus)contactsAuthorizationStatus {
    return (KSHContactsAuthorizationStatus)[CNContactStore authorizationStatusForEntityType:CNEntityTypeContacts];
}

@end
