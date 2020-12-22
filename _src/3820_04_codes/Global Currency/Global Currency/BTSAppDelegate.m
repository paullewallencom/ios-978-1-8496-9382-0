//
//  BTSAppDelegate.m
//  Global Currency
//
//  Created by rwiebe on 12-04-23.
//  Copyright (c) 2012 BurningThumb Software. All rights reserved.
//

#import "BTSAppDelegate.h"

@implementation BTSAppDelegate

@synthesize window = _window;

/* 
    Define the GUI elements
 */

@synthesize mLastUpdateTimeTextField;
@synthesize mLastUpdateTimeProgressIndicator;
@synthesize mValueToConvertTextField;
@synthesize mCurrencyToConvertPopUp;
@synthesize mConvertedCurrencyTableView;

/*
    Define the Member elements
 */

@synthesize mLastUpdateTime;
@synthesize mCurrencyRates;

/*
 This method will download the XML file from
 the European Central Bank and parse it into
 member variables.
 
 Input: 
 a_object - the protocol for NSThread requires
            this method to take an arbitrary
            object as an argument.  It will 
            not be used.
 
 Output:
 As a side effect, the member variables mLastUpdateTime
 and mCurrencyRates will be populated.
 */

- (void) getExchangeRatesFromECB: (id)a_object
{
    // Create a URL object using a string
    NSURL *l_URL = [NSURL URLWithString: D_ECB_RATES_URL];
    
    // Create an XML Document object and
    // initialize it with the contents of the URL
    // This downloads the contents of the URL
    // from the internet
    NSXMLDocument * l_xmlDocument = [[NSXMLDocument alloc] 
                                     initWithContentsOfURL:l_URL 
                                     options:NSXMLDocumentTidyXML 
                                     error: Nil];
    // If the XML document was
    // successfully retrieved we
    // can parse it
    if (l_xmlDocument)
    {
    
        // Declare an array object that we
        // can use to examine nodes
        NSArray *l_nodes;
    
        // Create an array of nodes at the path
        // where we can find the time attribute
        l_nodes = [l_xmlDocument nodesForXPath:D_XML_PATH_TIME 
                                        error:Nil];
    
        // Extract the time attribute from the node
        mLastUpdateTime = 
         [[[l_nodes objectAtIndex:0] 
          attributeForName: kTimeKey] 
           stringValue];
    
        // Create an array of nodes at the path
        // where we can find the currency and rate attributes
        l_nodes = [l_xmlDocument nodesForXPath:D_XML_PATH_RATES 
                                        error:Nil];
        
        // Declare some working variables
        NSString *l_currency;
        NSString *l_rate;
        NSXMLElement *l_element;
    
        // Loop over all the currency and rate nodes
        // and look at each element
        for (l_element in l_nodes)
        {
            // Extract the currency attribute into a NSString
            l_currency = [[l_element attributeForName: kCurrencyKey] 
                          stringValue];
        
            // Extract the rate attribute into a NSString
            l_rate = [[l_element attributeForName: kRateKey] 
                      stringValue];
        
            // Add the rate to the mutable NSDictionary using
            // the currency as the dictionary key
            [mCurrencyRates setObject:l_rate
                               forKey:l_currency];
        }
    }

    // Because this method will execute on a 
    // backgrond thread we need to invoke
    // another method, on the main thread, to
    // update the GUI
    [self 
     performSelectorOnMainThread:@selector(populateGUIOnMainThread:)
                      withObject:nil
                   waitUntilDone:NO];
}

/*
 This method will be called from the 
 getExchangeRatesFromECB: to update
 the GUI from the main thread
 
 Input: 
 a_object - the protocol for 
 performSelectorOnMainThread requires
 this method to take an arbitrary
 object as an argument.  It will 
 not be used.
 
 Output:
 As a side effect, the GUI will be updated
 and the progress indicator will stop 
 animating.
 */

- (void) populateGUIOnMainThread: (id) a_object
{
    // If the last update time is nil its because
    // the XML file could not be retrieved or
    // parsed so there is nothing to 
    // display
    if (mLastUpdateTime)
    {
        // Display the time in the GUI
        [mLastUpdateTimeTextField setStringValue:mLastUpdateTime];
    
        // Remove everything from the Pop Up Menu
        [mCurrencyToConvertPopUp removeAllItems];
        
        // Add an item "Select Currency" to the Pop Up menu
        [mCurrencyToConvertPopUp addItemWithTitle:D_SELECT_CURRENCY];
        
        // The currency rates returned in the XML
        // file are not sorted.  Create a new NSArray
        // sorted in alphabetical order
        NSArray *l_sortedKeys = [[mCurrencyRates allKeys] 
                   sortedArrayUsingSelector:@selector(compare:)];
        
        // Add the currencies to the Pop Up Menu
        [mCurrencyToConvertPopUp addItemsWithTitles: l_sortedKeys];
    }
    
    // Stop animating the progress indicator.
    // Animation was started just before the 
    // background thread to download the XML file
    // was invoked
    [mLastUpdateTimeProgressIndicator stopAnimation:self];
}

// This method will be invoked whenever a currency
// code is selected from the Pop Up Menu
- (IBAction)selectToCurrency:(id)a_sender
{
    
//        NSBeep();
    
    // Send a message to the table view telling it that
    // it needs to reload its data
    [mConvertedCurrencyTableView reloadData];
}

- (void)applicationDidFinishLaunching:(NSNotification *)aNotification
{
    // Insert code here to initialize your application
    
    // Create a mutable NSDictionary so that we can 
    // save the exchange rate information
    mCurrencyRates = [[NSMutableDictionary alloc] init];

    // Modify the Progress Indicator
    // so that it is not visible when
    // it is not animating
    [mLastUpdateTimeProgressIndicator 
     setDisplayedWhenStopped:NO];
    
    // Start the Progress Indicator spinning
    // It will spin until the XML file is
    // downloaded and parsed.  It should be
    // very brief
    [mLastUpdateTimeProgressIndicator 
     startAnimation:self];
    
    // Start the background thread to download
    // the XML file
    [NSThread 
     detachNewThreadSelector:@selector(getExchangeRatesFromECB:) 
                    toTarget:self 
                  withObject:nil];
    

}

@end
