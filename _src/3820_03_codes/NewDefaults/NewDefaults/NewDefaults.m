//
//  NewDefaults.m
//  NewDefaults
//
//  Created by rwiebe on 12-04-16.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "NewDefaults.h"

@implementation NewDefaults

/*
    Create the user interface setter and getter functions
 */

// In this example we are not using setter and getter
// functions so there is nothing to do here

/*
    Create the Preference Pane implementation for when 
    a checkbox is clicked this method is called with the
    sender equal to the check box that envoked it
 */

- (IBAction)myButtonAction:(id)sender;
{
    
    // For now, just beep
//    NSBeep();
    
    // Disable sudden termination, it is not
    // safe to kill the System Preferences
    [[NSProcessInfo processInfo] disableSuddenTermination];

    // Was the Show ~/Library Folder button pressed?
    if (YES == [sender isEqual: enableHomeLibraryCheckbox])
    {
        // Get a URL reference to the file
        NSURL *l_url = 
         [NSURL fileURLWithPath:
          [D_HOME_LIBRARY_PATH stringByExpandingTildeInPath]];
        
        // If the checkbox is ON (checked) then
        if (NSOnState == [sender state])
        {
            // Set the URL IsHidden value to NO
            // This makes the folder Visible in the Finder
            [l_url setResourceValue:
             [NSNumber numberWithBool:NO] 
                             forKey:NSURLIsHiddenKey 
                              error:NULL];
        }
        // else the checkbox is OFF (unchecked)
        else
        {
            // Set the URL IsHidden value to YES
            // This makes the folder Invisible in the Finder
            [l_url setResourceValue:
             [NSNumber numberWithBool:YES] 
                             forKey:NSURLIsHiddenKey 
                              error:NULL];
        }
    }

    // Was the Show Hidden Files in Finder button pressed?
    if (YES == [sender isEqual: enableHiddenFilesCheckbox])
    {
        // If the checkbox is ON (checked) then
        if (NSOnState == [sender state])
        {
            // Execute the command to enable showing hidden files
            system(D_DEFAULTS_SHOW_FILES);
        }
        // else the checkbox is OFF (unchecked) then
        else
        {
            // Execute the command to disable showing hidden files
            system(D_DEFAULTS_HIDE_FILES);
        }
        
        // Execute the system command to restart the Finder
        system(D_RESTART_FINDER);
    }
    
    
    // Was the Enable Launchpad fading button pressed?
    if (YES == [sender isEqual: enableLaunchpadFadeCheckbox])
    {
        // If the checkbox is ON (checked) then
        if (NSOnState == [sender state])
        {
            // Execute the commands to enable fading
            system(D_DEFAULTS_DEL_SHOW_DURATION);
            system(D_DEFAULTS_DEL_HIDE_DURATION);
        }
        else
        {
            // Execute the commands to disable fading
            system(D_DEFAULTS_SHOW_DURATION_0);
            system(D_DEFAULTS_HIDE_DURATION_0);
        }
        
        // Execute the system command to restart the Finder
        system(D_RESTART_DOCK);
    }
    
    
    // Enable sudden termination, it is 
    // safe to kill the System Preferences
    [[NSProcessInfo processInfo] enableSuddenTermination];
  
    
}

/*
    The didSelect delegate method is called whenever
    the Prefernce Pane is displayed, even if the 
    System Preferences were not quit and relaunced
 */

