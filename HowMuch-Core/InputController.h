//
//  InputController.h
//  HowMuchCore
//
//  Created by Daniel Khamsing on 6/9/16.
//

#import <XLForm/XLForm.h>

@interface InputController : XLFormViewController

- (instancetype)initWithItem:(NSDictionary *)item;

@property (nonatomic, copy) void (^completion)(NSDictionary *values);

@end
