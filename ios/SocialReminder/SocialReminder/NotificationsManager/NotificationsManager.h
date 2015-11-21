//
//  NotificationsManager.h
//  SocialReminder
//
//  Created by Evgeny Kubrakov on 21/11/15.
//  Copyright © 2015 Streetmage. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NotificationsManager : NSObject

+ (instancetype)sharedManager;

- (void)reloadLocalNotifications;

@end
