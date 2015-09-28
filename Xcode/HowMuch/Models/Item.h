//
//  Items.h
//  HowMuch
//
//  Created by Daniel Khamsing on 9/15/15.
//  Copyright © 2015 Daniel Khamsing. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Item : NSObject <NSCoding, NSCopying>

@property (nonatomic, strong) NSString *itemId;

@property (nonatomic, strong) NSString *name;

@property (nonatomic, strong) NSNumber *price;

@property (nonatomic, strong) NSString *unit;

@end
