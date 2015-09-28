# DKTwitterReverseAuth

Simple Twitter Reverse Authentication for iOS 

![](Assets/demo.gif)

# Installation

## [CocoaPods](https://cocoapods.org/)

``` ruby
platform :ios, '7.0'
pod 'DKTwitterReverseAuth'
```

## Manual

Add the files in the DKTwitterReverseAuth folder to your project.

## Usage

``` objc
ACAccountStore *store = [[ACAccountStore alloc] init];
ACAccountType *accountType = [store accountTypeWithAccountTypeIdentifier:ACAccountTypeIdentifierTwitter];
[store requestAccessToAccountsWithType:accountType options:nil completion:^(BOOL granted, NSError *error) {
    if (granted) {
        NSArray *accounts = [store accountsWithAccountType:accountType];
        ACAccount *account = accounts.firstObject;        
        [[DKTwitterReverseAuth sharedInstance] performReverseAuthForAccount:account withHandler:^(NSDictionary *responseJson, NSError *error) {
            if (!error) {
                NSLog(@"👍 got oauth token: %@, response: %@", responseJson[tw_key_oauth_token], responseJson);
            }
        }];
    }
}];
```

# Demo

DKTwitterReverseAuth includes a demo project.

# Thanks

This project uses the work of [Loren Brichter](https://github.com/atebits/OAuthCore) and [Sean Cook](https://github.com/seancook/TWReverseAuthExample).

# Contact

- [github.com/dkhamsing](https://github.com/dkhamsing)
- [twitter.com/dkhamsing](https://twitter.com/dkhamsing)

# License

DKTwitterReverseAuth is available under the MIT license. See the [LICENSE](LICENSE) file for more info.
