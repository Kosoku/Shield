//
//  KSHSpeechAuthorization.m
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

#import "KSHSpeechAuthorization.h"

#import <Stanley/KSTFunctions.h>

#import <Speech/Speech.h>

@implementation KSHSpeechAuthorization

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

+ (KSHSpeechAuthorization *)sharedAuthorization {
    static KSHSpeechAuthorization *kRetval;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        kRetval = [[KSHSpeechAuthorization alloc] init];
    });
    return kRetval;
}

- (BOOL)hasSpeechRecognitionAuthorization {
    return self.speechRecognitionAuthorizationStatus == KSHSpeechRecognitionAuthorizationStatusAuthorized;
}
- (KSHSpeechRecognitionAuthorizationStatus)speechRecognitionAuthorizationStatus {
    return (KSHSpeechRecognitionAuthorizationStatus)[SFSpeechRecognizer authorizationStatus];
}

@end
