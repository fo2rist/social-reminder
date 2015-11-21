//
//  ForeignReminderCell.h
//  SocialReminder
//
//  Created by Evgeny Kubrakov on 21/11/15.
//  Copyright © 2015 Streetmage. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "UserReminderCell.h"

@class ForeignReminderCell;

typedef void(^SubscribeButtonHandler)(ForeignReminderCell *cell);

@interface ForeignReminderCell : UserReminderCell

@property (nonatomic, strong) SubscribeButtonHandler subscribeButtonHandler;

@end
