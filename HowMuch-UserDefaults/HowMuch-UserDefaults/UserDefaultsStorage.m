//
//  UserDefaultsStorage.m
//  HowMuch-UserDefaults
//
//  Created by Daniel Khamsing on 6/9/16.
//  Copyright © 2016 Daniel Khamsing. All rights reserved.
//

#import "UserDefaultsStorage.h"

@interface UserDefaultsStorage ()

@property (nonatomic, strong) NSString *key;

@end

@implementation UserDefaultsStorage

- (instancetype)initWithKey:(NSString *)key;
{
  self = [super init];
  if (!self)
    return nil;

    self.key = key;

  return self;
}

- (void)debugClean;
{
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    [defaults removeObjectForKey:self.key];
}

- (void)deleteItem:(NSDictionary *)item completion:(void (^)(NSError *error))completion;
{
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];

    NSArray *list = [defaults objectForKey:self.key];

    NSString *key = item.allKeys.firstObject;
    __block NSDictionary *objToRemove;
    [list enumerateObjectsUsingBlock:^(NSDictionary *  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        if ([obj.allKeys.firstObject isEqualToString:key]) {
            objToRemove = obj;
            *stop = YES;
        }
    }];
    
    if (objToRemove==nil) {
        if (completion) {
            completion([NSError errorWithDomain:@"Delete Error" code:-1 userInfo:item]);
        }
        return;
    }
    
    NSMutableArray *mutable = list.mutableCopy;
    
    [mutable removeObject:objToRemove];

    [defaults setObject:mutable forKey:self.key];

    if (completion) {
        completion(nil);
    }
}

- (void)loadItemsWithCompletion:(void (^)(NSArray *))completion;
{
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    NSArray *unsorted = [defaults objectForKey:self.key];

    NSArray *sorted = [unsorted sortedArrayUsingComparator:^NSComparisonResult(NSDictionary *a, NSDictionary *b) {
        NSString *first = a.allValues.firstObject[@"name"];
        NSString *second = b.allValues.firstObject[@"name"];
        return [first compare:second options:NSCaseInsensitiveSearch];
    }].mutableCopy;
    
    if (completion) {
        completion(sorted);
    }
}

- (void)saveItem:(NSDictionary *)item completion:(void (^)(NSError *))completion;
{
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];

    NSArray *list = [defaults objectForKey:self.key];

    if (list==nil)
        list = [NSArray new];
    
    NSMutableArray *mutable = list.mutableCopy;
    [mutable addObject:[UserDefaultsStorage safeItem:item]];

    [defaults setObject:mutable forKey:self.key];

    if (completion) {
        completion(nil);
    }
}

- (void)updateItem:(NSDictionary *)item withValue:(NSDictionary *)value completion:(void (^)(NSError *))completion;
{
    NSString *key = item.allKeys.firstObject;
    
    [self deleteItem:item completion:^(NSError *error) {
        if (error) {
            if (completion) {
                completion(error);
            }
            return;
        }

        NSDictionary *insert = [UserDefaultsStorage safeItem: @{key:value}];        
        [self saveItem:insert completion:completion];
    }];
}

- (NSDictionary *)valuesForItem:(NSDictionary *)item;
{
    return item.allValues.firstObject;
}

#pragma mark Private

+ (NSDictionary *)safeItem:(NSDictionary *)item;
{
    NSMutableDictionary *safe = item.mutableCopy;
    
    NSString *key = safe.allKeys.firstObject;
    
    NSDictionary *verify = safe.allValues.firstObject;
    NSMutableDictionary *values = [NSMutableDictionary new];
    [verify enumerateKeysAndObjectsUsingBlock:^(id  _Nonnull key, id  _Nonnull obj, BOOL * _Nonnull stop) {
        if (obj != (id)[NSNull null]) {
            values[key] = obj;
        }
    }];
    
    safe[key] = values;
    
    return safe;
}

@end
