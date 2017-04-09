//
//  KSHBluetoothAuthorization.m
//  Shield
//
//  Created by William Towe on 4/8/17.
//  Copyright © 2017 Kosoku Interactive, LLC. All rights reserved.
//
//  Redistribution and use in source and binary forms, with or without modification, are permitted provided that the following conditions are met:
//
//  1. Redistributions of source code must retain the above copyright notice, this list of conditions and the following disclaimer.
//
//  2. Redistributions in binary form must reproduce the above copyright notice, this list of conditions and the following disclaimer in the documentation and/or other materials provided with the distribution.
//
//  THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS "AS IS" AND ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED TO, THE IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE ARE DISCLAIMED. IN NO EVENT SHALL THE COPYRIGHT HOLDER OR CONTRIBUTORS BE LIABLE FOR ANY DIRECT, INDIRECT, INCIDENTAL, SPECIAL, EXEMPLARY, OR CONSEQUENTIAL DAMAGES (INCLUDING, BUT NOT LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS OR SERVICES; LOSS OF USE, DATA, OR PROFITS; OR BUSINESS INTERRUPTION) HOWEVER CAUSED AND ON ANY THEORY OF LIABILITY, WHETHER IN CONTRACT, STRICT LIABILITY, OR TORT (INCLUDING NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY OUT OF THE USE OF THIS SOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.

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
