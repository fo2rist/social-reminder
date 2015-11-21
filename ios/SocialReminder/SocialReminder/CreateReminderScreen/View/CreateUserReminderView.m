//
//  CreateUserReminderView.m
//  SocialReminder
//
//  Created by Evgeny Kubrakov on 20/11/15.
//  Copyright © 2015 Streetmage. All rights reserved.
//

#import "CreateUserReminderView.h"

@interface CreateUserReminderView ()

@property (nonatomic, strong) UIScrollView *scrollView;
@property (nonatomic, strong) UIView *reminderTextFieldHolder;
@property (nonatomic, strong) UIView *fireDateLabelHolder;

@end

@implementation CreateUserReminderView

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    
    if (self) {
        
        _scrollView = [[UIScrollView alloc] init];
        [self addSubview:_scrollView];
        
        _reminderTextFieldHolder = [[UIView alloc] init];
        [_reminderTextFieldHolder setBackgroundColor:[UIColor colorWithHexInt:0xe5e5e5]];
        [_scrollView addSubview:_reminderTextFieldHolder];
        
        _reminderTitleField = [[UITextField alloc] init];
        [_reminderTitleField setFont:[UIFont systemFontOfSize:20.0f]];
        [_reminderTitleField setPlaceholder:@"Title"];
        [_reminderTitleField setTextColor:DEFAULT_TEXT_COLOR];
        [_reminderTextFieldHolder addSubview:_reminderTitleField];
        
        _fireDateLabelHolder = [[UIView alloc] init];
        [_fireDateLabelHolder setBackgroundColor:[UIColor colorWithHexInt:0xe5e5e5]];
        [_scrollView addSubview:_fireDateLabelHolder];
        
        _fireDateLabel = [[UILabel alloc] init];
        [_fireDateLabel setFont:[UIFont systemFontOfSize:20.0f]];
        [_fireDateLabel setTextColor:DEFAULT_TEXT_COLOR];
        [_fireDateLabelHolder addSubview:_fireDateLabel];
        
        _pickDateButton = [[UIButton alloc] init];
        [_pickDateButton setBackgroundColor:[UIColor colorWithHexInt:0xe5e5e5]];
        [_pickDateButton setTitle:@"Pick Date" forState:UIControlStateNormal];
        [_scrollView addSubview:_pickDateButton];
        
    }
    
    return self;
}

- (void)layoutSubviews {
    [super layoutSubviews];
    
    [_scrollView setFrame:self.bounds];
    [_scrollView setContentSize:CGSizeMake(self.frame.size.width, self.frame.size.height + 1.0f)];
    
    [_reminderTextFieldHolder setFrame:CGRectMake(5.0f, 5.0f, self.frame.size.width - 10.0f, 50.0f)];
    
    [_reminderTitleField setFrame:UIEdgeInsetsInsetRect(_reminderTextFieldHolder.bounds, UIEdgeInsetsMake(5.0f, 5.0f, 5.0f, 5.0f))];
    
    [_fireDateLabelHolder setFrame:CGRectMake(5.0f,
                                              CGRectGetMaxY(_reminderTextFieldHolder.frame) + 10.0f,
                                              self.frame.size.width - 70.0f,
                                              50.0f)];
    
    [_fireDateLabel setFrame:UIEdgeInsetsInsetRect(_fireDateLabelHolder.bounds, UIEdgeInsetsMake(5.0f, 5.0f, 5.0f, 5.0f))];
    
    [_pickDateButton setFrame:CGRectMake(CGRectGetMaxX(_fireDateLabelHolder.frame) + 10.0f, _fireDateLabelHolder.frame.origin.y, 50.0f, 50.0f)];
    
}

@end
