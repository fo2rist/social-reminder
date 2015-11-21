//
//  AllRemindersListView.m
//  SocialReminder
//
//  Created by Evgeny Kubrakov on 21/11/15.
//  Copyright © 2015 Streetmage. All rights reserved.
//

#import "AllRemindersListView.h"

@implementation AllRemindersListView

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    
    if (self) {
        
        _searchBar = [[UISearchBar alloc] init];
        _searchBar.barTintColor = DEFAULT_COLOR_DARK;
        [self addSubview:_searchBar];
        
        _segmentedControl = [[StylizedSegmentedControl alloc] initWithItems:@[@"Popular", @"Friends"]];
        [self addSubview:_segmentedControl];
        
        _tableView = [[UITableView alloc] init];
        [self addSubview:_tableView];
        
    }
    
    return self;
}

- (void)layoutSubviews {
    [super layoutSubviews];
    
    [_searchBar setFrame:CGRectMake(0.0f,
                                    0.0f,
                                    self.frame.size.width,
                                    40.0f)];
    
    [_segmentedControl setFrame:CGRectMake(0.0f,
                                           CGRectGetMaxY(_searchBar.frame),
                                           self.frame.size.width,
                                           40.0f)];
    
    CGFloat tableViewTopMargin = CGRectGetMaxY(_segmentedControl.frame);
    [_tableView setFrame:CGRectMake(0.0f,
                                    tableViewTopMargin,
                                    self.frame.size.width,
                                    self.frame.size.height - tableViewTopMargin)];
    
}

@end
