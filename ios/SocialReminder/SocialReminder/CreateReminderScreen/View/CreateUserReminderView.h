//
//  CreateUserReminderView.h
//  SocialReminder
//
//  Created by Evgeny Kubrakov on 20/11/15.
//  Copyright © 2015 Streetmage. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface CreateUserReminderView : UIView

@property (nonatomic, strong) UITextField *reminderTitleField;
@property (nonatomic, strong) UILabel *fireDateLabel;

@property (nonatomic, strong) UIDatePicker *datePicker;
@property (nonatomic, strong) UIDatePicker *timePicker;

@end
