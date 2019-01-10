//
//  KSHBluetoothAuthorization.m
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

#import "KSHBluetoothAuthorization.h"

#import <Stanley/KSTFunctions.h>

#import <CoreBluetooth/CoreBluetooth.h>

@interface KSHBluetoothAuthorization () <CBPeripheralManagerDelegate>
@property (strong,nonatomic) CBPeripheralManager *peripheralManager;
@property (copy,nonatomic) KSHRequestBluetoothPeripheralAuthorizationCompletionBlock requestBluetoothPeripheralAuthorizationCompletionBlock;
@end

@implementation KSHBluetoothAuthorization

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

- (void)requestBluetoothPeripheralAuthorizationWithCompletion:(KSHRequestBluetoothPeripheralAuthorizationCompletionBlock)completion {
    NSParameterAssert(completion != nil);
    NSParameterAssert([NSBundle mainBundle].infoDictionary[@"NSBluetoothPeripheralUsageDescription"] != nil);
    NSParameterAssert([[NSBundle mainBundle].infoDictionary[@"UIBackgroundModes"] containsObject:@"bluetooth-peripheral"] || [[NSBundle mainBundle].infoDictionary[@"UIBackgroundModes"] containsObject:@"bluetooth-central"]);
    
    if (self.hasBluetoothPeripheralAuthorization) {
        KSTDispatchMainAsync(^{
            completion(KSHBluetoothPeripheralAuthorizationStatusAuthorized,nil);
        });
        return;
    }
    
    [self setRequestBluetoothPeripheralAuthorizationCompletionBlock:completion];
    [self setPeripheralManager:[[CBPeripheralManager alloc] initWithDelegate:self queue:nil]];
}

+ (KSHBluetoothAuthorization *)sharedAuthorization {
    static KSHBluetoothAuthorization *kRetval;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        kRetval = [[KSHBluetoothAuthorization alloc] init];
    });
    return kRetval;
}

- (BOOL)hasBluetoothPeripheralAuthorization {
    return self.bluetoothPeripheralAuthorizationStatus == KSHBluetoothPeripheralAuthorizationStatusAuthorized;
}
- (KSHBluetoothPeripheralAuthorizationStatus)bluetoothPeripheralAuthorizationStatus {
    return (KSHBluetoothPeripheralAuthorizationStatus)[CBPeripheralManager authorizationStatus];
}

@end
