# DKHud

Simple hud for iOS.

![](Assets/demo.gif)

# Installation

## [CocoaPods](https://cocoapods.org/)

``` ruby
platform :ios, '8.0'
pod 'DKHud'
```

## Manual

Add the files in the DKHud folder to your project.

## Usage

``` objc
DKHud *hud = [[DKHud alloc] initWithDefaultStyleAndBlockUserInteraction:NO];
[hud showInView:self.view animationDuration:.2];
   
```

# Demo

DKHud includes a demo project.

# Contact

- [github.com/dkhamsing](https://github.com/dkhamsing)
- [twitter.com/dkhamsing](https://twitter.com/dkhamsing)

# License

DKHud is available under the MIT license. See the [LICENSE](LICENSE) file for more info.
