//
//  KSHAccountsAuthorization.m
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

#import "KSHAccountsAuthorization.h"

#import <Stanley/KSTFunctions.h>

#import <Accounts/Accounts.h>

@interface KSHAccountsAuthorization ()
- (NSString *)_accountIdentifierForType:(KSHAccountsType)type;
@end

@implementation KSHAccountsAuthorization

- (void)requestAccountsAuthorizationForType:(KSHAccountsType)type options:(NSDictionary<NSString *,id> *)options completion:(KSHRequestAccountsAuthorizationCompletionBlock)completion {
    ACAccountStore *store = [[ACAccountStore alloc] init];
    ACAccountType *accountType = [store accountTypeWithAccountTypeIdentifier:[self _accountIdentifierForType:type]];
    
    [store requestAccessToAccountsWithType:accountType options:options completion:^(BOOL granted, NSError *error) {
        KSTDispatchMainAsync(^{
            completion(granted,error);
        });
    }];
}

+ (KSHAccountsAuthorization *)sharedAuthorization {
    static KSHAccountsAuthorization *kRetval;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        kRetval = [[KSHAccountsAuthorization alloc] init];
    });
    return kRetval;
}

- (NSString *)_accountIdentifierForType:(KSHAccountsType)type; {
    switch (type) {
        case KSHAccountsTypeTwitter:
            return ACAccountTypeIdentifierTwitter;
        case KSHAccountsTypeFacebook:
            return ACAccountTypeIdentifierFacebook;
        case KSHAccountsTypeSinaWeibo:
            return ACAccountTypeIdentifierSinaWeibo;
        case KSHAccountsTypeTencentWeibo:
            return ACAccountTypeIdentifierTencentWeibo;
#if (TARGET_OS_OSX)
        case KSHAccountsTypeLinkedIn:
            return ACAccountTypeIdentifierLinkedIn;
#endif
        default:
            return nil;
    }
}

@end
