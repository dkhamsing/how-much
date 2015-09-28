//
//  DataStorageProtocol.h
//  HowMuch
//
//  Created by Daniel Khamsing on 9/17/15.
//  Copyright © 2015 Daniel Khamsing. All rights reserved.
//

@import Foundation;

// Models
#import "Item.h"

@protocol DataStorageProtocol <NSObject>

- (void)debugClearItems;

- (void)deleteItem:(Item *)item success:(void (^)(NSError *error))successBlock;

- (void)loadItemWithSuccess:(void (^)(NSArray *))successBlock;

- (void)saveItem:(Item *)item success:(void (^)(NSError *))successBlock;

- (void)updateItem:(Item *)item success:(void (^)(NSError *))successBlock;

@end
