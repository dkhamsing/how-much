//
//  AuthenticationController.m
//  HowMuch
//
//  Created by Daniel Khamsing on 9/17/15.
//  Copyright © 2015 Daniel Khamsing. All rights reserved.
//

#import "AuthenticationController.h"

// Categories
#import "UIColor+HM.h"

// Constants
#import "HowMuchConstants.h"
#import "HowmuchKeys.h"

// Twitter
@import Accounts;
#import "ParseTwitterUtils.h"
#import "DKTwitterReverseAuth.h"

// Vendor
#import "SVProgressHUD.h"

// Views
#import "InputCell.h"

@interface AuthenticationController () <UITableViewDataSource, UITableViewDelegate, UITextFieldDelegate>

@property (nonatomic, strong) UITableView *tableView;

@property (nonatomic, strong) NSArray *dataSource;

@property (nonatomic, strong) UIView *footerView;

@property (nonatomic, strong) UIButton *toggleButton;

@property (nonatomic, strong) UIButton *goButton;

@property (nonatomic, strong) InputCell *emailInputCell;

@property (nonatomic, strong) InputCell *passwordInputCell;

@property (nonatomic, strong) InputCell *passwordConfirmInputCell;

@property (nonatomic) BOOL signup;

//@property (nonatomic, strong) TWTAPIManager *apiManager;

@property (nonatomic, strong) ACAccountStore *accountStore;

@end

@implementation AuthenticationController

NS_ENUM(NSInteger, HM_loginRowType) {
    HM_loginRowTypeEmail,
    HM_loginRowTypePassword,
    HM_loginRowTypePasswordConfirm,
};

NS_ENUM(NSInteger, HM_loginSectionType) {
    HM_loginSectionTypeInput,
    HM_loginSectionTypeActions,
    HM_loginSectionCount,
};

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    // Init
    self.accountStore = [[ACAccountStore alloc] init];
    
    self.tableView = [[UITableView alloc] initWithFrame:self.view.bounds style:UITableViewStyleGrouped];
    
    self.emailInputCell = [[InputCell alloc] init];
    self.passwordInputCell = [[InputCell alloc] init];
    self.passwordConfirmInputCell = [[InputCell alloc] init];
    
    self.goButton = [[UIButton alloc] init];
    self.toggleButton = [[UIButton alloc] init];
    
    self.footerView = [[UIView alloc] initWithFrame:({
        CGRect frame = self.view.bounds;
        frame.size.height = 40;
        frame;
    })];
    
    // Subviews
    [self.view addSubview:self.tableView];
    [self.footerView addSubview:self.goButton];
    [self.footerView addSubview:self.toggleButton];
    
    // Setup
    self.title = @"Login";
    
    {
        HowmuchKeys *keys = [[HowmuchKeys alloc] init];
        [[DKTwitterReverseAuth sharedInstance] configureConsumerKey:keys.twitterConsumerKey consumerSecret:keys.twitterConsumerSecret];
    }
    
    self.toggleButton.titleLabel.font = [UIFont systemFontOfSize:12];
    [self.toggleButton setTitleColor:[UIColor grayColor] forState:UIControlStateNormal];
    [self.toggleButton addTarget:self action:@selector(actionToggle) forControlEvents:UIControlEventTouchUpInside];
    [self.toggleButton setTitle:@"sign up" forState:UIControlStateNormal];
    
    [self.goButton setTitleColor:[UIColor hm_tintColor] forState:UIControlStateNormal];
    [self.goButton setTitle:@"go" forState:UIControlStateNormal];
    [self.goButton addTarget:self action:@selector(actionGo) forControlEvents:UIControlEventTouchUpInside];
    
    self.emailInputCell.textField.delegate = self;
    self.passwordInputCell.textField.delegate = self;
    self.passwordConfirmInputCell.textField.delegate = self;
    
    self.emailInputCell.textField.placeholder = @"Email";
    self.passwordInputCell.textField.placeholder = @"Password";
    self.passwordConfirmInputCell.textField.placeholder = @"Confirm Password";
    
    self.emailInputCell.textField.autocorrectionType = UITextAutocorrectionTypeNo;
    self.emailInputCell.textField.keyboardType = UIKeyboardTypeEmailAddress;
    
    self.passwordInputCell.textField.secureTextEntry = YES;
    self.passwordConfirmInputCell.textField.secureTextEntry = YES;
    
    [@[self.emailInputCell, self.passwordInputCell, self.passwordConfirmInputCell] enumerateObjectsUsingBlock:^(UITableViewCell * obj, NSUInteger idx, BOOL * _Nonnull stop) {
        obj.selectionStyle = UITableViewCellSelectionStyleNone;
    }];
    
    self.tableView.keyboardDismissMode = UIScrollViewKeyboardDismissModeOnDrag;
    
    self.tableView.dataSource = self;
    self.tableView.delegate = self;
    
    self.dataSource = @[
                        @"Email",
                        @"Password",
                        ];
    
    // Layout
    self.tableView.autoresizingMask = UIViewAutoresizingFlexibleHeight | UIViewAutoresizingFlexibleWidth;
    
    self.goButton.translatesAutoresizingMaskIntoConstraints = NO;
    self.toggleButton.translatesAutoresizingMaskIntoConstraints = NO;
    
    NSDictionary *views = @{
                            @"go":self.goButton,
                            @"toggle":self.toggleButton,
                            };
    NSDictionary *metrics = nil;
    
    {
        NSArray *constraints = [NSLayoutConstraint constraintsWithVisualFormat:@"|[toggle][go(toggle)]|" options:kNilOptions metrics:metrics views:views];
        [self.footerView addConstraints:constraints];
    }
    
    {
        NSArray *constraints = [NSLayoutConstraint constraintsWithVisualFormat:@"V:|[go]|" options:kNilOptions metrics:metrics views:views];
        [self.footerView addConstraints:constraints];
    }
    {
        NSArray *constraints = [NSLayoutConstraint constraintsWithVisualFormat:@"V:|[toggle]|" options:kNilOptions metrics:metrics views:views];
        [self.footerView addConstraints:constraints];
    }
}

