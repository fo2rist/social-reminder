//
//  UserReminderCell.m
//  SocialReminder
//
//  Created by Evgeny Kubrakov on 21/11/15.
//  Copyright © 2015 Streetmage. All rights reserved.
//

#import "UserReminderCell.h"

static NSDateFormatter *dateFormatter;

@interface UserReminderCell ()

@end

@implementation UserReminderCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    
    if (self) {
        
        if (!dateFormatter) {
            dateFormatter = [[NSDateFormatter alloc] init];
            [dateFormatter setDateFormat:@"yyyy:MM:dd hh:mm"];
        }
        
        [self setSelectionStyle:UITableViewCellSelectionStyleNone];
        
        _holderView = [[UIView alloc] init];
        [self addSubview:_holderView];
        
        _locationImageView = [[UIImageView alloc] init];
        [_locationImageView setBackgroundColor:DEFAULT_COLOR];
        [_holderView addSubview:_locationImageView];
        
        _locationImageView.layer.shadowColor = [UIColor blackColor].CGColor;
        _locationImageView.layer.shadowOffset = CGSizeMake(2, 2);
        _locationImageView.layer.shadowOpacity = 1;
        _locationImageView.layer.shadowRadius = 1.0;
        
        _titleLabel = [[UILabel alloc] init];
        [_titleLabel setNumberOfLines:3];
        [_titleLabel setFont:[UIFont systemFontOfSize:30.0f]];
        [_titleLabel setTextColor:[UIColor whiteColor]];
        [_locationImageView addSubview:_titleLabel];
        
        _countdownHolder = [[UIView alloc] init];
        [_holderView addSubview:_countdownHolder];
        
        _countdownLabel = [[UILabel alloc] init];
        [_countdownLabel setTextColor:DEFAULT_TEXT_COLOR];
        [_countdownLabel setFont:[UIFont systemFontOfSize:30.0f]];
        [_countdownHolder addSubview:_countdownLabel];
        
        _fireDateLabel = [[UILabel alloc] init];
        [_fireDateLabel setTextColor:DEFAULT_COLOR_DARK];
        [_fireDateLabel setTextAlignment:NSTextAlignmentRight];
        [_countdownHolder addSubview:_fireDateLabel];
        
    }
    
    return self;
}

- (void)layoutSubviews {
    [super layoutSubviews];
    
    [_holderView setFrame:UIEdgeInsetsInsetRect(self.bounds, UIEdgeInsetsMake(5.0f, 15.0f, 5.0f, 5.0f))];
    
    [_locationImageView setFrame:CGRectMake(0.0f, 5.0f, _holderView.frame.size.width - 5.0f, 120.0f)];
    
    [_titleLabel setFrame:UIEdgeInsetsInsetRect(_locationImageView.bounds, UIEdgeInsetsMake(80.0f, 5.0f, 5.0f, 5.0f))];
    
    [_countdownHolder setFrame:CGRectMake(0.0f, CGRectGetMaxY(_locationImageView.frame), _holderView.frame.size.width - 5.0f, 60.0f)];
    
    [_countdownLabel setFrame:UIEdgeInsetsInsetRect(_countdownHolder.bounds, UIEdgeInsetsMake(5.0f, 5.0f, 20.0f, 5.0f))];
    
    [_fireDateLabel setFrame:CGRectMake(0.0f, CGRectGetMaxY(_countdownLabel.frame), _countdownHolder.frame.size.width - 5.0f, 20.0f)];
    
}

- (void)prepareForReuse {
    [self.timer invalidate];
}

- (void)setupWithReminder:(id <Reminder>)reminder {
    NSDate *fireDate = [reminder fireDate];
    NSInteger timeInterval = [fireDate timeIntervalSinceNow];
    if (timeInterval > 0) {
        self.countdown = timeInterval;
        [self onTick];
        self.timer = [NSTimer scheduledTimerWithTimeInterval:1.0
                                                      target:self
                                                    selector:@selector(onTick)
                                                    userInfo:nil
                                                     repeats:YES];
    }
    [_titleLabel setText:[reminder title]];
    [_fireDateLabel setText:[dateFormatter stringFromDate:fireDate]];
}

- (void)onTick {
    self.countdown--;
    if (self.countdown >= 0) {
        NSUInteger days = self.countdown / 86400;
        NSUInteger hours = (self.countdown % 86400) / 3600;
        NSUInteger minutes = (self.countdown % 3600) / 60;
        NSUInteger seconds = (self.countdown % 3600) % 60;
        NSString *daysString = @"";
        if (days > 0) {
            daysString = [NSString stringWithFormat:@"%ld day%@", days, days == 1 ? @"" : @"s"];
        }
        _countdownLabel.text = [NSString  stringWithFormat:@"%@ %ld : %ld : %ld", daysString, hours, minutes, seconds];
    }
    else {
        if (self.firedEventHandler) {
            self.firedEventHandler();
        }
    }
}

+ (CGFloat)cellHeight {
    return 200.0f;
}

@end
