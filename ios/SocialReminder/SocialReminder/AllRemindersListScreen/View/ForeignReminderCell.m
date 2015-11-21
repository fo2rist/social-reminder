//
//  ForeignReminderCell.m
//  SocialReminder
//
//  Created by Evgeny Kubrakov on 21/11/15.
//  Copyright © 2015 Streetmage. All rights reserved.
//

#import "ForeignReminderCell.h"

@interface ForeignReminderCell ()

@property (nonatomic, strong) UIButton *subscribeButton;

@end

@implementation ForeignReminderCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    
    if (self) {
        
        _subscribeButton = [[UIButton alloc] init];
        [_subscribeButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        [self addSubview:_subscribeButton];
        
    }
    
    return self;
}

- (void)setupWithReminder:(id <Reminder>)reminder {
    [super setupWithReminder:reminder];
    [_subscribeButton setTitle:[reminder isSubscribed] ? @"Unsubscribe" : @"Subscribe" forState:UIControlStateNormal];
    [_subscribeButton setTitleColor:[reminder isSubscribed] ? [UIColor redColor] : [UIColor blueColor] forState:UIControlStateNormal];
}

- (void)layoutSubviews {
    [super layoutSubviews];
    
    [_subscribeButton  setFrame:CGRectMake(0.0f, 0.0f, 50.0f, 30.0f)];
    
}

@end