#pragma mark Private

- (void)errorAlertMessage:(NSString *)message {
    [SVProgressHUD dismiss];
    [self errorAlertMessage:message focusInputCell:nil];
}

- (void)errorAlertMessage:(NSString *)message focusInputCell:(InputCell *)inputCell {
    if (inputCell) {
        [inputCell.textField becomeFirstResponder];
    }
    
    UIAlertController *controller = [UIAlertController alertControllerWithTitle:@"Error" message:message preferredStyle:UIAlertControllerStyleAlert];
    
    UIAlertAction *okAction = [UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault handler:nil];
    [controller addAction:okAction];
    
    [self presentViewController:controller animated:YES completion:nil];
}

- (void)finish {
    [SVProgressHUD dismiss];
    [self.view endEditing:YES];
    [[NSNotificationCenter defaultCenter] postNotificationName:hm_notificationSelectedStorage object:@(HM_storageTypeParse)];
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (void)twitterLoginWithAccount:(ACAccount *)account {
    [SVProgressHUD show];    
    [[DKTwitterReverseAuth sharedInstance] performReverseAuthForAccount:account withHandler:^(NSDictionary *jsonResponse, NSError *error) {
        if (error) {
            NSString *message = [NSString stringWithFormat:@"There was a problem with Twitter login (reverse auth process error: %@).", error.localizedDescription];
            [self errorAlertMessage:message];
        }
        else {
            [PFTwitterUtils initializeWithConsumerKey:[DKTwitterReverseAuth sharedInstance].consumerKey consumerSecret:[DKTwitterReverseAuth sharedInstance].consumerSecret];
            [PFTwitterUtils logInWithTwitterId:jsonResponse[tw_key_user_id] screenName:jsonResponse[tw_key_screen_name] authToken:jsonResponse[tw_key_oauth_token] authTokenSecret:jsonResponse[tw_key_oauth_token_secret] block:^(PFUser * _Nullable user, NSError * _Nullable error) {
                dispatch_async(dispatch_get_main_queue(), ^{
                    if (!user) {
                        [self errorAlertMessage:@"There was a problem with Twitter login."];
                        return;
                    }
                    
                    [self finish];
                });
            }];
        }
    }];
}

- (BOOL)validEmail {
    NSString *email = self.emailInputCell.textField.text;
    return email.length>5 && [email containsString:@"@"];
    
    return NO;
}

- (BOOL)validPassword {
    NSString *password = self.passwordInputCell.textField.text;
    
    return password.length>7;
    
    return NO;
}

- (BOOL)validConfirmPassword {
    NSString *password = self.passwordInputCell.textField.text;
    NSString *passwordConfirm = self.passwordConfirmInputCell.textField.text;
    
    return self.signup ? [password isEqualToString:passwordConfirm] : YES;
    
    return NO;
}

- (BOOL)validated {
    return [self validEmail] && [self validPassword] & [self validConfirmPassword];
}

#pragma mark Actions

- (void)actionGo {
    if (![self validated]) {
        if (![self validEmail]) {
            [self errorAlertMessage:@"Invalid email, please try again." focusInputCell:self.emailInputCell];
            return;
        }
        
        if (![self validPassword]) {
            [self errorAlertMessage:@"Your password must be at least 7 characters, please try again." focusInputCell:self.passwordInputCell];
            return;
        }
        
        if (![self validConfirmPassword]) {
            [self errorAlertMessage:@"Your passwords do not match, please try again."];
            return;
        }
        
        NSString *error = @"There was an error";
        [self errorAlertMessage:error];
        return;
    }
    
    NSString *email = [self.emailInputCell.textField.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
    NSString *password = self.passwordInputCell.textField.text ;
    if (self.signup) {
        [SVProgressHUD show];
        [self.authentication signupWithEmail:email password:password success:^(NSString *errorMessage) {
            if (errorMessage) {
                [self errorAlertMessage:errorMessage];
            }
            else {
                [self finish];
            }
        }];
    }
    else {
        [self.authentication loginWithEmail:email password:password success:^(NSString *errorMessage) {
            if (errorMessage) {
                [self errorAlertMessage:errorMessage];
            }
            else {
                [self finish];
            }
        }];
    }
}

- (void)actionToggle {
    self.signup = self.signup ? NO : YES;
    
    self.title = !self.signup?@"Login":@"Sign Up";
    
    [self.toggleButton setTitle:self.signup?@"login":@"sign up" forState:UIControlStateNormal];
    
    self.dataSource = self.signup ?
    @[
      @"Email",
      @"Password",
      @"Password Confirm",
      ]:
    @[
      @"Email",
      @"Password",
      ];
    
    NSArray *indexPaths = @[
                            [NSIndexPath indexPathForRow:HM_loginRowTypePasswordConfirm inSection:HM_loginSectionTypeInput],
                            ];
    if (self.signup) {
        [self.tableView insertRowsAtIndexPaths:indexPaths withRowAnimation:UITableViewRowAnimationTop];
    }
    else {
        [self.tableView deleteRowsAtIndexPaths:indexPaths withRowAnimation:UITableViewRowAnimationTop];
    }
}

#pragma mark - Table View

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return HM_loginSectionCount;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if (section==HM_loginSectionTypeActions)
        return self.editing?0:1;
    
    return self.dataSource.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.section==HM_loginSectionTypeInput) {
        if (indexPath.row == HM_loginRowTypeEmail)
            return self.emailInputCell;
        
        if (indexPath.row == HM_loginRowTypePassword)
            return self.passwordInputCell;
        
        if (indexPath.row == HM_loginRowTypePasswordConfirm)
            return self.passwordConfirmInputCell;
        
        else
            return [[InputCell alloc] init];
    }
    
    NSString *cellId = @"actionCell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellId];
    if (!cell) {
        cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellId];
        cell.textLabel.textAlignment = NSTextAlignmentCenter;
    }
    
    cell.textLabel.text = @"Twitter";
    
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    if (section==HM_loginSectionTypeInput) {
        return 30;
    }
    return 0;
}

- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section {
    return section==HM_loginSectionTypeInput ? self.footerView:nil;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    if (indexPath.section==HM_loginSectionTypeActions) {
        UITableViewCell *cell = [tableView cellForRowAtIndexPath:indexPath];
        if ([cell.textLabel.text isEqualToString:@"Twitter"]) {
            ACAccountType *accountType = [self.accountStore accountTypeWithAccountTypeIdentifier:ACAccountTypeIdentifierTwitter];
            
            [self.accountStore requestAccessToAccountsWithType:accountType options:nil completion:^(BOOL granted, NSError *error) {
                if (!granted) {
                    dispatch_async(dispatch_get_main_queue(), ^{
                        [self errorAlertMessage:@"Please enable access to Twitter in Settings → Privacy."];
                    });
                }
                else {
                    NSArray *accounts = [self.accountStore accountsWithAccountType:accountType];
                    if (accounts.count==0) {
                        dispatch_async(dispatch_get_main_queue(), ^{
                            [self errorAlertMessage:@"Please add a Twitter account in Settings → Twitter."];
                        });
                    }
                    else {
                        if (accounts.count==1) {
                            [self twitterLoginWithAccount:accounts.firstObject];
                            return ;
                        }
                        
                        UIAlertController *controller = [UIAlertController alertControllerWithTitle:nil message:nil preferredStyle:UIAlertControllerStyleActionSheet];
                        
                        [accounts enumerateObjectsUsingBlock:^(ACAccount * obj, NSUInteger idx, BOOL * _Nonnull stop) {
                            UIAlertAction *twitter = [UIAlertAction actionWithTitle:obj.username style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
                                [self twitterLoginWithAccount:obj];
                            }];
                            [controller addAction:twitter];
                        }];
                        
                        UIAlertAction *cancel = [UIAlertAction actionWithTitle:@"Cancel" style:UIAlertActionStyleCancel handler:nil];
                        [controller addAction:cancel];
                        
                        controller.popoverPresentationController.sourceView = self.view;
                        controller.popoverPresentationController.sourceRect = [tableView rectForRowAtIndexPath:indexPath];
                        controller.popoverPresentationController.permittedArrowDirections = 0;
                        
                        dispatch_async(dispatch_get_main_queue(), ^{
                            [self presentViewController:controller animated:YES completion:nil];
                        });
                    }
                }
            }];
        }
        return;
    }
}

#pragma mark - UITextField

- (void)textFieldDidBeginEditing:(UITextField *)textField {
    self.editing = YES;
    [self.tableView reloadSections:[NSIndexSet indexSetWithIndex:HM_loginSectionTypeActions] withRowAnimation:NO];
}

@end
