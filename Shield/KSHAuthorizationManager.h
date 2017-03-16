//
//  KSHAuthorizationManager.h
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

#import <TargetConditionals.h>

#if (TARGET_OS_IPHONE)
#if (TARGET_OS_IOS || TARGET_OS_WATCH)
#import <HealthKit/HKHealthStore.h>
#if (TARGET_OS_IOS)
#import <Intents/INPreferences.h>
#import <Speech/SFSpeechRecognizer.h>
#endif
#endif
#import <AVFoundation/AVCaptureDevice.h>
#import <Photos/PHPhotoLibrary.h>
#import <CoreBluetooth/CBPeripheralManager.h>
#else
#import <ApplicationServices/ApplicationServices.h>
#endif
#import <CoreLocation/CLLocationManager.h>
#if (TARGET_OS_IOS || TARGET_OS_OSX || TARGET_OS_WATCH)
#import <EventKit/EKTypes.h>
#import <Contacts/CNContactStore.h>
#endif

NS_ASSUME_NONNULL_BEGIN

#if (TARGET_OS_IPHONE)
#if (TARGET_OS_IOS || TARGET_OS_WATCH)
/**
 Enum defining the possible camera authorization status values. See AVAuthorizationStatus for more information.
 */
typedef NS_ENUM(NSInteger, KSHCameraAuthorizationStatus) {
    /**
     See AVAuthorizationStatusNotDetermined for more information.
     */
    KSHCameraAuthorizationStatusNotDetermined = AVAuthorizationStatusNotDetermined,
    /**
     See AVAuthorizationStatusRestricted for more information.
     */
    KSHCameraAuthorizationStatusRestricted = AVAuthorizationStatusRestricted,
    /**
     See AVAuthorizationStatusDenied for more information.
     */
    KSHCameraAuthorizationStatusDenied = AVAuthorizationStatusDenied,
    /**
     See AVAuthorizationStatusAuthorized for more information.
     */
    KSHCameraAuthorizationStatusAuthorized = AVAuthorizationStatusAuthorized
};
/**
 Completion block that is invoked after requesting camera access.
 
 @param status The current camera authorization status
 @param error The error
 */
typedef void(^KSHRequestCameraAuthorizationCompletionBlock)(KSHCameraAuthorizationStatus status, NSError * _Nullable error);

/**
 Enum defining the possible microphone authorization status values. See AVAuthorizationStatus for more information.
 */
typedef NS_ENUM(NSInteger, KSHMicrophoneAuthorizationStatus) {
    /**
     See AVAuthorizationStatusNotDetermined for more information.
     */
    KSHMicrophoneAuthorizationStatusNotDetermined = AVAuthorizationStatusNotDetermined,
    /**
     See AVAuthorizationStatusRestricted for more information.
     */
    KSHMicrophoneAuthorizationStatusRestricted = AVAuthorizationStatusRestricted,
    /**
     See AVAuthorizationStatusDenied for more information.
     */
    KSHMicrophoneAuthorizationStatusDenied = AVAuthorizationStatusDenied,
    /**
     See AVAuthorizationStatusAuthorized for more information.
     */
    KSHMicrophoneAuthorizationStatusAuthorized = AVAuthorizationStatusAuthorized
};
/**
 Completion block that is invoked after requesting microphone access.
 
 @param status The current microphone authorization status
 @param error The error
 */
typedef void(^KSHRequestMicrophoneAuthorizationCompletionBlock)(KSHMicrophoneAuthorizationStatus status, NSError * _Nullable error);
#endif

/**
 Enum defining the possible photo library authorization status values. See PHAuthorizationStatus for more information.
 */
