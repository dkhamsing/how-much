//
//  UIViewController+HM.h
//  HowMuch
//
//  Created by Daniel Khamsing on 9/25/15.
//  Copyright © 2015 Daniel Khamsing. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIViewController (HM)

- (NSString *)hm_combinedInputFromControlInput:(NSString *)input shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string;

@end
