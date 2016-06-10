//
//  ListController.h
//  HowMuchCore
//
//  Created by Daniel Khamsing on 6/9/16.
//

#import <UIKit/UIKit.h>

#import "DKAuthenticationProtocol.h"
#import "StorageProtocol.h"

@class ListCoordinator;

@interface ListController : UIViewController

@property (nonatomic, strong) ListCoordinator *coordinator;

@end

@interface ListCoordinator : NSObject

@property (nonatomic, strong) UIColor *backgroundColor;

@property (nonatomic, strong) NSArray *items;

@property (nonatomic) BOOL overrideSignIn;

@property (nonatomic) BOOL signedIn;

@property (nonatomic, strong) NSString *title;

@property (nonatomic, strong) NSString *unit;

+ (instancetype)coreViewModel;

// protocols

@property (nonatomic) id <DKAuthenticationProtocol> auth;

@property (nonatomic, strong) id <StorageProtocol> storage;

@end
