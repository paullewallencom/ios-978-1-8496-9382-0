//
//  BTSWindowController.h
//  iSight iMage cApture
//
//  Created by rwiebe on 12-06-04.
//  Copyright (c) 2012 BurningThumb Software. All rights reserved.
//

#import <Cocoa/Cocoa.h>
#import <Quartz/Quartz.h>

@interface BTSWindowController : NSWindowController

// Define the references to the GUI view and
// the array that will hod the images for it
// to display
@property (strong) IBOutlet
 IKImageBrowserView *m_imageBrowser;    
@property (strong) NSMutableArray *m_images;

// Define a reference to an array that will cache
// valid image file extensions
@property (strong) NSArray *m_validFileExtensions;

// Define a reference to an array that will cache
// desired file attribute keys
@property (strong) NSArray *m_fileAttributeKeys;


@end
