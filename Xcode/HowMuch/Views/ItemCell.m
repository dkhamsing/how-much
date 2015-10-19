//
//  ItemCell.m
//  HowMuch
//
//  Created by Daniel Khamsing on 9/15/15.
//  Copyright © 2015 Daniel Khamsing. All rights reserved.
//

#import "ItemCell.h"

@interface ItemCell ()

@property (nonatomic, strong) UIView *container;

@end

@implementation ItemCell

static BOOL kLogItemCell = NO;

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (!self)
        return nil;
    
    // Init
    self.container = [[UIView alloc] init];
    
    self.nameLabel = [[UILabel alloc] init];
    self.storeLabel = [[UILabel alloc] init];
    self.priceLabel = [[UILabel alloc] init];
    self.unitLabel = [[UILabel alloc] init];
    
    NSArray *controls = @[
                          self.nameLabel,
                          self.storeLabel,
                          self.priceLabel,
                          self.unitLabel,
                          ];
    
    // Setup
    self.nameLabel.accessibilityIdentifier = @"name";
    self.nameLabel.font = [UIFont systemFontOfSize:18];
    
    self.unitLabel.accessibilityIdentifier = @"unit";
    self.unitLabel.font = [UIFont systemFontOfSize:10];
    self.unitLabel.textAlignment = NSTextAlignmentCenter;
    self.unitLabel.layer.cornerRadius = 4;
    self.unitLabel.clipsToBounds = YES;
    
    self.storeLabel.accessibilityIdentifier = @"store";
    self.storeLabel.font = self.unitLabel.font;
    self.storeLabel.textAlignment = self.unitLabel.textAlignment;
    self.storeLabel.layer.cornerRadius = 4;
    self.storeLabel.clipsToBounds = YES;
    
    self.priceLabel.accessibilityIdentifier = @"price";
    self.priceLabel.textAlignment = NSTextAlignmentRight;
    self.priceLabel.font = [UIFont systemFontOfSize:20];
    
    if (kLogItemCell) {
        self.priceLabel.backgroundColor = [UIColor redColor];
        self.unitLabel.backgroundColor = [UIColor yellowColor];
    }
    
    // Layout
    [self.contentView addSubview:self.container];
    [controls enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        [self.container addSubview:obj];
    }];
    
    [[controls.mutableCopy arrayByAddingObject:self.container]
     enumerateObjectsUsingBlock:^(UIView * obj, NSUInteger idx, BOOL * _Nonnull stop) {
         obj.translatesAutoresizingMaskIntoConstraints = NO;
     }];
    NSDictionary *views = @{
                            @"container":self.container,
                            
                            @"name":self.nameLabel,
                            @"store":self.storeLabel,
                            @"price":self.priceLabel,
                            @"unit":self.unitLabel,
                            };
    NSDictionary *metrics = @{
                              @"pad":@2,
                              };
    
    // Container
    {
        NSArray *constraints = [NSLayoutConstraint constraintsWithVisualFormat:@"|-[container]-|" options:kNilOptions metrics:metrics views:views];
        [self.contentView addConstraints:constraints];
    }
    {
        NSArray *constraints = [NSLayoutConstraint constraintsWithVisualFormat:@"V:|-[container]-|" options:kNilOptions metrics:metrics views:views];
        [self.contentView addConstraints:constraints];
    }
    
    // Horizontal
    {
        NSArray *constraints = [NSLayoutConstraint constraintsWithVisualFormat:@"|[name][price(80)]|" options:kNilOptions metrics:metrics views:views];
        [self.container addConstraints:constraints];
    }
    {
        NSArray *constraints = [NSLayoutConstraint constraintsWithVisualFormat:@"|[store]" options:kNilOptions metrics:metrics views:views];
        [self.container addConstraints:constraints];
    }
    {
        NSArray *constraints = [NSLayoutConstraint constraintsWithVisualFormat:@"[unit]|" options:kNilOptions metrics:metrics views:views];
        [self.container addConstraints:constraints];
    }
    
    // Vertical
    {
        NSArray *constraints = [NSLayoutConstraint constraintsWithVisualFormat:@"V:|[name]-2-[store(15)]|" options:kNilOptions metrics:metrics views:views];
        [self.container addConstraints:constraints];
    }
    {
        NSArray *constraints = [NSLayoutConstraint constraintsWithVisualFormat:@"V:[price][unit(15)]|" options:kNilOptions metrics:metrics views:views];
        [self.container addConstraints:constraints];
    }
    
    // Constraint properties
//    self.priceTopConstraint = [NSLayoutConstraint constraintWithItem:self.priceLabel attribute:NSLayoutAttributeTop relatedBy:NSLayoutRelationEqual toItem:self.contentView attribute:NSLayoutAttributeTop multiplier:1 constant:kCellPadVertical];
//    [self.contentView addConstraint:self.priceTopConstraint];
    
    self.unitWidthConstraint = [NSLayoutConstraint constraintWithItem:self.unitLabel attribute:NSLayoutAttributeWidth relatedBy:NSLayoutRelationEqual toItem:nil attribute:NSLayoutAttributeNotAnAttribute multiplier:1 constant:0];
    [self.contentView addConstraint:self.unitWidthConstraint];
    
    self.storeWidthConstraint = [NSLayoutConstraint constraintWithItem:self.storeLabel attribute:NSLayoutAttributeWidth relatedBy:NSLayoutRelationEqual toItem:nil attribute:NSLayoutAttributeNotAnAttribute multiplier:1 constant:0];
    [self.contentView addConstraint:self.storeWidthConstraint];
    
    return self;
}

@end