typedef NS_ENUM(NSInteger, KSHPhotoLibraryAuthorizationStatus) {
    /**
     See PHAuthorizationStatusNotDetermined for more information.
     */
    KSHPhotoLibraryAuthorizationStatusNotDetermined = PHAuthorizationStatusNotDetermined,
    /**
     See PHAuthorizationStatusRestricted for more information.
     */
    KSHPhotoLibraryAuthorizationStatusRestricted = PHAuthorizationStatusRestricted,
    /**
     See PHAuthorizationStatusDenied for more information.
     */
    KSHPhotoLibraryAuthorizationStatusDenied = PHAuthorizationStatusDenied,
    /**
     See PHAuthorizationStatusAuthorized for more information.
     */
    KSHPhotoLibraryAuthorizationStatusAuthorized = PHAuthorizationStatusAuthorized
};
/**
 Completion block that is invoked after requesting photo library access.
 
 @param status The current photo library authorization status
 @param error The error
 */
typedef void(^KSHRequestPhotoLibraryAuthorizationCompletionBlock)(KSHPhotoLibraryAuthorizationStatus status, NSError * _Nullable error);

#if (TARGET_OS_IOS || TARGET_OS_WATCH)
/**
 Enum defining the possible health share authorization status values. See HKAuthorizationStatus for more information.
 */
typedef NS_ENUM(NSInteger, KSHHealthShareAuthorizationStatus) {
    /**
     See HKAuthorizationStatusNotDetermined for more information.
     */
    KSHHealthShareAuthorizationStatusNotDetermined = HKAuthorizationStatusNotDetermined,
    /**
     See HKAuthorizationStatusSharingDenied for more information.
     */
    KSHHealthShareAuthorizationStatusDenied = HKAuthorizationStatusSharingDenied,
    /**
     See HKAuthorizationStatusSharingAuthorized for more information.
     */
    KSHHealthShareAuthorizationStatusAuthorized = HKAuthorizationStatusSharingAuthorized
};
/**
 Completion block that is invoked after requesting health share access.
 
 @param success Whether access was granted
 @param objectsToAuthorizationStatus A dictionary of the object types that were passed in to the authorization status for each type
 @param error The error
 */
typedef void(^KSHRequestHealthShareAuthorizationCompletionBlock)(BOOL success, NSDictionary<HKObjectType *, NSNumber *> *objectsToAuthorizationStatus, NSError * _Nullable error);
#endif

#if (TARGET_OS_IOS)
/**
 Enum defining the possible siri authorization status values. See INSiriAuthorizationStatus for more information.
 */
typedef NS_ENUM(NSInteger, KSHSiriAuthorizationStatus) {
    /**
     See INSiriAuthorizationStatusNotDetermined for more information.
     */
    KSHSiriAuthorizationStatusNotDetermined = INSiriAuthorizationStatusNotDetermined,
    /**
     See INSiriAuthorizationStatusRestricted for more information.
     */
    KSHSiriAuthorizationStatusRestricted = INSiriAuthorizationStatusRestricted,
    /**
     See INSiriAuthorizationStatusDenied for more information.
     */
    KSHSiriAuthorizationStatusDenied = INSiriAuthorizationStatusDenied,
    /**
     See INSiriAuthorizationStatusAuthorized for more information.
     */
    KSHSiriAuthorizationStatusAuthorized = INSiriAuthorizationStatusAuthorized
};
/**
 Completion block that is invoked after requesting siri access.
 
 @param status The current siri authorization status
 @param error The error
 */
typedef void(^KSHRequestSiriAuthorizationCompletionBlock)(KSHSiriAuthorizationStatus status, NSError * _Nullable error);

/**
 Enum defining the possible speech recognition authorization status values. See SFSpeechRecognizerAuthorizationStatus for more information.
 */
