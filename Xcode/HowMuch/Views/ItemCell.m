//
//  ItemCell.m
//  HowMuch
//
//  Created by Daniel Khamsing on 9/15/15.
//  Copyright © 2015 Daniel Khamsing. All rights reserved.
//

#import "ItemCell.h"

@implementation ItemCell

static BOOL kLogItemCell = NO;

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (!self)
        return nil;
    
    // Init
    self.nameLabel = [[UILabel alloc] init];
    self.priceLabel = [[UILabel alloc] init];
    self.unitLabel = [[UILabel alloc] init];
    
    NSArray *controls = @[
                          self.nameLabel,
                          self.priceLabel,
                          self.unitLabel,
                          ];
    
    // Subviews
    [controls enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        [self.contentView addSubview:obj];
    }];
    
    // Setup
    self.unitLabel.accessibilityIdentifier = @"unit";
    self.unitLabel.font = [UIFont systemFontOfSize:12];
    self.unitLabel.textAlignment = NSTextAlignmentCenter;
    self.unitLabel.layer.cornerRadius = 4;
    self.unitLabel.textColor = [UIColor whiteColor];
    self.unitLabel.clipsToBounds = YES;
    
    self.nameLabel.accessibilityIdentifier = @"name";
    self.nameLabel.font = [UIFont fontWithName:@"Helvetica-Light" size:24];
    
    self.priceLabel.accessibilityIdentifier = @"price";
    self.priceLabel.textAlignment = NSTextAlignmentRight;
    self.priceLabel.font = [UIFont systemFontOfSize:20];
    
    if (kLogItemCell) {
        self.priceLabel.backgroundColor = [UIColor redColor];
        self.unitLabel.backgroundColor = [UIColor yellowColor];
    }
    
    // Layout
    [controls enumerateObjectsUsingBlock:^(UIView * obj, NSUInteger idx, BOOL * _Nonnull stop) {
        obj.translatesAutoresizingMaskIntoConstraints = NO;
    }];
    NSDictionary *views = @{
                            @"name":self.nameLabel,
                            @"price":self.priceLabel,
                            @"unit":self.unitLabel,
                            };
    NSDictionary *metrics = @{
                              @"pad":@(kCellPadVertical),
                              };
    
    // Horizontal
    {
        NSArray *constraints = [NSLayoutConstraint constraintsWithVisualFormat:@"|-[name][price(80)]-|" options:kNilOptions metrics:metrics views:views];
        [self.contentView addConstraints:constraints];
    }
    {
        NSArray *constraints = [NSLayoutConstraint constraintsWithVisualFormat:@"[unit]-|" options:kNilOptions metrics:metrics views:views];
        [self.contentView addConstraints:constraints];
    }
    
    // Vertical
    {
        NSArray *constraints = [NSLayoutConstraint constraintsWithVisualFormat:@"V:|[name]|" options:kNilOptions metrics:metrics views:views];
        [self.contentView addConstraints:constraints];
    }
    {
        NSArray *constraints = [NSLayoutConstraint constraintsWithVisualFormat:@"V:[price][unit(price)]-pad-|" options:kNilOptions metrics:metrics views:views];
        [self.contentView addConstraints:constraints];
    }
    
    // Constraint properties
    self.priceTopConstraint = [NSLayoutConstraint constraintWithItem:self.priceLabel attribute:NSLayoutAttributeTop relatedBy:NSLayoutRelationEqual toItem:self.contentView attribute:NSLayoutAttributeTop multiplier:1 constant:kCellPadVertical];
    [self.contentView addConstraint:self.priceTopConstraint];
    
    self.unitWidthConstraint = [NSLayoutConstraint constraintWithItem:self.unitLabel attribute:NSLayoutAttributeWidth relatedBy:NSLayoutRelationEqual toItem:nil attribute:NSLayoutAttributeNotAnAttribute multiplier:1 constant:0];
    [self.contentView addConstraint:self.unitWidthConstraint];
    
    return self;
}


@end
