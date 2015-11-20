//
//  UserRemindersListController.m
//  SocialReminder
//
//  Created by Evgeny Kubrakov on 20/11/15.
//  Copyright © 2015 Streetmage. All rights reserved.
//

#import "UserRemindersListController.h"
#import "Reminder.h"
#import "AppService.h"

@interface UserRemindersListController () <UITableViewDataSource, UITableViewDelegate>

@property (nonatomic, strong) NSArray *userReminders;

@property (nonatomic, strong) UITableView *tableView;

@end

@implementation UserRemindersListController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    _userReminders = @[[[Reminder alloc] init],
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
    
    [[AppService sharedService] createUserWithPhoneNumber:@"712312313"
                                               completion:nil];
    
}

- (void)viewDidLayoutSubviews {
    [super viewDidLayoutSubviews];
    
    [_tableView setFrame:self.view.bounds];
    
}

#pragma mark - UITableViewDataSource Methods

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.userReminders.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *userReminderTableCellId = @"UserReminderTableCellId";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:userReminderTableCellId];
    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle
                                      reuseIdentifier:userReminderTableCellId];
    }
    cell.textLabel.text = @"Name";
    cell.detailTextLabel.text = @"Fire Date";
    return cell;
}

#pragma mark - UITableViewDelegate Methods

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
}

@end
