//
//  FirebaseStorage.m
//  HowMuch-Firebase
//
//  Created by Daniel Khamsing on 6/9/16.
//  Copyright © 2016 Daniel Khamsing. All rights reserved.
//

#import "FirebaseStorage.h"
@import Firebase;

@implementation FirebaseStorage

- (void)deleteItem:(FIRDataSnapshot *)item completion:(void (^)(NSError *error))completion;
{
    [item.ref removeValue];
    
    if (completion) {
        completion(nil);
    }
}

- (void)saveItem:(NSDictionary *)item completion:(void (^)(NSError *))completion;
{
    FIRDatabaseReference *itemsRef = [FirebaseStorage itemsRef];
    
    NSString *uuid = item.allKeys.firstObject;
    FIRDatabaseReference *newItemRef = [itemsRef child:uuid];
    
    [newItemRef setValue:item.allValues.firstObject];
    
    if (completion) {
        completion(nil);
    }
}

- (void)updateItem:(FIRDataSnapshot *)item withValue:(NSDictionary *)value completion:(void (^)(NSError *))completion
{
    [item.ref updateChildValues:value];
    
    if (completion) {
        completion(nil);
    }
}

- (NSDictionary *)valuesForItem:(FIRDataSnapshot *)item;
{
    return item.value;
}

- (void)setupListenerWithCompletion:(void (^)(NSArray *))completion;
{
    FIRDatabaseReference *itemsRef = [FirebaseStorage itemsRef];
    [itemsRef observeEventType:FIRDataEventTypeValue withBlock:^(FIRDataSnapshot * _Nonnull snapshot) {
        NSMutableArray *list = [NSMutableArray new];
        
        for (FIRDataSnapshot *snap in snapshot.children) {
            [list addObject:snap];
        }
        
        NSArray *items = [list sortedArrayUsingComparator:^NSComparisonResult(FIRDataSnapshot *a, FIRDataSnapshot *b) {
            NSString *first = a.value[@"name"];
            NSString *second = b.value[@"name"];
            return [first compare:second options:NSCaseInsensitiveSearch];
        }].mutableCopy;
        
        if (completion) {
            completion(items);
        }
    }];
}

#pragma mark Private

+ (FIRDatabaseReference *)itemsRef;
{
    FIRDatabaseReference *rootRef = [[FIRDatabase database] reference];
    
    NSString *userId = [FIRAuth auth].currentUser.uid;
    FIRDatabaseReference *itemsRef = [rootRef child:userId];
    
    return itemsRef;
}

@end
