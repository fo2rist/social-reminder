//
//  AllRemindersListController.m
//  SocialReminder
//
//  Created by Evgeny Kubrakov on 21/11/15.
//  Copyright © 2015 Streetmage. All rights reserved.
//

#import "AllRemindersListController.h"
#import "AllRemindersListView.h"
#import "ForeignReminderCell.h"
#import "AppService.h"

@interface AllRemindersListController () <UISearchBarDelegate, UITableViewDataSource, UITableViewDelegate>

@property (nonatomic, strong) NSArray *reminders;

@property (nonatomic, strong) AllRemindersListView *screenView;

@end

@implementation AllRemindersListController

- (void)loadView {
    _screenView = [[AllRemindersListView alloc] init];
    self.view = _screenView;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [_screenView.searchBar setDelegate:self];
    
    [_screenView.segmentedControl addTarget:self
                                     action:@selector(onSegmentedControlChange:)
                           forControlEvents:UIControlEventValueChanged];
    
    [_screenView.tableView setDataSource:self];
    [_screenView.tableView setDelegate:self];
    
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    [[AppService sharedService] allRemindersWithFilter:ReminderFilterNone
                                            completion:^(BOOL success, NSArray *reminders, NSString *responseString, NSError *error) {
                                                [MBProgressHUD hideAllHUDsForView:self.view animated:YES];
                                                _reminders = reminders;
                                                [_screenView.tableView reloadData];
                                            }];
    
}

#pragma mark - PRivate Methods

- (void)onSegmentedControlChange:(UISegmentedControl *)sender {
    // TODO: change filter
}

#pragma mark - UITableViewDataSource Methods

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.reminders.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *userReminderTableCellId = @"UserReminderTableCellId";
    ForeignReminderCell *cell = [tableView dequeueReusableCellWithIdentifier:userReminderTableCellId];
    if (!cell) {
        cell = [[ForeignReminderCell alloc] initWithStyle:UITableViewCellStyleDefault
                                          reuseIdentifier:userReminderTableCellId];
    }
    id <Reminder> reminder = [self.reminders objectAtIndex:indexPath.row];
    [cell setupWithReminder:reminder];
    return cell;
}

@end
