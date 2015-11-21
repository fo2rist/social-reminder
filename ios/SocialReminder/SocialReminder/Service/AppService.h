//
//  AppService.h
//  VenuesViewer
//
//  Created by Admin on 25.08.15.
//  Copyright (c) 2015 Admin. All rights reserved.
//

#import <Foundation/Foundation.h>

@class RKObjectManager;

typedef NS_ENUM(NSUInteger, ReminderFilter) {
    ReminderFilterNone = 1 << 0,
    ReminderFilterGeo = 1 << 1,
    ReminderFilterFriends = 1 << 2
};

typedef void(^ServiceCompletionHandler)(BOOL success, id parsedData, NSString *responseString, NSError *error);

@interface AppService : NSObject

@property (nonatomic, strong) RKObjectManager *objectManager;

+ (instancetype)sharedService;

- (void)createUserWithPhoneNumber:(NSString *)phoneNumber completion:(ServiceCompletionHandler)completion;

- (void)saveReminderWithTitle:(NSString *)title
                     fireDate:(NSDate *)fireDate
                   completion:(ServiceCompletionHandler)completion;

- (void)userRemindersWithCompletion:(ServiceCompletionHandler)completion;
- (void)allRemindersWithFilter:(ReminderFilter)filter completion:(ServiceCompletionHandler)completion;

@end
