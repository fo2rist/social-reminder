//
//  Reminder.m
//  SocialReminder
//
//  Created by Evgeny Kubrakov on 20/11/15.
//  Copyright © 2015 Streetmage. All rights reserved.
//

#import "Reminder.h"

@implementation RuntimeReminder

+ (RKObjectMapping *)objectMapping {
    RKObjectMapping *mapping = [RKObjectMapping mappingForClass:[self class]];
    [mapping addAttributeMappingsFromDictionary:@{@"id" : @"reminderId",
                                                  @"name" : @"title",
                                                  @"datetime" : @"fireDateSecondsSince1970",
                                                  @"subscribed" : @"subscribed"}];
    return mapping;
}

- (BOOL)isSubscribed {
    return [self.subscribed boolValue];
}

- (NSDate *)fireDate {
    return [NSDate dateWithTimeIntervalSince1970:[self.fireDateSecondsSince1970 unsignedIntegerValue]];
}

@end


@implementation DBReminder

@dynamic reminderId;
@dynamic title;
@dynamic fireDateSecondsSince1970;
@dynamic subscribed;
@dynamic latitude;
@dynamic longitude;

+ (RKEntityMapping *)entityMappingWithManagedObjectStore:(RKManagedObjectStore *)store {
    RKEntityMapping *mapping = [RKEntityMapping mappingForEntityForName:NSStringFromClass([self class])
                                                   inManagedObjectStore:store];
    [mapping setIdentificationAttributes:@[@"reminderId"]];
    [mapping addAttributeMappingsFromDictionary:@{@"id" : @"reminderId",
                                                  @"name" : @"title",
                                                  @"datetime" : @"fireDateSecondsSince1970",
                                                  @"subscribed" : @"subscribed",
                                                  @"lat" : @"latitude",
                                                  @"lon" : @"logitude"}];
    return mapping;
}

- (BOOL)isSubscribed {
    return [self.subscribed boolValue];
}

- (NSDate *)fireDate {
    return [NSDate dateWithTimeIntervalSince1970:[self.fireDateSecondsSince1970 unsignedIntegerValue]];
}


@end