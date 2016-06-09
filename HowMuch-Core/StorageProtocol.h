//
//  StorageProtocol.h
//  HowMuchCore
//
//  Created by Daniel Khamsing on 6/9/16.
//

#import <Foundation/Foundation.h>

@protocol StorageProtocol <NSObject>

- (void)deleteItem:(id)item completion:(void (^)(NSError *error))completion;

- (void)saveItem:(id)item completion:(void (^)(NSError *))completion;

- (void)updateItem:(id)item withValue:(NSDictionary *)value completion:(void (^)(NSError *))completion;

- (NSDictionary *)valuesForItem:(id)item;

@optional

- (void)loadItemsWithCompletion:(void (^)(NSArray *items))completion;

- (void)setupListenerWithCompletion:(void (^)(NSArray *items))completion;

@end
