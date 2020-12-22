//
//  BTSAppDelegate.h
//  iSight Recorder
//
//  Created by rwiebe on 12-06-12.
//  Copyright (c) 2012 BurningThumb Software. All rights reserved.
//

#import <Cocoa/Cocoa.h>
#import <QTKit/QTKit.h>

// Define the image size for pictures
#define D_BTS_SNAP_WIDTH 640
#define D_BTS_SNAP_HEIGHT 480

// Define the image type for pictures
#define D_BTS_SNAP_TYPE @"jpg"

// Define the key for the value we want
// to observe to determine if a PopUp 
// button menu has changed
#define kBTS_SelectionIndex @"selectionIndex" 

// Our App handles the NSWindowDeleage protocol to
// support Full Screen
@interface BTSAppDelegate : NSObject <NSApplicationDelegate, 
                                      NSWindowDelegate>

// ----- Reader challenge, skip one frame
{
    BOOL m_skipOneFrame;
    
    // The window delegate needs to remember
    // windowFrame and bounds rectangles
    NSRect m_windowFrame;
    NSRect m_viewBounds;
    NSRect m_viewFrame;
    
    // The window delegate needs to remember
    // controls view Frame and Bounds
    NSRect m_controlsViewBounds;
    NSRect m_controlsViewFrame;
    
}

@property (assign) IBOutlet NSWindow* window;

// A reference to the Capture View in the GUI
@property (strong) IBOutlet QTCaptureView* m_QTCaptureView;

// A reference to the volume slider in the GUI
@property (strong) IBOutlet NSSlider* m_volumeSlider;

// A reference to the buttons in the GUI
@property (strong) IBOutlet NSButton* m_takePictureButton;
@property (strong) IBOutlet NSButton* m_stopButton;
@property (strong) IBOutlet NSButton* m_recordButton;

// A reference to the compression buttons in the GUI
@property (strong) IBOutlet NSButton* m_compressButton;
@property (strong) IBOutlet NSPopUpButton* m_compressVideoPopUp;
@property (strong) IBOutlet NSPopUpButton* m_compressAudioPopUp;

// A reference to the compression array controller objects
@property (strong) IBOutlet 
 NSArrayController* 
  m_videoCompressionArrayController;
@property (strong) IBOutlet 
 NSArrayController* 
  m_audioCompressionArrayController;

// A reference to the view that contains the 
// GUI controls
@property (strong) IBOutlet NSView* m_controlsView;

// A reference to the HUD Window in the GUI
@property (assign) IBOutlet NSWindow* m_HUDWindow;

// A reference to the capture session
@property (strong) QTCaptureSession* m_CaptureSession;

// A reference to the Audio Input device
@property (strong) QTCaptureDeviceInput* 
 m_CaptureDeviceInput_Audio;

// A reference to the Video Input device
@property (strong) QTCaptureDeviceInput* 
 m_CaptureDeviceInput_Video;

// Use this property to capture images
// from frames
@property (strong) QTCaptureDecompressedVideoOutput* m_CDVO;

// Use this property to preview audio
@property (strong) QTCaptureAudioPreviewOutput* m_audioPreviewOutput;

// Use this property to capture a movie to disk
@property (strong) QTCaptureMovieFileOutput* 
 m_CaptureMovieFileOutput;

// Define how long to wait for mouse movement
#define D_BTS_FADE_TIME 10

// Use this property to manage the timer object
@property (strong) NSTimer* m_fadeTimer; 


// The action method for the Take Picture button
- (IBAction)takePicture:(id)a_sender;

// The action method for the preview volume slider
- (IBAction)setPreviewVolume:(id)a_sender;

// The action method for the Stop and Record buttns
- (IBAction)startRecording:(id)a_sender;
- (IBAction)stopRecording:(id)a_sender;

// The methods for the compression menus
- (IBAction)compressButtonAction:(id)a_sender;
- (void) populateMenus;
- (void) setCaptureOptions;
- (void) clearCaptureOptions;

@end
