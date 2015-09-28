//
//  DKTwitterReverseAuth.m
//
//  Created by Daniel Khamsing on 9/30/15.
//  Copyright © 2015 Daniel Khamsing. All rights reserved.
//

#import "DKTwitterReverseAuth.h"
#import "DKAPIManager.h"

@interface DKTwitterReverseAuth ()

@property (nonatomic, strong) DKAPIManager *apiManager;

@end

@implementation DKTwitterReverseAuth

+ (instancetype)sharedInstance {
    static id _sharedInstance = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _sharedInstance = [[self alloc] init];
    });

    return _sharedInstance;
}

- (instancetype)init {
  self = [super init];

  // Init
  self.apiManager = [[DKAPIManager alloc] init];

  return self;
}

- (void)configureConsumerKey:(NSString *)consumerKey consumerSecret:(NSString *)consumerSecret {
    self.consumerKey = consumerKey;
    self.consumerSecret = consumerSecret;
}

- (void)performReverseAuthForAccount:(ACAccount *)account withHandler:(void (^)(NSDictionary *, NSError *))handler {
    [self.apiManager performReverseAuthForAccount:account withHandler:^(NSData *responseData, NSError *error) {
        if (responseData) {
            NSMutableDictionary *json = [[NSMutableDictionary alloc] init];
            for (NSString *part in ({
                NSString *responseStr = [[NSString alloc] initWithData:responseData encoding:NSUTF8StringEncoding];
                NSArray *parts = [responseStr componentsSeparatedByString:@"&"];
                parts;
            })) {
                NSArray *keyValue = [part componentsSeparatedByString:@"="];
                json[keyValue.firstObject] = keyValue[1];
            }

            if (handler) {
                handler(json, nil);
            }
        }
        else {
            if (handler) {
                handler(nil, error);
            }
        }
    }];
}

@end
