//
//  BTSWindowController.m
//  iSight iMage cApture
//
//  Created by rwiebe on 12-06-04.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "BTSWindowController.h"
#import "BTSWindowController+Browser.h"

@interface BTSWindowController ()

@end

@implementation BTSWindowController

// Implement the accessors to the GUI view and
// the array that will hod the images for it
// to display
@synthesize m_imageBrowser;    
@synthesize m_images;

// Implememnt the accessor for the array of
// valid image file types
@synthesize m_validFileExtensions;

// Implement the accessor for the array of
// desired image file attributes
@synthesize m_fileAttributeKeys;

- (id)initWithWindow:(NSWindow *)window
{
    self = [super initWithWindow:window];
    if (self) {
        // Initialization code here.
    }
    
    return self;
}

- (void)windowDidLoad
{
    [super windowDidLoad];
    
    // Implement this method to handle any initialization after your window controller's window has been loaded from its nib file.
}

// When the object is successfully loaded from a .xib
// file this method is automatically invoked
- (void) awakeFromNib
{
    // Setup the IKImageBrowserView
    [self setupBrowser];    
}


@end
