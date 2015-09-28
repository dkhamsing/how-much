//
//  ItemCell.h
//  HowMuch
//
//  Created by Daniel Khamsing on 9/15/15.
//  Copyright © 2015 Daniel Khamsing. All rights reserved.
//

#import <UIKit/UIKit.h>

static CGFloat kCellPadVertical = 8;

@interface ItemCell : UITableViewCell

// UI

@property (strong, nonatomic) UILabel *nameLabel;

@property (strong, nonatomic) UILabel *priceLabel;

@property (strong, nonatomic) UILabel *unitLabel;

// Constraints

@property (strong, nonatomic) NSLayoutConstraint *priceTopConstraint;

@property (strong, nonatomic) NSLayoutConstraint *unitWidthConstraint;

@end
