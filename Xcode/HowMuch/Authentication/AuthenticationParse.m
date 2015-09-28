//
//  AuthenticationParse.m
//  HowMuch
//
//  Created by Daniel Khamsing on 9/17/15.
//  Copyright © 2015 Daniel Khamsing. All rights reserved.
//

#import "AuthenticationParse.h"

// Frameworks
#import <Parse/Parse.h>

@implementation AuthenticationParse

- (void)loginWithEmail:(NSString *)email password:(NSString *)password success:(void (^)(NSString *))successBlock {
    [PFUser logInWithUsernameInBackground:email password:password block:^(PFUser * _Nullable user, NSError * _Nullable error) {
        if (error) {
            NSString *message = @"Invalid email / password combination, please try again.";
            successBlock(message);
        }
        else {
            successBlock(nil);
        }
    }];
}

- (void)logout {
    [PFUser logOut];
}

- (void)signupWithEmail:(NSString *)email password:(NSString *)password success:(void (^)(NSString *))successBlock {
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
            
            successBlock(message);
        }
        else {
            successBlock(nil);
        }
    }];
}

@end
