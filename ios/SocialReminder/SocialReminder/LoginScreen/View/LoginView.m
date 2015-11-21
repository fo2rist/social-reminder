//
//  LoginView.m
//  SocialReminder
//
//  Created by Evgeny Kubrakov on 21/11/15.
//  Copyright © 2015 Streetmage. All rights reserved.
//

#import "LoginView.h"

@implementation LoginView

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    
    if (self) {
        
        _loginField = [[UITextField alloc] init];
        [_loginField setBackgroundColor:[UIColor grayColor]];
        [self addSubview:_loginField];
        
        _loginButton = [[UIButton alloc] init];
        [_loginButton setTitle:@"Login" forState:UIControlStateNormal];
        [_loginButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        [self addSubview:_loginButton];
        
    }
    
    return self;
}

- (void)layoutSubviews {
    [super layoutSubviews];
    
    CGFloat loginFieldSideMargin = 20.0f;
    [_loginField setFrame:CGRectMake(loginFieldSideMargin,
                                     self.frame.size.height / 2 - 60.0f,
                                     self.frame.size.width - 2 * loginFieldSideMargin,
                                     40.0)];
    
    CGFloat loginButtonSideMargin = 50.0f;
    [_loginButton setFrame:CGRectMake(loginButtonSideMargin,
                                      CGRectGetMaxY(_loginField.frame),
                                      self.frame.size.width - 2 * loginButtonSideMargin,
                                      40.0f)];
    
}

@end
