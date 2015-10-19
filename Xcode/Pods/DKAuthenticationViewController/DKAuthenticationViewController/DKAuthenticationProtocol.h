//
//  DKAuthenticationProtocol.h
//
//  Created by Daniel Khamsing on 9/17/15.
//  Copyright © 2015 Daniel Khamsing. All rights reserved.
//

@import Foundation;

/** Authentication protocol. */
@protocol DKAuthenticationProtocol <NSObject>

/**
 Email login.
 @param email Email address.
 @param password Account password.
 @param completion Block to be executed after authentication was initiated.
 */
- (void)loginWithEmail:(NSString *)email password:(NSString *)password completion:(void (^)(id user, NSString *errorMessage))completionBlock;

/**
 Login with Twitter.
 @param twitterId Twitter id.
 @param screeName Twitter screen name.
 @param authToken Auth token.
 @param authTokenSecret Auth token secret.
 @param completion Block to be executed after authentication was initiated.
 */
- (void)loginWithTwitterId:(NSString *)twitterId screenName:(NSString *)screenName authToken:(NSString *)authToken authTokenSecret:(NSString *)authTokenSecret completion:(void (^)(id user, NSString *errorMessage))completionBlock;

/**
 User logout.
 */
- (void)logout;

/**
 Email signup.
 @param email Email address.
 @param password Account password.
 @param password Confirm password.
 @param completion Block to be executed after authentication was initiated.
 */
- (void)signupWithEmail:(NSString *)email password:(NSString *)password completion:(void (^)(id user, NSString *errorMessage))completionBlock;

@end
