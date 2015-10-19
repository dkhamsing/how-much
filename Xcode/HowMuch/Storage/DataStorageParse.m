//
//  DataStorageParse.m
//  HowMuch
//
//  Created by Daniel Khamsing on 9/17/15.
//  Copyright © 2015 Daniel Khamsing. All rights reserved.
//

#import "DataStorageParse.h"

// Frameworks
#import <Parse/Parse.h>

@implementation DataStorageParse

static NSString * const itemClassName = @"Item";

static BOOL logging = NO;

- (void)debugClearItems;
{
    
}

- (void)deleteItem:(Item *)item success:(void (^)(NSError *error))successBlock;
{
    PFQuery *query = [PFQuery queryWithClassName:itemClassName];
    [query getObjectInBackgroundWithId:item.itemId block:^(PFObject * _Nullable parseItem, NSError * _Nullable error) {
        if (error) {
            if (successBlock) {
                successBlock(error);
            }
        }
        else {
            [parseItem deleteInBackgroundWithBlock:^(BOOL succeeded, NSError * _Nullable error) {
                if (succeeded) {
                    if (successBlock) {
                        successBlock(nil);
                    }
                }
                else {
                    if (successBlock) {
                        successBlock(error);
                    }
                }
            }];
        }
    }];
}

- (void)loadItemWithSuccess:(void (^)(NSArray *))successBlock
{
    NSDate *date;
    if (logging) {
        date = [NSDate date];
    }
    
    PFQuery *query = [PFQuery queryWithClassName:itemClassName];
    query.cachePolicy = kPFCachePolicyNetworkElseCache;
    [query whereKey:@"userId" equalTo:[PFUser currentUser].objectId];
    [query findObjectsInBackgroundWithBlock:^(NSArray * _Nullable objects, NSError * _Nullable error) {
        NSMutableArray *list = [[NSMutableArray alloc] init];
        
        for (PFObject *object in objects) {
            Item *item = [[Item alloc] init];
            
            item.itemId = object.objectId;
            item.name = object[hm_key_Name];
            item.price = object[hm_key_Price];
            item.store = object[hm_key_Store];
            item.unit = object[hm_key_Unit];
            
            [list addObject:item];
        }
        
        if (logging) {
            NSLog( @"parse load items time: %@ s",
                  @(-[date timeIntervalSinceNow]) );
        }
        
        NSSortDescriptor *descriptor = [[NSSortDescriptor alloc]initWithKey:@"name" ascending:YES selector:@selector(caseInsensitiveCompare:)];
        NSArray *sorted = [list sortedArrayUsingDescriptors:@[descriptor]];
        successBlock(sorted);
    }];
}

- (void)saveItem:(Item *)item success:(void (^)(NSError *))successBlock
{
    PFObject *parseItem = [PFObject objectWithClassName:itemClassName];
    
    parseItem[hm_key_Name] = item.name;
    parseItem[hm_key_Store] = item.store;
    parseItem[hm_key_Price] = item.price;
    parseItem[hm_key_Unit] = item.unit;
    
    parseItem[@"userId"] = [PFUser currentUser].objectId;
    
    [parseItem saveInBackgroundWithBlock:^(BOOL succeeded, NSError * _Nullable error) {
        dispatch_async(dispatch_get_main_queue(), ^{
            successBlock(succeeded?nil:error);
        });
    }];
}

- (void)updateItem:(Item *)item success:(void (^)(NSError *))successBlock
{
    PFQuery *query = [PFQuery queryWithClassName:itemClassName];
    [query getObjectInBackgroundWithId:item.itemId block:^(PFObject * _Nullable parseItem, NSError * _Nullable error) {
        if (error) {
            successBlock(error);
        }
        else {
            parseItem[hm_key_Name] = item.name;
            parseItem[hm_key_Price] = item.price;
            parseItem[hm_key_Store] = item.store;
            parseItem[hm_key_Unit] = item.unit;
            
            [parseItem saveInBackgroundWithBlock:^(BOOL succeeded, NSError * _Nullable error) {
                successBlock(succeeded?nil:error);
            }];
        }
    }];
}

@end
