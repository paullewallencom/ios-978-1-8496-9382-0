//
//  BTSAppDelegate.m
//  iSight Recorder
//
//  Created by rwiebe on 12-06-12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "BTSAppDelegate.h"

@implementation BTSAppDelegate

@synthesize window = _window;

// Create accessors for the Capture View
@synthesize m_QTCaptureView;

// Create accessors for the session,
// audio input device and video input
// device
@synthesize m_CaptureSession;
@synthesize m_CaptureDeviceInput_Video;
@synthesize m_CaptureDeviceInput_Audio;

// Create the accessors for the Capture
// Decompressed Video Output object
@synthesize m_CDVO;

// Create the accessors for the Capture
// Movie File Output object
@synthesize m_CaptureMovieFileOutput;

// Create the volume slider accessor
@synthesize m_volumeSlider;

// Create the audio preview  accessor
@synthesize m_audioPreviewOutput;

// Create the button accessors
@synthesize m_takePictureButton;
@synthesize m_stopButton;
@synthesize m_recordButton;

// Create the compression button accessors
@synthesize m_compressButton;
@synthesize m_compressVideoPopUp;
@synthesize m_compressAudioPopUp;

// Create the array controller accessors
@synthesize m_videoCompressionArrayController;
@synthesize m_audioCompressionArrayController;

// Create the controls subview accessors
@synthesize m_controlsView;

// Create the HUD Window accessors
@synthesize m_HUDWindow;

// Create the timer accessors
@synthesize m_fadeTimer;

- (void)applicationDidFinishLaunching:(NSNotification *)aNotification
{
    // Insert code here to initialize your application
    
    // ----- not in word file
    [[self window] makeKeyAndOrderFront:self];
    
    // This App window supports Full Screen
    [_window setCollectionBehavior:
     NSWindowCollectionBehaviorFullScreenPrimary];
    
    // This App is going to implement Full Screen methods
    // so it need to be the window delegate
    [_window setDelegate:self];
    
    // Define two local variables
    // that will contain the results
    // of various operations
    BOOL l_success = NO;
	NSError* l_error;

    // Populate the compression format menus
    [self populateMenus];
    
    // Create the capture session
	m_CaptureSession = [[QTCaptureSession alloc] init];
    
    // Connect inputs and outputs to the session
    // 1. Find a video device and open it
    // 2. Add the video device to the session
    // 3. Find an audio device and open it
    // 4. Add the audio device to the session
    
    // Find a video device  
    QTCaptureDevice* l_videoDevice = 
     [QTCaptureDevice 
      defaultInputDeviceWithMediaType:QTMediaTypeVideo];
    
    // Open the video device  
    l_success = [l_videoDevice open:&l_error];
    
    
    // If a video input device can't be found or opened, try to find and open a muxed input device
/*    
	if (!l_success) {
		videoDevice = [QTCaptureDevice defaultInputDeviceWithMediaType:QTMediaTypeMuxed];
		l_success = [videoDevice open:&l_error];
		
    }
    
    if (!l_success) {
        videoDevice = nil;
        // Handle l_error
        
    }
*/    

    // Add the video device to the session as a device input
    // only if it was successfully initialized
    if (l_success) 
    {
        // Allocate and initialize the video input device
		m_CaptureDeviceInput_Video = 
         [[QTCaptureDeviceInput alloc] 
           initWithDevice:l_videoDevice];
        
        // Add the video input device to the session
		l_success = [m_CaptureSession 
                      addInput:m_CaptureDeviceInput_Video 
                         error:&l_error];
        
		if (!l_success) 
        {
			// Handle l_error
		}
    }
       
    // If the video device doesn't also supply audio,
    // add an audio device input to the session
    if (![l_videoDevice hasMediaType:QTMediaTypeSound] &&
        ![l_videoDevice hasMediaType:QTMediaTypeMuxed]) 
    {
        // Find an audio device
        QTCaptureDevice *l_audioDevice = 
         [QTCaptureDevice 
          defaultInputDeviceWithMediaType:QTMediaTypeSound];
        
        // open the audio device
        l_success = [l_audioDevice open:&l_error];

/*
        if (!l_success) 
        {
            audioDevice = nil;
            // Handle l_error
        }
*/            
        // Add the audio device to the session as a device input
        // only if it was successfully initialized
        if (l_success)
        {
            // Allocate and initialize the audio input device
            m_CaptureDeviceInput_Audio = 
             [[QTCaptureDeviceInput alloc] 
              initWithDevice:l_audioDevice];
                
            // Add the audio input device to the session
            l_success = [m_CaptureSession 
                         addInput:m_CaptureDeviceInput_Audio 
                            error:&l_error];
            
            if (!l_success)
            {
                // Handle l_error
            }
        }

    }

    
    // Set the capture session for the Capture View
    [m_QTCaptureView setCaptureSession:m_CaptureSession];
    
    // Allocate and initialize and audio preview object
    m_audioPreviewOutput = 
     [[QTCaptureAudioPreviewOutput alloc] init];
    
    // Set the preview volume
	[m_audioPreviewOutput setVolume:
     [self.m_volumeSlider floatValue] / 100];
    
    // Add the preview to our capture session
	[m_CaptureSession addOutput:m_audioPreviewOutput error:nil];	
    
    // Create the movie file output and add it to the session
    m_CaptureMovieFileOutput = 
     [[QTCaptureMovieFileOutput alloc] init];
    l_success = [m_CaptureSession addOutput:m_CaptureMovieFileOutput 
                                      error:&l_error];
    
    if (!l_success) {
        // Handle error
    }
    
    // Make the BTSAppDelegate also the delegate for the
    // capture movie file output object so that it receives
    // a notification when movie recording stops
    [m_CaptureMovieFileOutput setDelegate:self];

    // Start the capture session
    [m_CaptureSession startRunning];
}

