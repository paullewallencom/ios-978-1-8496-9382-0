//
//  BTS_NCTableViewDelegate.h
//  Numbers in the Cloud
//
//  Created by rwiebe on 12-05-14.
//  Copyright (c) 2012 Burning Thumb Software. All rights reserved.
//


#import <Foundation/Foundation.h>
#import "BTSAppDelegate.h"

// Define the key that will be used
// to access the keys array in the categories dictionary
#define kBTSNCKeysKey @"keys"

@interface BTS_NCTableViewDelegate : NSObject
{
    // Create a reference to the AppDelegate so
    // that we only need to look it up one time
    BTSAppDelegate *m_appDelegate;
}

@end
