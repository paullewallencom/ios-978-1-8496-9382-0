//
//  BTS_GCTableViewDelegate.h
//  Global Currency
//
//  Created by rwiebe on 12-04-28.
//  Copyright (c) 2012 BurningThumb Software. All rights reserved.
//

#import "BTSAppDelegate.h"
#import <Foundation/Foundation.h>

// Create defines that will be used
// to identify the column in the
// table view

#define kBTSGCCurrency @"currency"
#define kBTSGCValue @"value"

@interface BTS_GCTableViewDelegate : NSObject
{
    // Create a reference to the AppDelegate so
    // that we only need to look it up one time
    BTSAppDelegate *mAppDelegate;
}
@end
