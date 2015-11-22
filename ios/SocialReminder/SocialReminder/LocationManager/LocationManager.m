//
//  LocationManager.m
//  SocialReminder
//
//  Created by Evgeny Kubrakov on 22/11/15.
//  Copyright © 2015 Streetmage. All rights reserved.
//

#import "LocationManager.h"

@interface LocationManager () <CLLocationManagerDelegate>

@property (nonatomic, strong) CLLocationManager *locationManager;

@end

@implementation LocationManager

- (instancetype)init {
    self = [super init];
    
    if (self) {
        _locationManager = [[CLLocationManager alloc] init];
        _locationManager.delegate = self;
        _locationManager.distanceFilter = kCLDistanceFilterNone;
        _locationManager.desiredAccuracy = kCLLocationAccuracyBest;
    }
    
    return self;
}

#pragma mark - Accessors

- (CLLocationCoordinate2D)currentCoordinate {
    return _locationManager.location.coordinate;
}

- (void)startLocationChangeEventsPropagation {
    if ([self.locationManager respondsToSelector:@selector(requestWhenInUseAuthorization)]) {
        [self.locationManager requestWhenInUseAuthorization];
    }
    [_locationManager startUpdatingLocation];
}

- (void)stopLocationChangeEventsPropagation {
    [_locationManager stopUpdatingLocation];
}

#pragma mark - CLLocationManagerDelegate

- (void)locationManager:(CLLocationManager *)manager
     didUpdateLocations:(NSArray *)locations {
    if (self.handler) {
        self.handler(_locationManager.location.coordinate);
    }
}

- (void)locationManager:(CLLocationManager *)manager didFailWithError:(NSError *)error {
    [self stopLocationChangeEventsPropagation];
}

- (void)locationManager:(CLLocationManager *)manager didChangeAuthorizationStatus:(CLAuthorizationStatus)status {
    if (status == kCLAuthorizationStatusAuthorizedWhenInUse) {
        [self startLocationChangeEventsPropagation];
    }
}

@end
