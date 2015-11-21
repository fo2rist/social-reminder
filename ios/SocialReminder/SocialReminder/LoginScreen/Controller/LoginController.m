//
//  LoginController.m
//  SocialReminder
//
//  Created by Evgeny Kubrakov on 21/11/15.
//  Copyright © 2015 Streetmage. All rights reserved.
//

#import "LoginController.h"
#import "LoginView.h"

#import <Contacts/Contacts.h>
#import "Contact.h"

#import "UserRemindersListController.h"

#import "User.h"
#import "AppService.h"

@interface LoginController ()

@property (nonatomic, strong) LoginView *screenView;

@end

@implementation LoginController

- (void)loadView {
    _screenView = [[LoginView alloc] init];
    self.view = _screenView;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [_screenView.loginButton addTarget:self
                                action:@selector(onLoginButtonClick:)
                      forControlEvents:UIControlEventTouchUpInside];
    
    [self.navigationController setNavigationBarHidden:YES];
    
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    [_screenView.loginField becomeFirstResponder];
    
}

#pragma mark - Private Methods

- (void)onLoginButtonClick:(UIButton *)sender {
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];

    [[AppService sharedService] createUserWithPhoneNumber:_screenView.loginField.text
                                               completion:^(BOOL success, NSArray *userEnclosed, NSString *responseString, NSError *error) {
                                                   [MBProgressHUD hideAllHUDsForView:self.view animated:YES];
                                                   if (success) {
                                                   User *user = [userEnclosed firstObject];
                                                   [[NSUserDefaults standardUserDefaults] setObject:user.userId forKey:UIDDefaultsKey];
                                                   CNContactStore *store = [[CNContactStore alloc] init];
                                                   [store requestAccessForEntityType:CNEntityTypeContacts completionHandler:^(BOOL granted, NSError * _Nullable error) {
                                                       if (granted == YES) {
                                                           //keys with fetching properties
                                                           NSArray *keys = @[CNContactFamilyNameKey, CNContactGivenNameKey, CNContactPhoneNumbersKey, CNContactImageDataKey];
                                                           NSString *containerId = store.defaultContainerIdentifier;
                                                           NSPredicate *predicate = [CNContact predicateForContactsInContainerWithIdentifier:containerId];
                                                           NSError *error;
                                                           NSArray *cnContacts = [store unifiedContactsMatchingPredicate:predicate keysToFetch:keys error:&error];
                                                           if (error) {
                                                               NSLog(@"error fetching contacts %@", error);
                                                           } else {
                                                               NSMutableArray *contacts = [NSMutableArray array];
                                                               for (CNContact *contact in cnContacts) {
                                                                   CNLabeledValue *labeledValue = [contact.phoneNumbers firstObject];
                                                                   Contact *newContact = [Contact contactWithFullName:[contact.givenName stringByAppendingString:contact.familyName]
                                                                                                          phoneNumber:[labeledValue.value stringValue]];
                                                                   [contacts addObject:newContact];
                                                               }
                                                               
                                                               [[AppService sharedService] saveContacts:contacts
                                                                                             completion:^(BOOL success, id parsedData, NSString *responseString, NSError *error) {
                                                                                               
                                                                                                 UserRemindersListController *userRemindersController = [[UserRemindersListController alloc] init];
                                                                                                 [self.navigationController setViewControllers:@[userRemindersController] animated:YES];
                                                                                             }];
                                                           }
                                                       }
                                                       else {
                                                          
                                                           UserRemindersListController *userRemindersController = [[UserRemindersListController alloc] init];
                                                           [self.navigationController setViewControllers:@[userRemindersController] animated:YES];
                                                       }
                                                   }];
                                                   }
                                               }];
    


}

@end
