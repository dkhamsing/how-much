//
//  InputController.h
//  
//
//  Created by Daniel Khamsing on 9/17/15.
//
//

#import <UIKit/UIKit.h>

@class Item;
@class InputController;

@protocol InputControllerProtocol <NSObject>

- (void)InputController:(InputController *)controller savedItem:(Item *)item;

@end

@interface InputController : UIViewController

@property (nonatomic, weak) id delegate;

@property (nonatomic, strong) Item *item;

@property (nonatomic, strong) NSArray *unitsDataSource;

@end
