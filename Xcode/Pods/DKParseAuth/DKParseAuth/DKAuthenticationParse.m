//
//  DKAuthenticationParse.m
//
//  Created by Daniel Khamsing on 9/17/15.
//  Copyright © 2015 Daniel Khamsing. All rights reserved.
//

#import "DKAuthenticationParse.h"

// Parse
#import <Parse/Parse.h>
#import "ParseTwitterUtils.h"

@implementation DKAuthenticationParse

- (void)loginWithEmail:(NSString *)email password:(NSString *)password completion:(void (^)(id, NSString *))completionBlock;
{
    [PFUser logInWithUsernameInBackground:email password:password block:^(PFUser * _Nullable user, NSError * _Nullable error) {
        if (error) {
            NSString *message = @"Invalid email / password combination, please try again.";
            completionBlock(nil, message);
        }
        else {
            completionBlock(user, nil);
        }
    }];
}

- (void)loginWithTwitterId:(NSString *)twitterId screenName:(NSString *)screenName authToken:(NSString *)authToken authTokenSecret:(NSString *)authTokenSecret completion:(void (^)(id, NSString *))completionBlock;
{
    [PFTwitterUtils logInWithTwitterId:twitterId screenName:screenName authToken:authToken authTokenSecret:authTokenSecret block:^(PFUser * _Nullable user, NSError * _Nullable error) {
        if (error) {
            NSString *message = @"There was a Twitter login error.";
            completionBlock(nil, message);
        }
        else {
            completionBlock(user, nil);
        }
    }];
}

- (void)logout {
    [PFUser logOutInBackground];
}

- (void)signupWithEmail:(NSString *)email password:(NSString *)password completion:(void (^)(id, NSString *))completionBlock;
{
    PFUser *user = [PFUser user];
    user.username = email;
    user.email = user.username;
    user.password = password;
    
    [user signUpInBackgroundWithBlock:^(BOOL succeeded, NSError * _Nullable error) {
        if (error) {
            NSString *message = @"There was an error, please try again.";
            
            if (error.code==202)
                message = @"The username is already taken, please choose another.";
            
            if (error.code==125)
                message = @"Invalid email address, please try again.";
            
            completionBlock(nil, message);
        }
        else {
            completionBlock(user, nil);
        }
    }];
}

@end
