//
//  AuthenticationController.h
//  HowMuch
//
//  Created by Daniel Khamsing on 9/17/15.
//  Copyright © 2015 Daniel Khamsing. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "AuthenticationProtocol.h"

@interface AuthenticationController : UIViewController

@property (nonatomic, strong) id<AuthenticationProtocol> authentication;

@end
