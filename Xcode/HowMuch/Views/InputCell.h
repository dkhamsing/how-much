//
//  InputCell.h
//  HowMuch
//
//  Created by Daniel Khamsing on 9/17/15.
//  Copyright © 2015 Daniel Khamsing. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface InputCell : UITableViewCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier showLabel:(BOOL)showLabel;

@property (nonatomic) BOOL showLabel;

@property (nonatomic, strong) UILabel *label;

@property (nonatomic, strong) UITextField *textField;

@end
