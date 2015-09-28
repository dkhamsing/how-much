//
//  InputCell.m
//  HowMuch
//
//  Created by Daniel Khamsing on 9/17/15.
//  Copyright © 2015 Daniel Khamsing. All rights reserved.
//

#import "InputCell.h"

// Categories
#import "UIColor+HM.h"

@implementation InputCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    return [self initWithStyle:style reuseIdentifier:reuseIdentifier showLabel:NO];
}

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier showLabel:(BOOL)showLabel;
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (!self)
        return nil;
    
    self.showLabel = showLabel;
    
    // Init
    self.label = [[UILabel alloc] init];
    self.textField = [[UITextField alloc] init];
    NSArray *controls = @[self.label,
                          self.textField];
    
    // Subviews
    [controls enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        [self.contentView addSubview:obj];
    }];
    
    // Setup
    self.textField.backgroundColor = [[UIColor hm_lightColor] colorWithAlphaComponent:.2];
    self.textField.layer.cornerRadius = 4;
    self.textField.leftViewMode = UITextFieldViewModeAlways;
    self.textField.leftView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 5, 5)];;
    
    // Layout
    [controls enumerateObjectsUsingBlock:^(UIView * obj, NSUInteger idx, BOOL * _Nonnull stop) {
        obj.translatesAutoresizingMaskIntoConstraints = NO;
    }];
    NSDictionary *views = @{
                            @"label":self.label,
                            @"textfield":self.textField,
                            };
    NSDictionary *metrics = @{
                              @"pad":@5,
                              };
    
    {
        NSArray *constraints = self.showLabel ? [NSLayoutConstraint constraintsWithVisualFormat:@"|-[label(60)]-[textfield]-|" options:kNilOptions metrics:metrics views:views]:
        [NSLayoutConstraint constraintsWithVisualFormat:@"|-[textfield]-|" options:kNilOptions metrics:metrics views:views]
        ;
        
        [self.contentView addConstraints:constraints];
    }
    
    if (self.showLabel)
    {
        NSArray *constraints = [NSLayoutConstraint constraintsWithVisualFormat:@"V:|-[label]-|" options:kNilOptions metrics:metrics views:views];
        [self.contentView addConstraints:constraints];
    }
    
    {
        NSArray *constraints = [NSLayoutConstraint constraintsWithVisualFormat:@"V:|-pad-[textfield]-pad-|" options:kNilOptions metrics:metrics views:views];
        [self.contentView addConstraints:constraints];
    }
    
    return self;
}

@end
