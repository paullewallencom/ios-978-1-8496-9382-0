//
//  BTS_NCToolbarDelegate.h
//  Numbers in the Cloud
//
//  Created by rwiebe on 12-05-14.
//  Copyright (c) 2012 Burning Thumb Software. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "BTSAppDelegate.h"

@interface BTS_NCToolbarDelegate : NSObject
{
// Create a reference to the AppDelegate so
// that we only need to look it up one time
BTSAppDelegate *m_appDelegate;
    
}

// Handle the Toolbar Item selection
- (IBAction)selectToolbarItem:(id)a_sender;

@end
