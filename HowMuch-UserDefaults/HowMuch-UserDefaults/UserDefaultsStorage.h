//
//  UserDefaultsStorage.h
//  HowMuch-UserDefaults
//
//  Created by Daniel Khamsing on 6/9/16.
//  Copyright © 2016 Daniel Khamsing. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "StorageProtocol.h"

@interface UserDefaultsStorage : NSObject <StorageProtocol>

- (instancetype)initWithKey:(NSString *)key;

- (void)debugClean;

@end
