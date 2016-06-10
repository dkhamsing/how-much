//
//  ListController.m
//  HowMuchCore
//
//  Created by Daniel Khamsing on 6/9/16.
//

#import "ListController.h"

// Auth
#import "DKAuthenticationViewController.h"

// Input
#import "InputController.h"

// Views
#import "DKHud.h"

@interface ListController () <UITableViewDataSource, UITableViewDelegate>

@property (nonatomic, strong) DKHud *hud;

//@property (nonatomic, strong) UILabel *noContentLabel;

@property (nonatomic, strong) UITableView *tableView;

@end

@implementation ListController

- (void)viewDidLoad;
{
    [super viewDidLoad];

    [self setup];
}

- (void)setup;
{
    // init
    self.hud = [[DKHud alloc] initWithDefaultStyleAndBlockUserInteraction:YES];

    self.tableView = [[UITableView alloc] initWithFrame:self.view.bounds];

    // layout
    [self.view addSubview:self.tableView];
    self.tableView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;

    //    [self.view addSubview:label];
    //    label.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;

    // set
    self.title = self.coordinator.title;

    self.view.backgroundColor = self.coordinator.backgroundColor;

    self.tableView.delegate = self;
    self.tableView.dataSource = self;

    if ([self.coordinator.storage respondsToSelector:@selector(loadItemsWithCompletion:)]) {
        [self.coordinator.storage loadItemsWithCompletion:^(NSArray *items) {
            self.coordinator.items = items;
            [self render];
        }];
    }

    if (self.coordinator.signedIn &&
        [self.coordinator.storage respondsToSelector:@selector(setupListenerWithCompletion:)]) {
        [self.hud showInView:self.view animationDuration:0];
        [self.coordinator.storage setupListenerWithCompletion:^(NSArray *items) {
            [self.hud hideInView:self.view animationDuration:0];

            self.coordinator.items = items;
            [self render];
        }];
    }
}

- (void)viewWillAppear:(BOOL)animated;
{
    [super viewWillAppear:animated];

    [self render];
}

- (void)render;
{
    [self.tableView reloadData];

    UIBarButtonItem *addButton = [[UIBarButtonItem alloc]initWithBarButtonSystemItem:UIBarButtonSystemItemAdd target:self action:@selector(actionAdd)];

    if (self.coordinator.overrideSignIn) {
        self.navigationItem.rightBarButtonItem = addButton;

        return;
    }

    self.navigationItem.leftBarButtonItem = self.coordinator.signedIn ?
    [[UIBarButtonItem alloc] initWithTitle:@"Sign Out" style:UIBarButtonItemStylePlain target:self action:@selector(actionSignOut)]:
    [[UIBarButtonItem alloc] initWithTitle:@"Sign In"  style:UIBarButtonItemStylePlain target:self action:@selector(actionSignIn)];

    self.navigationItem.rightBarButtonItem = self.coordinator.signedIn ? addButton : nil;
}

#pragma mark Private

- (void)actionAdd;
{
    InputController *inputController = [[InputController alloc] init];
    inputController.completion = ^void (NSDictionary *value) {
        NSMutableDictionary *updated = value.mutableCopy;

        NSInteger dateInt = @( [[NSDate date] timeIntervalSince1970] ).integerValue;
        updated[@"dateUpdated"] = @(dateInt);

        NSString *uuid = [[NSUUID UUID] UUIDString];
        NSDictionary *insert = @{uuid:updated};

        [self.coordinator.storage saveItem:insert completion:^(NSError *error) {
            if (error) {
                NSLog(@"TODO save handle error");
                return;
            }

            if ([self.coordinator.storage respondsToSelector:@selector(loadItemsWithCompletion:)]) {
                [self.coordinator.storage loadItemsWithCompletion:^(NSArray *items) {
                    self.coordinator.items = items;
                    [self render];
                }];
            }
        }];
    };

    UINavigationController *navigationController = [[UINavigationController alloc] initWithRootViewController:inputController];
    [self presentViewController:navigationController animated:YES completion:nil];
}