typedef NS_ENUM(NSInteger, KSHSpeechRecognitionAuthorizationStatus) {
    /**
     See SFSpeechRecognizerAuthorizationStatusNotDetermined for more information.
     */
    KSHSpeechRecognitionAuthorizationStatusNotDetermined = SFSpeechRecognizerAuthorizationStatusNotDetermined,
    /**
     See SFSpeechRecognizerAuthorizationStatusRestricted for more information.
     */
    KSHSpeechRecognitionAuthorizationStatusRestricted = SFSpeechRecognizerAuthorizationStatusRestricted,
    /**
     See SFSpeechRecognizerAuthorizationStatusDenied for more information.
     */
    KSHSpeechRecognitionAuthorizationStatusDenied = SFSpeechRecognizerAuthorizationStatusDenied,
    /**
     See SFSpeechRecognizerAuthorizationStatusAuthorized for more information.
     */
    KSHSpeechRecognitionAuthorizationStatusAuthorized = SFSpeechRecognizerAuthorizationStatusAuthorized
};
/**
 Completion block that is invoked after requesting speech recognition access.
 
 @param status The current speech recognition authorization status
 @param error The error
 */
typedef void(^KSHRequestSpeechRecognitionAuthorizationCompletionBlock)(KSHSpeechRecognitionAuthorizationStatus status, NSError * _Nullable error);

/**
 Enum defining the possible bluetooth peripheral authorization status values. See CBPeripheralManagerAuthorizationStatus for more information.
 */
typedef NS_ENUM(NSInteger, KSHBluetoothPeripheralAuthorizationStatus) {
    /**
     See CBPeripheralManagerAuthorizationStatusNotDetermined for more information.
     */
    KSHBluetoothPeripheralAuthorizationStatusNotDetermined = CBPeripheralManagerAuthorizationStatusNotDetermined,
    /**
     See CBPeripheralManagerAuthorizationStatusRestricted for more information.
     */
    KSHBluetoothPeripheralAuthorizationStatusRestricted = CBPeripheralManagerAuthorizationStatusRestricted,
    /**
     See CBPeripheralManagerAuthorizationStatusDenied for more information.
     */
    KSHBluetoothPeripheralAuthorizationStatusDenied = CBPeripheralManagerAuthorizationStatusDenied,
    /**
     See CBPeripheralManagerAuthorizationStatusAuthorized for more information.
     */
    KSHBluetoothPeripheralAuthorizationStatusAuthorized = CBPeripheralManagerAuthorizationStatusAuthorized
};
/**
 Completion block that is invoked after requesting bluetooth peripheral access.
 
 @param status The current bluetooth peripheral authorization status
 @param error The error
 */
typedef void(^KSHRequestBluetoothPeripheralAuthorizationCompletionBlock)(KSHBluetoothPeripheralAuthorizationStatus status, NSError * _Nullable error);
#endif
#endif

/**
 Enum defining the possible location authorization status values. See CLAuthorizationStatus for more information.
 */
typedef NS_ENUM(int, KSHLocationAuthorizationStatus) {
    /**
     See kCLAuthorizationStatusNotDetermined for more information.
     */
    KSHLocationAuthorizationStatusNotDetermined = kCLAuthorizationStatusNotDetermined,
    /**
     See kCLAuthorizationStatusRestricted for more information.
     */
    KSHLocationAuthorizationStatusRestricted = kCLAuthorizationStatusRestricted,
    /**
     See kCLAuthorizationStatusDenied for more information.
     */
    KSHLocationAuthorizationStatusDenied = kCLAuthorizationStatusDenied,
#if (TARGET_OS_IOS || TARGET_OS_OSX || TARGET_OS_WATCH)
    /**
     See kCLAuthorizationStatusAuthorizedAlways for more information.
     */
    KSHLocationAuthorizationStatusAuthorizedAlways = kCLAuthorizationStatusAuthorizedAlways,
#endif
#if (TARGET_OS_IPHONE)
    /**
     See kCLAuthorizationStatusAuthorizedWhenInUse for more information.
     */
    KSHLocationAuthorizationStatusAuthorizedWhenInUse = kCLAuthorizationStatusAuthorizedWhenInUse
#endif
};
/**
 Completion block that is invoked after requesting location access.
 
 @param status The current location authorization status
 @param error The error
 */
