//
//  LoginView.m
//  SocialReminder
//
//  Created by Evgeny Kubrakov on 21/11/15.
//  Copyright © 2015 Streetmage. All rights reserved.
//

#import "LoginView.h"

@interface LoginView ()

@property (nonatomic, strong) UIImageView *imageView;
@property (nonatomic, strong) UIView *loginFieldHolder;

@end

@implementation LoginView

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    
    if (self) {
        
        _imageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"LoginBackground"]];
        [self addSubview:_imageView];
        
        _loginFieldHolder = [[UIView alloc] init];
        [_loginFieldHolder setBackgroundColor:[UIColor colorWithHexInt:0xe5e5e5]];
        [self addSubview:_loginFieldHolder];
        
        _loginField = [[UITextField alloc] init];
        [_loginField setFont:[UIFont systemFontOfSize:20.0f]];
        [_loginField setPlaceholder:@"Please, enter phone number"];
        [_loginFieldHolder addSubview:_loginField];
        
        _loginButton = [[UIButton alloc] init];
        [_loginButton setTitle:@"Login" forState:UIControlStateNormal];
        [_loginButton setBackgroundColor:[UIColor colorWithHexInt:0xe5e5e5]];
        [_loginButton setTitleColor:DEFAULT_TEXT_COLOR forState:UIControlStateNormal];
        [self addSubview:_loginButton];
        
    }
    
    return self;
}

- (void)layoutSubviews {
    [super layoutSubviews];
    
    [_imageView setFrame:self.bounds];
    
    [_loginFieldHolder setFrame:CGRectMake(5.0f, self.frame.size.height / 2 - 90, self.frame.size.width - 10.0f, 50.0f)];
    
    [_loginField setFrame:UIEdgeInsetsInsetRect(_loginFieldHolder.bounds, UIEdgeInsetsMake(5.0f, 5.0f, 5.0f, 5.0f))];
    
    CGFloat loginButtonSideMargin = 50.0f;
    [_loginButton setFrame:CGRectMake(loginButtonSideMargin,
                                      CGRectGetMaxY(_loginFieldHolder.frame) + 10.0f,
                                      self.frame.size.width - 2 * loginButtonSideMargin,
                                      40.0f)];
    
}

@end
