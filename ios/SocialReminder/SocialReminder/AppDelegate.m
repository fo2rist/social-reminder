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

@interface AppDelegate ()

@end

@implementation AppDelegate

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    
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
    
    self.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    [self.window setRootViewController:self.rootNavigationController];
    [self.window makeKeyAndVisible];
    
    return YES;
}

@end
