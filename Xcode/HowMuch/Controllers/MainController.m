//
//  ViewController.m
//  HowMuch
//
//  Created by Daniel Khamsing on 9/14/15.
//  Copyright © 2015 Daniel Khamsing. All rights reserved.
//

#import "MainController.h"

// Categories
#import "UIColor+HM.h"
#import "UIViewController+HM.h"

// Constants
#import "HowMuchConstants.h"

// Controllers
#import "InputController.h"
#import "SetupController.h"

// Models
#import "Item.h"
#import "ItemCellData.h"

// Storage
#import "DataStorageProtocol.h"
#import "DataStorageParse.h"
#import "DataStorageUserDefaults.h"

// Views
#import "ItemCell.h"

// Vendors
#import "Reachability.h"
//#import "SVProgressHUD.h"

@interface MainController () <UITableViewDataSource, UITableViewDelegate, InputControllerProtocol, UISearchBarDelegate>

@property (nonatomic, strong) NSString *currency;

@property (nonatomic, strong) id<DataStorageProtocol> storage;

@property (nonatomic, strong) UITableView *tableView;

@property (nonatomic, strong) NSArray *tableViewDataSource;

@property (nonatomic, strong) NSArray *tableViewDataSourceOriginal;

@property (nonatomic, strong) UISearchBar *tableViewSearchBar;

@property (nonatomic, strong) Reachability *reach;

@end

static NSString * const hm_userDefaultsStorageSelection = @"hm_userDefaultsStorageSelection";

@implementation MainController

BOOL debugClearing = NO;
BOOL logging = NO;

- (void) dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    // Init
    self.tableView = [[UITableView alloc] init];
    self.tableViewSearchBar = [[UISearchBar alloc] init];
    NSNumberFormatter *currencyFormatter = [[NSNumberFormatter alloc] init];
    NSNumber *searchBarHeight = @44;
    NSArray *controls = @[
                          self.tableView,
                          self.tableViewSearchBar,
                          ];
    self.reach = [Reachability reachabilityForInternetConnection];
    
    // Subviews
    [controls enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        [self.view addSubview:obj];
    }];
    
    // Setup
    self.title = hm_appName;
    
    self.edgesForExtendedLayout = UIRectEdgeNone;
    
    self.tableViewSearchBar.delegate = self;
    [[UISearchBar appearance] setImage:({
        CGSize size = CGSizeMake(1, 1);
        UIGraphicsBeginImageContextWithOptions(size, YES, 0);
        [[UIColor whiteColor] setFill];
        UIRectFill(CGRectMake(0, 0, size.width, size.height));
        UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
        UIGraphicsEndImageContext();
        image;
    }) forSearchBarIcon:UISearchBarIconClear state:UIControlStateNormal];
    
    self.currency = ({
        currencyFormatter.locale = [NSLocale currentLocale];
        [currencyFormatter currencySymbol];
    });
    
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    self.tableView.rowHeight = 60;
    self.tableView.contentInset = UIEdgeInsetsMake(searchBarHeight.integerValue, 0, 0, 0);
    self.tableView.keyboardDismissMode = UIScrollViewKeyboardDismissModeOnDrag;
    
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"Setup" style:UIBarButtonItemStylePlain target:self action:@selector(actionSetup)];
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemAdd target:self action:@selector(actionAdd)];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(receiveNotificationSelectedStorage:) name:hm_notificationSelectedStorage object:nil];
    
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    if (![defaults objectForKey:hm_userDefaultsStorageSelection]) {
        [self presentSetupControllerAnimated:NO];
    }
    else {
        [self setupStorage];
    }
    
    __block MainController *weakSelf = self;
    self.reach.reachableBlock = ^(Reachability*reach)
    {
        dispatch_async(dispatch_get_main_queue(), ^{
            if (logging)
                NSLog(@"REACHABLE!");
            
            if (self.storageSelection == HM_storageTypeParse) {
                weakSelf.navigationItem.rightBarButtonItem.enabled = YES;
                [weakSelf.tableView reloadData];
            }
        });
    };
    
    self.reach.unreachableBlock = ^(Reachability*reach)
    {
        dispatch_async(dispatch_get_main_queue(), ^{
            if (logging)
                NSLog(@"UNREACHABLE!");
            
            if (self.storageSelection == HM_storageTypeParse) {
                weakSelf.navigationItem.rightBarButtonItem.enabled = NO;
                [weakSelf.tableView reloadData];
                
                [weakSelf alertWithErrorMessage:@"It appears you are offline, adding and editing items is disabled"];
            }
        });
    };
    
    [self.reach startNotifier];
    
    // Layout
    [controls enumerateObjectsUsingBlock:^(UIView *obj, NSUInteger idx, BOOL * _Nonnull stop) {
        obj.translatesAutoresizingMaskIntoConstraints = NO;
    }];
    NSDictionary *views = @{
                            @"table":self.tableView,
                            @"search":self.tableViewSearchBar,
                            };
    NSDictionary *metrics = @{
                              @"searchHeight":searchBarHeight,
                              };
    
    {
        NSArray *constraints = [NSLayoutConstraint constraintsWithVisualFormat:@"|[table]|" options:kNilOptions metrics:metrics views:views];
        [self.view addConstraints:constraints];
    }
    {
        NSArray *constraints = [NSLayoutConstraint constraintsWithVisualFormat:@"|[search]|" options:kNilOptions metrics:metrics views:views];
        [self.view addConstraints:constraints];
    }
    
    {
        NSArray *constraints = [NSLayoutConstraint constraintsWithVisualFormat:@"V:|[table]|" options:kNilOptions metrics:metrics views:views];
        [self.view addConstraints:constraints];
    }
    {
        NSArray *constraints = [NSLayoutConstraint constraintsWithVisualFormat:@"V:|[search(searchHeight)]" options:kNilOptions metrics:metrics views:views];
        [self.view addConstraints:constraints];
    }
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    if (self.tableViewSearchBar.showsCancelButton == YES) {
        [self.tableViewSearchBar becomeFirstResponder];
    }
    
    self.navigationItem.rightBarButtonItem.enabled = self.reach.isReachable || self.storageSelection == HM_storageTypeLocal;
}

