//
//  ItemCellData.h
//  HowMuch
//
//  Created by Daniel Khamsing on 9/25/15.
//  Copyright © 2015 Daniel Khamsing. All rights reserved.
//

#import <UIKit/UIKit.h>

@class Item;
@class ItemCell;

@interface ItemCellData : NSObject

+ (void)configureCell:(ItemCell *)cell withItem:(Item *)item color:(UIColor *)color currency:(NSString *)currency;

@end
