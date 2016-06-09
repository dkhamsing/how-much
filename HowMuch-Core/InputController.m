//
//  InputController.m
//  HowMuchCore
//
//  Created by Daniel Khamsing on 6/9/16.
//

#import "InputController.h"

@interface InputController ()

@property NSDictionary *item;

@end

@implementation InputController

- (instancetype)initWithItem:(NSDictionary *)item;
{
    _item = item;
    
    self = [self init];
    
    return self;
}

- (instancetype)init;
{
    self = [super init];
    if (self){
        [self setup];
        [self initializeForm];
    }
    return self;
}

- (void)initializeForm {
    XLFormDescriptor * form = [XLFormDescriptor formDescriptorWithTitle:@"Add Item"];

    XLFormSectionDescriptor * section = [XLFormSectionDescriptor formSection];
    [form addFormSection:section];

    XLFormRowDescriptor * row;
    NSString * key;

    key = @"name";
    row = [XLFormRowDescriptor formRowDescriptorWithTag:key rowType:XLFormRowDescriptorTypeText];
    [row.cellConfigAtConfigure setObject:@"Name" forKey:@"textField.placeholder"];
    row.value = self.item[key];
    [section addFormRow:row];
    
    key = @"brand";
    row = [XLFormRowDescriptor formRowDescriptorWithTag:key rowType:XLFormRowDescriptorTypeText];
    [row.cellConfigAtConfigure setObject:@"Brand (optional)" forKey:@"textField.placeholder"];
    row.value = self.item[key];
    [section addFormRow:row];
    
    key = @"price";
    row = [XLFormRowDescriptor formRowDescriptorWithTag:key rowType:XLFormRowDescriptorTypeNumber];
    [row.cellConfigAtConfigure setObject:@"Price" forKey:@"textField.placeholder"];
    row.value = self.item[key];
    [section addFormRow:row];
    
    key = @"store";
    row = [XLFormRowDescriptor formRowDescriptorWithTag:key rowType:XLFormRowDescriptorTypeText];
    [row.cellConfigAtConfigure setObject:@"Store (Optional)" forKey:@"textField.placeholder"];
    row.value = self.item[key];
    [section addFormRow:row];
    
    key = @"unit";
    row = [XLFormRowDescriptor formRowDescriptorWithTag:key rowType:XLFormRowDescriptorTypeText];
    [row.cellConfigAtConfigure setObject:@"Unit (Optional)" forKey:@"textField.placeholder"];
    row.value = self.item[key];
    [section addFormRow:row];
    
    self.form = form;
}

- (void)setup;
{
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemCancel target:self action:@selector(actionCancel)];
    
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"Save" style:UIBarButtonItemStyleDone target:self action:@selector(actionSave)];
}

#pragma mark Private

- (void)actionCancel;
{
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (void)actionSave;
{
    if ([self validValues:self.formValues]) {
        if (self.completion) {
            self.completion(self.formValues);
        }
        [self dismissViewControllerAnimated:YES completion:nil];
    }
    else {
        NSString *title = @"Input Error";
        NSString *message = @"Please fill out Name and Price.";
        UIAlertController *controller = [UIAlertController alertControllerWithTitle:title message:message preferredStyle:UIAlertControllerStyleAlert];
        [controller addAction:[UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault handler:nil]];
        [self presentViewController:controller animated:YES completion:nil];
    }
}

- (BOOL)validValues:(NSDictionary *)values;
{
    id value1 = values[@"name"];
    id value2 = values[@"price"];
    
    if (value1 != [NSNull null] && value2 != [NSNull null])
        return YES;
    
    return NO;
}

@end
