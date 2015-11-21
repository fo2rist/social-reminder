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

@property (nonatomic, strong) UIView *holderView;
@property (nonatomic, strong) UIImageView *locationImageView;

@property (nonatomic, strong) UIView *countdownHolder;
@property (nonatomic, strong) UILabel *countdownLabel;
@property (nonatomic, strong) UILabel *fireDateLabel;

@property (nonatomic, assign) NSUInteger countdown;
@property (nonatomic, strong) NSTimer *timer;

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
        [_locationImageView setBackgroundColor:[UIColor lightGrayColor]];
        [_holderView addSubview:_locationImageView];
        
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
    
    [_locationImageView setFrame:UIEdgeInsetsInsetRect(_holderView.bounds, UIEdgeInsetsMake(0.0f,
                                                                                     0.0f,
                                                                                     0.4 * _holderView.frame.size.height,
                                                                                     5.0f))];
    
    [_countdownHolder setFrame:UIEdgeInsetsInsetRect(_holderView.bounds, UIEdgeInsetsMake(0.6 * _holderView.frame.size.height,
                                                                                   0.0f,
                                                                                   0.0f,
                                                                                   5.0f))];
    
    [_countdownLabel setFrame:UIEdgeInsetsInsetRect(_countdownHolder.bounds, UIEdgeInsetsMake(5.0f, 5.0f, 20.0f, 5.0f))];
    
    [_fireDateLabel setFrame:CGRectMake(0.0f, _countdownHolder.frame.size.height - 20.0f, _countdownHolder.frame.size.width - 5.0f, 20.0f)];
    
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
    [_fireDateLabel setText:[dateFormatter stringFromDate:fireDate]];
}

- (void)onTick {
    self.countdown--;
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

+ (CGFloat)cellHeight {
    return 200.0f;
}

@end