typedef void(^KSHRequestLocationAuthorizationCompletionBlock)(KSHLocationAuthorizationStatus status, NSError * _Nullable error);
#if (TARGET_OS_IOS || TARGET_OS_OSX || TARGET_OS_WATCH)
/**
 Enum defining the possible calendars authorization status values. See EKAuthorizationStatus for more information.
 */
typedef NS_ENUM(NSInteger, KSHCalendarsAuthorizationStatus) {
    /**
     See EKAuthorizationStatusNotDetermined for more information.
     */
    KSHCalendarsAuthorizationStatusNotDetermined = EKAuthorizationStatusNotDetermined,
    /**
     See EKAuthorizationStatusRestricted for more information.
     */
    KSHCalendarsAuthorizationStatusRestricted = EKAuthorizationStatusRestricted,
    /**
     See EKAuthorizationStatusDenied for more information.
     */
    KSHCalendarsAuthorizationStatusDenied = EKAuthorizationStatusDenied,
    /**
     See EKAuthorizationStatusAuthorized for more information.
     */
    KSHCalendarsAuthorizationStatusAuthorized = EKAuthorizationStatusAuthorized
};
/**
 Completion block that is invoked after requesting calendars access.
 
 @param status The current calendars authorization status
 @param error The error
 */
typedef void(^KSHRequestCalendarsAuthorizationCompletionBlock)(KSHCalendarsAuthorizationStatus status, NSError * _Nullable error);

/**
 Enum defining the possible reminders authorization status values. See EKAuthorizationStatus for more information.
 */
typedef NS_ENUM(NSInteger, KSHRemindersAuthorizationStatus) {
    /**
     See EKAuthorizationStatusNotDetermined for more information.
     */
    KSHRemindersAuthorizationStatusNotDetermined = EKAuthorizationStatusNotDetermined,
    /**
     See EKAuthorizationStatusRestricted for more information.
     */
    KSHRemindersAuthorizationStatusRestricted = EKAuthorizationStatusRestricted,
    /**
     See EKAuthorizationStatusDenied for more information.
     */
    KSHRemindersAuthorizationStatusDenied = EKAuthorizationStatusDenied,
    /**
     See EKAuthorizationStatusAuthorized for more information.
     */
    KSHRemindersAuthorizationStatusAuthorized = EKAuthorizationStatusAuthorized
};
/**
 Completion block that is invoked after requesting reminders access.
 
 @param status The current reminders authorization status
 @param error The error
 */
typedef void(^KSHRequestRemindersAuthorizationCompletionBlock)(KSHRemindersAuthorizationStatus status, NSError * _Nullable error);

/**
 Enum defining possible contacts authorization status values. See CNAuthorizationStatus for more information.
 */
typedef NS_ENUM(NSInteger, KSHContactsAuthorizationStatus) {
    /**
     See CNAuthorizationStatusNotDetermined for more information.
     */
    KSHContactsAuthorizationStatusNotDetermined = CNAuthorizationStatusNotDetermined,
    /**
     See CNAuthorizationStatusRestricted for more information.
     */
    KSHContactsAuthorizationStatusRestricted = CNAuthorizationStatusRestricted,
    /**
     See CNAuthorizationStatusDenied for more information.
     */
    KSHContactsAuthorizationStatusDenied = CNAuthorizationStatusDenied,
    /**
     See CNAuthorizationStatusAuthorized for more information.
     */
    KSHContactsAuthorizationStatusAuthorized = CNAuthorizationStatusAuthorized
};
/**
 Completion block that is invoked after requesting contacts access.
 
 @param status The current contacts authorization status
 @param error The error
 */
typedef void(^KSHRequestContactsAuthorizationCompletionBlock)(KSHContactsAuthorizationStatus status, NSError * _Nullable error);
#endif

