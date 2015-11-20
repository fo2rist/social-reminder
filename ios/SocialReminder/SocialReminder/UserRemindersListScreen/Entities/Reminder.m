//
//  Reminder.m
//  SocialReminder
//
//  Created by Evgeny Kubrakov on 20/11/15.
//  Copyright © 2015 Streetmage. All rights reserved.
//

#import "Reminder.h"

@implementation Reminder

+ (RKObjectMapping *)objectMapping {
    RKObjectMapping *mapping = [RKObjectMapping mappingForClass:[self class]];
    [mapping addAttributeMappingsFromDictionary:@{@"id" : @"reminderId",
                                                  @"name" : @"title",
                                                  @"datetime" : @"fireDate"}];
    return mapping;
}

@end
