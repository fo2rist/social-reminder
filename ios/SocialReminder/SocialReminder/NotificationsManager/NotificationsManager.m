//
//  NotificationsManager.m
//  SocialReminder
//
//  Created by Evgeny Kubrakov on 21/11/15.
//  Copyright © 2015 Streetmage. All rights reserved.
//

#import "NotificationsManager.h"
#import "AppService.h"

@implementation NotificationsManager

#pragma mark - Singleton Methods

+ (instancetype)sharedService {
    static NotificationsManager *manager = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        manager = [[NotificationsManager alloc] init];
    });
    return manager;
}

- (void)reloadLocalNotifications {
    [[UIApplication sharedApplication] cancelAllLocalNotifications];
    NSFetchRequest *request = [NSFetchRequest fetchRequestWithEntityName:@"DBReminder"];
}

@end
