//
//  UserReminderCell.m
//  SocialReminder
//
//  Created by Evgeny Kubrakov on 21/11/15.
//  Copyright © 2015 Streetmage. All rights reserved.
//

#import "UserReminderCell.h"

static NSDateFormatter *dateFormatter;
static NSNumberFormatter *numberFormatter;
static NSArray *colors = nil;

@interface UserReminderCell ()

@end

@implementation UserReminderCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    
    if (self) {
        
        if (!dateFormatter) {
            dateFormatter = [[NSDateFormatter alloc] init];
            [dateFormatter setDateFormat:@"yyyy:MM:dd hh:mm a"];
        }
        
        if (!numberFormatter) {
            numberFormatter = [[NSNumberFormatter alloc] init];
            [numberFormatter setMinimumIntegerDigits:2];
        }
        
        if (!colors) {
            colors = @[[UIColor colorWithHexInt:0x4caf50],
                       [UIColor colorWithHexInt:0x9e9d24],
                       [UIColor colorWithHexInt:0x607d8b],
                       [UIColor colorWithHexInt:0xf44336],
                       [UIColor colorWithHexInt:0xe91e63],
                       [UIColor colorWithHexInt:0x0c27b0],
                       [UIColor colorWithHexInt:0x3f51b5],
                       [UIColor colorWithHexInt:0x00bcd4]];
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
        
        _titleLabel.layer.shadowColor = [UIColor blackColor].CGColor;
        _titleLabel.layer.shadowOffset = CGSizeMake(2, 2);
        _titleLabel.layer.shadowOpacity = 1;
        _titleLabel.layer.shadowRadius = 1.0;
        
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
    
    [_fireDateLabel setFrame:CGRectMake(0.0f, CGRectGetMaxY(_countdownLabel.frame) + 5.0f, _countdownHolder.frame.size.width - 5.0f, 20.0f)];
    
}

- (void)prepareForReuse {
    [self.timer invalidate];
    [self.fireDateLabel setText:nil];
    [self.locationImageView setImage:nil];
    [self.titleLabel setTextColor:[UIColor whiteColor]];
}

- (void)setupWithReminder:(id <Reminder>)reminder {
    NSDate *fireDate = [reminder fireDate];
    NSInteger timeInterval = [fireDate timeIntervalSinceNow];
    if (timeInterval > 0) {
        self.countdown = timeInterval;
        [self onTick];
        self.timer = [NSTimer timerWithTimeInterval:1.0
                                             target:self
                                           selector:@selector(onTick)
                                           userInfo:nil
                                            repeats:YES];
        [[NSRunLoop mainRunLoop] addTimer:self.timer forMode:NSRunLoopCommonModes];
        [_fireDateLabel setText:[dateFormatter stringFromDate:fireDate]];
    }
    NSUInteger itemColorIndex = [[reminder title] hash] % colors.count;
    if (itemColorIndex < colors.count) {
        [_locationImageView setBackgroundColor:[colors objectAtIndex:itemColorIndex]];
    }
    if ([[[reminder title] lowercaseString] containsString:@"вдв"]) {
        [_locationImageView setImage:[UIImage imageNamed:@"VDVFlag"]];
    }
    if ([[[reminder title] lowercaseString] containsString:@"вмф"]) {
        [_locationImageView setImage:[UIImage imageNamed:@"AdreevskyFlag"]];
        [self.titleLabel setTextColor:[UIColor grayColor]];
    }
    if ([[[reminder title] lowercaseString] containsString:@"росси"]) {
        [_locationImageView setImage:[UIImage imageNamed:@"RussianFlag"]];
    }
    [_titleLabel setText:[reminder title]];
}

- (void)onTick {
    self.countdown--;
    if (self.countdown >= 0) {
        NSUInteger days = self.countdown / 86400;
        NSNumber *hours = @((self.countdown % 86400) / 3600);
        NSNumber *minutes = @((self.countdown % 3600) / 60);
        NSNumber *seconds = @((self.countdown % 3600) % 60);
        NSString *daysString = @"";
        if (days > 0) {
            daysString = [NSString stringWithFormat:@"%ld day%@", (unsigned long)days, days == 1 ? @"" : @"s"];
        }
        _countdownLabel.text = [NSString  stringWithFormat:@"%@ %@ : %@ : %@", daysString, [numberFormatter stringFromNumber:hours], [numberFormatter stringFromNumber:minutes], [numberFormatter stringFromNumber:seconds]];
    }
    else {
        [self.timer invalidate];
        if (self.firedEventHandler) {
            self.firedEventHandler();
        }
    }
}

+ (CGFloat)cellHeight {
    return 200.0f;
}

@end
