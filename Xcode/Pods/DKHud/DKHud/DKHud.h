//
//  DKHud.h
//
//  Created by Daniel Khamsing on 8/12/15.
//
//

@import UIKit;

/** Simple HUD (or spinner view) for loading. */
@interface DKHud : UIView

/**
 Convenience initializer with a default style.
 @param blockUserInteraction Boolean that specifies whether the HUD blocks the UI.
 @return Instance of DKHud.
 */
- (instancetype)initWithDefaultStyleAndBlockUserInteraction:(BOOL)blockUserInteraction;

/**
 Convenience initializer.
 @param style Value from UIActivityIndicatorViewStyle enum, i.e. UIActivityIndicatorViewStyleWhiteLarge.
 @param color HUD background color.
 @param size: HUD size.
 @param alpha HUD alpha.
 @param blockUserInteraction Boolean that specifies whether the HUD blocks the UI.
 @return Instance of DKHud.
 */
- (instancetype)initWithIndicatorStyle:(NSInteger)style backgroundColor:(UIColor *)backgroundColor size:(CGFloat)size alpha:(CGFloat)alpha blockUserInteraction:(BOOL)blockUserInteraction;

/**
 Hide HUD.
 */
- (void)hideInView:(UIView *)view animationDuration:(CGFloat)duration;

/**
 Show HUD.
 */
- (void)showInView:(UIView *)view animationDuration:(CGFloat)duration;

@end
