//
//  KSHBluetoothAuthorization.h
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
#import <CoreBluetooth/CBPeripheralManager.h>

NS_ASSUME_NONNULL_BEGIN

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

/**
 KSHBluetoothAuthorization wraps the APIs needed to request bluetooh peripheral access from the user.
 */
@interface KSHBluetoothAuthorization : NSObject

/**
 Get the shared bluetooth authorization object.
 */
@property (class,readonly,nonatomic) KSHBluetoothAuthorization *sharedAuthorization;

/**
 Get whether the user has authorized bluetooth peripheral access.
 */
@property (readonly,nonatomic) BOOL hasBluetoothPeripheralAuthorization;
/**
 Get the bluetooth peripheral authorization status.
 
 @see KSHBluetoothPeripheralAuthorizationStatus
 */
@property (readonly,nonatomic) KSHBluetoothPeripheralAuthorizationStatus bluetoothPeripheralAuthorizationStatus;

/**
 Request bluetooth peripheral authorization from the user and invoke the provided completion block when authorization status has been determined. The completion block is always invoked on the main thread. The client must provide a reason in their plist using NSBluetoothPeripheralUsageDescription and include the bluetooth-peripheral mode in the UIBackgroundModes array otherwise an exception will be thrown.
 
 @param completion The completion block to invoke when authorization status has been determined
 */
- (void)requestBluetoothPeripheralAuthorizationWithCompletion:(KSHRequestBluetoothPeripheralAuthorizationCompletionBlock)completion;

@end

NS_ASSUME_NONNULL_END
