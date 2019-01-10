//
//  ViewController.m
//  ShieldDemo-tvOS
//
//  Created by William Towe on 3/16/17.
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

#import "ViewController.h"

#import <Shield/Shield.h>

typedef NS_ENUM(NSInteger, AuthorizationType) {
    AuthorizationTypePhotoLibrary,
    AuthorizationTypeLocation,
    AuthorizationTypeNotification,
    AuthorizationTypeVideoSubscriberAccount
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
                                  @(AuthorizationTypeNotification),
                                  @(AuthorizationTypeVideoSubscriberAccount)]];
    [self setAuthorizationTitles:@[@"Photos",
                                   @"Location",
                                   @"Notification",
                                   @"Video Subscriber Account"]];
    
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
            [KSHPhotosAuthorization.sharedAuthorization requestPhotoLibraryAuthorizationWithCompletion:^(KSHPhotosAuthorizationStatus status, NSError * _Nullable error) {
                NSLog(@"%@ %@",@(status),error);
            }];
        }
            break;
        case AuthorizationTypeLocation: {
            [KSHLocationAuthorization.sharedAuthorization requestLocationAuthorization:KSHLocationAuthorizationStatusAuthorizedWhenInUse completion:^(KSHLocationAuthorizationStatus status, NSError * _Nullable error) {
                NSLog(@"%@ %@",@(status),error);
            }];
        }
            break;
        case AuthorizationTypeNotification: {
            [KSHNotificationAuthorization.sharedAuthorization requestNotificationAuthorizationForOptions:KSHNotificationAuthorizationOptionsBadge completion:^(KSHNotificationAuthorizationStatus status, NSError * _Nullable error) {
                NSLog(@"%@ %@",@(status),error);
            }];
        }
            break;
        case AuthorizationTypeVideoSubscriberAccount: {
            [KSHVideoSubscriberAccountAuthorization.sharedAuthorization requestVideoSubscriberAccountAuthorizationWithCompletion:^(KSHVideoSubscriberAccountAuthorizationStatus status, NSError * _Nullable error) {
                NSLog(@"%@ %@",@(status),error);
            }];
        }
            break;
        default:
            break;
    }
}

@end
