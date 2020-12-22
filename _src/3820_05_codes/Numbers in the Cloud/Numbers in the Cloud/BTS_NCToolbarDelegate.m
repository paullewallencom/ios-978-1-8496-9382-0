//
//  BTS_NCToolbarDelegate.m
//  Numbers in the Cloud
//
//  Created by rwiebe on 12-05-14.
//  Copyright (c) 2012 Burning Thumb Software. All rights reserved.
//

#import "BTS_NCToolbarDelegate.h"
#import "BTS_NCTableViewDelegate.h"

@implementation BTS_NCToolbarDelegate

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
 
 This method is assigned in teh .xib
 file as the target action for
 the toolbar items.  As a result, it
 is invoked whenever a toolbar item
 is clicked.
 
 Input: a_sender - the object that was
                   clicked
 
 Output: None
 
 */

- (IBAction)selectToolbarItem:(id)a_sender
{
    // Create a reference to the row of the -
    // categories table that is selected -
    NSInteger l_selectedCategory = -1;
    
    // Create a reference to the row of the -
    // key table that is selected -
    NSInteger l_selectedKey = -1;
    
    // Create a reference to an array that
    // will hold a list of all the columns
    // in the selected table view
    NSArray *l_columns;
    
    // Create a reference to an array that
    // will hold a list of all the rows
    // in the dataSource for the table view
    NSMutableArray *l_rows;
    
    // Get the number of the selected
    // row in the Category table view
    l_selectedCategory = 
     m_appDelegate.m_categoryTableView.selectedRow;
    
    
    // Get the number of the selected
    // row in the Key table view
    l_selectedKey = m_appDelegate.m_keyTableView.selectedRow;

    // Was the Delete Key toolbar item clicked
    if (a_sender == m_appDelegate.m_deleteKeyToolbarItem)
    {
        // Was a row in the Key table view selected
        if (l_selectedKey >= 0)
        {
            // Get all the rows
            l_rows = [[m_appDelegate.m_numbersArray 
                                objectAtIndex:l_selectedCategory] 
                               objectForKey:kBTSNCKeysKey];
            
            // Remove the selected row
            [l_rows removeObjectAtIndex: l_selectedKey];
            
            // Re-display the table
            [m_appDelegate.m_keyTableView reloadData];
            
        }
    }
    
    // Was the Delete Category toolbar item clicked
    else 
    if (a_sender == m_appDelegate.m_deleteCategoryToolbarItem)
    {
        // Was a row in the Category table view selected
        if (l_selectedCategory >= 0)
        {
            // Remove the selected row
            [m_appDelegate.m_numbersArray 
             removeObjectAtIndex: l_selectedCategory];
            
            // Re-display both tables
            [m_appDelegate.m_categoryTableView reloadData];
            [m_appDelegate.m_keyTableView reloadData];
            
        }
    }
 
    // Was the Add Key toolbar item clicked
    else 
    if (a_sender == m_appDelegate.m_addKeyToolbarItem)
    {
        // Was a row in the Category table view selected
        if (l_selectedCategory >= 0)
        {
            // Create a new empty dictionary 
            NSMutableDictionary *l_newRow = 
             [[NSMutableDictionary alloc] init];
            
            // Get a list of table columns
            l_columns = m_appDelegate.m_keyTableView.tableColumns;
            
            // For each column, add an entry
            // to the dictioary that matches
            // the column identifier
            for (id l_column in l_columns)
            {
                [l_newRow setObject:[l_column identifier] 
                             forKey:[l_column identifier]];
            }
            
            // Get the key array for the selected
            // category
            l_rows = [[m_appDelegate.m_numbersArray 
                       objectAtIndex:l_selectedCategory] 
                      objectForKey:kBTSNCKeysKey];
            
            // Add the newly create row
            [l_rows insertObject:l_newRow 
                         atIndex: l_selectedKey + 1];
            
            // Re-dispaly the table
            [m_appDelegate.m_keyTableView reloadData];
        }
    }
    
    // Was the Add Category toolbar item clicked
    else 
    if (a_sender == m_appDelegate.m_addCategoryToolbarItem)
    {

        // Create a new empty dictionary 
        NSMutableDictionary *l_newRow = 
         [[NSMutableDictionary alloc] init];
        
        // Get a list of table columns
        l_columns = m_appDelegate.m_categoryTableView.tableColumns;
        
        
        // For each column, add an entry
        // to the dictioary that matches
        // the column identifier
        for (id l_column in l_columns)
        {
            [l_newRow setObject:[l_column identifier] 
                         forKey:[l_column identifier]];
        }

        // Add an empty set of Keys to
        // the dictionary
        [l_newRow setObject:[[NSMutableArray alloc] init] 
                     forKey:kBTSNCKeysKey];
        
        // Add the newly create row
        [m_appDelegate.m_numbersArray insertObject: l_newRow 
                            atIndex:l_selectedCategory + 1];
        
        
        // Re-display both tables
        [m_appDelegate.m_categoryTableView reloadData];
        [m_appDelegate.m_keyTableView reloadData];
     }
    
    // Save the changed array to iCloud
    [m_appDelegate saveNumbersToCloud];
    
}


@end
