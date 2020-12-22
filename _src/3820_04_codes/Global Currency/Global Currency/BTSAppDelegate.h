//
//  BTSAppDelegate.h
//  Global Currency
//
//  Created by rwiebe on 12-04-23.
//  Copyright (c) 2012 BurningThumb Software. All rights reserved.
//

#import <Cocoa/Cocoa.h>

/* 
    Global Currency defines
 */

// The European Central Bank exchange rate XML File
#define D_ECB_RATES_URL @"http://www.ecb.int/stats/eurofxref/eurofxref-daily.xml"

// The path to the last update time in the XML tree
#define D_XML_PATH_TIME @"/gesmes:Envelope/Cube/Cube"

// The path to the exchange rates in the XML tree
#define D_XML_PATH_RATES @"/gesmes:Envelope/Cube/Cube/Cube"

// The popup menu title
#define D_SELECT_CURRENCY @"Select Currency"

// The keys for the XML attributes
#define kTimeKey @"time"
#define kCurrencyKey @"currency"
#define kRateKey @"rate"

@interface BTSAppDelegate : NSObject <NSApplicationDelegate>

@property (assign) IBOutlet NSWindow *window;

/* 
    Define the GUI elements
 */

@property (assign) IBOutlet NSTextField *mLastUpdateTimeTextField;
@property (assign) IBOutlet NSProgressIndicator *mLastUpdateTimeProgressIndicator;
@property (assign) IBOutlet NSTextField *mValueToConvertTextField;
@property (assign) IBOutlet NSPopUpButton *mCurrencyToConvertPopUp;
@property (assign) IBOutlet NSTableView *mConvertedCurrencyTableView;

/* 
 Define the Member elements
 */

@property (strong)  NSString *mLastUpdateTime;
@property (strong)  NSMutableDictionary *mCurrencyRates;

/*
    Methods we need to implement
 */

// Define the method to get the exchange
// rates and parse them.  It takes an object
// as an argument because it will be run on
// a background NSThread
- (void) getExchangeRatesFromECB: (id)a_object;

// Handle the Pop Up Menu selection
- (IBAction)selectToCurrency:(id)a_sender;

@end
