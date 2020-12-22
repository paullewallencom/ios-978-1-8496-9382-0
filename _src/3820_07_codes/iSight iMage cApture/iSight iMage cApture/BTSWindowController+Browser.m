//
//  BTSWindowController+Browser.m
//  iSight iMage cApture
//
//  Created by rwiebe on 12-06-06.
//  Copyright (c) 2012 BurningThumb Software. All rights reserved.
//

#import "BTSWindowController+Browser.h"
#import "BTSImage.h"


@implementation BTSWindowController (Browser)

#pragma mark -
#pragma mark import images from a directory

/*
 ** - (void) addImageWithURL:(NSURL *) a_fileURL
 **
 ** Add one image URL to the array of images.
 ** Filter out images that are directories
 ** or hidden files
 **
 ** Input:  A URL that points to an image
 ** Output: None.
 */

- (void) addImageWithURL:(NSURL *) a_fileURL
{   
    // A reference to an image
    BTSImage *l_image;
    
    // A reference to an error object
    NSError *err;
    
    // Get the file attributes
    NSDictionary *fileAttribs = 
     [a_fileURL resourceValuesForKeys:self.m_fileAttributeKeys 
                                error:&err];
    
    // For directories or hidden files, do nothing
    if (
        (YES == [[fileAttribs 
                  objectForKey:NSURLIsDirectoryKey] 
                 boolValue]) ||
        (YES == [[fileAttribs 
                  objectForKey:NSURLIsHiddenKey] 
                 boolValue])
        )
    {
        return;
    }
    
    // Create a BTSImage object for the URL
	l_image = [[BTSImage alloc] initWithURL:a_fileURL];
    
    // Add the object to the array of images
	[self.m_images addObject:l_image];
    
}

/*
 ** - (void) addImagesFromDirectory:(NSString *) path
 **
 ** Add all the images from a folder and its
 ** subfolders to the array of images.
 ** Filter out images that do not have supported
 ** file extensions (like .jpg, or .png, etc)
 **
 ** Input:  A string that represents a file system
 **         path.
 ** Output: None.
 */

- (void) addImagesFromDirectory:(NSString *) path
{

    // Cache a reference to the default
    // shared file manager object
    NSFileManager *l_manager = 
     [NSFileManager defaultManager];
    
    // Create a flag that indicates if 
    // a file system item is a directory
    BOOL l_isDir;
	
    // Ask the file manager to determine if the
    // item exists, and if it is a directory
    [l_manager fileExistsAtPath:path 
                    isDirectory:&l_isDir];
    
    // If the item is a directory
    if (l_isDir)
    {
        // Ask the file manager for a list
        // of everything in the directory
        NSArray *l_content = 
         [l_manager contentsOfDirectoryAtPath:path 
                                        error:nil];
        // For each item in the directory
        for (NSString *l_path in l_content)
        {
            // Call this function again
            [self addImagesFromDirectory: 
             [path stringByAppendingPathComponent:l_path]];
        }
    }
    // Otherwise the item is a file
    else
    {
        // If the file has a supported image extension
        // like .jpg or .png etc
        if ([self.m_validFileExtensions containsObject:
             [path pathExtension]])
        {
            // Add the item to the array of images
            [self addImageWithURL:
             [NSURL fileURLWithPath:path]];
        }
    }
	
    // Redisplay the IKBrowserView
	[self.m_imageBrowser reloadData];
}

#pragma mark -
#pragma mark setup the IKBrowserView

/*
 ** - (void) setupBrowser
 **
 ** When the view is loaded from the .xib
 ** file, invoke this method to setup the 
 ** view
 **
 ** Input:  None.
 ** Output: None.
 */

- (void) setupBrowser
{   
    // Turn on the animation effect
    [self.m_imageBrowser setAnimates:YES];
    
    // Cache a reference to the default
    // NSFileManager object
    NSFileManager *l_manager = 
     [NSFileManager defaultManager];
    
    // Cache an array of desired file system
    // attribute keys
    self.m_fileAttributeKeys = 
     [[NSArray alloc] initWithObjects:
       NSURLIsDirectoryKey,
       NSURLIsHiddenKey,
       nil];
    
    // Cache a list of supported image file
    // extensions like .jpg, .png, etc.
    self.m_validFileExtensions =
     [NSImage imageFileTypes];
    
    // allocate our datasource array: will contain instances of 
    // BTSImage
    self.m_images = [[NSMutableArray alloc] init];
    
    // Set IKImageBrowser cell style so that the
    // title is displayed
    [self.m_imageBrowser setCellsStyleMask:IKCellsStyleTitled];
    
    // Find the Pictures folder the "correct" way
    NSArray *l_paths = 
     NSSearchPathForDirectoriesInDomains(NSPicturesDirectory, 
                                         NSUserDomainMask, 
                                         YES);
    
    // There should be only one
    NSString *l_path = [l_paths lastObject];
    
    // Append the name of our App to the 
    // path to the Pictures folder
    NSString *l_finalPath = 
         [l_path stringByAppendingPathComponent:
          [[[NSBundle mainBundle] infoDictionary] 
           objectForKey:(NSString *)kCFBundleNameKey]];
        
    // If the directory does not exist
    if (NO == [l_manager fileExistsAtPath:l_finalPath])
    {
        // Create the directory
        [l_manager createDirectoryAtPath:l_finalPath 
             withIntermediateDirectories: YES 
                              attributes:nil 
                                error: nil];
    }
        
    // Add all the images from the directory
    // to the array
    [self addImagesFromDirectory:l_finalPath];
   
    // Re-display the view
    [self.m_imageBrowser reloadData];
}

#pragma mark -
#pragma mark IKImageBrowserDataSource

// Implement image-browser's datasource protocol 
// Our datasource representation is a simple mutable array

// Return the number of items in the array
- (NSUInteger) numberOfItemsInImageBrowser:
 (IKImageBrowserView *) a_view
{
    return [self.m_images count];
}

// Return the requested object
- (id) imageBrowser:(IKImageBrowserView *) a_view 
        itemAtIndex:(NSUInteger) a_index
{
    return [self.m_images objectAtIndex:a_index];
}

// Delete the selected images
- (void) imageBrowser:(IKImageBrowserView *) a_view 
         removeItemsAtIndexes: (NSIndexSet *) a_indexes
{
    // Cache a reference to the default
    // NSWorkspace object
    NSWorkspace * l_workspace = 
     [NSWorkspace sharedWorkspace];
    
    // Create an array to hold the deleted
    // objects
    NSMutableArray *l_deletedURLs =
    [[NSMutableArray alloc] init];
    
    // For all the selected images
    [a_indexes enumerateIndexesUsingBlock:
     ^(NSUInteger l_idx, BOOL *stop) 
    {
        // Get the BTSImage object
        BTSImage *l_image = [self.m_images objectAtIndex:l_idx];
        
        // Get the URL for the from the BTSImage
        NSURL *l_URL = l_image.m_URL;
        
        // Add the URL to the list of
        // deleted URLs
        [l_deletedURLs addObject:l_URL];
        
    }];
    
    // Move the delete items to the Trash
    [l_workspace recycleURLs:l_deletedURLs completionHandler:nil];
    
    // Remove all the images from the array
    [self.m_images removeObjectsAtIndexes:a_indexes];
}

@end