- (void)setEditing:(BOOL)editing {
    [super setEditing:editing];
    
    [self navigationEnable:!editing];
    
    self.tableViewSearchBar.userInteractionEnabled = !editing;
    self.tableViewSearchBar.alpha = editing ? .5 : 1;
}

#pragma mark - Private

- (void)actionAdd {
    [self presentInputControllerAndEditItem:nil];
}

- (void)actionSetup {
    [self searchBarOff];
    
    [self presentSetupControllerAnimated:YES];
}

- (void)navigationEnable:(BOOL)enable {
    self.navigationItem.leftBarButtonItem.enabled = enable;
    self.navigationItem.rightBarButtonItem.enabled = enable;
}

- (void)alertWithErrorMessage:(NSString *)message {
    UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"Error" message:message delegate:nil cancelButtonTitle:nil otherButtonTitles:@"OK", nil];
    [alertView show];
}

- (void)presentController:(UIViewController *)controller animated:(BOOL)animated {
    UINavigationController *navigationController = [[UINavigationController alloc] initWithRootViewController:controller];
    [self presentViewController:navigationController animated:animated completion:nil];
}

- (void)presentInputControllerAndEditItem:(Item *)item
{
    if (!self.reach.isReachable && self.storageSelection == HM_storageTypeParse) {
        [self alertWithErrorMessage:@"The internet connection appears to be offline."];
        return;
    }
    
    InputController *inputController = [[InputController alloc] init];
    inputController.delegate = self;
    inputController.item = item;
    inputController.unitsDataSource = [self unitList];
    
    [self presentController:inputController animated:YES];
}

- (void)presentSetupControllerAnimated:(BOOL)animated {
    SetupController *storageController = [[SetupController alloc] init];
    
    if ([[NSUserDefaults standardUserDefaults] objectForKey:hm_userDefaultsStorageSelection]) {
        storageController.selectedStorage = self.storageSelection;
    }
    
    [self presentController:storageController animated:animated];
}

- (void)receiveNotificationSelectedStorage:(NSNotification *)notification {
    NSNumber *selectedStorage = notification.object;
    
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    [defaults setObject:selectedStorage forKey:hm_userDefaultsStorageSelection];
    [defaults synchronize];
    
    [self setupStorage];
}

- (void)reloadList {
    [self.storage loadItemWithSuccess:^(NSArray *list) {
        self.tableViewDataSource = list;
        self.tableViewDataSourceOriginal = self.tableViewDataSource.copy;
        [self.tableView reloadData];
    }];
}

- (void)searchBarOff {
    [self.tableViewSearchBar setShowsCancelButton:NO animated:YES];
    [self.tableViewSearchBar resignFirstResponder];
}

- (void)setupStorage {
    self.storage = self.storageSelection == HM_storageTypeLocal ? [[DataStorageUserDefaults alloc] init] : [[DataStorageParse alloc] init];
    
    if (debugClearing) {
        [self.storage debugClearItems];
    }
    
    [self reloadList];
}

- (BOOL)storageSelection {
    NSNumber *selectedStorage = [[NSUserDefaults standardUserDefaults] objectForKey:hm_userDefaultsStorageSelection];
    return selectedStorage.integerValue;
}

