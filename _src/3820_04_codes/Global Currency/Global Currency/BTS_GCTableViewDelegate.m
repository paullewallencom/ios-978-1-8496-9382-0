//
//  BTS_GCTableViewDelegate.m
//  Global Currency
//
//  Created by rwiebe on 12-04-28.
//  Copyright (c) 2012 BurningThumb Software. All rights reserved.
//

#import "BTS_GCTableViewDelegate.h"

@implementation BTS_GCTableViewDelegate

/*
    This method is invoked automatically
    when the object instance is revived
    from the .xib file
 
    This is where we do any initialization
    needed by the .xib object
 */

-(void) awakeFromNib
{
    // Get a reference to our AppDelegate
    // object and save it for later use
    mAppDelegate = [NSApp delegate];
}

/*
 This method is invoked automatically
 when the table view GUI element needs
 to know how many rows it has to 
 display
 
 All dataSource objects must implement
 this method.
 */

- (NSInteger)numberOfRowsInTableView:(NSTableView *)aTableView
{    
    
    // Ask the AppDelegate to lookup the mCurrencyRates
    // member variable and then ask it for the number
    // of objects it contains.  That is the number of 
    // rows in the table view
   return mAppDelegate.mCurrencyRates.count;
    
}

/*
 This method is invoked automatically
 when the table view GUI element needs
 to display a column value for any
 column row
 
 All dataSource objects must implement
 this method.
 */

- (id)tableView:(NSTableView *)a_tableView objectValueForTableColumn:(NSTableColumn *)a_tableColumn row:(NSInteger)a_rowIndex 
{
    // Retrive the identifier for the row.  These are
    // set in the .xib file
    
    NSString *l_identifier = [a_tableColumn identifier];
    
    // If the desired column is the currency, then
    // return the value for the currency code
    if ([kBTSGCCurrency isEqual: l_identifier])
    {   
        return [mAppDelegate.mCurrencyRates.allKeys 
                objectAtIndex:a_rowIndex];
    }
    
    // If the desired column is the value, then
    // return the value for the value for that currency code
    if ([kBTSGCValue isEqual: l_identifier])
    {   
        // Get the value to convert from
        // the AppDelegate
        double l_valueToConvert = 
         [mAppDelegate.mValueToConvertTextField doubleValue];
        
        // Get the currency code of the value
        // to convert from the AppDelegate
        NSString * l_selectedCurrency = 
         [mAppDelegate.mCurrencyToConvertPopUp titleOfSelectedItem];
        
        // Get the exchange rate to Euros for
        // the value to convert from the AppDelegate
        double l_rateFrom = 
         [[mAppDelegate.mCurrencyRates 
           objectForKey:l_selectedCurrency] doubleValue];
        
        // Get the currency codes from the AppDelegate
        // and look up the currency code for the
        // requested table row
        NSString *l_toCurrency = 
         [mAppDelegate.mCurrencyRates.allKeys 
          objectAtIndex:a_rowIndex];
        
        // Get the exchange rate to Euros for
        // the row from the AppDelegate
        double l_rateTo = 
         [[mAppDelegate.mCurrencyRates objectForKey:l_toCurrency]
          doubleValue];
        
        // Calculate the converted value.
        // First by converting the from currency to
        // Euros, then by converting the result
        // from Euors to the desired currency
        double l_euroValue = l_valueToConvert / l_rateFrom;
        double l_finalValue = l_euroValue * l_rateTo;
        
        // Return the result as an NSString
        return [NSString stringWithFormat:@"%f",l_finalValue];
    }

    // We should never get here
    return @"not implemented";
    
}

@end
