//
//  UserReminderCell.m
//  SocialReminder
//
//  Created by Evgeny Kubrakov on 21/11/15.
//  Copyright © 2015 Streetmage. All rights reserved.
//

#import "UserReminderCell.h"


@interface UserReminderCell ()

@property (nonatomic, strong) UILabel *countdownLabel;
@property (nonatomic, strong) UILabel *fireDateLabel;

@property (nonatomic, assign) NSUInteger countdown;
@property (nonatomic, strong) NSTimer *timer;

@end

@implementation UserReminderCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    
    if (self) {
        
        _countdownLabel = [[UILabel alloc] init];
        [self addSubview:_countdownLabel];
        
        _fireDateLabel = [[UILabel alloc] init];
        [self addSubview:_fireDateLabel];
        
    }
    
    return self;
}

- (void)layoutSubviews {
    [super layoutSubviews];
    [_countdownLabel setFrame:self.bounds];
}

- (void)prepareForReuse {
    [self.timer invalidate];
}

- (void)setupWithReminder:(id <Reminder>)reminder {
    reminder.fireDate = [NSDate dateWithTimeIntervalSinceNow:arc4random() % 500];
    NSInteger timeInterval = [reminder.fireDate timeIntervalSinceNow];
    if (timeInterval > 0) {
        self.countdown = timeInterval;
        [self onTick];
        self.timer = [NSTimer scheduledTimerWithTimeInterval:1.0
                                                      target:self
                                                    selector:@selector(onTick)
                                                    userInfo:nil
                                                     repeats:YES];
    }
}

- (void)onTick {
    self.countdown -- ;
    NSUInteger days = self.countdown / 86400;
    NSUInteger hours = self.countdown / 3600;
    NSUInteger minutes = (self.countdown % 3600) / 60;
    NSUInteger seconds = (self.countdown % 3600) % 60;
    _countdownLabel.text = [NSString  stringWithFormat:@"%ld : %ld : %ld : %ld", days, hours, minutes, seconds];
}

@end
