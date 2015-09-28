//
//  Items.m
//  HowMuch
//
//  Created by Daniel Khamsing on 9/15/15.
//  Copyright © 2015 Daniel Khamsing. All rights reserved.
//

#import "Item.h"

@implementation Item

- (instancetype)init {
    self = [super init];
    
    if (!self)
        return nil;
    
    self.itemId = @"-1";
    self.name = @"";
    self.price = @0;
    self.unit = @"";
    
    return self;
}

#pragma mark - Override

- (NSString *)description {    
    return [NSString stringWithFormat:@"<%@: %p> %@: %@ with price %@ and unit %@", self.class, self, self.itemId, self.name, self.price, self.unit];
}

- (BOOL)isEqual:(Item *)object {
    return [self.itemId isEqualToString:object.itemId];
}

- (NSString *)unit {
    return [_unit stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
}

#pragma mark NSCoding

static NSString * const hm_key_Id = @"id";
static NSString * const hm_key_Name = @"name";
static NSString * const hm_key_Price = @"price";
static NSString * const hm_key_Unit = @"unit";

- (void)encodeWithCoder:(NSCoder *)aCoder {
    [aCoder encodeObject:self.itemId forKey:hm_key_Id];
    [aCoder encodeObject:self.name forKey:hm_key_Name];
    [aCoder encodeObject:self.price forKey:hm_key_Price];
    [aCoder encodeObject:self.unit forKey:hm_key_Unit];
}

- (nullable instancetype)initWithCoder:(NSCoder *)aDecoder;
{
    self = [super init];
    if (!self)
        return nil;
    
    self.itemId = [aDecoder decodeObjectForKey:hm_key_Id];
    self.name = [aDecoder decodeObjectForKey:hm_key_Name];
    self.price = [aDecoder decodeObjectForKey:hm_key_Price];
    self.unit = [aDecoder decodeObjectForKey:hm_key_Unit];
    
    return self;
}

#pragma mark NSCopying

- (id)copyWithZone:(nullable NSZone *)zone;
{
    Item *item = [[[self class] allocWithZone:zone] init];
    
    item.itemId = self.itemId;
    item.name = self.name;
    item.price = self.price;
    item.unit = self.unit;    
    
    return item;
}

@end
