//
//  UserReminderCell.h
//  SocialReminder
//
//  Created by Evgeny Kubrakov on 21/11/15.
//  Copyright © 2015 Streetmage. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "Reminder.h"

typedef void(^FiredEventHandler)(void);

@interface UserReminderCell : UITableViewCell

@property (nonatomic, strong) UIView *holderView;
@property (nonatomic, strong) UIImageView *locationImageView;

@property (nonatomic, strong) UIView *countdownHolder;
@property (nonatomic, strong) UILabel *countdownLabel;
@property (nonatomic, strong) UILabel *fireDateLabel;
@property (nonatomic, strong) UILabel *titleLabel;

@property (nonatomic, assign) NSUInteger countdown;
@property (nonatomic, strong) NSTimer *timer;

@property (nonatomic, strong) FiredEventHandler firedEventHandler;

- (void)setupWithReminder:(id <Reminder>)reminder;

+ (CGFloat)cellHeight;

@end
