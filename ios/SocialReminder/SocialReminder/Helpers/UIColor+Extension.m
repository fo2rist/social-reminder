//
//  UIColor+Extension.m
//  INOKeyboard
//
//  Created by Eugeny Kubrakov on 18/09/14.
//  Copyright (c) 2014 inostudio. All rights reserved.
//

#import "UIColor+Extension.h"

@implementation UIColor (Extension)

+ (UIColor *)colorWithHexInt:(NSUInteger)hexColor {
    return [UIColor colorWithHexInt:hexColor alpha:1.0f];
}

+ (UIColor *)colorWithHexInt:(NSUInteger)hexColor alpha:(CGFloat)alpha {
    return [UIColor colorWithRed:((float)((hexColor & 0xFF0000) >> 16))/255.0 green:((float)((hexColor & 0xFF00) >> 8))/255.0 blue:((float)(hexColor & 0xFF))/255.0 alpha:alpha];
}

+ (NSUInteger)hexIntFromColor:(UIColor *)color {
    CGFloat red = 0.0f;
    CGFloat green = 0.0f;
    CGFloat blue = 0.0;
    [color getRed:&red green:&green blue:&blue alpha:nil];
    
    NSUInteger intRed = round(red * 255.0f);
    NSUInteger intGreen = round(green * 255.0f);
    NSUInteger intBlue = round(blue * 255.0f);
    
    NSUInteger hexIntColor = intRed << 16 | intGreen << 8 | intBlue;
    return hexIntColor;
}

@end
