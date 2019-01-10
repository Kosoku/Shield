//
//  KSHContactsAuthorization.m
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

#import "KSHContactsAuthorization.h"

#import <Stanley/KSTFunctions.h>

#import <Contacts/Contacts.h>

@implementation KSHContactsAuthorization

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

+ (KSHContactsAuthorization *)sharedAuthorization {
    static KSHContactsAuthorization *kRetval;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        kRetval = [[KSHContactsAuthorization alloc] init];
    });
    return kRetval;
}

- (BOOL)hasContactsAuthorization {
    return self.contactsAuthorizationStatus == KSHContactsAuthorizationStatusAuthorized;
}
- (KSHContactsAuthorizationStatus)contactsAuthorizationStatus {
    return (KSHContactsAuthorizationStatus)[CNContactStore authorizationStatusForEntityType:CNEntityTypeContacts];
}

@end
