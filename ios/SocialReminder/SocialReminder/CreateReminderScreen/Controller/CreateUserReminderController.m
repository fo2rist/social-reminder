//
//  CreateUserReminderController.m
//  SocialReminder
//
//  Created by Evgeny Kubrakov on 20/11/15.
//  Copyright © 2015 Streetmage. All rights reserved.
//

#import "CreateUserReminderController.h"
#import "CreateUserReminderView.h"

#import "AppService.h"

static NSDateFormatter *dateFormatter;

@interface CreateUserReminderController ()

@property (nonatomic, strong) CreateUserReminderView *screenView;
@property (nonatomic, strong) UIButton *saveButton;

@property (nonatomic, strong) NSDate *currentDate;
@property (nonatomic, strong) NSDate *currentTime;

@end

@implementation CreateUserReminderController

- (void)loadView {
    _screenView = [[CreateUserReminderView alloc] init];
    self.view = _screenView;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    static dispatch_once_t token;
    dispatch_once(&token, ^{
        dateFormatter = [[NSDateFormatter alloc] init];
        [dateFormatter setDateFormat:@"yyyy.MM.dd hh:mm"];
    });
    
    [_screenView.datePicker addTarget:self
                               action:@selector(onDatePickerValueChange:)
                     forControlEvents:UIControlEventValueChanged];
    
    [_screenView.timePicker addTarget:self
                               action:@selector(onTimePickerValueChange:)
                     forControlEvents:UIControlEventValueChanged];
    
    self.currentDate = _screenView.datePicker.date;
    self.currentTime = _screenView.timePicker.date;
    
    _screenView.fireDateLabel.text = [dateFormatter stringFromDate:[self combineDate:self.currentDate withTime:self.currentTime]];
    
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    UIBarButtonItem *saveButtonItem = [[UIBarButtonItem alloc] initWithCustomView:self.saveButton];
    [self.navigationItem setRightBarButtonItem:saveButtonItem];
    
}

#pragma mark - Accessors

- (UIButton *)saveButton {
    if (!_saveButton) {
        _saveButton = [[UIButton alloc] initWithFrame:CGRectMake(0.0f, 0.0f, 50.0f, 40.0f)];
        [_saveButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        [_saveButton setTitle:@"Save" forState:UIControlStateNormal];
        [_saveButton addTarget:self
                        action:@selector(onSaveButtonClick:)
              forControlEvents:UIControlEventTouchUpInside];
    }
    return _saveButton;
}

#pragma mark - Private Methods

- (void)onDatePickerValueChange:(UIDatePicker *)sender {
    self.currentDate = sender.date;
    _screenView.fireDateLabel.text = [dateFormatter stringFromDate:[self combineDate:self.currentDate
                                                                            withTime:self.currentTime]];
}

- (void)onTimePickerValueChange:(UIDatePicker *)sender {
    self.currentTime = sender.date;
    _screenView.fireDateLabel.text = [dateFormatter stringFromDate:[self combineDate:self.currentDate
                                                                            withTime:self.currentTime]];
}

- (NSDate *)combineDate:(NSDate *)date withTime:(NSDate *)time {
    
    NSCalendar *gregorian = [[NSCalendar alloc] initWithCalendarIdentifier:NSCalendarIdentifierGregorian];
    
    unsigned unitFlagsDate = NSCalendarUnitYear | NSCalendarUnitMonth
    |  NSCalendarUnitDay;
    NSDateComponents *dateComponents = [gregorian components:unitFlagsDate
                                                    fromDate:date];
    unsigned unitFlagsTime = NSCalendarUnitHour | NSCalendarUnitMinute;
    NSDateComponents *timeComponents = [gregorian components:unitFlagsTime
                                                    fromDate:time];
    
    [dateComponents setSecond:0];
    [dateComponents setHour:[timeComponents hour]];
    [dateComponents setMinute:[timeComponents minute]];
    
    NSDate *combDate = [gregorian dateFromComponents:dateComponents];
    
    return combDate;
}

- (void)onSaveButtonClick:(UIButton *)sender {
    [[AppService sharedService] saveReminderWithTitle:_screenView.reminderTitleField.text
                                             fireDate:[self combineDate:self.currentDate
                                                               withTime:self.currentTime]
                                           completion:^(BOOL success, id parsedData, NSString *responseString, NSError *error) {
                                               
                                           }];
}

@end