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
#import "LocationManager.h"

#import <RMDateSelectionViewController/RMDateSelectionViewController.h>

#import "AppService.h"

static NSDateFormatter *dateFormatter;

@interface CreateUserReminderController ()

@property (nonatomic, strong) CreateUserReminderView *screenView;
@property (nonatomic, strong) UIButton *saveButton;
@property (nonatomic, strong) UIButton *backButton;

@property (nonatomic, strong) NSDate *selectedDate;
@property (nonatomic, strong) LocationManager *locationManager;

@end

@implementation CreateUserReminderController

- (void)loadView {
    _screenView = [[CreateUserReminderView alloc] init];
    self.view = _screenView;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self setTitle:@"Create"];
    
    dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"yyyy/MM/dd hh:mm a"];
    
    NSDate *currentDate = [NSDate date];
    self.selectedDate = [NSDate dateWithDate:currentDate time:currentDate];
    
    [_screenView.pickDateButton addTarget:self
                                   action:@selector(onPickDateButtonClick:)
                         forControlEvents:UIControlEventTouchUpInside];
    
    [self updateSelectedDateLabel];
    
    _locationManager = [[LocationManager alloc] init];
    [_locationManager setHandler:^(CLLocationCoordinate2D coordinate) {
        
    }];
    
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    UIBarButtonItem *saveButtonItem = [[UIBarButtonItem alloc] initWithCustomView:self.saveButton];
    [self.navigationItem setRightBarButtonItem:saveButtonItem];
    
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    
    [_screenView.reminderTitleField becomeFirstResponder];
    
}

#pragma mark - Accessors

- (UIButton *)saveButton {
    if (!_saveButton) {
        _saveButton = [[UIButton alloc] initWithFrame:CGRectMake(0.0f, 0.0f, 30.0f, 30.0f)];
        [_saveButton.imageView setContentMode:UIViewContentModeScaleAspectFit];
        [_saveButton setImage:[UIImage imageNamed:@"SaveIcon"] forState:UIControlStateNormal];
        [_saveButton setImageEdgeInsets:UIEdgeInsetsMake(5.0f, 5.0f, 5.0f, 5.0f)];
        [_saveButton addTarget:self
                        action:@selector(onSaveButtonClick:)
              forControlEvents:UIControlEventTouchUpInside];
    }
    return _saveButton;
}

- (void)onPickDateButtonClick:(UIButton *)sender {
    RMAction *selectAction = [RMAction actionWithTitle:@"Select" style:RMActionStyleDone andHandler:^(RMActionController *controller) {
        self.selectedDate = ((UIDatePicker *)controller.contentView).date;
        NSTimeInterval time = floor([self.selectedDate timeIntervalSinceReferenceDate] / 60.0) * 60.0;
        self.selectedDate = [NSDate dateWithTimeIntervalSinceReferenceDate:time];
        [self updateSelectedDateLabel];
    }];
    
    RMAction *cancelAction = [RMAction actionWithTitle:@"Cancel" style:RMActionStyleCancel andHandler:^(RMActionController *controller) {
        
    }];

    RMDateSelectionViewController *dateSelectionController = [RMDateSelectionViewController actionControllerWithStyle:RMActionControllerStyleWhite selectAction:selectAction andCancelAction:cancelAction];
    dateSelectionController.title = @"Pick Fire Date";
    [self presentViewController:dateSelectionController animated:YES completion:nil];
}

#pragma mark - Private Methods

- (void)updateSelectedDateLabel {
    _screenView.fireDateLabel.text = [dateFormatter stringFromDate:self.selectedDate];
}

- (void)onSaveButtonClick:(UIButton *)sender {
    if ([[NSDate date] compare:self.selectedDate] == NSOrderedAscending) {
        [MBProgressHUD showHUDAddedTo:self.view animated:YES];
        [[AppService sharedService] saveReminderWithTitle:_screenView.reminderTitleField.text
                                                 fireDate:self.selectedDate
                                               completion:^(BOOL success, id parsedData, NSString *responseString, NSError *error) {
                                                   [MBProgressHUD hideAllHUDsForView:self.view animated:YES];
                                                   [UIView transitionWithView:self.navigationController.view
                                                                     duration:0.75
                                                                      options:UIViewAnimationOptionTransitionFlipFromLeft
                                                                   animations:^{
                                                                       [self.navigationController popToRootViewControllerAnimated:NO];
                                                                   }
                                                                   completion:nil];
                                               }];
    }
    else {
        UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"Warning"
                                                                       message:@"Date should be set in future"
                                                                preferredStyle:UIAlertControllerStyleAlert];
        [alert addAction:[UIAlertAction actionWithTitle:@"OK"
                                                  style:UIAlertActionStyleDefault
                                                handler:^(UIAlertAction *action) {
                                                    [alert dismissViewControllerAnimated:YES completion:nil];
                                                }]];
        [self presentViewController:alert animated:YES completion:nil];
    }
}

@end