#pragma mark -
#pragma mark - Start and stop movie recording

// The action method invoked when the button
// titled Record is clicked in the GUI
- (IBAction)startRecording:(id)sender
{
    // Cache a reference to the NSFileManager
    NSFileManager* l_manager = [NSFileManager defaultManager];
    
    // Append the name of our App to the 
    // path to the NSTemporaryDirectory folder
    NSString *l_finalPath = 
    [NSTemporaryDirectory() stringByAppendingPathComponent:
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
	
    // Use the date and time to create a unique file name
    NSDate *today = [NSDate date];
    NSDateFormatter *dateFormat = [[NSDateFormatter alloc] init];
    [dateFormat setDateFormat:@"yyyy-MM-dd hh.mm.ss"];
    NSString *dateString = [dateFormat stringFromDate:today];
    
    // Build the URL to the final path in temporary items
    NSURL* l_url = 
     [NSURL fileURLWithPath:
      [[l_finalPath stringByAppendingPathComponent:dateString] 
       stringByAppendingPathExtension:@"mov"]];
    
    // When the output URL is set to a path, recording starts
    [m_CaptureMovieFileOutput recordToOutputFileURL:l_url];
    
    // Reset the button states
    [self.m_recordButton setEnabled:NO];
    [self.m_stopButton setEnabled:YES];
    [self.m_takePictureButton setEnabled:NO];
    
    // Disable the compression GUI elements
    [self.m_compressButton setEnabled:NO];
    [self.m_compressVideoPopUp setEnabled:NO];
    [self.m_compressAudioPopUp setEnabled:NO];
    
}

// The action method invoked when the button
// titled Stop is clicked in the GUI
- (IBAction)stopRecording:(id)sender
{
    // When the output URL is set to nil, recording stops
	[m_CaptureMovieFileOutput recordToOutputFileURL:nil];
}

// Do something with the QuickTime movie 
// in the temporary items folder
- (void)captureOutput:(QTCaptureFileOutput *)a_captureOutput 
        didFinishRecordingToOutputFileAtURL:(NSURL *)a_outputFileURL 
       forConnections:(NSArray *)a_connections 
           dueToError:(NSError *)a_error
{
    
    // Preform the save on the main thread
    [self performSelectorOnMainThread:@selector(saveMovie:) 
                           withObject:a_outputFileURL
                        waitUntilDone:YES];
    
    // Reset the button states
    [self.m_recordButton setEnabled:YES];
    [self.m_stopButton setEnabled:NO];
    [self.m_takePictureButton setEnabled:YES];
    
    // ----- not in word file
    [self.m_compressButton setEnabled:YES];
    [self.m_compressVideoPopUp setEnabled:YES];
    [self.m_compressAudioPopUp setEnabled:YES];
}

// This method will be invoked on the
// main thread to save a movie
-(void)saveMovie:(NSURL*)a_url
{
    // Cache a reference to the NSFileManager
    NSFileManager* l_manager = [NSFileManager defaultManager];

    // Create a new save panel
    NSSavePanel *l_savePanel = [NSSavePanel savePanel];
        
    // Restrict the save panel to 
    // MOV files
    [l_savePanel setAllowedFileTypes: 
     [NSArray arrayWithObject:@"mov"]];
    
    // Begin the save panel as a sheet on the
    // window
    [l_savePanel beginSheetModalForWindow:_window 
                        completionHandler:^(NSInteger result) 
     {
         // If the Save button is pressed
         if (result == NSFileHandlingPanelOKButton) 
         {
             // Write the JPG data to the URL
             [l_manager moveItemAtURL:a_url toURL:[l_savePanel URL] error:nil];
         }
         else 
         {
             [l_manager removeItemAtURL:a_url error:nil];
         }
     }
     ];

}

#pragma mark -
#pragma mark - Set the preview volume

// The action method for the preview volume slider
- (IBAction)setPreviewVolume:(id)a_sender
{
    // Set the preview volume
    [m_audioPreviewOutput setVolume:
     [self.m_volumeSlider floatValue] / 100];
}

#pragma mark -
#pragma mark - Set movie file compression

// The method that will populate the video and
// audio compression PopUp button menus
- (void) populateMenus
{
    // A reference to the array of returned
    // compresion options
    NSArray* l_optionsIdentifiers;
   
    // Retrieve all the video compression 
    // options identifiers
    l_optionsIdentifiers = 
     [QTCompressionOptions 
      compressionOptionsIdentifiersForMediaType:
       QTMediaTypeVideo];
    
    // Add each video option to the video
    // compression array controller
    for (NSString* l_optionID in l_optionsIdentifiers) 
    {
        [m_videoCompressionArrayController 
          addObject:
           [QTCompressionOptions 
            compressionOptionsWithIdentifier:l_optionID]];
    }

    // Retrieve all the audio compression 
    // options identifiers
    l_optionsIdentifiers = 
     [QTCompressionOptions 
      compressionOptionsIdentifiersForMediaType:
       QTMediaTypeSound];
    
    // Add each audio option to the audio
    // compression array controller
    for (NSString* l_optionID in l_optionsIdentifiers) 
    {
        [m_audioCompressionArrayController 
         addObject:
          [QTCompressionOptions 
           compressionOptionsWithIdentifier:l_optionID]];
    }

    // Select the first option for video and audio
    [m_videoCompressionArrayController setSelectionIndex:0];
    [m_audioCompressionArrayController setSelectionIndex:0];

    // Use Key-Value-Observing to monitor the state
    // of the selected video compression option 
    [m_videoCompressionArrayController 
     addObserver:self 
      forKeyPath:kBTS_SelectionIndex 
         options:NSKeyValueObservingOptionNew 
         context:nil];
    
    // Use Key-Value-Observing to monitor the state
    // of the selected audio compression option 
    [m_audioCompressionArrayController 
     addObserver:self 
      forKeyPath:kBTS_SelectionIndex
         options:NSKeyValueObservingOptionNew 
         context:nil];
    
}

// The method that will be invoked when an 
// observed value changes for the @"selectionIndex" key
- (void) observeValueForKeyPath:(NSString *)keyPath 
                       ofObject:(id)object 
                         change:(NSDictionary *)change 
                        context:(void *)context
{

    // Is compression enabled
    if (NSOnState == [m_compressButton state])
    {
        // Invoke the method to set the video
        // and audio compression options
        [self setCaptureOptions];
    }

}

// The action method that is invoked when the Compress
// checkbox value changes
- (IBAction)compressButtonAction:(id)a_sender
{
    // If compression is enabled
    if (NSOnState == [m_compressButton state])
    {
        // Set the compression options
        [self setCaptureOptions];
    }
    // Otherwise
    else
    {
        // Turn off compression
        [self clearCaptureOptions];
    }
}

// This method is invoked to clear any compression
// that may have been enabled on a caputure session
-(void) clearCaptureOptions
{
    // Get the list of captrue connections for the file output
    NSArray* l_connections = [m_CaptureMovieFileOutput connections];
    
    // Stop the capture session
    [m_CaptureSession stopRunning];
    
    // For each of the connections
    for (QTCaptureConnection* l_connection in l_connections)
    {
        // Set the compression option to nil, which
        // turns compression off
        [m_CaptureMovieFileOutput 
         setCompressionOptions:nil
         forConnection:l_connection];
    }    

    // Restart the capture session
    [m_CaptureSession startRunning];

}

// This method is invoked to set any compression
// that may have been enabled on a caputure session
- (void) setCaptureOptions
{
    // Get the list of captrue connections for the file output
    NSArray* l_connections = [m_CaptureMovieFileOutput connections];
    
    // Stop the capture session
    [m_CaptureSession stopRunning];
    
    // For each of the connections
    for (QTCaptureConnection* l_connection in l_connections)
    {
        // Get the media type of the connection
        NSString *l_mediaType = [l_connection mediaType];
        
        // Is it video
        if (YES == [QTMediaTypeVideo isEqual: l_mediaType])
        {
            // Assign the selected video compression options
            [m_CaptureMovieFileOutput 
             setCompressionOptions:
              [[m_videoCompressionArrayController 
                selectedObjects] lastObject] 
             forConnection:l_connection];
        }
        // Is it audio
        else if (YES == [QTMediaTypeSound isEqual: l_mediaType])
        {
            // Assign the selected audio compression options
            [m_CaptureMovieFileOutput 
             setCompressionOptions:
             [[m_audioCompressionArrayController 
               selectedObjects] lastObject] 
             forConnection:l_connection];
        }
        
    }
    
    // Restart the capture session
   [m_CaptureSession startRunning];

}

#pragma mark -
#pragma mark - Take a snapshot by grabbing the frame

// The action method for the take snapshot button
- (IBAction)takePicture:(id)a_sender
{
    // If the QTCaptureDecompressedVideoOutput object
    // does not exist
    if (nil == m_CDVO)
    {
        // Create the QTCaptureDecompressedVideoOutput object
        m_CDVO = [[QTCaptureDecompressedVideoOutput alloc] init];

        // Set the frame size and pixel format to provide
        // a nice image buffer for JPG creation
        [m_CDVO setPixelBufferAttributes:
         [NSDictionary dictionaryWithObjectsAndKeys:
           [NSNumber numberWithDouble:D_BTS_SNAP_WIDTH], 
           (id)kCVPixelBufferWidthKey,
           [NSNumber numberWithDouble:D_BTS_SNAP_HEIGHT],
           (id)kCVPixelBufferHeightKey,
           [NSNumber numberWithInt:kCVPixelFormatType_32ARGB], 
           (id) kCVPixelBufferPixelFormatTypeKey,
            nil]];

        }
    
    // Stop the capture session
    [m_CaptureSession stopRunning];
    
    // Add the QTCaptureDecompressedVideoOutput object
    // to the capture session
    [m_CaptureSession addOutput:m_CDVO error:nil];
    
    // Make ourselves the delegate so that the 
    // captureOutput:didOutputVideoFrame:
    //  withSampleBuffer:fromConnection:
    // method will be invoked
    [m_CDVO setDelegate:self];
    
    // Restart the capture session
    [m_CaptureSession startRunning];
        
}

// This method is automatically invoked on the
// QTCaptureDecompressedVideoOutput objects
// delegate when a frame is ready

- (void)captureOutput:(QTCaptureOutput *)captureOutput 
  didOutputVideoFrame:(CVImageBufferRef)videoFrame
     withSampleBuffer:(QTSampleBuffer *)sampleBuffer 
       fromConnection:(QTCaptureConnection *)connection
{
    // ----- Reader challenge skip one frame
    if (!m_skipOneFrame)
    {
        m_skipOneFrame = YES;
        return;
    }

    m_skipOneFrame = NO;

    // We only need one frame so remove ourselves
    // as the delegate and then remove the
    // QTCaptureDecompressedVideoOutput from
    // the session
    [m_CDVO setDelegate:nil];
    [m_CaptureSession removeOutput: m_CDVO];
    
    // Creat a new image representation for
    // the frame
    NSCIImageRep *imageRep = 
     [NSCIImageRep imageRepWithCIImage:
      [CIImage imageWithCVImageBuffer:videoFrame]];
    
    // Create an NSImage object from with the 
    // new image representation
    NSImage *l_image = [[NSImage alloc] 
                        initWithSize:[imageRep size]];
    [l_image addRepresentation:imageRep];
    
    // Save the image on the main 
    // program thread, make sure we 
    // wait until the save is done so that
    // no object disappear out from under us
    [self performSelectorOnMainThread:@selector(saveImage:) 
                           withObject:l_image 
                        waitUntilDone:YES];

}

// This method will be invoked on the
// main thread to save an image

-(void)saveImage:(NSImage*)a_image
{
    // Get the TIFF Representaiton
    // and convert it to raw JPG data
    // using default settings
    NSData *bitmapData = [a_image TIFFRepresentation];
    NSBitmapImageRep *bitmapRep = 
     [NSBitmapImageRep imageRepWithData:bitmapData];
    NSData *imageData = 
    [bitmapRep representationUsingType:NSJPEGFileType 
                            properties:nil];
    
    // Use the image size as the 
    // accessory view frame size
    // and create a new NSImage view
    NSRect l_frame = 
     NSMakeRect(0,0,a_image.size.width,a_image.size.height);
    NSImageView* l_imageView = 
    [[NSImageView alloc] initWithFrame:l_frame];
    
    // Set the image for the accessory view
    [l_imageView setImage:a_image];
    
    // Create a new save panel
    NSSavePanel *l_savePanel = [NSSavePanel savePanel];
    
    // Set the image view as the save panel
    // accessory view
    [l_savePanel setAccessoryView:l_imageView];
    
    // Restrict the save panel to 
    // JPG files
    [l_savePanel setAllowedFileTypes: 
     [NSArray arrayWithObject:D_BTS_SNAP_TYPE]];
    
    // Begin the save panel as a sheet on the
    // window
    [l_savePanel beginSheetModalForWindow:_window 
                        completionHandler:^(NSInteger result) 
    {
        // If the Save button is pressed
        if (result == NSFileHandlingPanelOKButton) 
        {
            // Write the JPG data to the URL
            [imageData writeToURL: l_savePanel.URL atomically: YES];
        }
    }
    ];
}

@end
