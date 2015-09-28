//
//  UIColor+TD.m
//
//  Copyright (c) 2015 Daniel Khamsing. All rights reserved.
//

#import "UIColor+HM.h"

@implementation UIColor (HM)

+ (UIColor *)hm_tintColor {
    return [UIColor dk_colorWithHexString:@"8EB897"];
}


+ (UIColor *)hm_lightColor {
    return [UIColor dk_colorWithHexString:@"C3E8BD"];
}

#pragma mark Private

+ (UIColor *)dk_colorWithHexString:(NSString *)hexString {
    hexString = [hexString stringByReplacingOccurrencesOfString:@"#" withString:@""];
    unsigned rgbValue = 0;
    NSScanner *scanner = [NSScanner scannerWithString:hexString];
    [scanner setScanLocation:0];
    [scanner scanHexInt:&rgbValue];
    return [UIColor colorWithRed:((rgbValue & 0xFF0000) >> 16)/255.0 green:((rgbValue & 0xFF00) >> 8)/255.0 blue:(rgbValue & 0xFF)/255.0 alpha:1.0];
}

@end
