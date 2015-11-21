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
@property (nonatomic, strong) NSDate *fireDate;
@property (nonatomic, strong) NSNumber *subscribed;

- (BOOL)isSubscribed;

@end

@interface RuntimeReminder : NSObject <Reminder>

@property (nonatomic, strong) NSString *reminderId;
@property (nonatomic, strong) NSString *title;
@property (nonatomic, strong) NSDate *fireDate;
@property (nonatomic, strong) NSNumber *subscribed;

+ (RKObjectMapping *)objectMapping;

@end

@interface DBReminder : NSManagedObject <Reminder>

@property (nonatomic, strong) NSString *reminderId;
@property (nonatomic, strong) NSString *title;
@property (nonatomic, strong) NSDate *fireDate;
@property (nonatomic, strong) NSNumber *subscribed;

+ (RKEntityMapping *)entityMappingWithManagedObjectStore:(RKManagedObjectStore *)store;

@end
