//
//  ParseStorage.m
//  HowMuch-Parse
//
//  Created by Daniel Khamsing on 6/10/16.
//  Copyright © 2016 Daniel Khamsing. All rights reserved.
//

#import "ParseStorage.h"

#import <Parse/Parse.h>

@implementation ParseStorage

static NSString * const itemClassName = @"Item";

static NSString * const hm_key_Name = @"name";
static NSString * const hm_key_Brand = @"brand";
static NSString * const hm_key_Price = @"price";
static NSString * const hm_key_Store = @"store";
static NSString * const hm_key_Unit = @"unit";

- (void)deleteItem:(PFObject *)item completion:(void (^)(NSError *error))completion;
{
    [item deleteInBackgroundWithBlock:^(BOOL succeeded, NSError * _Nullable error) {
        if (succeeded) {
            if (completion) {
                completion(nil);
            }
        }
        else {
            if (completion) {
                completion(error);
            }
        }
    }];
}

- (void)saveItem:(NSDictionary *)item completion:(void (^)(NSError *))completion;
{
    PFObject *parseItem = [PFObject objectWithClassName:itemClassName];
    
    parseItem[@"userId"]    = [PFUser currentUser].objectId;
    NSDictionary *values = item.allValues.firstObject;
    parseItem[hm_key_Name]  = values[hm_key_Name];
    parseItem[hm_key_Brand] = values[hm_key_Brand];
    parseItem[hm_key_Store] = values[hm_key_Store];
    parseItem[hm_key_Price] = values[hm_key_Price];
    parseItem[hm_key_Unit]  = values[hm_key_Unit];
    
    [parseItem saveInBackgroundWithBlock:^(BOOL succeeded, NSError * _Nullable error) {
        dispatch_async(dispatch_get_main_queue(), ^{
            completion(succeeded?nil:error);
        });
    }];
}

- (void)updateItem:(PFObject *)parseItem withValue:(NSDictionary *)values completion:(void (^)(NSError *))completion;
{
    parseItem[hm_key_Name]  = values[hm_key_Name];
    parseItem[hm_key_Brand] = values[hm_key_Brand];
    parseItem[hm_key_Store] = values[hm_key_Store];
    parseItem[hm_key_Price] = values[hm_key_Price];
    parseItem[hm_key_Unit]  = values[hm_key_Unit];
    
    [parseItem saveInBackgroundWithBlock:^(BOOL succeeded, NSError * _Nullable error) {
        completion(succeeded?nil:error);
    }];
}

- (NSDictionary *)valuesForItem:(PFObject *)item;
{
    NSMutableDictionary *values = [NSMutableDictionary new];
    [item.allKeys enumerateObjectsUsingBlock:^(NSString * _Nonnull key, NSUInteger idx, BOOL * _Nonnull stop) {
        values[key] = item[key];
    }];
    
    return values;
}

- (void)loadItemsWithCompletion:(void (^)(NSArray *items))completion;
{
    PFQuery *query = [PFQuery queryWithClassName:itemClassName];
    query.cachePolicy = kPFCachePolicyNetworkElseCache;
    [query whereKey:@"userId" equalTo:[PFUser currentUser].objectId];
    [query findObjectsInBackgroundWithBlock:^(NSArray * _Nullable objects, NSError * _Nullable error) {            
        NSArray *sorted = [objects sortedArrayUsingComparator:^NSComparisonResult(PFObject *a, PFObject *b) {
            NSString *first = a[hm_key_Name];
            NSString *second = b[hm_key_Name];
            return [first compare:second options:NSCaseInsensitiveSearch];
        }].mutableCopy;
        
        completion(sorted);
    }];
}

@end