- (NSArray *)unitList {
    NSMutableSet *units = [[NSMutableSet alloc] init];
    
    for (Item *item in self.tableViewDataSource) {
        if (item.unit && item.unit.length>0) {
            [units addObject:item.unit];
        }
    }
    
    NSArray *sorted = [units.allObjects sortedArrayUsingSelector:@selector(localizedCaseInsensitiveCompare:)];
    
    return  sorted;
}

#pragma mark - Tableview

- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    if (self.storageSelection == HM_storageTypeLocal)
        return YES;
    
    return self.reach.isReachable;
}

- (void)tableView:(UITableView *)tableView willBeginEditingRowAtIndexPath:(NSIndexPath *)indexPath {
    [self.tableViewSearchBar setShowsCancelButton:NO animated:YES];
    self.editing = YES;
    
    [self searchBarOff];
}

- (void)tableView:(UITableView*)tableView didEndEditingRowAtIndexPath:(NSIndexPath *)indexPath;
{
    self.editing = NO;
}

- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    if (editingStyle==UITableViewCellEditingStyleDelete) {
        Item *itemToDelete = self.tableViewDataSource[indexPath.row];
        
        [self.storage deleteItem:itemToDelete success:^(NSError *error) {
            if (error) {
                self.tableViewDataSource = ({
                    NSMutableArray *mutable = self.tableViewDataSource.mutableCopy;
                    [mutable insertObject:itemToDelete atIndex:indexPath.row];
                    mutable.copy;
                });
                [self.tableView reloadData];
                
                [self alertWithErrorMessage:@"There was an error deleting the item."];
            }
        }];
        
        self.tableViewDataSource = ({
            NSMutableArray *mutable = self.tableViewDataSource.mutableCopy;
            [mutable removeObjectAtIndex:indexPath.row];
            mutable.copy;
        });
        [self.tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationLeft];
    }
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.tableViewDataSource.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    NSString *cellId = @"howMuchCell";
    ItemCell *cell = [tableView dequeueReusableCellWithIdentifier:cellId];
    if (!cell) {
        cell = [[ItemCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellId];
    }
    
    [ItemCellData configureCell:cell withItem:({
        Item *item = self.tableViewDataSource[indexPath.row];
        item;
    }) color:[UIColor hm_tintColor] currency:self.currency];
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    [self presentInputControllerAndEditItem:({
        Item *item = self.tableViewDataSource[indexPath.row];
        item;
    })];
}

#pragma mark - InputControllerProtocol

- (void)InputController:(InputController *)controller savedItem:(Item *)item {
    if (controller.editing) {
        [self.storage updateItem:item success:^(NSError *error) {
            //            [SVProgressHUD dismiss];
            if (error) {
                [self alertWithErrorMessage:@"There was an error editing the item."];
                return ;
            }
            
            [self reloadList];
        }];
    }
    else {
        // add
        [self.storage saveItem:item success:^(NSError *error) {
            //            [SVProgressHUD dismiss];
            if (error) {
                [self alertWithErrorMessage:@"There was an error adding the item."];
                return ;
            }
            
            [self reloadList];
        }];
    }
}

#pragma mark - UISearchBar

- (BOOL)searchBar:(UISearchBar *)searchBar shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text
{
    NSString *combined = [self hm_combinedInputFromControlInput:searchBar.text shouldChangeCharactersInRange:range replacementString:text];
    
    if (logging) {
        NSLog(@"combined: %@", combined);
    }
    
    if (combined.length>0) {
        self.tableViewDataSource = ({
            NSPredicate *predicate = [NSPredicate predicateWithFormat:@"self.name CONTAINS[cd] %@", combined];
            [self.tableViewDataSource filteredArrayUsingPredicate:predicate];
        });
        [self.tableView reloadData];
    }
    else {
        [self searchBarResetDataSource];
    }
    
    return YES;
}

- (void)searchBarTextDidBeginEditing:(UISearchBar *)searchBar {
    [searchBar setShowsCancelButton:YES animated:YES];
    
    [self navigationEnable:NO];
}

- (void)searchBarTextDidEndEditing:(UISearchBar *)searchBar {
    [self navigationEnable:YES];
}

- (void)searchBarCancelButtonClicked:(UISearchBar *)searchBar {
    searchBar.text = @"";
    
    [searchBar resignFirstResponder];
    
    [searchBar setShowsCancelButton:NO animated:YES];
    
    [self searchBarResetDataSource];
}

- (void)searchBarResetDataSource {
    self.tableViewDataSource = self.tableViewDataSourceOriginal;
    [self.tableView reloadData];
}

@end
