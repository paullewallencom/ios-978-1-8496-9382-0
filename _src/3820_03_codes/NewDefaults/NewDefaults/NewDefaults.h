//
//  NewDefaults.h
//  NewDefaults
//
//  Created by rwiebe on 12-04-16.
//  Copyright (c) 2012 BurningThumb Software. All rights reserved.
//

#import <PreferencePanes/PreferencePanes.h>

// Define the path to the Library folder
// in the users home folder
#define D_HOME_LIBRARY_PATH @"~/Library"

// Define the path to the defaults command
#define D_DEFAULTS_PATH @"/usr/bin/defaults"

// Define the read command
#define D_READ_COMMAND  @"read"

// Define the Finders domain
#define D_DOMAIN_FINDER @"com.apple.finder"

// Define the Docks domain
#define D_DOMAIN_DOCK @"com.apple.dock"

// Define the defaults command to show
// hidden files in the Finder
#define D_DEFAULTS_SHOW_FILES \
    "defaults write com.apple.finder AppleShowAllFiles YES"

// Define the defaults command to hide
// hidden files in the Finder
#define D_DEFAULTS_HIDE_FILES \
    "defaults write com.apple.finder AppleShowAllFiles NO"

// Define the defaults command to delete
// the Finder hidden files key
#define D_DEFAULTS_DEL_HIDE_FILES \
    "defaults delete com.apple.finder AppleShowAllFiles"

// Define the defaults commands to enable
// Launchpad fading
#define D_DEFAULTS_DEL_SHOW_DURATION \
    "defaults delete com.apple.dock springboard-show-duration"
#define D_DEFAULTS_DEL_HIDE_DURATION \
    "defaults delete com.apple.dock springboard-hide-duration"

// Define the defaults commands to disable
// Launchpad fading
#define D_DEFAULTS_SHOW_DURATION_0 \
    "defaults write com.apple.dock \
    springboard-show-duration -int 0"
#define D_DEFAULTS_HIDE_DURATION_0 \
    "defaults write com.apple.dock \
    springboard-hide-duration -int 0"

// Define the command to restart
// the Finder
#define D_RESTART_FINDER "killall Finder"

// Define the command to restart
// the Dock
#define D_RESTART_DOCK "killall Dock"

// Define the key to show / hide hidden files
#define kHiddenFileKey @"AppleShowAllFiles"

// Define the key to disable Launchpad fading
#define kSpringboardShowTime @"springboard-show-duration"
#define kSpringboardHideTime @"springboard-hide-duration"

// Define a string equal to YES
#define D_YES @"YES"

@interface NewDefaults : NSPreferencePane
{
    
/*
    Create the user interface elements
 */

// Buttons - A Check Box is a button
IBOutlet NSButton*   enableHiddenFilesCheckbox;
IBOutlet NSButton*   enableLaunchpadFadeCheckbox;
IBOutlet NSButton*   enableHomeLibraryCheckbox;
    
}

- (void)mainViewDidLoad;

/*
    Create the Preference Pane interface for the buttons
 */

- (IBAction)myButtonAction:(id)sender;

/*
    Define the interface to a method that will use
    the defaults command to retrieve a domain 
    defaults value for a key
 */

- (NSString *) readDefaults: (NSString *)a_domain 
                     forKey: (NSString *)a_key;

@end
