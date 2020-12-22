//
//  BTSAppDelegate.m
//  Numbers in the Cloud
//
//  Created by rwiebe on 12-04-30.
//  Copyright (c) 2012 Burning Thumb Software. All rights reserved.
//

#import "BTSAppDelegate.h"

@implementation BTSAppDelegate

@synthesize window = _window;

//
// Define the GUI object references
//

@synthesize m_toolbar;
@synthesize m_addCategoryToolbarItem;
@synthesize m_deleteCategoryToolbarItem;
@synthesize m_addKeyToolbarItem;
@synthesize m_deleteKeyToolbarItem;
@synthesize m_categoryTableView;
@synthesize m_keyTableView;

//
// Define the Member elements
//

@synthesize m_numbersArray;

// This method is invoked automatically
// when our App finishes launching

- (void)applicationDidFinishLaunching:
        (NSNotification *)aNotification
{
    // Insert code here to initialize your application
        
    // Create a variable to hold the error code
    BOOL l_result;
    
    // The NSUbiquitousKeyValueStore class provides a 
    // programmatic interface for storing small amounts of 
    // configuration data in iCloud.
    
    // An application must always use the default store 
    // object to get and set values. This store is tied to 
    // the unique identifier string your application provides 
    // in its entitlements.
    NSUbiquitousKeyValueStore *l_store = 
    [NSUbiquitousKeyValueStore defaultStore];
    
    // When the value of a key changes externally, the shared 
    // key-value store object posts a 
    // NSUbiquitousKeyValueStoreDidChangeExternallyNotification 
    // notification to your application. This notification is sent 
    // only when a  key changes externally or when there was a 
    // problem writing a local change to iCloud. It is not sent when
    // your application succeeds in setting a value.
    
    // Register for notifications so that we can detect errors
    [[NSNotificationCenter defaultCenter] 
     addObserver:self
     selector:@selector(updateKVStoreItems:)
     name:NSUbiquitousKeyValueStoreDidChangeExternallyNotification
     object:l_store];
    
    // Sychronize the store so that any changes that were made
    // are known to our App
    l_result = [l_store synchronize];
    
    // Retrieve the numbers from iCloud, if they are
    // not found the object will not be created
    
    // This code uses CFPropertyListCreateDeepCopy to
    // make a mutable copy of the retreived item
    // which would otherwise have some immutable
    // items
    m_numbersArray = 
    (__bridge_transfer  NSMutableArray*)
      CFPropertyListCreateDeepCopy(
       kCFAllocatorDefault, 
        (__bridge_retained  CFPropertyListRef)
         [l_store arrayForKey:kBTSNCNumbersKey], 
        kCFPropertyListMutableContainers);
    
    // If the numbers were not found in iCloud then
    // create a new, empty numbers object
    if (m_numbersArray == NULL)
    {
        m_numbersArray = [[NSMutableArray alloc] init];
    }
    
    // Update the GUI
    [m_categoryTableView reloadData];
}

// This method will be invoked by the toolbar
// and tableview delegate methods whenever they
// need to update iCloud
// 
// Input: none
//
// Output: none

- (void)saveNumbersToCloud
{
    // Create a variable to hold the error code
    BOOL l_result;
    
    // The NSUbiquitousKeyValueStore class provides a 
    // programmatic interface for storing small amounts of 
    // configuration data in iCloud.
    
    // An application must always use the default store 
    // object to get and set values. This store is tied to 
    // the unique identifier string your application provides 
    // in its entitlements.
    NSUbiquitousKeyValueStore *l_store = 
    [NSUbiquitousKeyValueStore defaultStore];
    
    // Write the Array to local memory
    // in such a way that it will automatically
    // be written to disk and then automatically
    // be transferred to iCloud
    [l_store setArray:m_numbersArray forKey:kBTSNCNumbersKey];
    
    // Sychronize the store so that any changes that were made
    // are known to our App
    l_result = [l_store synchronize];
    
}

/*
 This notification is posted when the Key-Value
 Store changes.  We register to receive this
 notificaiton in the applicationDidFinishLaunching
 method
 
 Input: A notification whose userInfo contains
 the changed item reason or error and
 keys.
 
 Output: none
 */

- (void)updateKVStoreItems:(NSNotification*)a_notification 
{
    
    // Get the userInfo dictionary from
    // the notification object
    NSDictionary* l_userInfo = [a_notification userInfo];
    
    // Get the reason for the change
    // from the userInfo dictionary
    NSNumber* reasonForChange = 
    [l_userInfo
     objectForKey:NSUbiquitousKeyValueStoreChangeReasonKey];
    
    NSInteger l_reason = -1;
    
    // If a reason could not be determined, do not update anything.
    if (!reasonForChange)
        return;
    
    // Convert the NSNumber object to an 
    // integer
    l_reason = [reasonForChange integerValue];
    
    // Update only for changes from the server.
    if ((l_reason == NSUbiquitousKeyValueStoreServerChange) ||
        (l_reason == NSUbiquitousKeyValueStoreInitialSyncChange)) 
    {
        
        // Get the array of keys that changed
        // This should only ever include one string
        // with the value kBTSNCNumbersKey
        NSArray* l_changedKeys = 
        [l_userInfo 
         objectForKey:NSUbiquitousKeyValueStoreChangedKeysKey];
        
        // An application must always use the default store 
        // object to get and set values. This store is tied to 
        // the unique identifier string your application provides 
        // in its entitlements.
        NSUbiquitousKeyValueStore *l_store = 
        [NSUbiquitousKeyValueStore defaultStore];
        
        // Loop over the keys
        for (NSString* key in l_changedKeys) 
        {
            // This should be the only key
            if ([key isEqual:kBTSNCNumbersKey ])
            {
                // This code uses CFPropertyListCreateDeepCopy to
                // make a mutable copy of the retreived item
                // which would otherwise have some immutable
                // items
                m_numbersArray = 
                (__bridge_transfer  NSMutableArray*)
                CFPropertyListCreateDeepCopy(
                                             kCFAllocatorDefault, 
                                             (__bridge_retained  CFPropertyListRef)
                                             [l_store arrayForKey:kBTSNCNumbersKey], 
                                             kCFPropertyListMutableContainers);
                
                
                // Update the GUI
                [m_categoryTableView reloadData];
                
            }
        }
    }
}
@end