- (void)actionSignIn;
{
    UIColor *color = self.navigationController.navigationBar.tintColor;
    NSArray *classes = @[[DKAuthenticationViewController class]];
    [[UIButton appearanceWhenContainedInInstancesOfClasses:classes] setTitleColor:color forState:UIControlStateNormal];

    DKAuthenticationViewController *authController = [[DKAuthenticationViewController alloc] init];

    authController.passwordLength = 6;
    authController.hud = (id<DKHudProtocol>)self.hud;
    authController.authentication = self.coordinator.auth;
    authController.successBlock = ^void(id user, BOOL signup) {
        self.coordinator.signedIn = YES;
        [self render];

        if ([self.coordinator.storage respondsToSelector:@selector(loadItemsWithCompletion:)]) {
            [self.coordinator.storage loadItemsWithCompletion:^(NSArray *items) {
                self.coordinator.items = items;
                [self render];
            }];
        }

        if ([self.coordinator.storage respondsToSelector:@selector(setupListenerWithCompletion:)]) {
            [self.hud showInView:self.view animationDuration:0];
            [self.coordinator.storage setupListenerWithCompletion:^(NSArray *items) {
                [self.hud hideInView:self.view animationDuration:0];

                self.coordinator.items = items;
                [self render];
            }];
        }
    };

    UINavigationController *navigationController = [[UINavigationController alloc] initWithRootViewController:authController];
    navigationController.navigationBar.tintColor = color;
    [self presentViewController:navigationController animated:YES completion:nil];
}

- (void)actionSignOut;
{
    [self.coordinator.auth logout];

    self.coordinator.signedIn = NO;
    self.coordinator.items = [NSArray new];
    [self render];
}

#pragma mark Table view

- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath;
{
    return YES;
}

- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        NSDictionary *item = self.coordinator.items[indexPath.row];
        [self.coordinator.storage deleteItem:item completion:^(NSError *error) {
            [self.coordinator.storage loadItemsWithCompletion:^(NSArray *items) {
                self.coordinator.items = items;
                [self render];
            }];
        }];
    }
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section;
{
    return self.coordinator.items.count;
}

static NSString * const cellId = @"cellId";

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath;
{
    NSDictionary *item = self.coordinator.items[indexPath.row];

    NSDictionary *values = [self.coordinator.storage valuesForItem:item];
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellId];
    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:cellId];
    }
    
    NSNumber *priceNumber = values[@"price"];
    NSString *price = [NSString stringWithFormat:@"%@%.2f", self.coordinator.unit, priceNumber.doubleValue];
    
    cell.textLabel.text = values[@"name"];
    cell.detailTextLabel.text = price;

    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath;
{
    NSDictionary *item = self.coordinator.items[indexPath.row];
    NSDictionary *values = [self.coordinator.storage valuesForItem:item];
    InputController *inputController = [[InputController alloc] initWithItem:values];
    inputController.completion = ^void(NSDictionary *value){
        NSMutableDictionary *insert = value.mutableCopy;
        NSInteger dateInt = @( [[NSDate date] timeIntervalSince1970] ).integerValue;
        insert[@"dateUpdated"] = @(dateInt);

        [self.coordinator.storage updateItem:item withValue:insert completion:^(NSError *error) {
            if ([self.coordinator.storage respondsToSelector:@selector(loadItemsWithCompletion:)]) {
                [self.coordinator.storage loadItemsWithCompletion:^(NSArray *items) {
                    self.coordinator.items = items;
                    [self render];
                }];
            }
        }];
    };

    UINavigationController *navigationController = [[UINavigationController alloc] initWithRootViewController:inputController];
    [self presentViewController:navigationController animated:YES completion:nil];
}

@end

@implementation ListCoordinator

+ (instancetype)coreViewModel;
{
    ListCoordinator *viewModel = [[ListCoordinator alloc] init];

    viewModel.title = @"How Much";
    viewModel.backgroundColor = [UIColor lightGrayColor];
    viewModel.unit = @"$";

    return viewModel;
}

@end
