//
//  UIViewController+HM.m
//  HowMuch
//
//  Created by Daniel Khamsing on 9/25/15.
//  Copyright © 2015 Daniel Khamsing. All rights reserved.
//

#import "UIViewController+HM.h"

@implementation UIViewController (HM)

- (NSString *)hm_combinedInputFromControlInput:(NSString *)input shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string;
{
    NSString *combined = [string isEqualToString:@""] ?
    [input stringByReplacingOccurrencesOfString:[input substringWithRange:range] withString:string]:({
        NSString *text = [input substringToIndex:range.location];
        text = [text stringByAppendingString:string];
        text = [text stringByAppendingString: [input substringFromIndex:range.location+range.length] ];
    });
    
    return combined;
}

@end