/**
 KSHAuthorizationManager is an NSObject subclass that combines all the authorization methods into a consistent interface.
 */
@interface KSHAuthorizationManager : NSObject

/**
 Get the shared manager instance.
 */
@property (class,readonly,nonatomic) KSHAuthorizationManager *sharedManager;

#if (TARGET_OS_IPHONE)
#if (TARGET_OS_IOS || TARGET_OS_WATCH)
/**
 Get whether the user has authorized camera access.
 */
@property (readonly,nonatomic) BOOL hasCameraAuthorization;
/**
 Get the camera authorization status.
 
 @see KSHCameraAuthorizationStatus
 */
@property (readonly,nonatomic) KSHCameraAuthorizationStatus cameraAuthorizationStatus;

/**
 Get whether the user has authorized microphone access.
 */
@property (readonly,nonatomic) BOOL hasMicrophoneAuthorization;
/**
 Get the microphone authorization status.
 
 @see KSHMicrophoneAuthorizationStatus
 */
@property (readonly,nonatomic) KSHMicrophoneAuthorizationStatus microphoneAuthorizationStatus;
#endif

/**
 Get whether the user has authorized photo library access.
 */
@property (readonly,nonatomic) BOOL hasPhotoLibraryAuthorization;
/**
 Get the photo library authorization status.
 
 @see KSHPhotoLibraryAuthorizationStatus
 */
@property (readonly,nonatomic) KSHPhotoLibraryAuthorizationStatus photoLibraryAuthorizationStatus;
#if (TARGET_OS_IOS)
/**
 Get whether the user has authorized siri access.
 */
@property (readonly,nonatomic) BOOL hasSiriAuthorization;
/**
 Get the siri authorization status.
 
 @see KSHSiriAuthorizationStatus
 */
@property (readonly,nonatomic) KSHSiriAuthorizationStatus siriAuthorizationStatus;

/**
 Get whether the user has authorized speech recognition access.
 */
@property (readonly,nonatomic) BOOL hasSpeechRecognitionAuthorization;
/**
 Get the speech recognition authorization status.
 
 @see KSHSpeechRecognitionAuthorizationStatus
 */
@property (readonly,nonatomic) KSHSpeechRecognitionAuthorizationStatus speechRecognitionAuthorizationStatus;

/**
 Get whether the user has authorized bluetooth peripheral access.
 */
@property (readonly,nonatomic) BOOL hasBluetoothPeripheralAuthorization;
/**
 Get the bluetooth peripheral authorization status.
 
 @see KSHBluetoothPeripheralAuthorizationStatus
 */
@property (readonly,nonatomic) KSHBluetoothPeripheralAuthorizationStatus bluetoothPeripheralAuthorizationStatus;
#endif
#else
/**
 Get whether the user has authorized accessibility access.
 */
@property (readonly,nonatomic) BOOL hasAccessibilityAuthorization;
#endif

/**
 Get whether the user has authorized location access.
 */
@property (readonly,nonatomic) BOOL hasLocationAuthorization;
#if (TARGET_OS_IOS || TARGET_OS_OSX || TARGET_OS_WATCH)
/**
 Get whether the user has authorized location always access.
 */
@property (readonly,nonatomic) BOOL hasLocationAuthorizationAlways;
#endif
#if (TARGET_OS_IPHONE)
/**
 Get whether the user has authorized location when in use access.
 */
@property (readonly,nonatomic) BOOL hasLocationAuthorizationWhenInUse;
#endif
/**
 Get the location authorization status.
 
 @see KSHLocationAuthorizationStatus
 */
@property (readonly,nonatomic) KSHLocationAuthorizationStatus locationAuthorizationStatus;
#if (TARGET_OS_IOS || TARGET_OS_OSX || TARGET_OS_WATCH)
/**
 Get whether the user has authorized calendars access.
 */
@property (readonly,nonatomic) BOOL hasCalendarsAuthorization;
/**
 Get the calendars authorization status.
 
 @see KSHCalendarsAuthorizationStatus
 */