- (void) didSelect
{

    // Read the current setting for 
    // Showing Hidden files in he Finder
    NSString *l_showHiddenFile = [self readDefaults: D_DOMAIN_FINDER 
                                             forKey:kHiddenFileKey];
    
    
    // Read the current setting for 
    // Disabling launchpad fading
    NSString *l_launchpadFadeOut = 
        [self readDefaults: D_DOMAIN_DOCK 
                    forKey:kSpringboardHideTime];
    NSString *l_launchpadFadeIn = 
        [self readDefaults: D_DOMAIN_DOCK
                    forKey:kSpringboardShowTime];

    // Assume everything is off, later we will
    // turn the correct things back on
    [enableHiddenFilesCheckbox setState: NSOffState];
    [enableLaunchpadFadeCheckbox setState: NSOffState];
    [enableHomeLibraryCheckbox setState: NSOffState];
    
    // If the show hidden files value was found
    if (l_showHiddenFile)
    {
        // If the show hidden files value is YES
        if ([D_YES isEqual: l_showHiddenFile])
        {
            // Turn the check box on in the 
            // interface
            [enableHiddenFilesCheckbox setState: NSOnState];
        }
        else 
        {
            // Execute the system command to delete
            // the setting
            system(D_DEFAULTS_DEL_HIDE_FILES);
        }
     }
    
    // If both launchpad values were found
    if ((l_launchpadFadeOut) &&(l_launchpadFadeIn))
    {
        // If either launchpad values is not equal to 0
        if ((0 != [l_launchpadFadeOut integerValue]) ||
            (0 != [l_launchpadFadeIn integerValue]))
        {
            // Turn the check box on in the 
            // interface
            [enableLaunchpadFadeCheckbox setState: NSOnState];
        }
    }
    else
    {
        // Turn the check box on in the 
        // interface
        [enableLaunchpadFadeCheckbox setState: NSOnState];
    }
    

    // Create a URL object that references the 
    // Library file in the users home directory
    NSURL *l_url = [NSURL fileURLWithPath:
                    [D_HOME_LIBRARY_PATH stringByExpandingTildeInPath]];
    
    // Define a NSNumber pointer to hod the result
    // of the getResourceValue method
    NSNumber  *l_isHidden;
    
    // Get the value of the IsHidden attribute
    BOOL l_result = [l_url getResourceValue:&l_isHidden 
                                     forKey:NSURLIsHiddenKey 
                                      error:NULL];
    
    // If a value was returned
    if (l_result)
    {
        // If the returned value was NO
        if (NO == [l_isHidden boolValue])
        {
            // Turn the check box on in the 
            // interface
            [enableHomeLibraryCheckbox setState: NSOnState];
        }
    }
    
}

/*
    The mainViewDidLoad delegate method is called only
    when the Prefernce Pane is displayed, the first time
    in the System Preferences but no subsequent times
    unless the System Preferences are relaunched
 */

- (void)mainViewDidLoad
{
    
        

}

/*
    This method will execute the command line tool defaults
    to read a value from a domain for a specific key
 
    Input: 
        a_domain - a reverse domain id for the value to read
        a_key - a key value to read
 
    Output:
        Either the string value of the result or null if there
        is no value to return.
 */

- (NSString *) readDefaults: (NSString *)a_domain 
                     forKey: (NSString *)a_key
{
    // Create a string object to hold the result
    NSString *l_result;
    
    // Create and initialize a new task
    NSTask *l_readTask = [[NSTask alloc] init];
    
    // Assign the launch path for the task
    [l_readTask setLaunchPath:D_DEFAULTS_PATH];
    
    // Create an array with the read command
    // and the domain and key values
    NSArray *l_arguments = 
    [NSArray arrayWithObjects:  D_READ_COMMAND, 
     a_domain, 
     a_key, 
     nil];
    
    // Assign the argument array to the NSTask
    [l_readTask setArguments:l_arguments];
    
    // Create a new pipe to read the results
    // of the command
    NSPipe *l_pipe = [NSPipe pipe];
    
    // Assign the read pipe to the NSTask
    [l_readTask setStandardOutput:l_pipe];
    
    // Retrieve the pipe's fileHandleForReading
    NSFileHandle *l_file = [l_pipe fileHandleForReading];
    
    // Launch the Task
    [l_readTask launch];
    
    // Release the Task - this is not needed on 
    // Mac OS X 10.7 but is also harmless
    [l_readTask release];
    
    // Read all the output data from the Task
    // and create a mutable copy
    // The NSTask will exit when done
    NSMutableData *l_data = 
        [[l_file readDataToEndOfFile] mutableCopy];
    
    // If the NSTask ended but returned
    // nothing, then return a NULL
    if (0 == [l_data length])
    {
        return NULL; 
    }
    
    // The defaults command will append a newline (\n)
    // character to its output.  This trims that 
    // character off so that it is not included in
    // the returned value
    [l_data setLength:[l_data length] - 1];
    
    // Create a new string from the remaining
    // returned data
    l_result = [[NSString alloc] initWithData:l_data 
                                     encoding:NSUTF8StringEncoding];
    
    // Return the final string 
    return l_result;
    
}


@end
