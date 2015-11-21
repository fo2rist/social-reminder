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
                                       NSFontAttributeName : [UIFont fontWithName:@"HelveticaNeue" size:13],
                                       NSShadowAttributeName : shadow}
                            forState:UIControlStateSelected];
        
        [self setTitleTextAttributes:@{NSForegroundColorAttributeName : [UIColor colorWithHexInt:0x84b7b2],
                                       NSFontAttributeName : [UIFont fontWithName:@"HelveticaNeue" size:13],
                                       NSShadowAttributeName : shadow}
                            forState:UIControlStateNormal];
        
        
        [self setBackgroundImage:[UIImage imageNamed:@"segment_selected.png"]
                        forState:UIControlStateSelected
                      barMetrics:UIBarMetricsDefault];
        
        [self setBackgroundImage:[UIImage imageNamed:@"segment_unselected.png"]
                        forState:UIControlStateNormal
                      barMetrics:UIBarMetricsDefault];
        
        [self setBackgroundImage:[UIImage imageNamed:@"segment_unselected.png"]
                        forState:UIControlStateHighlighted
                      barMetrics:UIBarMetricsDefault];
        
        
        self.layer.borderWidth = 1.0f;
        self.layer.borderColor = [UIColor colorWithHexInt:0x355162].CGColor;
        self.layer.cornerRadius = 0.0f;
        self.layer.masksToBounds = YES;
        
        
        [self setDividerImage:[UIImage imageNamed:@"segmented_divider.png"]
          forLeftSegmentState:UIControlStateNormal
            rightSegmentState:UIControlStateNormal
                   barMetrics:UIBarMetricsDefault];
        
        [self setDividerImage:[UIImage imageNamed:@"segmented_divider.png"]
          forLeftSegmentState:UIControlStateSelected
            rightSegmentState:UIControlStateNormal
                   barMetrics:UIBarMetricsDefault];
        
        [self setDividerImage:[UIImage imageNamed:@"segmented_divider.png"]
          forLeftSegmentState:UIControlStateNormal
            rightSegmentState:UIControlStateSelected
                   barMetrics:UIBarMetricsDefault];
        
    }
    
    return self;
}

@end
