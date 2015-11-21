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
@property (nonatomic, assign) NSUInteger selectedFilter;

@property (nonatomic, strong) AllRemindersListView *screenView;

@end

@implementation AllRemindersListController

- (void)loadView {
    _screenView = [[AllRemindersListView alloc] init];
    self.view = _screenView;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self setTitle:@"Search"];
    
    [_screenView.searchBar setDelegate:self];
    [_screenView.searchBar setPlaceholder:@"Search"];
    
    [_screenView.segmentedControl addTarget:self
                                     action:@selector(onSegmentedControlChange:)
                           forControlEvents:UIControlEventValueChanged];
    
    [_screenView.tableView setDataSource:self];
    [_screenView.tableView setDelegate:self];
    
    self.selectedFilter = 0;
    [_screenView.segmentedControl setSelectedSegmentIndex:self.selectedFilter];
    
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    [self reloadData];
}

#pragma mark - Private Methods

- (void)onSegmentedControlChange:(UISegmentedControl *)sender {
    self.selectedFilter = sender.selectedSegmentIndex;
    [self reloadData];
}

- (void)reloadData {
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    [[AppService sharedService] allRemindersWithFilter:self.selectedFilter
                                                search:_screenView.searchBar.text
                                            completion:^(BOOL success, NSArray *reminders, NSString *responseString, NSError *error) {
                                                [MBProgressHUD hideAllHUDsForView:self.view animated:YES];
                                                _reminders = reminders;
                                                [_screenView.tableView reloadData];
                                            }];
}

- (void)subscribeForReminderOnIndexPath:(NSIndexPath *)indexPath {
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    id <Reminder> reminder = [self.reminders objectAtIndex:indexPath.row];
 [[AppService sharedService] subscribeToReminderWithId:[reminder reminderId]
                                            completion:^(BOOL success, NSArray *reminderEnclosed, NSString *responseString, NSError *error) {
                                                [MBProgressHUD hideAllHUDsForView:self.view animated:YES];
                                            }];
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
        cell.subscribeButtonHandler = ^(ForeignReminderCell *cell) {
            [self subscribeForReminderOnIndexPath:[tableView indexPathForCell:cell]];
        };
    }
    id <Reminder> reminder = [self.reminders objectAtIndex:indexPath.row];
    [cell setupWithReminder:reminder];
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return [ForeignReminderCell cellHeight];
}

#pragma mark - UISearchBarDelegate Methods

- (void)searchBarTextDidBeginEditing:(UISearchBar *)searchBar {
    [searchBar setShowsCancelButton:YES animated:YES];
}

- (void)searchBarTextDidEndEditing:(UISearchBar *)searchBar {
    [searchBar setShowsCancelButton:NO animated:YES];
}

- (void)searchBarSearchButtonClicked:(UISearchBar *)searchBar {
    [searchBar resignFirstResponder];
}

- (void)searchBarCancelButtonClicked:(UISearchBar *)searchBar {
    [self reloadData];
    [searchBar resignFirstResponder];
}

@end
