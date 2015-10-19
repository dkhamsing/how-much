//
//  DKHud.h.m
//
//  Created by Daniel Khamsing on 8/12/15.
//
//

#import "DKHud.h"

@interface DKHud ()

@property (nonatomic, strong) UIView *backgroundView;

@property (nonatomic, strong) UIActivityIndicatorView *activityIndicatorView;

@property (nonatomic) CGFloat initialAlpha;

@end

@implementation DKHud

- (instancetype)initWithDefaultStyleAndBlockUserInteraction:(BOOL)blockUserInteraction
;
{
    return [[DKHud alloc] initWithIndicatorStyle:UIActivityIndicatorViewStyleWhiteLarge
                                 backgroundColor:[UIColor grayColor]
                                            size:80
                                           alpha:.8
                            blockUserInteraction:blockUserInteraction];
}

- (instancetype)initWithIndicatorStyle:(NSInteger)style backgroundColor:(UIColor *)backgroundColor size:(CGFloat)size alpha:(CGFloat)alpha blockUserInteraction:(BOOL)blockUserInteraction;
{
    self.initialAlpha = alpha;
    
    self = [super init];
    if (self) {
        // init
        self.backgroundView = [[UIView alloc] init];
        self.activityIndicatorView = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:style];
        
        // subviews
        [self addSubview:self.backgroundView];
        [self.backgroundView addSubview:self.activityIndicatorView];
        
        // setup
        self.backgroundColor = [UIColor clearColor];
        self.userInteractionEnabled = blockUserInteraction;
        
        self.backgroundView.backgroundColor = backgroundColor;
        self.backgroundView.layer.cornerRadius = 6;
        self.backgroundView.alpha = 0;
        
        [self.activityIndicatorView startAnimating];
        
        // layout
        self.backgroundView.translatesAutoresizingMaskIntoConstraints = NO;
        self.activityIndicatorView.translatesAutoresizingMaskIntoConstraints = NO;
        
        NSDictionary *views = @{
                                @"background":self.backgroundView,
                                @"activity":self.activityIndicatorView,
                                @"superview":self,
                                };
        NSDictionary *metrics = @{@"side":@(size)};
        {
            NSArray *horizontal = [NSLayoutConstraint constraintsWithVisualFormat:@"[superview]-(<=1)-[background(side)]" options:NSLayoutFormatAlignAllCenterY metrics:metrics views:views];
            [self addConstraints:horizontal];
        }
        {
            NSArray *vertical = [NSLayoutConstraint constraintsWithVisualFormat:@"V:[superview]-(<=1)-[background(side)]" options:NSLayoutFormatAlignAllCenterX metrics:metrics views:views];
            [self addConstraints:vertical];
        }
        
        {
            NSArray *horizontal = [NSLayoutConstraint constraintsWithVisualFormat:@"|[activity]|" options:kNilOptions metrics:metrics views:views];
            [self.backgroundView addConstraints:horizontal];
        }
        {
            NSArray *vertical = [NSLayoutConstraint constraintsWithVisualFormat:@"V:|[activity]|" options:kNilOptions metrics:metrics views:views];
            [self.backgroundView addConstraints:vertical];
        }
    }
    
    return self;
}

- (instancetype)init;
{
    NSAssert(self.initialAlpha, @"Please use the convenience initializer - initWithIndicatorStyle:backgroundColor:alpha");
    self = [super init];
    return self;
}

#pragma mark Public

- (void)hideInView:(UIView *)view animationDuration:(CGFloat)duration;
{
    [UIView animateWithDuration:duration animations:^{
        self.backgroundView.alpha = 0;
    } completion:^(BOOL finished) {
        [self removeFromSuperview];
    }];
}

- (void)showInView:(UIView *)view animationDuration:(CGFloat)duration;
{
    [view addSubview:self];
    
    self.translatesAutoresizingMaskIntoConstraints = NO;
    
    NSDictionary *views = @{@"spinnerView":self};
    NSDictionary *metrics = nil;
    {
        NSArray *horizontal = [NSLayoutConstraint constraintsWithVisualFormat:@"|[spinnerView]|" options:kNilOptions metrics:metrics views:views];
        [view addConstraints:horizontal];
    }
    {
        NSArray *vertical = [NSLayoutConstraint constraintsWithVisualFormat:@"V:|[spinnerView]|" options:kNilOptions metrics:metrics views:views];
        [view addConstraints:vertical];
    }
    
    [UIView animateWithDuration:duration animations:^{
        self.backgroundView.alpha = self.initialAlpha;
    }];
}

@end
