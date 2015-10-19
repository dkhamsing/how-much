//
//  DKAuthenticationInputCell.m
//
//  Created by Daniel Khamsing on 9/17/15.
//  Copyright © 2015 Daniel Khamsing. All rights reserved.
//

#import "DKAuthenticationInputCell.h"

@implementation DKAuthenticationInputCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (!self)
        return nil;
    
    // Init
    self.textField = [[UITextField alloc] init];
    NSArray *controls = @[self.textField,];
    
    // Subviews
    [controls enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        [self.contentView addSubview:obj];
    }];
    
    // Setup
    self.textField.layer.cornerRadius = 4;
    self.textField.leftViewMode = UITextFieldViewModeAlways;
    self.textField.leftView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 5, 5)];;
    
    // Layout
    [controls enumerateObjectsUsingBlock:^(UIView * obj, NSUInteger idx, BOOL * _Nonnull stop) {
        obj.translatesAutoresizingMaskIntoConstraints = NO;
    }];
    NSDictionary *views = @{
                            @"textfield":self.textField,
                            };
    NSDictionary *metrics = @{
                              @"pad":@5,
                              };
    
    {
        NSArray *constraints =
        [NSLayoutConstraint constraintsWithVisualFormat:@"|-[textfield]-|" options:kNilOptions metrics:metrics views:views]
        ;
        
        [self.contentView addConstraints:constraints];
    }
    
    {
        NSArray *constraints = [NSLayoutConstraint constraintsWithVisualFormat:@"V:|-pad-[textfield]-pad-|" options:kNilOptions metrics:metrics views:views];
        [self.contentView addConstraints:constraints];
    }
    
    return self;
}

@end
