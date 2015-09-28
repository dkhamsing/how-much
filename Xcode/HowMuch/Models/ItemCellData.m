//
//  ItemCellData.m
//  HowMuch
//
//  Created by Daniel Khamsing on 9/25/15.
//  Copyright © 2015 Daniel Khamsing. All rights reserved.
//

#import "ItemCellData.h"

// Models
#import "Item.h"

// Views
#import "ItemCell.h"

@implementation ItemCellData

+ (void)configureCell:(ItemCell *)cell withItem:(Item *)item color:(UIColor *)color currency:(NSString *)currency;
{
    // style
    cell.unitLabel.backgroundColor = [color colorWithAlphaComponent:.4];
    
    // values
    cell.nameLabel.text = item.name;
    cell.unitLabel.text = item.unit;
    cell.priceLabel.attributedText = ({
        NSNumber *price = item.price;
        NSString *combined = [NSString stringWithFormat:@"%@%.2f", currency, price.floatValue];
        
        NSMutableAttributedString *attributed = [[NSMutableAttributedString alloc] initWithString:combined];
        NSDictionary *attributes = @{NSForegroundColorAttributeName:[color colorWithAlphaComponent:.6]};
        [attributed addAttributes:attributes range:[combined rangeOfString:currency]];
        
        attributed;
    });
    
    // constraints
    cell.priceTopConstraint.constant = item.unit.length>0?kCellPadVertical:20;
    cell.unitWidthConstraint.constant = ({
        NSDictionary *attributes = @{NSFontAttributeName:cell.unitLabel.font};
        CGSize size = [item.unit sizeWithAttributes:attributes];
        CGFloat pad = 6;
        item.unit.length==0?0:size.width + pad * 2;
    });
}

@end
