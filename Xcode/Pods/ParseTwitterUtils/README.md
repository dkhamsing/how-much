# Parse Twitter Utils for iOS

[![Build Status][build-status-svg]][build-status-link]
[![Coverage Status][coverage-status-svg]][coverage-status-link]
[![Podspec][podspec-svg]][podspec-link]
[![License][license-svg]][license-link]
![Platforms][platforms-svg]

A utility library to authenticate Parse `PFUser`s with Twitter. For more information see our [guide][guide].

## Getting Started

To use parse, head on over to the [releases][releases] page, and download the latest build.
And you're off! Take a look at the public [documentation][docs] and start building.

**Other Installation Options**

 1. **CocoaPods**

    Add the following line to your podfile:

        pod 'ParseTwitterUtils'

    Run pod install, and you should now have the latest parse release.

 2. **Using ParseTwitterUtils as a sub-project**

    You can also include parse as a subproject inside of your application if you'd prefer, although we do not recommend this, as it will increase your indexing time significantly. To do so, just drag and drop the `ParseTwitterUtils.xcodeproj` file into your workspace.

## How Do I Contribute?

We want to make contributing to this project as easy and transparent as possible. Please refer to the [Contribution Guidelines][contributing].

## Other Parse Projects

 - [Parse for iOS/OS X][parse-iosx-link]
 - [ParseUI for iOS][parseui-ios-link]
 - [ParseFacebookUtils for iOS][parsefacebookutils-ios-link]
 - [Parse SDK for Android][android-sdk-link]

## Dependencies

We use the following libraries as dependencies inside of ParseTwitterUtils:

 - [Parse SDK][parse-iosx-link]
 - [Bolts][bolts-framework], for task management.
 - [OCMock][ocmock-framework], for unit testing.

## License

```
Copyright (c) 2015-present, Parse, LLC.
All rights reserved.

This source code is licensed under the BSD-style license found in the
LICENSE file in the root directory of this source tree. An additional grant 
of patent rights can be found in the PATENTS file in the same directory.
```

 [parse.com]: https://www.parse.com/products/ios
 [docs]: https://www.parse.com/docs/ios/guide
 [guide]: https://parse.com/docs/ios/guide#users-twitter-users
 [blog]: https://blog.parse.com/

 [parse-iosx-link]: https://github.com/ParsePlatform/Parse-SDK-iOS-OSX
 [parseui-ios-link]: https://github.com/ParsePlatform/ParseUI-iOS
 [parsefacebookutils-ios-link]: https://github.com/ParsePlatform/ParseFacebookUtils-iOS
 [android-sdk-link]: https://github.com/ParsePlatform/Parse-SDK-Android

 [releases]: https://github.com/ParsePlatform/ParseTwitterUtils-iOS/releases
 [contributing]: https://github.com/ParsePlatform/ParseTwitterUtils-iOS/blob/master/CONTRIBUTING.md

 [bolts-framework]: https://github.com/BoltsFramework/Bolts-iOS
 [ocmock-framework]: http://ocmock.org

 [build-status-svg]: https://travis-ci.org/ParsePlatform/ParseTwitterUtils-iOS.svg
 [build-status-link]: https://travis-ci.org/ParsePlatform/ParseTwitterUtils-iOS/branches

 [coverage-status-svg]: https://codecov.io/github/ParsePlatform/ParseTwitterUtils-iOS/coverage.svg?branch=master
 [coverage-status-link]: https://codecov.io/github/ParsePlatform/ParseTwitterUtils-iOS?branch=master

 [license-svg]: https://img.shields.io/badge/license-BSD-lightgrey.svg
 [license-link]: https://github.com/ParsePlatform/ParseTwitterUtils-iOS/blob/master/LICENSE

 [podspec-svg]: https://img.shields.io/cocoapods/v/ParseTwitterUtils.svg
 [podspec-link]: https://cocoapods.org/pods/ParseTwitterUtils

 [platforms-svg]: https://img.shields.io/badge/platform-ios-lightgrey.svg
