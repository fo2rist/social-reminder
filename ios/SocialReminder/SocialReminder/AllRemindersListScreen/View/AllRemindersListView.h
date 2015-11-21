//
//  AllRemindersListView.h
//  SocialReminder
//
//  Created by Evgeny Kubrakov on 21/11/15.
//  Copyright © 2015 Streetmage. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "StylizedSegmentedControl.h"

@interface AllRemindersListView : UIView

@property (nonatomic, strong) UISearchBar *searchBar;
@property (nonatomic, strong) StylizedSegmentedControl *segmentedControl;
@property (nonatomic, strong) UITableView *tableView;

@end
