//
//  NGWLocationRetriever.m
//  ios-workshops
//
//  Created by Patryk Kaczmarek on 12/11/15.
//  Copyright © 2015 Netguru. All rights reserved.
//

#import <CoreLocation/CoreLocation.h>

#import "NGWLocationRetriever.h"

@interface NGWLocationRetriever () <CLLocationManagerDelegate>

@property (copy, nonatomic, nullable) void (^completion)(CLLocation *, NSError *);

@end

@implementation NGWLocationRetriever

- (instancetype)init {
    self = [super init];
    if (self) {
        _locationManager = [[CLLocationManager alloc] init];
        _locationManager.desiredAccuracy = kCLLocationAccuracyNearestTenMeters;
        _locationManager.distanceFilter = 100;
        _locationManager.delegate = self;
    }
    return self;
}

#pragma mark - Geocoding

- (void)obtainUserLocationWithCompletion:(void (^)(CLLocation * _Nullable, NSError * _Nullable))completion {
    
    self.completion = completion;
    
    if (completion != NULL) {
        [self.locationManager requestWhenInUseAuthorization];
        if ([CLLocationManager authorizationStatus] == kCLAuthorizationStatusDenied) {
            completion(nil, [self deniedAuthorizationStatusError]);
            return;
        }
        [self.locationManager startUpdatingLocation];
    }
}

- (nonnull NSError *)deniedAuthorizationStatusError {
    NSError *error = [[NSError alloc] initWithDomain:NSLocalizedString(@"ios-workshops_error_domain",nil)
                                                code:-666
                                            userInfo:@{@"localizedDescription" : NSLocalizedString(@"denied_localization_service", nil)}];
    return error;
}

#pragma mark - CLLocationManagerDelegate

- (void)locationManager:(CLLocationManager *)manager didFailWithError:(NSError *)error {
    if (self.completion) {
        self.completion(nil, error);
    }
}

- (void)locationManager:(CLLocationManager *)manager didUpdateLocations:(NSArray *)locations {
    
    if (self.completion) {
        self.completion(locations.lastObject, nil);
    }

    [self.locationManager stopUpdatingLocation];
}

- (void)locationManager:(CLLocationManager *)manager didChangeAuthorizationStatus:(CLAuthorizationStatus)status {
    if (status == kCLAuthorizationStatusAuthorizedWhenInUse) {
        [self.locationManager startUpdatingLocation];
    }
}

@end
