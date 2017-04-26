//
//  RealmStorage.m
//  HowMuch-Realm
//
//  Created by dkhamsing on 4/25/17.
//  Copyright © 2017 dkhamsing. All rights reserved.
//

#import "RealmStorage.h"

#import <Realm/Realm.h>

@interface Item : RLMObject

@property  NSString *itemId;

@property NSString *brand;

@property NSInteger dateUpdated;

@property NSString *name;

@property double price;

@property NSString *store;

@property NSString *unit;

@end

@implementation Item

@end

@implementation RealmStorage

- (void)debugClean;
{
    [[NSFileManager defaultManager] removeItemAtURL:[RLMRealmConfiguration defaultConfiguration].fileURL error:nil];
}

- (void)deleteItem:(id)item completion:(void (^)(NSError *))completion
{
    RLMRealm *realm = [RLMRealm defaultRealm];
    
    [realm beginWriteTransaction];
    [realm deleteObject:item];
    [realm commitWriteTransaction];
    
    if (completion)
        completion(nil);
}

- (void)saveItem:(id)item completion:(void (^)(NSError *))completion;
{
    NSDictionary *d = item;
    NSString *itemId = d.allKeys.firstObject;
    NSDictionary *v = d.allValues.firstObject;
    
    NSString *brand = v[@"brand"];

    NSInteger dateUpdated = [NSDate new].timeIntervalSince1970;
    
    NSString *name = v[@"name"];
    
    NSNumber *p = v[@"price"];
    double price = p.doubleValue;

    NSString *store = v[@"store"];
    
    NSString *unit = v[@"unit"];
    
    Item *i = [Item new];
    i.itemId = itemId;
    i.brand = brand?:@"";
    i.dateUpdated = dateUpdated;
    i.name = name;
    i.price = price;
    i.store = store?:@"";
    i.unit = unit?:@"";
    
    RLMRealm *realm = [RLMRealm defaultRealm];

    [realm beginWriteTransaction];
    [realm addObject:i];
    [realm commitWriteTransaction];
    
    if (completion)
        completion(nil);
}

- (void)updateItem:(id)item withValue:(NSDictionary *)v completion:(void (^)(NSError *))completion;
{    
    NSString *brand = v[@"brand"];
    
    NSString *name = v[@"name"];
    
    NSInteger dateUpdated = [NSDate new].timeIntervalSince1970;
    
    NSNumber *p = v[@"price"];
    double price = p.doubleValue;
    
    NSString *store = v[@"store"];
    
    NSString *unit = v[@"unit"];
    
    Item *i = item;
    
    RLMRealm *realm = [RLMRealm defaultRealm];
    
    [realm beginWriteTransaction];

    i.brand = [RealmStorage _safeString:brand];
    i.dateUpdated = dateUpdated;
    i.name = name;
    i.price = price;
    i.store = [RealmStorage _safeString:store];
    i.unit = [RealmStorage _safeString:unit];

    [realm commitWriteTransaction];
    
    if (completion)
        completion(nil);
}

- (NSDictionary *)valuesForItem:(id)item;
{
    Item *o = item;
    NSString *brand = o.brand;
    
    NSString *name = o.name;
    
    double p = o.price;
    NSNumber *price = @(p);
    
    NSString *store = o.store;
    
    NSString *unit = o.unit;
    
    return @{
             @"brand":brand?:@"",
             @"name":name?:@"",
             @"price":price,
             @"store":store?:@"",
             @"unit":unit?:@""
             };
}

- (void)loadItemsWithCompletion:(void (^)(NSArray *items))completion;
{
    RLMRealm *r = [RLMRealm defaultRealm];
    RLMResults *realmResults = [Item allObjectsInRealm:r];
    
    NSArray *results = (NSArray *)realmResults;
    if (completion)
        completion(results);
}

#pragma mark Private

+ (NSString *)_safeString:(id)string;
{
    return string == [NSNull null]?
        @"":
        string;
}

@end
