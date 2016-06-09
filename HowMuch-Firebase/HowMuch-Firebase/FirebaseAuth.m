//
//  FirebaseAuth.m
//  HowMuch-Firebase
//
//  Created by Daniel Khamsing on 6/9/16.
//  Copyright © 2016 Daniel Khamsing. All rights reserved.
//

#import "FirebaseAuth.h"

@import Firebase;

@implementation FirebaseAuth

- (void)loginWithEmail:(NSString *)email password:(NSString *)password completion:(void (^)(id, NSString *))completionBlock;
{
    [[FIRAuth auth] signInWithEmail:email password:password completion:^(FIRUser * _Nullable user, NSError * _Nullable error) {
        if (completionBlock) {
            completionBlock(user, error.localizedDescription);
        }
    }];
}

- (void)loginWithTwitterId:(NSString *)twitterId screenName:(NSString *)screenName authToken:(NSString *)authToken authTokenSecret:(NSString *)authTokenSecret completion:(void (^)(id, NSString *))completionBlock;
{
    NSLog(@"TODO");
}

- (void)logout;
{
    NSError *error;
    [[FIRAuth auth] signOut:&error];
}

- (void)signupWithEmail:(NSString *)email password:(NSString *)password completion:(void (^)(id, NSString *))completionBlock;
{
    [[FIRAuth auth]
     createUserWithEmail:email
     password:password
     completion:^(FIRUser *_Nullable user,
                  NSError *_Nullable error) {
         if (completionBlock) {
             completionBlock(user, error.localizedDescription);
         }
     }];
}

@end
