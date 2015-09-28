//
//  DataStorageUserDefaults.m
//
//
//  Created by Daniel Khamsing on 9/17/15.
//
//

#import "DataStorageUserDefaults.h"

@implementation DataStorageUserDefaults

static NSString * const hm_userDefaults = @"hm_userDefaults";

static const BOOL logging = NO;

- (void)debugClearItems;
{
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    [defaults removeObjectForKey:hm_userDefaults];
    [defaults synchronize];
}

- (void)deleteItem:(Item *)item success:(void (^)(NSError *))successBlock
{
    NSArray *list = [self loadItems];
    
    NSMutableArray *mutable = list.mutableCopy;
    
    if (!mutable && ![mutable containsObject:item] && logging) {
        NSLog(@"error updating item: %@", item);
        return;
    }
    
    NSInteger index = [mutable indexOfObject:item];
    [mutable removeObjectAtIndex:index];
    
    [self saveList:mutable];
    
    successBlock(nil);
}

- (NSArray *)loadItems;
{
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    
    if (![defaults objectForKey:hm_userDefaults])
        return nil;
    
    NSData *data = [defaults objectForKey:hm_userDefaults];
    
    NSArray *list = [NSKeyedUnarchiver unarchiveObjectWithData:data];
    
    return list;
}

- (void)loadItemWithSuccess:(void (^)(NSArray *))successBlock;
{
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    
    if (![defaults objectForKey:hm_userDefaults]) {
        successBlock(nil);
        return;
    }
    
    NSData *data = [defaults objectForKey:hm_userDefaults];
    if (!data) {
        successBlock(nil);
    }
    else {
        NSArray *list = [NSKeyedUnarchiver unarchiveObjectWithData:data];
        successBlock(list);
    }
}

- (void)saveItem:(Item *)item success:(void (^)(NSError *))successBlock
{
    NSArray *list = [self loadItems];
    
    NSMutableArray *mutable = list.mutableCopy;
    
    if (!mutable) {
        mutable = [[NSMutableArray alloc] init];
    }
    
    [mutable addObject:item];
    
    [self saveList:mutable];
    
    if (logging)
        NSLog(@"saved %@", mutable);
    
    successBlock(nil);
}

- (void)updateItem:(Item *)item success:(void (^)(NSError *))successBlock
{
    NSArray *list = [self loadItems];
    
    NSMutableArray *mutable = list.mutableCopy;
    
    if (!mutable && ![mutable containsObject:item] && logging) {
        NSLog(@"error updating item: %@", item);
        return;
    }
    
    NSInteger index = [mutable indexOfObject:item];
    mutable[index] = item;
    
    [self saveList:mutable];
    
    successBlock(nil);
}

- (void)saveList:(NSArray *)list {
    NSArray *sorted = [list sortedArrayUsingComparator:^NSComparisonResult(Item *obj1, Item *obj2) {
        return [obj1.name compare:obj2.name];
    }];
    
    {
        NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
        NSData *data = [NSKeyedArchiver archivedDataWithRootObject:sorted];
        [defaults setObject:data forKey:hm_userDefaults];
        [defaults synchronize];
    }
}

@end
