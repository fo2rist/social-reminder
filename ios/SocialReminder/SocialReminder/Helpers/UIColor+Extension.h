//
//  UIColor+Extension.h
//  INOKeyboard
//
//  Created by Eugeny Kubrakov on 18/09/14.
//  Copyright (c) 2014 inostudio. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIColor (Extension)

+ (UIColor *)colorWithHexInt:(NSUInteger)hexColor;

+ (UIColor *)colorWithHexInt:(NSUInteger)hexColor alpha:(CGFloat)alpha;

+ (NSUInteger)hexIntFromColor:(UIColor *)color;

@end
