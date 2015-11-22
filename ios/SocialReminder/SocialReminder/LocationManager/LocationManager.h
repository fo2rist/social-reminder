//
//  LocationManager.h
//  SocialReminder
//
//  Created by Evgeny Kubrakov on 22/11/15.
//  Copyright © 2015 Streetmage. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreLocation/CoreLocation.h>

typedef void(^LocationManagerHandler)(CLLocationCoordinate2D coordinate);

@interface LocationManager : NSObject

@property (nonatomic, readonly) CLLocationCoordinate2D currentLocation;
@property (nonatomic, strong) LocationManagerHandler handler;

@end
