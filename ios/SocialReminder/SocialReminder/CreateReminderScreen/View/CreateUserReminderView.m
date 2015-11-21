//
//  CreateUserReminderView.m
//  SocialReminder
//
//  Created by Evgeny Kubrakov on 20/11/15.
//  Copyright © 2015 Streetmage. All rights reserved.
//

#import "CreateUserReminderView.h"

@implementation CreateUserReminderView

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    
    if (self) {
        
        _reminderTitleField = [[UITextField alloc] init];
        [_reminderTitleField setPlaceholder:@"Title"];
        [self addSubview:_reminderTitleField];
        
        _fireDateLabel = [[UILabel alloc] init];
        [self addSubview:_fireDateLabel];
        
        _datePicker = [[UIDatePicker alloc] init];
        [_datePicker setDatePickerMode:UIDatePickerModeDate];
        [self addSubview:_datePicker];
        
        _timePicker = [[UIDatePicker alloc] init];
        [_timePicker setDatePickerMode:UIDatePickerModeTime];
        [self addSubview:_timePicker];
        
    }
    
    return self;
}

- (void)layoutSubviews {
    [super layoutSubviews];
    
    [_reminderTitleField setFrame:CGRectMake(0.0f,
                                             0.0f,
                                             self.bounds.size.width,
                                             40.0f)];
    
    [_fireDateLabel setFrame:CGRectMake(0.0f,
                                        CGRectGetMaxY(_reminderTitleField.frame),
                                        self.bounds.size.width,
                                        40.0f)];
    
    [_datePicker setFrame:CGRectMake(0.0f,
                                     CGRectGetMaxY(_fireDateLabel.frame),
                                     self.bounds.size.width,
                                     200.0f)];
    
    [_timePicker setFrame:CGRectMake(0.0f,
                                     CGRectGetMaxY(_datePicker.frame),
                                     self.bounds.size.width,
                                     200.0f)];
    
}

@end
