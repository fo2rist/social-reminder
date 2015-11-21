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

#import <RMDateSelectionViewController/RMDateSelectionViewController.h>

#import "AppService.h"

static NSDateFormatter *dateFormatter;

@interface CreateUserReminderController ()

@property (nonatomic, strong) CreateUserReminderView *screenView;
@property (nonatomic, strong) UIButton *saveButton;
@property (nonatomic, strong) UIButton *backButton;

@property (nonatomic, strong) NSDate *selectedDate;

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
    [dateFormatter setDateFormat:@"yyyy/MM/dd hh:mm"];
    
    NSDate *currentDate = [NSDate date];
    self.selectedDate = [NSDate dateWithDate:currentDate time:currentDate];
    
    [_screenView.pickDateButton addTarget:self
                                   action:@selector(onPickDateButtonClick:)
                         forControlEvents:UIControlEventTouchUpInside];
    
    [self updateSelectedDateLabel];
    
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
    [[AppService sharedService] saveReminderWithTitle:_screenView.reminderTitleField.text
                                             fireDate:self.selectedDate
                                           completion:^(BOOL success, id parsedData, NSString *responseString, NSError *error) {
                                               [UIView transitionWithView:self.navigationController.view
                                                                 duration:0.75
                                                                  options:UIViewAnimationOptionTransitionFlipFromLeft
                                                               animations:^{
                                                                   [self.navigationController popToRootViewControllerAnimated:NO];
                                                               }
                                                               completion:nil];
                                           }];
}

@end