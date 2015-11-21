//
//  LoginController.m
//  SocialReminder
//
//  Created by Evgeny Kubrakov on 21/11/15.
//  Copyright © 2015 Streetmage. All rights reserved.
//

#import "LoginController.h"
#import "LoginView.h"

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
                                                       UserRemindersListController *userRemindersController = [[UserRemindersListController alloc] init];
                                                       [self.navigationController setViewControllers:@[userRemindersController] animated:YES];
                                                   }
                                               }];
}

@end
