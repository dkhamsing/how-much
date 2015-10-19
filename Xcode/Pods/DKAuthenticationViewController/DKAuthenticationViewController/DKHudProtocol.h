//
//  DKHudProtocol.h
//  Pods
//
//  Created by Daniel Khamsing on 10/7/15.
//
//

@import UIKit;

/** HUD protocol. */
@protocol DKHudProtocol <NSObject>

/**
 Hide HUD.
 */
- (void)hideInView:(UIView *)view animationDuration:(CGFloat)duration;

/**
 Show HUD.
 */
- (void)showInView:(UIView *)view animationDuration:(CGFloat)duration;;

@end