@property (readonly,nonatomic) KSHCalendarsAuthorizationStatus calendarsAuthorizationStatus;

/**
 Get whether the user has authorized reminders access.
 */
@property (readonly,nonatomic) BOOL hasRemindersAuthorization;
/**
 Get the reminders authorization status.
 
 @see KSHRemindersAuthorizationStatus
 */
@property (readonly,nonatomic) KSHRemindersAuthorizationStatus remindersAuthorizationStatus;

/**
 Get whether the user has authorized contacts access.
 */
@property (readonly,nonatomic) BOOL hasContactsAuthorization;
/**
 Get the contacts authorization status.
 
 @see KSHContactsAuthorizationStatus
 */
@property (readonly,nonatomic) KSHContactsAuthorizationStatus contactsAuthorizationStatus;
#endif

#if (TARGET_OS_IPHONE)
#if (TARGET_OS_IOS || TARGET_OS_WATCH)
/**
 Request camera authorization from the user and invoke the provided completion block when authorization status has been determined. The completion block is always invoked on the main thread. The client must provide a reason in their plist using NSCameraUsageDescription or an exception will be thrown.
 
 @param completion The completion block to invoke when authorization status has been determined
 */
- (void)requestCameraAuthorizationWithCompletion:(KSHRequestCameraAuthorizationCompletionBlock)completion;
/**
 Request microphone authorization from the user and invoke the provided completion block when authorization status has been determined. The completion block is always invoked on the main thread. The client must provide a reason in their plist using NSMicrophoneUsageDescription or an exception will be thrown.
 
 @param completion The completion block to invoke when authorization status has been determined
 */
- (void)requestMicrophoneAuthorizationWithCompletion:(KSHRequestMicrophoneAuthorizationCompletionBlock)completion;
#endif
/**
 Request photo library authorization from the user and invoke the provided completion block when authorization status has been determined. The completion block is always invoked on the main thread. The client must provide a reason in their plist using NSPhotoLibraryUsageDescription or an exception will be thrown.
 
 @param completion The completion block to invoke when authorization status has been determined
 */
- (void)requestPhotoLibraryAuthorizationWithCompletion:(KSHRequestPhotoLibraryAuthorizationCompletionBlock)completion;
#if (TARGET_OS_IOS || TARGET_OS_WATCH)
/**
 Returns the health share authorization status for the provided type.
 
 @param type The type for which to return health share authorization status
 @return The health share authorization status
 */
- (KSHHealthShareAuthorizationStatus)healthShareAuthorizationStatusForType:(HKObjectType *)type;
/**
 Request health share authorization to read for *readTypes* and to write for *writeTypes* and invoke the provided completion block when authorization has been determined. The completion block is always invoked on the main thread. The client must provide a reason in their plist using NSHealthShareUsageDescription if *readTypes* is non-null and NSHealthUpdateUsageDescription if *writeTypes* is non-null, otherwise an exception will be thrown.
 
 @param readTypes The types to read from
 @param writeTypes The types to write to
 @param completion The completion block to invoke when authorization status has been determined
 */
- (void)requestHealthShareAuthorizationToReadTypes:(nullable NSArray<HKObjectType *> *)readTypes writeTypes:(nullable NSArray<HKSampleType *> *)writeTypes completion:(KSHRequestHealthShareAuthorizationCompletionBlock)completion;
#endif
#if (TARGET_OS_IOS)
/**
 Requst siri authorization from the user and invoke the provided completion block when authorization status has been determined. The completion block is always invoked on the main thread. The client must provide a reason in their plist using NSSiriUsageDescription or an exception will be thrown.
 
 @param completion The completion block to invoke when authorization status has been determined
 */
