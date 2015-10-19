//
//  InputController
//
//
//  Created by Daniel Khamsing on 9/17/15.
//
//

#import "InputController.h"

// Categories
#import "UIViewController+HM.h"

// Models
#import "Item.h"

// Views
#import "InputCell.h"

NS_ENUM(NSInteger, HM_InputSectionType) {
    HM_InputSectionTypeInput,
    HM_InputSectionTypeUnit,
    HM_InputSectionTypeCount,
};

NS_ENUM(NSInteger, HM_InputRowType) {
    HM_InputRowTypeName,
    HM_InputRowTypePrice,
    HM_InputRowTypeUnit,
    HM_InputRowTypeStore,
    HM_InputRowTypeCount,
};

@interface InputController () <UITableViewDataSource, UITableViewDelegate, UITextFieldDelegate>

@property (nonatomic, strong) UITableView *tableView;

@property (nonatomic, strong) NSString *unitSelected;

@property (nonatomic, strong) Item *addItem;

@end

@implementation InputController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    // Init
    self.tableView = [[UITableView alloc] initWithFrame:({
        CGRect frame = self.view.bounds;
        frame;
    }) style:UITableViewStyleGrouped];
    
    // Subviews
    [self.view addSubview:self.tableView];
    
    // Setup
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemCancel target:self action:@selector(actionDismiss)];
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemSave target:self action:@selector(actionSave)];
    
    self.tableView.dataSource = self;
    self.tableView.delegate = self;
    self.tableView.tableFooterView = [[UIView alloc] init];
    self.tableView.keyboardDismissMode = UIScrollViewKeyboardDismissModeOnDrag;
    
    // Layout
    self.tableView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
}

#pragma mark - Override

- (void)setItem:(Item *)item {
    _item = item;
    
    self.editing = item?YES:NO;
    
    if (item) {
        [self.tableView reloadData];
    }
}

#pragma mark - Private

- (void)actionDismiss {
    [self.view endEditing:YES];
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (void)actionSave {
    Item *savedItem = self.item?: ({
        self.addItem.itemId = ({
            NSInteger interval = [NSDate date].timeIntervalSince1970;
            @(interval).stringValue;
        });
        self.addItem;
    });
    
    if (savedItem == nil) {
        [self alertError:@"Please fill out name and price."];
        return;
    }
    
    if (savedItem.name.length==0) {
        [self alertError:@"Please fill out item name."];
        return;
    }
    
    if (savedItem.price.floatValue<0) {
        [self alertError:@"Please enter a positive value for price."];
        return;
    }
    
    if ([self.delegate respondsToSelector:@selector(InputController:savedItem:)]) {
        [self.delegate InputController:self savedItem:savedItem];
    }
    
    [self actionDismiss];
}

- (void)alertError:(NSString *)error {
    UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"Error" message:error preferredStyle:UIAlertControllerStyleAlert];
    
    UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        [alertController dismissViewControllerAnimated:YES completion:nil];
    }];
    
    [alertController addAction:cancelAction];
    [self presentViewController:alertController animated:YES completion:nil];
}

#pragma mark - Table View

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return HM_InputSectionTypeCount;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return section == HM_InputSectionTypeUnit ? self.unitsDataSource.count : HM_InputRowTypeCount;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.section == HM_InputSectionTypeUnit) {
        
        NSString *cellId = @"cellUnit";
        UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellId];
        if (!cell) {
            cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellId];
        }
        
        cell.textLabel.text = self.unitsDataSource[indexPath.row];
        cell.accessoryType = [self.unitSelected isEqualToString:cell.textLabel.text] ? UITableViewCellAccessoryCheckmark : UITableViewCellAccessoryNone;
        
        return cell;
    }
    
    NSString *cellId = @"cellInput";
    InputCell *cell = [tableView dequeueReusableCellWithIdentifier:cellId];
    if (!cell) {
        cell = [[InputCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellId showLabel:YES];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        cell.textField.delegate = self;
    }
    
    cell.textField.tag = indexPath.row;
    cell.textField.placeholder = indexPath.row == HM_InputRowTypeUnit || indexPath.row == HM_InputRowTypeStore ? @"(optional)":nil;
    cell.textField.keyboardType = indexPath.row == HM_InputRowTypePrice ? UIKeyboardTypeDecimalPad : UIKeyboardTypeAlphabet;
    
    cell.label.text = ({
        NSArray *labels = @[@"Name",
                            @"Price",
                            @"Unit",
                            @"Store",
                            ];
        labels[indexPath.row];
    });
    
    if (self.item) {
        NSArray *item = @[
                          self.item.name,
                          self.item.price.stringValue,
                          self.item.unit?:@"",
                          self.item.store?:@"",
                          ];
        
        cell.textField.text = item[indexPath.row];
    }
    
    if (self.unitSelected && indexPath.section == HM_InputSectionTypeInput && indexPath.row == HM_InputRowTypeUnit) {
        cell.textField.text = self.unitSelected;
        
        if (self.item) {
            self.item.unit = self.unitSelected;
        }
    }
    
    return cell;
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section {
    if (self.unitsDataSource.count==0)
        return @"";
    
    return section == HM_InputSectionTypeUnit ? @"Units" : @"";
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.section == HM_InputSectionTypeUnit) {
        [tableView deselectRowAtIndexPath:indexPath animated:YES];
        
        self.unitSelected = self.unitsDataSource[indexPath.row];
        NSArray *indexPaths = @[ [NSIndexPath indexPathForRow:HM_InputRowTypeUnit inSection:HM_InputSectionTypeInput] ];
        [self.tableView reloadRowsAtIndexPaths:indexPaths withRowAnimation:UITableViewRowAnimationNone];
        
        [self.tableView reloadSections:[NSIndexSet indexSetWithIndex:HM_InputSectionTypeUnit] withRowAnimation:UITableViewRowAnimationNone];
    }
}

#pragma mark - UITextField

- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string {
    NSString *combined = [self hm_combinedInputFromControlInput:textField.text shouldChangeCharactersInRange:range replacementString:string];
    
    BOOL logging = NO;
    if (logging) {
        NSLog(@"combined: %@", combined);
    }
    
    if (self.item) {
        if (textField.tag == HM_InputRowTypeName)
            self.item.name = combined;

        if (textField.tag == HM_InputRowTypeStore)
            self.item.store = combined;
        
        if (textField.tag == HM_InputRowTypePrice)
            self.item.price = @(combined.floatValue);
        
        if (textField.tag == HM_InputRowTypeUnit) {
            self.item.unit = combined;
            self.unitSelected = combined;
            [self.tableView reloadSections:[NSIndexSet indexSetWithIndex:HM_InputSectionTypeUnit] withRowAnimation:UITableViewRowAnimationNone];
        }
    }
    else {
        if (!self.addItem)
            self.addItem = [[Item alloc] init];
        
        if (textField.tag == HM_InputRowTypeName)
            self.addItem.name = combined;
        
        if (textField.tag == HM_InputRowTypeStore)
            self.addItem.store = combined;

        if (textField.tag == HM_InputRowTypePrice)
            self.addItem.price = @(combined.floatValue);
        
        if (textField.tag == HM_InputRowTypeUnit) {
            self.addItem.unit = combined;
            self.unitSelected = combined;
            [self.tableView reloadSections:[NSIndexSet indexSetWithIndex:HM_InputSectionTypeUnit] withRowAnimation:UITableViewRowAnimationNone];
        }
    }
    
    return YES;
}

@end
