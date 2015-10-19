//
//  DKParseAuth.m
//
//  Created by Daniel Khamsing on 9/30/15.
//  Copyright © 2015 Daniel Khamsing. All rights reserved.
//

#import "DKParseAuth.h"

// Auth
#import "DKAuthenticationParse.h"

// Controllers
#import "DKAuthenticationViewController.h"

// Hud
#import "DKHud.h"

// Parse
#import <Parse/Parse.h>

// Twitter
#import "DKTwitterReverseAuth.h"
#import "ParseTwitterUtils.h"

@interface DKParseAuth ()

@property (nonatomic) BOOL twitter;

@end

@implementation DKParseAuth

+ (instancetype)sharedInstance;
{
    static id _sharedInstance = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _sharedInstance = [[self alloc] init];
    });
    
    return _sharedInstance;
}

- (void)configureWithParseClientId:(NSString *)parseClientId parseClientKey:(NSString *)parseClientKey;
{
    [Parse setApplicationId:parseClientId clientKey:parseClientKey];
}

- (void)configureWithTwitterConsumerKey:(NSString *)twitterConsumerKey twitterConsumerSecret:(NSString *)twitterConsumerSecret;
{
    [[DKTwitterReverseAuth sharedInstance] configureConsumerKey:twitterConsumerKey consumerSecret:twitterConsumerSecret];
    [PFTwitterUtils initializeWithConsumerKey:twitterConsumerKey consumerSecret:twitterConsumerSecret];
    self.twitter = YES;
}

- (UIViewController *)authViewControllerWithPasswordLength:(NSInteger)passwordLength hud:(id<DKHudProtocol>)hud successBlock:(void (^)(id user, BOOL signup))successBlock;
{
    return ({
        DKAuthenticationViewController *controller = [[DKAuthenticationViewController alloc] init];
        controller.authentication = [[DKAuthenticationParse alloc] init];
        controller.passwordLength = passwordLength;
        controller.hud = hud;
        controller.twitter = self.twitter;
        controller.successBlock = successBlock;
        controller.cellBackgroundColor = self.cellBackgroundColor;
        UINavigationController *navigationController = [[UINavigationController alloc] initWithRootViewController:controller];
        navigationController;
    });
}

- (id<DKHudProtocol>)hud;
{
    return (id<DKHudProtocol>)[[DKHud alloc] initWithDefaultStyleAndBlockUserInteraction:YES];
}

- (BOOL)authenticated;
{
    return [PFUser currentUser] != nil;
}

- (void)logout;
{
    id <DKAuthenticationProtocol> authentication = [[DKAuthenticationParse alloc] init];;
    [authentication logout];
}

@end
