//
//  CreateUserReminderController.m
//  SocialReminder
//
//  Created by Evgeny Kubrakov on 20/11/15.
//  Copyright © 2015 Streetmage. All rights reserved.
//


#import "CreateUserReminderController.h"
#import "CreateUserReminderView.h"
#import "NSDate+Helpers.h"

#import "AppService.h"

static NSDateFormatter *dateFormatter;

@interface CreateUserReminderController ()

@property (nonatomic, strong) CreateUserReminderView *screenView;
@property (nonatomic, strong) UIButton *saveButton;

@property (nonatomic, strong) NSDate *selectedDate;

@end

@implementation CreateUserReminderController

- (void)loadView {
    _screenView = [[CreateUserReminderView alloc] init];
    self.view = _screenView;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"yyyy.MM.dd hh:mm"];
    
    [_screenView.datePicker addTarget:self
                               action:@selector(onDatePickerValueChange:)
                     forControlEvents:UIControlEventValueChanged];
    
    [_screenView.timePicker addTarget:self
                               action:@selector(onTimePickerValueChange:)
                     forControlEvents:UIControlEventValueChanged];
    
    NSDate *currentDate = [NSDate date];
    self.selectedDate = [NSDate dateWithDate:currentDate time:currentDate];
    
    [self updateSelectedDateLabel];
    
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

- (void)updateSelectedDateLabel {
    _screenView.fireDateLabel.text = [dateFormatter stringFromDate:self.selectedDate];
}

- (void)onDatePickerValueChange:(UIDatePicker *)sender {
    self.selectedDate = [NSDate dateWithDate:sender.date time:self.selectedDate];
    [self updateSelectedDateLabel];
}

- (void)onTimePickerValueChange:(UIDatePicker *)sender {
    self.selectedDate = [NSDate dateWithDate:self.selectedDate time:sender.date];
    [self updateSelectedDateLabel];
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
                                             fireDate:self.selectedDate
                                           completion:^(BOOL success, id parsedData, NSString *responseString, NSError *error) {
                                               
                                           }];
}

@end