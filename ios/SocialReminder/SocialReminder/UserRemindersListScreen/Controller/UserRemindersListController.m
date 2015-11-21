//
//  UserRemindersListController.m
//  SocialReminder
//
//  Created by Evgeny Kubrakov on 20/11/15.
//  Copyright © 2015 Streetmage. All rights reserved.
//

#import "UserRemindersListController.h"
#import "CreateUserReminderController.h"
#import "AllRemindersListController.h"
#import "UserReminderCell.h"

#import "User.h"
#import "Reminder.h"
#import "AppService.h"

static NSDateFormatter *dateFormatter;

@interface UserRemindersListController () <UITableViewDataSource, UITableViewDelegate, NSFetchedResultsControllerDelegate>

@property (nonatomic, strong) NSFetchedResultsController *fetchedResultsController;

@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) UIButton *addButton;
@property (nonatomic, strong) UIButton *searchButton;

@end

@implementation UserRemindersListController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"yyyy.MM.dd hh:mm"];
    
    _tableView = [[UITableView alloc] init];
    [_tableView setDataSource:self];
    [_tableView setDelegate:self];
    [self.view addSubview:_tableView];
    
    [self setupFetchedResultsController];
    
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    UIBarButtonItem *addButtonItem = [[UIBarButtonItem alloc] initWithCustomView:self.addButton];
    UIBarButtonItem *searchButtonItem = [[UIBarButtonItem alloc] initWithCustomView:self.searchButton];
    [self.navigationItem setRightBarButtonItems:@[addButtonItem, searchButtonItem]];
}

- (void)viewDidLayoutSubviews {
    [super viewDidLayoutSubviews];
    [_tableView setFrame:self.view.bounds];
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    [[AppService sharedService] userRemindersWithCompletion:^(BOOL success, NSArray *userReminders, NSString *responseString, NSError *error) {
        [MBProgressHUD hideAllHUDsForView:self.view animated:YES];
    }];
    
}

#pragma mark - Accessors

- (UIButton *)addButton {
    if (!_addButton) {
        _addButton = [[UIButton alloc] initWithFrame:CGRectMake(0.0f, 0.0f, 30.0f, 30.0f)];
        [_addButton setTitle:@"A" forState:UIControlStateNormal];
        [_addButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        [_addButton addTarget:self
                       action:@selector(onAddButtonClick:)
             forControlEvents:UIControlEventTouchUpInside];
    }
    return _addButton;
}

- (UIButton *)searchButton {
    if (!_searchButton) {
        _searchButton = [[UIButton alloc] initWithFrame:CGRectMake(0.0f, 0.0f, 30.0f, 30.0f)];
        [_searchButton setTitle:@"S" forState:UIControlStateNormal];
        [_searchButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        [_searchButton addTarget:self
                          action:@selector(onSearchButtonClick:)
                forControlEvents:UIControlEventTouchUpInside];
    }
    return _searchButton;
}

#pragma mark - Private Methods

- (void)onAddButtonClick:(UIButton *)sender {
    CreateUserReminderController *createUserReminderController = [[CreateUserReminderController alloc] init];
    [self.navigationController pushViewController:createUserReminderController animated:YES];
}

- (void)onSearchButtonClick:(UIButton *)sender {
    AllRemindersListController *allRemindersController = [[AllRemindersListController alloc] init];
    [self.navigationController pushViewController:allRemindersController animated:YES];
}

#pragma mark - NSFetchedResultsController Methods

- (void)setupFetchedResultsController {
    _fetchedResultsController = [[NSFetchedResultsController alloc] initWithFetchRequest:[self createFetchRequest]
                                                                    managedObjectContext:[AppService sharedService].objectManager.managedObjectStore.mainQueueManagedObjectContext
                                                                      sectionNameKeyPath:nil
                                                                               cacheName:nil];
    [self updatePredicate];
    _fetchedResultsController.delegate = self;
    [self updateFetchedResults];
}

- (void)updatePredicate {
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"%@ < fireDateSecondsSince1970", @([[NSDate date] timeIntervalSince1970])];
    [_fetchedResultsController.fetchRequest setPredicate:predicate];
}

- (void)updateFetchedResults {
    NSError *error = nil;
    [_fetchedResultsController performFetch:&error];
#ifdef DEBUG
    NSAssert(!error, @"NSFetchedResultsController init failed %@", error.description);
#endif
}

- (NSFetchRequest *)createFetchRequest {
    NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] initWithEntityName:NSStringFromClass([DBReminder class])];
    NSSortDescriptor *descriptor = [[NSSortDescriptor alloc] initWithKey:@"fireDateSecondsSince1970" ascending:YES];
    [fetchRequest setSortDescriptors:@[descriptor]];
    [fetchRequest setFetchBatchSize:10];
    return fetchRequest;
}

- (void)controllerWillChangeContent:(NSFetchedResultsController *)controller {
    [self.tableView beginUpdates];
}

- (void)controller:(NSFetchedResultsController *)controller
   didChangeObject:(id)anObject
       atIndexPath:(NSIndexPath *)indexPath
     forChangeType:(NSFetchedResultsChangeType)type
      newIndexPath:(NSIndexPath *)newIndexPath {
    
    switch(type) {
        case NSFetchedResultsChangeInsert:
            if (newIndexPath) {
                [_tableView insertRowsAtIndexPaths:@[newIndexPath]
                                  withRowAnimation:UITableViewRowAnimationAutomatic];
            }
            break;
            
        case NSFetchedResultsChangeDelete:
            if (indexPath) {
                [_tableView deleteRowsAtIndexPaths:@[indexPath]
                                  withRowAnimation:UITableViewRowAnimationAutomatic];
            }
            break;
            
        case NSFetchedResultsChangeUpdate:
            if (indexPath) {
                [_tableView reloadRowsAtIndexPaths:@[indexPath]
                                  withRowAnimation:UITableViewRowAnimationFade];
            }
            break;
            
        case NSFetchedResultsChangeMove:
            if (indexPath && newIndexPath) {
                [_tableView deleteRowsAtIndexPaths:@[indexPath]
                                  withRowAnimation:UITableViewRowAnimationAutomatic];
                [_tableView insertRowsAtIndexPaths:@[newIndexPath]
                                  withRowAnimation:UITableViewRowAnimationAutomatic];
            }
            break;
            
        default:
            break;
    }
    
}

- (void)controllerDidChangeContent:(NSFetchedResultsController *)controller {
    [self.tableView endUpdates];
}

#pragma mark - UITableViewDataSource Methods

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [_fetchedResultsController.fetchedObjects count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *userReminderTableCellId = @"UserReminderTableCellId";
    UserReminderCell *cell = [tableView dequeueReusableCellWithIdentifier:userReminderTableCellId];
    if (!cell) {
        cell = [[UserReminderCell alloc] initWithStyle:UITableViewCellStyleDefault
                                       reuseIdentifier:userReminderTableCellId];
    }
    id <Reminder> reminder = [_fetchedResultsController.fetchedObjects objectAtIndex:indexPath.row];
    [cell setupWithReminder:reminder];
    return cell;
}

#pragma mark - UITableViewDelegate Methods

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
}

@end
