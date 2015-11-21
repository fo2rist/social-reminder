//
//  NotificationsManager.m
//  SocialReminder
//
//  Created by Evgeny Kubrakov on 21/11/15.
//  Copyright © 2015 Streetmage. All rights reserved.
//

#import "NotificationsManager.h"
#import "AppService.h"
#import "Reminder.h"

@implementation NotificationsManager

#pragma mark - Singleton Methods

+ (instancetype)sharedManager {
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
    [request setPredicate:[NSPredicate predicateWithFormat:@"%@ < fireDateSecondsSince1970", @([[NSDate date] timeIntervalSince1970])]];
    NSManagedObjectContext *managedObjectContext = [AppService sharedService].objectManager.managedObjectStore.mainQueueManagedObjectContext;
    [managedObjectContext performBlockAndWait:^{
        NSError *error = nil;
        NSArray *reminders = [managedObjectContext executeFetchRequest:request error:&error];
        for (id <Reminder> reminder in reminders) {
            UILocalNotification* alarm = [[UILocalNotification alloc] init];
            if (alarm)
            {
                alarm.fireDate = [reminder fireDate];
                alarm.timeZone = [NSTimeZone defaultTimeZone];
                alarm.repeatInterval = 0;
                alarm.soundName = @"alarmsound.caf";
                alarm.alertBody = @"Time to wake up!";
                
                [[UIApplication sharedApplication] scheduleLocalNotification:alarm];
            }
        }
    }];
}

@end
