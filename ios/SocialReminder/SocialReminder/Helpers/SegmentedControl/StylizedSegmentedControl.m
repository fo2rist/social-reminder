//
//  StylizedSegmentedControl.m
//  Network
//
//  Created by Eugeny Kubrakov on 03/03/15.
//  Copyright (c) 2015 Ivan Sykhov. All rights reserved.
//

#import "StylizedSegmentedControl.h"

@implementation StylizedSegmentedControl

- (id)initWithItems:(NSArray *)items {
    self = [super initWithItems:items];
    
    if (self) {
        
        NSShadow * shadow = [[NSShadow alloc] init];
        shadow.shadowColor = [UIColor clearColor];
        [shadow setShadowOffset:CGSizeZero];
        
        [self setTitleTextAttributes:@{NSForegroundColorAttributeName : [UIColor whiteColor],
                                       NSFontAttributeName : [UIFont fontWithName:@"HelveticaNeue" size:16],
                                       NSShadowAttributeName : shadow}
                            forState:UIControlStateSelected];
        
        [self setTitleTextAttributes:@{NSForegroundColorAttributeName : [UIColor whiteColor],
                                       NSFontAttributeName : [UIFont fontWithName:@"HelveticaNeue" size:16],
                                       NSShadowAttributeName : shadow}
                            forState:UIControlStateNormal];
        
        
        [self setBackgroundImage:[UIImage imageNamed:@"SelectedSegment"]
                        forState:UIControlStateSelected
                      barMetrics:UIBarMetricsDefault];
        
        [self setBackgroundImage:[UIImage imageNamed:@"UnselectedSegment"]
                        forState:UIControlStateNormal
                      barMetrics:UIBarMetricsDefault];
        
        [self setBackgroundImage:[UIImage imageNamed:@"UnselectedSegment"]
                        forState:UIControlStateHighlighted
                      barMetrics:UIBarMetricsDefault];
        
        
        [self setDividerImage:[UIImage imageNamed:@"Divider"]
          forLeftSegmentState:UIControlStateNormal
            rightSegmentState:UIControlStateNormal
                   barMetrics:UIBarMetricsDefault];
        
        [self setDividerImage:[UIImage imageNamed:@"Divider"]
          forLeftSegmentState:UIControlStateSelected
            rightSegmentState:UIControlStateNormal
                   barMetrics:UIBarMetricsDefault];
        
        [self setDividerImage:[UIImage imageNamed:@"Divider"]
          forLeftSegmentState:UIControlStateNormal
            rightSegmentState:UIControlStateSelected
                   barMetrics:UIBarMetricsDefault];
        
    }
    
    return self;
}

@end
