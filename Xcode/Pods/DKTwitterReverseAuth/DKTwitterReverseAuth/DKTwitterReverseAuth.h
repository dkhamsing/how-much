//
//  DKTwitterReverseAuth.h
//
//  Created by Daniel Khamsing on 9/30/15.
//  Copyright © 2015 Daniel Khamsing. All rights reserved.
//

@import Foundation;

static NSString const * tw_key_oauth_token = @"oauth_token";
static NSString const * tw_key_oauth_token_secret = @"oauth_token_secret";
static NSString const * tw_key_user_id = @"user_id";
static NSString const * tw_key_screen_name = @"screen_name";

@class ACAccount;

/** Twitter reverse auth. */
@interface DKTwitterReverseAuth : NSObject

/**
  Twitter consumer key.
*/
@property (nonatomic, strong) NSString *consumerKey;

/**
  Twitter consumer secret.
*/
@property (nonatomic, strong) NSString *consumerSecret;

/**
 😢 Shared instance.
 @return Shared instance.
 */
+ (instancetype)sharedInstance;

/**
 Configures DKTwitterReverseAuth.
 @param consumerKey Twitter consumer key.
 @param consumerSecret Twitter consumer secret.
 */
- (void)configureConsumerKey:(NSString *)consumerKey consumerSecret:(NSString *)consumerSecret;

/**
 Perform Twitter reverse auth.
 @param account System Twitter account.
 @param handler Completion handler that is called after reverse auth is performed (it returns on the main thread).
 */
- (void)performReverseAuthForAccount:(ACAccount *)account withHandler:(void (^)(NSDictionary *jsonResponse, NSError *error))handler;

@end
