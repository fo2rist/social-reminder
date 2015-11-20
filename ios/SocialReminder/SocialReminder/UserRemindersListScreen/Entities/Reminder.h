//
//  Reminder.h
//  SocialReminder
//
//  Created by Evgeny Kubrakov on 20/11/15.
//  Copyright © 2015 Streetmage. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Reminder : NSObject

@property (nonatomic, strong) NSString *reminderId;
@property (nonatomic, strong) NSString *title;
@property (nonatomic, strong) NSDate *fireDate;

+ (RKObjectMapping *)objectMapping;

@end
