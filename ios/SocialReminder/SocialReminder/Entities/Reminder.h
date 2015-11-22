//
//  Reminder.h
//  SocialReminder
//
//  Created by Evgeny Kubrakov on 20/11/15.
//  Copyright © 2015 Streetmage. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol Reminder <NSObject>

@property (nonatomic, strong) NSString *reminderId;
@property (nonatomic, strong) NSString *title;
@property (nonatomic, strong) NSNumber *fireDateSecondsSince1970;
@property (nonatomic, strong) NSNumber *subscribed;
@property (nonatomic, strong) NSNumber *latitude;
@property (nonatomic, strong) NSNumber *longitude;

- (BOOL)isSubscribed;
- (NSDate *)fireDate;

@end

@interface RuntimeReminder : NSObject <Reminder>

@property (nonatomic, strong) NSString *reminderId;
@property (nonatomic, strong) NSString *title;
@property (nonatomic, strong) NSNumber *fireDateSecondsSince1970;
@property (nonatomic, strong) NSNumber *subscribed;
@property (nonatomic, strong) NSNumber *latitude;
@property (nonatomic, strong) NSNumber *longitude;

+ (RKObjectMapping *)objectMapping;

@end

@interface DBReminder : NSManagedObject <Reminder>

@property (nonatomic, strong) NSString *reminderId;
@property (nonatomic, strong) NSString *title;
@property (nonatomic, strong) NSNumber *fireDateSecondsSince1970;
@property (nonatomic, strong) NSNumber *subscribed;
@property (nonatomic, strong) NSNumber *latitude;
@property (nonatomic, strong) NSNumber *longitude;

+ (RKEntityMapping *)entityMappingWithManagedObjectStore:(RKManagedObjectStore *)store;

@end
