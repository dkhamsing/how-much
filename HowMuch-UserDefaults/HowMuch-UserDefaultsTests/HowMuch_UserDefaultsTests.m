//
//  HowMuch_UserDefaultsTests.m
//  HowMuch-UserDefaultsTests
//
//  Created by Daniel Khamsing on 6/10/16.
//  Copyright © 2016 Daniel Khamsing. All rights reserved.
//

#import <XCTest/XCTest.h>
#import "StorageProtocol.h"
#import "UserDefaultsStorage.h"

@interface HowMuch_UserDefaultsTests : XCTestCase

@property (nonatomic, strong) UserDefaultsStorage *storage;

@property (nonatomic, strong) NSDictionary *item;

@end

static NSString * const kTestKey = @"testkey1234";

@implementation HowMuch_UserDefaultsTests

- (void)setUp {
    [super setUp];
    // Put setup code here. This method is called before the invocation of each test method in the class.
    
    self.storage = [[UserDefaultsStorage alloc] initWithKey:kTestKey];
    self.item = @{@"hi":@{@"name":@"test"}};
}

- (void)tearDown {
    // Put teardown code here. This method is called after the invocation of each test method in the class.
    [super tearDown];
    
    [self.storage debugClean];
}

- (void)testSave {
    [self.storage saveItem:self.item completion:^(NSError *error) {
        XCTAssertEqual(error, nil, @"there was an error saving");
    }];
}

- (void)testLoad {
    [self.storage saveItem:self.item completion:^(NSError *error) {
        [self.storage loadItemsWithCompletion:^(NSArray *items) {
            XCTAssertGreaterThan(items.count, 0, @"there should be one item");
        }];
    }];    
}

- (void)testUpdate {
    NSString *updatedValue = @"kjdslk";
    [self.storage saveItem:self.item completion:^(NSError *error) {
        [self.storage updateItem:self.item withValue:@{@"name":updatedValue} completion:^(NSError *error) {
            [self.storage loadItemsWithCompletion:^(NSArray *items) {
                NSDictionary *item = items.firstObject;
                NSDictionary *values = item.allValues.firstObject;
                XCTAssertTrue([updatedValue isEqualToString:values[@"name"]]);
            }];
        }];
    }];
}

@end
