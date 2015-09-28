//
//  AuthenticationProtocol.h
//  HowMuch
//
//  Created by Daniel Khamsing on 9/17/15.
//  Copyright © 2015 Daniel Khamsing. All rights reserved.
//

@import Foundation;

@protocol AuthenticationProtocol <NSObject>

- (void)loginWithEmail:(NSString *)email password:(NSString *)password success:(void (^)(NSString *errorMessage))successBlock;

- (void)logout;

- (void)signupWithEmail:(NSString *)email password:(NSString *)password success:(void (^)(NSString *errorMessage))successBlock;

@end
