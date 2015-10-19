//
//  Items.h
//  HowMuch
//
//  Created by Daniel Khamsing on 9/15/15.
//  Copyright © 2015 Daniel Khamsing. All rights reserved.
//

#import <Foundation/Foundation.h>

static NSString * const hm_key_Id = @"id";
static NSString * const hm_key_Name = @"name";
static NSString * const hm_key_Price = @"price";
static NSString * const hm_key_Store = @"store";
static NSString * const hm_key_Unit = @"unit";

@interface Item : NSObject <NSCoding, NSCopying>

@property (nonatomic, strong) NSString *itemId;

@property (nonatomic, strong) NSString *name;

@property (nonatomic, strong) NSNumber *price;

@property (nonatomic, strong) NSString *store;

@property (nonatomic, strong) NSString *unit;

@end
