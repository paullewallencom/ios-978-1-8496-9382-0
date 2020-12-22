//
//  BTSAppDelegate.h
//  Numbers in the Cloud
//
//  Created by rwiebe on 12-04-30.
//  Copyright (c) 2012 Burning Thumb Software. All rights reserved.
//

#import <Cocoa/Cocoa.h>

// Define the key that we will use
// to access our numbers in the 
// iCloud key / value data store
#define kBTSNCNumbersKey @"numbers"

@interface BTSAppDelegate : NSObject <NSApplicationDelegate>

@property (assign) IBOutlet NSWindow *window;

//
// Define the GUI object references
//

@property (strong) IBOutlet NSToolbar *m_toolbar;
@property (strong) IBOutlet NSToolbarItem *m_addCategoryToolbarItem;
@property (strong) IBOutlet NSToolbarItem *m_deleteCategoryToolbarItem;
@property (strong) IBOutlet NSToolbarItem *m_addKeyToolbarItem;
@property (strong) IBOutlet NSToolbarItem *m_deleteKeyToolbarItem;
@property (strong) IBOutlet NSTableView *m_categoryTableView;
@property (strong) IBOutlet NSTableView *m_keyTableView;

// 
// Define the Member elements
//

@property (strong)  NSMutableArray *m_numbersArray;

// This method will be invoked to
// save our numbers to iCloud
- (void)saveNumbersToCloud;

@end
