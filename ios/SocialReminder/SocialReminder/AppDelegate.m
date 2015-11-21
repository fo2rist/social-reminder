//
//  AppDelegate.m
//  SocialReminder
//
//  Created by Evgeny Kubrakov on 20/11/15.
//  Copyright © 2015 Streetmage. All rights reserved.
//

#import "AppDelegate.h"
#import "LoginController.h"
#import "UserRemindersListController.h"
#import "NotificationsManager.h"

@interface AppDelegate ()

@end

@implementation AppDelegate

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    
    UIUserNotificationType types = UIUserNotificationTypeBadge | UIUserNotificationTypeSound | UIUserNotificationTypeAlert;
    
    UIUserNotificationSettings *mySettings =
    [UIUserNotificationSettings settingsForTypes:types categories:nil];
    
    [[UIApplication sharedApplication] registerUserNotificationSettings:mySettings];
    
    UIViewController *rootController = nil;
    if ([[NSUserDefaults standardUserDefaults] objectForKey:UIDDefaultsKey]) {
        rootController = [[UserRemindersListController alloc] init];
    }
    else {
        rootController = [[LoginController alloc] init];
    }
    
    self.rootNavigationController = [[UINavigationController alloc] initWithRootViewController:rootController];
    [self.rootNavigationController.view setBackgroundColor:[UIColor whiteColor]];
    [self.rootNavigationController.navigationBar setTranslucent:NO];
     self.rootNavigationController.navigationBar.barTintColor = DEFAULT_COLOR;
    [self.rootNavigationController.navigationBar
     setTitleTextAttributes:@{NSForegroundColorAttributeName : [UIColor whiteColor]}];
    
    self.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    [self.window setRootViewController:self.rootNavigationController];
    [self.window makeKeyAndVisible];
    
    [[NotificationsManager sharedManager] reloadLocalNotifications];
    [self setupAppearence];
    
    return YES;
}

- (void)setupAppearence {
    [[UITextField appearance] setTintColor:DEFAULT_COLOR_DARK];
    [[UINavigationBar appearance] setTintColor:[UIColor whiteColor]];
}

- (void)application:(UIApplication *)application didReceiveLocalNotification:(UILocalNotification *)notification {
    NSDictionary *userInfo = notification.userInfo;
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"Notification"
                                                                   message:userInfo[@"title"]
                                                            preferredStyle:UIAlertControllerStyleAlert];
    [alert addAction:[UIAlertAction actionWithTitle:@"OK"
                                               style:UIAlertActionStyleDefault
                                            handler:^(UIAlertAction *action) {
                                                [alert dismissViewControllerAnimated:YES completion:nil];
    }]];
    [[self.rootNavigationController topViewController] presentViewController:alert
                                                                    animated:YES
                                                                  completion:nil];
}

@end
