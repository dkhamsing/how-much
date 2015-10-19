//
//  DKParseAuth.h
//
//  Created by Daniel Khamsing on 9/30/15.
//  Copyright © 2015 Daniel Khamsing. All rights reserved.
//


@import UIKit;

// Protocols
#import "DKHudProtocol.h"

/** Simple Parse Authentication. */
@interface DKParseAuth : NSObject

/**
 Input cell background color (optional).
 */
@property (nonatomic, strong) UIColor *cellBackgroundColor;

/**
 Shared instance.
 @return Shared instance.
 */
+ (instancetype)sharedInstance;

/**
 Configure Parse.
 @param parseClientId Client id.
 @param parseClientKey Client key.
 */
- (void)configureWithParseClientId:(NSString *)parseClientId parseClientKey:(NSString *)parseClientKey;

/**
 Configure Twitter (optional).
 @param twitterConsumerKey Consumer key.
 @param twitterConsumerSecret Consumer secret.
 */
- (void)configureWithTwitterConsumerKey:(NSString *)twitterConsumerKey twitterConsumerSecret:(NSString *)twitterConsumerSecret;

/**
 Returns a view controller for Parse authentication (sign in, sign up).
 @param passwordLength Minimum password length.
 @param hud Hud object that implements the hud protocol (use `nil` for no hud).
 @param sucessBlock Block to execute on auth success with one argument that specifies if the user has signed up.
 */
- (UIViewController *)authViewControllerWithPasswordLength:(NSInteger)passwordLength hud:(id<DKHudProtocol>)hud successBlock:(void (^)(id user, BOOL signup))successBlock;

/**
 Returns a view controller for Parse authentication with no hud.
 */
- (id<DKHudProtocol>)hud;

/**
 Specifies whether the user is authenticated with Parse.
 @return Boolean that specifies if the user is authenticated.
 */
- (BOOL)authenticated;

/**
 Log the user out.
 */
- (void)logout;

@end