- (void)requestSiriAuthorizationWithCompletion:(KSHRequestSiriAuthorizationCompletionBlock)completion;
/**
 Request speech recognition authorization from the user and invoke the provided completion block when authorization status has been determined. The completion block is always invoked on the main thread. The client must provide a reason in their plist using NSSpeechRecognitionUsageDescription or an exception will be thrown.
 
 @param completion The completion block to invoke when authorization status has been determined
 */
- (void)requestSpeechRecognitionAuthorizationWithCompletion:(KSHRequestSpeechRecognitionAuthorizationCompletionBlock)completion;
/**
 Request bluetooth peripheral authorization from the user and invoke the provided completion block when authorization status has been determined. The completion block is always invoked on the main thread. The client must provide a reason in their plist using NSBluetoothPeripheralUsageDescription and include the bluetooth-peripheral mode in the UIBackgroundModes array otherwise an exception will be thrown.
 
 @param completion The completion block to invoke when authorization status has been determined
 */
- (void)requestBluetoothPeripheralAuthorizationWithCompletion:(KSHRequestBluetoothPeripheralAuthorizationCompletionBlock)completion;
#endif
#else
/**
 Request accessibility authorization from the user and optionally display the system alert. If *openSystemPreferences* is YES and this method returns NO the Security & Privacy -> Privacy pane in System Preferences will be opened automatically.
 
 @param displaySystemAlert Whether to display the system accessibility alert
 @param openSystemPreferences Whether to open the appropriate system preferences pane if this method returns NO
 @return YES if the user has granted accessibility authorization, otherwise NO
 */
- (BOOL)requestAccessibilityAuthorizationDisplayingSystemAlert:(BOOL)displaySystemAlert openSystemPreferencesIfNecessary:(BOOL)openSystemPreferences;
#endif
/**
 Request location authorization from the user and invoke the provided completion block when authorization status has been determined. The client should pass KSHLocationAuthorizationStatusAuthorizedAlways or KSHLocationAuthorizationStatusAuthorizedWhenInUse for authorization. The completion block is always invoked on the main thread. The client must provide a reason in their plist using NSLocationWhenInUseUsageDescription or NSLocationAlwaysUsageDescription on iOS, NSLocationWhenInUseUsageDescription on tvOS or NSLocationUsageDescription on macOS, otherwise an exception will be thrown.
 
 @param authorization The location authorization to request
 @param completion The completion block to invoke when authorization status has been determined
 */
- (void)requestLocationAuthorization:(KSHLocationAuthorizationStatus)authorization completion:(KSHRequestLocationAuthorizationCompletionBlock)completion;
#if (TARGET_OS_IOS || TARGET_OS_OSX || TARGET_OS_WATCH)
/**
 Request calendars authorization from the user and invoke the provided completion block when authorization status has been determined. The completion block is always invoked on the main thread. The client must provide a reason in their plist using NSCalendarsUsageDescription or an exception will be thrown.
 
 @param completion The completion block to invoke when authorization status has been determined
 */
- (void)requestCalendarsAuthorizationWithCompletion:(KSHRequestCalendarsAuthorizationCompletionBlock)completion;
/**
 Request reminders authorization from the user and invoke the provided completion block when authorization status has been determined. The completion block is always invoked on the main thread. The client must provide a reason in their plist using NSRemindersUsageDescription or an exception will be thrown.
 
 @param completion The completion block to invoke when authorization status has been determined
 */
- (void)requestRemindersAuthorizationWithCompletion:(KSHRequestRemindersAuthorizationCompletionBlock)completion;
/**
 Request contacts authorization from the user and invoke the provided completion block when authorization status has been determined. The completion block is always invoked on the main thread. The client must provide a reason in their plist using NSContactsUsageDescription or an exception will be thrown.
 
 @param completion The completion block to invoke when authorization status has been determined
 */
- (void)requestContactsAuthorizationWithCompletion:(KSHRequestContactsAuthorizationCompletionBlock)completion;
#endif

@end

NS_ASSUME_NONNULL_END
