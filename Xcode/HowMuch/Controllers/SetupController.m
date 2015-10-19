//
//  SetupController.m
//  HowMuch
//
//  Created by Daniel Khamsing on 9/18/15.
//  Copyright © 2015 Daniel Khamsing. All rights reserved.
//

#import "SetupController.h"

// Constants
#import "HowMuchConstants.h"

// Libraries
#import "dkparseauth.h"

NS_ENUM(NSInteger, HM_setupSectionType) {
    HM_setupSectionTypeStorage,
    HM_setupSectionTypeAction,
    HM_setupSectionTypeCredit,
    HM_setupSectionTypeCount,
};

@interface SetupController () <UITableViewDataSource, UITableViewDelegate>

@property (nonatomic, strong) UITableView *tableView;

@property (nonatomic, strong) NSArray *actionDataSource;

@property (nonatomic, strong) NSArray *creditDataSource;

@property (nonatomic, strong) NSArray *storageDataSource;

@end

@implementation SetupController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    // Init
    self.tableView = [[UITableView alloc] initWithFrame:self.view.bounds style:UITableViewStyleGrouped];
    
    // Subviews
    [self.view addSubview:self.tableView];
    
    // Layout
    self.tableView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
    
    // Setup
    self.title = @"Setup";
    
    self.tableView.dataSource = self;
    self.tableView.delegate = self;
    
    // Data source
    self.actionDataSource = @[
                              @[@"Logout",
                                @"",
                                ],
                              ];
    
    self.creditDataSource = @[
                              @[
                                  @"App icon by icon 54",
                                  @"https://thenounproject.com/icon54app/",
                                  ],
                              @[
                                  @"How Much app by Daniel Khamsing",
                                  @"https://github.com/dkhamsing",
                                  ],
                              ];
    
    self.storageDataSource = ({
        NSDictionary *text = @{
                               @(HM_storageTypeLocal):@"Store list locally",
                               @(HM_storageTypeParse):@"Sync list in the cloud",
                               };
        
        NSDictionary *detail = @{
                                 @(HM_storageTypeLocal):@"On this device only",
                                 @(HM_storageTypeParse):@"Across devices",
                                 };
        
        @[
          @[
              text[@(HM_storageTypeLocal)],
              detail[@(HM_storageTypeLocal)],
              ],
          
          @[
              text[@(HM_storageTypeParse)],
              detail[@(HM_storageTypeParse)],
              ],
          ];
    });
}

- (void)setSelectedStorage:(NSInteger)selectedStorage {
    _selectedStorage = selectedStorage;
    
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemCancel target:self action:@selector(actionCancel)];
}

#pragma mark - Actions

- (void)actionCancel {
    [self dismissViewControllerAnimated:YES completion:nil];
}

#pragma mark - Private

- (void)storageSelected:(NSInteger)selected {
    [[NSNotificationCenter defaultCenter] postNotificationName:hm_notificationSelectedStorage object:@(selected)];
    
    [self dismissViewControllerAnimated:YES completion:nil];
}

#pragma mark - Table View

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return HM_setupSectionTypeCount;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if (section==HM_setupSectionTypeCredit) {
        return self.creditDataSource.count;
    }
    
    if (section==HM_setupSectionTypeAction) {
        return self.selectedStorage != HM_storageTypeLocal ? self.actionDataSource.count : 0;
    }
    
    // storage
    return self.storageDataSource.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    NSString *cellId = @(indexPath.section).stringValue;
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellId];
    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:cellId];
        cell.detailTextLabel.textColor = [UIColor lightGrayColor];
    }
    
    if (self.navigationItem.leftBarButtonItem && indexPath.section==HM_setupSectionTypeStorage) {
        cell.accessoryType = ({
            BOOL matches = self.selectedStorage == indexPath.row;
            matches;
        }) ? UITableViewCellAccessoryCheckmark : UITableViewCellAccessoryNone;
    }
    else {
        cell.accessoryType = UITableViewCellAccessoryNone;
    }
    
    NSArray *dataSource;
    switch (indexPath.section) {
        case HM_setupSectionTypeAction:
            dataSource = self.actionDataSource;
            break;
            
        case HM_setupSectionTypeCredit:
            dataSource = self.creditDataSource;
            break;
            
        default:
            dataSource = self.storageDataSource;
            break;
    }
    
    NSArray *row = dataSource[indexPath.row];
    cell.textLabel.text = row.firstObject;
    cell.detailTextLabel.text = row[1];
    
    return cell;
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section {
    if (section==HM_setupSectionTypeCredit) {
        return @"Credits";
    }
    
    return @"";
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    if (indexPath.section == HM_setupSectionTypeAction) {
        if (indexPath.row == 0) {
            UIAlertController *controller = [UIAlertController alertControllerWithTitle:nil message:nil preferredStyle:UIAlertControllerStyleActionSheet];
            
            UIAlertAction *confirmLogout = [UIAlertAction actionWithTitle:@"Confirm Logout" style:UIAlertActionStyleDestructive handler:^(UIAlertAction * _Nonnull action) {
                [[DKParseAuth sharedInstance] logout];
                [self storageSelected:HM_storageTypeLocal];
            }];
            [controller addAction:confirmLogout];
            
            UIAlertAction *actionCancel = [UIAlertAction actionWithTitle:@"Cancel" style:UIAlertActionStyleCancel handler:nil];
            [controller addAction:actionCancel];
            
            controller.popoverPresentationController.sourceView = self.view;
            controller.popoverPresentationController.sourceRect = [tableView rectForRowAtIndexPath:indexPath];
            controller.popoverPresentationController.permittedArrowDirections = 0;
            
            [self presentViewController:controller animated:YES completion:nil];
            
            return;
        }
        
        return;
    }
    
    if (indexPath.section == HM_setupSectionTypeCredit) {
        NSArray *row = self.creditDataSource[indexPath.row];
        NSString *urlString = row[1];
        
        if (urlString && urlString.length>0) {
            [[UIApplication sharedApplication] openURL:[NSURL URLWithString:urlString] ];
        }
        
        return;
    }
    
    // storage
    if (indexPath.row == HM_storageTypeLocal) {
        [self storageSelected:HM_storageTypeLocal];
        return;
    }
    
    if (indexPath.row == HM_storageTypeParse) {
        if (![DKParseAuth sharedInstance].authenticated) {
            UIViewController *controller = [[DKParseAuth sharedInstance] authViewControllerWithPasswordLength:8 hud:[DKParseAuth sharedInstance].hud successBlock:^(id user, BOOL signup) {
                NSLog(@"success sign in TODO...?? ");
                [self storageSelected:HM_storageTypeParse];
            }];
            
            [self presentViewController:controller animated:YES completion:nil];
        }
        else {
            [self storageSelected:HM_storageTypeParse];
        }
    }
}

@end
