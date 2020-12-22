//
//  BTS_NCTableViewDelegate.m
//  Numbers in the Cloud
//
//  Created by rwiebe on 12-05-14.
//  Copyright (c) 2012 Burning Thumb Software. All rights reserved.
//

#import "BTS_NCTableViewDelegate.h"

@implementation BTS_NCTableViewDelegate

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
    m_appDelegate = [NSApp delegate];
}

/*
 
 This method is invoked automatically
 when the table view GUI element needs
 to know how many rows it has to 
 display
 
 All dataSource objects must implement
 this method.
 
 */

- (NSInteger)numberOfRowsInTableView:(NSTableView *)a_tableView
{   
    // Create the reference that will be returned
    NSInteger l_numberOfRows = 0;
    
    // Create a reference to the row of the
    // categories table that is selected
    NSInteger l_selectedCategory = -1;
    
    // We need to behave differently based on
    // which table view wants to know how many
    // rows it must display
    
    // We can inspect the value of a_tableView to 
    // determine which table view is asking for
    // information
    
    // Is it the category table view ?
    if (a_tableView == m_appDelegate.m_categoryTableView)
    {
        // Set the return value to the number of rows
        // in the array
        l_numberOfRows = m_appDelegate.m_numbersArray.count;
    }
    // Is it the keys table view ?
    else if (a_tableView == m_appDelegate.m_keyTableView )
    {
        // Determine which category row is selected
        l_selectedCategory = 
         m_appDelegate.m_categoryTableView.selectedRow;
        
        // If a row was selected
        if (l_selectedCategory >= 0)
        {
            // Find the category row in the m_numbersArray.
            // Locate the second array using the kBTSNCKeysKey.
            // Set the return value to the number of rows
            // in the array.
            l_numberOfRows = [[[m_appDelegate.m_numbersArray 
                                objectAtIndex:l_selectedCategory] 
                                 objectForKey:kBTSNCKeysKey] count];
        }
    }
    
    // Return the number of rows
    return l_numberOfRows;
    
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
    // Create a reference to the value that
    // will be returned
    id l_columnValue;
    
    // Create a reference to the row of the
    // categories table that is selected
    NSInteger l_selectedCategory = -1;
    
    // Determine which table column the value is
    // for by looking up the identifier.  Remember to 
    // set the identifier in the .xib file for each
    // table column or this method will not work
    NSString *l_identifier = [a_tableColumn identifier];

    // We need to behave differently based on
    // which table view wants to know how many
    // rows it must display
    
    // We can inspect the value of a_tableView to 
    // determine which table view is asking for
    // information
    
    // Is it the category table view ?
    if (a_tableView == m_appDelegate.m_categoryTableView)
    {
        // Set the return value from dictionary item in
        // the array for the row.  Use the table identifer
        // set in the .xib file as the key to access the
        // dictionary
        l_columnValue = 
         [[m_appDelegate.m_numbersArray objectAtIndex:a_rowIndex] 
          objectForKey:l_identifier];
    }

    // Is it the keys table view ?
    else if (a_tableView == m_appDelegate.m_keyTableView)
    {
        // Determine which category row is selected
        l_selectedCategory = 
         m_appDelegate.m_categoryTableView.selectedRow;
        
        // If a row was selected
        if (l_selectedCategory >= 0)
        {
            // Set the return value from dictionary item in
            // the array for the selected row.  Use the table 
            // identifer set in the .xib file as the key to access 
            // thedictionary
            l_columnValue = 
             [[[[m_appDelegate.m_numbersArray 
                objectAtIndex:l_selectedCategory] 
                 objectForKey:kBTSNCKeysKey] 
                  objectAtIndex:a_rowIndex] 
                   objectForKey:l_identifier];
        }
    }

    // Save the changed array to iCloud
    [m_appDelegate saveNumbersToCloud];
    
    return l_columnValue;
}

/*
 
 This method is invoked automatically
 when the table view GUI element selection 
 changes.
 
 It is optional to implement this method
 
 */

- (void) tableViewSelectionDidChange: (NSNotification *) a_notification
{
    // The notification object is
    // the table view that has a new
    // selection.  We need a reference
    // to that object
    NSTableView *l_tableView = [a_notification object];
    
    // Is it the category table view ?
    if (l_tableView == m_appDelegate.m_categoryTableView)
    {
        // Tell the key table view to reload its 
        // data
        [m_appDelegate.m_keyTableView reloadData];
    }
    
}

/*
 
 This method is invoked automatically
 when any cell in the table view GUI element 
 changes.
 
 It is optional to implement this method but
 it must be implemented if cells are editable
 
 */

- (void)tableView:(NSTableView *)a_tableView 
   setObjectValue:(id)a_object 
   forTableColumn:(NSTableColumn *)a_tableColumn 
              row:(int)a_rowIndex
{
    
    // Create a reference to the row of the
    // categories table that is selected
    NSInteger l_selectedCategory = -1;

    // Create a reference to the mutable
    // dictionary that stores the data
    // for a row
    NSMutableDictionary *l_row;
    
    // Is it the category table view ?
    if (a_tableView == m_appDelegate.m_categoryTableView)
    {
        // Assign the row reference to the 
        // selected category dicitonary
        l_row = [m_appDelegate.m_numbersArray 
                 objectAtIndex:a_rowIndex];
        
        // Update the dictionary with the
        // new value
        [l_row setObject:a_object 
                  forKey:[a_tableColumn identifier]];
    }
    
    // Is it the keys table view ?
    else if (a_tableView == m_appDelegate.m_keyTableView)
    {
        // Determine which category row is selected
        l_selectedCategory = 
        m_appDelegate.m_categoryTableView.selectedRow;

         if (l_selectedCategory >= 0)
        {
            // Assign the row reference to the 
            // selected key dicitonary
            l_row = 
            [[[m_appDelegate.m_numbersArray 
                objectAtIndex:l_selectedCategory] 
               objectForKey:kBTSNCKeysKey] 
              objectAtIndex:a_rowIndex];
            
            // Update the dictioary with the
            // new value
            [l_row setObject:a_object 
                      forKey:[a_tableColumn identifier]];
        }

    }
}


@end
