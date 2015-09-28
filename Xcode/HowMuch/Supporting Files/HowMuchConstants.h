//
//  HowMuchConstants.h
//  HowMuch
//
//  Created by Daniel Khamsing on 9/18/15.
//  Copyright © 2015 Daniel Khamsing. All rights reserved.
//

static NSString * const hm_appName = @"How Much";

static NSString * const hm_notificationSelectedStorage = @"hm_notificationSelectedStorage";

typedef NS_ENUM(NSInteger, HM_storageType) {
    HM_storageTypeLocal,
    HM_storageTypeParse,
    //    HM_storageTypeiCloud,
};
