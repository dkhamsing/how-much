//
//  DKAuthenticationViewController.h
//
//  Created by Daniel Khamsing on 9/30/15.
//  Copyright © 2015 Daniel Khamsing. All rights reserved.
//

#import <UIKit/UIKit.h>

// Protocols
#import "DKAuthenticationProtocol.h"
#import "DKHudProtocol.h"

/** Parse authentication view controller. */
@interface DKAuthenticationViewController : UIViewController

/**
 Authentication.
 */
@property (nonatomic, strong) id<DKAuthenticationProtocol> authentication;

/**
 Input cell background color. The default color is white.
 */
@property (nonatomic, strong) UIColor *cellBackgroundColor;

/**
 Hud to show while user has initiated authentication (optional).
 */
@property (nonatomic, strong) id<DKHudProtocol> hud;

/**
 Hud animation duration in seconds (default value is 0.2 second).
 */
@property (nonatomic) CGFloat hudAnimationDuration;

/**
 Minimum password length.
 */
@property (nonatomic) NSInteger passwordLength;

/**
 Specify whether to enable Twitter.
 */
@property (nonatomic) BOOL twitter;

/**
 Block to execute after successful authentication.
 */
@property (nonatomic, copy) void(^successBlock)(id user, BOOL signup);

@end
