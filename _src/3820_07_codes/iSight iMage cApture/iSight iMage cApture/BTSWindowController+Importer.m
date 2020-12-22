//
//  BTSWindowController+Importer.m
//  iSight iMage cApture
//
//  Created by rwiebe on 12-06-06.
//  Copyright (c) 2012 BurningThumb Software. All rights reserved.
//

#import "BTSWindowController+Importer.h"
#import "BTSWindowController+Browser.h"

@implementation BTSWindowController (Importer)

#pragma mark -
#pragma mark pictureTaker callback

/** - (void) pictureTakerDidEnd:(IKPictureTaker *)a_pictureTaker 
 **                  returnCode:(NSInteger)a_returnCode 
 **                 contextInfo:(void  *)a_contextInfo 
 **
 ** This method is invoked when the Take Picture
 ** sheet Cancel or Set button is pressed
 **
 ** Input:  a_pictureTaker - the Picture Taker object
 **         a_returnCode - The status (Cancel or OK)
 **         a_contextInfo - Any object or nil
 **
 ** Output: none
 */

- (void) pictureTakerDidEnd:(IKPictureTaker *)a_pictureTaker 
                 returnCode:(NSInteger)a_returnCode 
                contextInfo:(void  *)a_contextInfo
{
    // If the Set button was not pressed
    // do nothing
    if (NSOKButton != a_returnCode)
    {
        return;
    }

    // Get todays date and time
    NSDate *l_today = [NSDate date];
    
    // Use a Gregorian calendar
    NSCalendar *l_gregorian = [[NSCalendar alloc]
      initWithCalendarIdentifier:NSGregorianCalendar];
    
    // Get the year, month, day, hour, minute, 
    // and second components from the date
    NSDateComponents *weekdayComponents = 
     [l_gregorian components:( NSYearCalendarUnit| 
                               NSMonthCalendarUnit |
                               NSDayCalendarUnit | 
                               NSHourCalendarUnit |
                               NSMinuteCalendarUnit |
                               NSSecondCalendarUnit)
                 fromDate:l_today];
    
    // Create a file name for our image from
    // the date components
    NSString *l_filename =
     [NSString stringWithFormat:D_FILENAME_TEMPLATE,
                                 weekdayComponents.year,
                                 weekdayComponents.month,
                                 weekdayComponents.day,
                                 weekdayComponents.hour,
                                 weekdayComponents.minute,
                                 weekdayComponents.second];
      
        
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

    // Append the file name to the path
    // of our Apps folder
    l_finalPath = 
        [l_finalPath stringByAppendingPathComponent: l_filename];
    
    // Get the image from the Picture Taker
    NSImage *l_image = [a_pictureTaker outputImage];
    
    // Get the image data as a TIFF file
    NSData *l_imageData = [l_image TIFFRepresentation];
    
    // Get a bitmap from the TIFF
    NSBitmapImageRep *l_imageRep = 
    [NSBitmapImageRep imageRepWithData:l_imageData];
    
    // Set the jpg compression to best
    NSDictionary *l_imageProps = 
     [NSDictionary dictionaryWithObject:
      [NSNumber numberWithFloat:1.0] 
        forKey:NSImageCompressionFactor];
    
    // Convert the TIFF to a JPG
    l_imageData = [l_imageRep representationUsingType:NSJPEGFileType 
                                           properties:l_imageProps];
    // Write the JPG to a file
    [l_imageData writeToFile:l_finalPath atomically:YES];
        
    //add it to our datasource
    [self addImageWithURL:[NSURL fileURLWithPath: l_finalPath]];
        
    //reflect changes
    [self.m_imageBrowser reloadData];

}


#pragma mark -
#pragma mark Actions

/** - (IBAction) takePicture:(id)sender
 **
 ** This method is invoked when the Take Picture
 ** button is clicked
 **
 ** Input:  a_sender - the button object
 **
 ** Output: none
 */

- (IBAction) takePicture:(id)a_sender
{
    // Get a reference to the didEndSelector method
    SEL l_didEndSelector = 
     @selector(pictureTakerDidEnd:returnCode:contextInfo:);
    
    // Get a reference to the buttons window
    NSWindow *l_window = [a_sender window];
    
    // Get a reference to the shared Picture Taker
    // object
    IKPictureTaker *l_pictureTaker = 
     [IKPictureTaker pictureTaker];

    // Set the maximum size 
    NSSize l_size = NSMakeSize(D_MAX_WIDTH, D_MAX_HEIGHT);

    // Disable the file chooser
    [l_pictureTaker setValue:[NSNumber numberWithBool:NO] 
                      forKey:IKPictureTakerAllowsFileChoosingKey];
    
    // Disable the recent pictures popup
    [l_pictureTaker setValue:[NSNumber numberWithBool:NO] 
                      forKey:IKPictureTakerShowRecentPictureKey];
    
    // Show the effects button and apply effects
    [l_pictureTaker setValue:[NSNumber numberWithBool:YES] 
                      forKey:IKPictureTakerShowEffectsKey];

    // Take larger pictures
    [l_pictureTaker setValue:[NSValue valueWithSize:l_size]  
                      forKey:IKPictureTakerOutputImageMaxSizeKey];
    [l_pictureTaker setValue:[NSValue valueWithSize:l_size]  
                      forKey:IKPictureTakerCropAreaSizeKey];
        

    // Display the Picture Taker sheet
    [l_pictureTaker 
      beginPictureTakerSheetForWindow:l_window
       withDelegate:self 
        didEndSelector:l_didEndSelector
         contextInfo:nil];
}

@end
