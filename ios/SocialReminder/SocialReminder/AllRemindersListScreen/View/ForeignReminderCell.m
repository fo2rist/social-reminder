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
        [_subscribeButton setTitle:@"Subscribe" forState:UIControlStateNormal];
        [_subscribeButton setBackgroundColor:DEFAULT_COLOR];
        [_subscribeButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [self addSubview:_subscribeButton];
        
        [_subscribeButton addTarget:self
                             action:@selector(onSubscribeButtonClick:)
                   forControlEvents:UIControlEventTouchUpInside];
        
    }
    
    return self;
}

- (void)layoutSubviews {
    [super layoutSubviews];
    
    [_subscribeButton  setFrame:CGRectMake(70.0f, CGRectGetMaxY(self.countdownHolder.frame) + 10.0f, self.frame.size.width - 140.0f, 40.0f)];

}

+ (CGFloat)cellHeight {
    return 250.0f;
}

#pragma mark - Private Methods

- (void)onSubscribeButtonClick:(UIButton *)sender {
    if (self.subscribeButtonHandler) {
        self.subscribeButtonHandler(self);
    }
}

@end
