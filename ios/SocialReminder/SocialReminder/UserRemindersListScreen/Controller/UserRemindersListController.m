//
//  UserRemindersListController.m
//  SocialReminder
//
//  Created by Evgeny Kubrakov on 20/11/15.
//  Copyright © 2015 Streetmage. All rights reserved.
//

#import "UserRemindersListController.h"
#import "CreateUserReminderController.h"
#import "UserReminderCell.h"

#import "User.h"
#import "Reminder.h"
#import "AppService.h"

static NSDateFormatter *dateFormatter;

@interface UserRemindersListController () <UITableViewDataSource, UITableViewDelegate>

@property (nonatomic, strong) NSArray *userReminders;

@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) UIButton *addButton;

@end

@implementation UserRemindersListController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"yyyy.MM.dd hh:mm"];
    
    _userReminders = @[[[Reminder alloc] init],
                       [[Reminder alloc] init],
                       [[Reminder alloc] init],
                       [[Reminder alloc] init],
                       [[Reminder alloc] init],
                       [[Reminder alloc] init],
                       [[Reminder alloc] init],
                       [[Reminder alloc] init],
                       [[Reminder alloc] init],
                       [[Reminder alloc] init],
                       [[Reminder alloc] init],
                       [[Reminder alloc] init],
                       [[Reminder alloc] init],
                       [[Reminder alloc] init],
                       [[Reminder alloc] init],
                       [[Reminder alloc] init],
                       [[Reminder alloc] init],
                       [[Reminder alloc] init],
                       [[Reminder alloc] init],
                       [[Reminder alloc] init],
                       [[Reminder alloc] init]];
    
    _tableView = [[UITableView alloc] init];
    [_tableView setDataSource:self];
    [_tableView setDelegate:self];
    [self.view addSubview:_tableView];
    
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    UIBarButtonItem *addButtonItem = [[UIBarButtonItem alloc] initWithCustomView:self.addButton];
    [self.navigationItem setRightBarButtonItem:addButtonItem];
}

- (void)viewDidLayoutSubviews {
    [super viewDidLayoutSubviews];
    [_tableView setFrame:self.view.bounds];
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    
//    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
//    [[AppService sharedService] userRemindersWithCompletion:^(BOOL success, NSArray *userReminders, NSString *responseString, NSError *error) {
//        [MBProgressHUD hideAllHUDsForView:self.view animated:YES];
//        self.userReminders = userReminders;
//        [self.tableView reloadData];
//    }];
    
}

#pragma mark - Accessors

- (UIButton *)addButton {
    if (!_addButton) {
        _addButton = [[UIButton alloc] initWithFrame:CGRectMake(0.0f, 0.0f, 30.0f, 30.0f)];
        [_addButton setImage:[UIImage imageNamed:@"AddButton"] forState:UIControlStateNormal];
        [_addButton addTarget:self
                       action:@selector(onAddButtonClick:)
             forControlEvents:UIControlEventTouchUpInside];
    }
    return _addButton;
}

#pragma mark - Private Methods

- (void)onAddButtonClick:(UIButton *)sender {
    CreateUserReminderController *createUserReminderController = [[CreateUserReminderController alloc] init];
    [self.navigationController pushViewController:createUserReminderController animated:YES];
}

#pragma mark - UITableViewDataSource Methods

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.userReminders.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *userReminderTableCellId = @"UserReminderTableCellId";
    UserReminderCell *cell = [tableView dequeueReusableCellWithIdentifier:userReminderTableCellId];
    if (!cell) {
        cell = [[UserReminderCell alloc] initWithStyle:UITableViewCellStyleDefault
                                       reuseIdentifier:userReminderTableCellId];
    }
    Reminder *reminder = [self.userReminders objectAtIndex:indexPath.row];
    [cell setupWithReminder:reminder];
    return cell;
}

#pragma mark - UITableViewDelegate Methods

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
}

@end
