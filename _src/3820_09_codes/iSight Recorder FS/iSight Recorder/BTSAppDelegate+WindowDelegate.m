//
//  BTSAppDelegate+WindowDelegate.m
//  iSight Recorder
//
//  Created by rwiebe on 12-06-22.
//  Copyright (c) 2012 BurningThumb Software. All rights reserved.
//

#import "BTSAppDelegate+WindowDelegate.h"
#import "NSButton+TextColor.h"

@implementation BTSAppDelegate (WindowDelegate)

// Initialze a few values when the nib has been loaded
- (void) awakeFromNib
{
    // Since the App always starts in windowed mode, it is
    // safe to always hide the HUD window by making it
    // transparent
    [self.m_HUDWindow setAlphaValue:0];
    
}

// This method is automatically invoked on the
// WindowDelegate object when the window is preparing
// to enter full screen
- (void)windowWillEnterFullScreen:(NSNotification *)notification
{
    
    // Save the current settings for the window and view
    // frames and boundaries so that we can restore them later
    m_windowFrame = [self.window frame];
    m_viewFrame = [self.m_QTCaptureView frame];
    m_viewBounds = [self.m_QTCaptureView bounds];
    
    // Save the current frame and bounds of the custom view 
    // that contains the GUI so that we can restore them later
    m_controlsViewFrame = [self.m_controlsView frame];
    m_controlsViewBounds = [self.m_controlsView bounds];
    
    // Scale the capture view frame up to fill the window
    [self.m_QTCaptureView 
     setFrame:NSMakeRect(0,
                         0, 
                         m_windowFrame.size.width, 
                         m_windowFrame.size.height)];
    
    // Scale the capture view bounds up to fill the window
    [self.m_QTCaptureView 
     setBounds:NSMakeRect(0,
                          0, 
                          m_windowFrame.size.width, 
                          m_windowFrame.size.height)];
    
    // Remove the controls from the main window
    [self.m_controlsView removeFromSuperview];
    
    // ----- not in word file
    [self.m_controlsView setFrame:[self.m_HUDWindow.contentView frame]];
    [self.m_controlsView setBounds:[self.m_HUDWindow.contentView bounds]];
    
    // Add the controls to the HUD window
    [[self.m_HUDWindow contentView] 
     addSubview:self.m_controlsView];
    
    // Change the checkbox text color to white
    [self.m_compressButton setTextColor:[NSColor whiteColor]];
    
}

// This method is automatically invoked on the
// WindowDelegate object when the window has 
// entered full screen
- (void)windowDidEnterFullScreen:(NSNotification *)notification
{
    // Show the HUD Window
    [self.m_HUDWindow setAlphaValue:1];

    // When in full screen the mouse needs to be tracked
    // so we enable acceptance of mouse moved events
    [self.window setAcceptsMouseMovedEvents:YES];
    
    // Showing the HUD Window is a Fade event so we
    // handle it here
    [self handleFadeEvent];

}

// This method is automatically invoked on the
// WindowDelegate object when the window is preparing
// to exit full screen
- (void)windowWillExitFullScreen:(NSNotification *)notification
{
    // Hide the HUD Window
    [self.m_HUDWindow setAlphaValue:0];
    
    // When not in full screen the mouse does not need to be
    // tracked
    [self.window setAcceptsMouseMovedEvents:NO];
}

// This method is automatically invoked on the
// WindowDelegate object when the window has 
// exited full screen
- (void)windowDidExitFullScreen:(NSNotification *)notification
{
    // Remove the controls from the HUD Window
    [self.m_controlsView removeFromSuperview];
    
    // Restore the custom view to its original size
    [self.m_controlsView setFrame:m_controlsViewFrame];
    [self.m_controlsView setBounds:m_controlsViewBounds];
    
    // Add the controls to the main window
    [self.window.contentView addSubview:self.m_controlsView];
    
    // Restore the Capture View to its original size
    [self.m_QTCaptureView setFrame:m_viewFrame];
    [self.m_QTCaptureView setBounds:m_viewBounds];

    // Hide the Controls
    [self.m_controlsView setAlphaValue:0];
    
    // Start an animation to cause the controls to fade in
    [[self.m_controlsView animator] setAlphaValue:1.0];
    
    // Restore the checkbox text color
    [self.m_compressButton setTextColor:[NSColor controlTextColor]];


}

// This method is invoked automatically whenever our
// window becomes the key window
- (void)windowDidBecomeKey:(NSNotification *)notification
{
    // Just handle the event
    [self handleFadeEvent];
}

// This method is invoked by our custom NSView subclass
// whenever it receives a mouse moved event
- (void)mouseMoved: (NSEvent*)a_event
{
    // Just handle the event
    [self handleFadeEvent];
}

// This is invoked when:
// -- The window becomes full screen
// -- The window becomes key
// -- The mouse moves
- (void) handleFadeEvent
{
    // If a timer is running, cancel it
    if (self.m_fadeTimer)
    {
        [self.m_fadeTimer invalidate];
        self.m_fadeTimer = NULL;
    }
    
    // If its a Full Screen window
    if ( self.window.styleMask & NSFullScreenWindowMask) 
    {
        // Display the contorls
        [self.m_HUDWindow setAlphaValue:1];
        
        // Start a fade timer
        self.m_fadeTimer = 
        [NSTimer scheduledTimerWithTimeInterval:D_BTS_FADE_TIME
                  target:self
                   selector:@selector(handleTimer:)
                    userInfo:nil
                    repeats:NO];
    } 
}

// If the NSTimer object counts down to zero then this
// method will be invoked
- (void) handleTimer: (id) a_object
{
    // If the GUI Controls window was clicked it will be key
    // so we don't want it to fade
    if (self.window.isKeyWindow)
    {
        // If the GUI controls window was not clicked the 
        // capture view will be key so fade the Contols out
        [[self.m_HUDWindow animator] setAlphaValue:0];
    }
    
}

#pragma mark -
#pragma mark - Custom full screen size

// -------------------------------------------------------------------------------
//	window:willUseFullScreenContentSize:proposedSize
//
//  A window's delegate can optionally override this method, to specify a different
//  Full Screen size for the window. This delegate method override's the window's full
//  screen content size to include a border around it.
// -------------------------------------------------------------------------------
- (NSSize)window:(NSWindow *)window willUseFullScreenContentSize:(NSSize)proposedSize
{
    
    // calculate the desired window size
    NSSize l_windowSize = 
     NSMakeSize(proposedSize.width -  D_BTS_WINDOW_BORDER ,
                proposedSize.height - D_BTS_WINDOW_BORDER );
    
    // If the desired size is smaller than the 
    // minumum acceptable size use minimum acceptable
    // size bounded by the proposed size
    if ((l_windowSize.width < BTS_MIN_WIDTH ) ||
        (l_windowSize.height < BTS_MIN_HEIGHT))
    {
        l_windowSize = 
         NSMakeSize(MIN(BTS_MIN_WIDTH,  proposedSize.width),
                    MIN(BTS_MIN_HEIGHT, proposedSize.height));
    }
        
    // Return the result.
    return l_windowSize;
}


#pragma mark -
#pragma mark - Custom animation

// Return the list of windows in the custom animation for
// entering full screen
- (NSArray *)customWindowsToEnterFullScreenForWindow:
  (NSWindow *)a_window
{
    // Just our window
    return [NSArray arrayWithObjects:a_window, nil];
}

// Return the list of windows in the custom animation for
// exiting full screen
- (NSArray *)customWindowsToExitFullScreenForWindow:
  (NSWindow *)a_window
{
    // Just our window
    return [NSArray arrayWithObjects:a_window, nil];
}

// This method is automatically invoked to allow us to
// sychronize out custom animation with the system animation
- (void)window:(NSWindow *)a_window 
        startCustomAnimationToEnterFullScreenWithDuration:
         (NSTimeInterval)a_duration
{    
    // Save the window frame so that it can be restored later
    m_windowFrame = self.window.frame;
        
    // Make sure the window style mask includes the
    // full screen bit
    [a_window setStyleMask:([a_window styleMask] | 
                            NSFullScreenWindowMask)];
    
    // Get the first screen
    NSScreen *l_screen = self.window.screen;
    
    // The final, full screen frame
    NSRect l_finalFrame;
    
    // Invoke the delegate to get the custom frame size
    l_finalFrame.size = 
     [self window:a_window 
           willUseFullScreenContentSize:l_screen.frame.size];
    
    // Calculate the origin as half the difference between
    // the window frame and the screen frame
    l_finalFrame.origin.x += 
     floor((NSWidth(l_screen.frame) - 
            NSWidth(l_finalFrame)) / 2);
    
    l_finalFrame.origin.y += 
     floor((NSHeight(l_screen.frame) - 
            NSHeight(l_finalFrame)) / 2);
    
    // The center frame for each window is used during 
    // the 1st half of the fullscreen animation and is
    // the window at its original size but moved to the
    // center of its eventual full screen frame.
    NSRect l_centerWindowFrame = [a_window frame];
    
    l_centerWindowFrame.origin.x = 
     l_finalFrame.size.width / 2 - 
     l_centerWindowFrame.size.width / 2;
    
    l_centerWindowFrame.origin.y = 
     l_finalFrame.size.height / 2 - 
     l_centerWindowFrame.size.height / 2;

    
    // Our animation must be slightly shorter than
    // the system animation to avoid a black flash
    // at the end of the animation -- seems like a bug
    a_duration -= D_BTS_DURATION_ADJUSTMENT;
        
    // Our animation will be broken into two steps.  
    
    [NSAnimationContext 
     runAnimationGroup:^(NSAnimationContext *l_context) 
    {
        
        // First, we move the window to the center
        // of the primary screen 
        [l_context setDuration:a_duration / D_BTS_ANIMATION_STEPS];
        [[a_window animator] 
         setFrame:l_centerWindowFrame display:YES];

        
    } 
        completionHandler:^
        {
        
            [NSAnimationContext 
             runAnimationGroup:^(NSAnimationContext *l_context)
             {
            // and then we enlarge it its full size.
            [l_context setDuration:a_duration/ D_BTS_ANIMATION_STEPS];
            [[a_window animator] setFrame:l_finalFrame display:YES];
            
             } 
                completionHandler:^
                {
                }
             ];
        }
     ];
}

- (void)windowDidFailToEnterFullScreen:(NSWindow *)window
{
    // If we had any cleanup to perform in the event of failure to enter Full Screen,
    // this would be the place to do it.
    //
    // One case would be if the user attempts to move to full screen but then
    // immediately switches to Dashboard.
}



// This method is automatically invoked to allow us to 
// sychronize out custom animation with the system animation
- (void) window:(NSWindow *)window 
        startCustomAnimationToExitFullScreenWithDuration:
         (NSTimeInterval)duration
{
    
    // Make sure the window style mask does not
    // include full screen bit
    [window setStyleMask:([window styleMask] & 
                          ~NSFullScreenWindowMask)];
    
    // The center frame for the window is used during 
    // the 1st half of the fullscreen animation and is
    // the window at its original size but moved to the
    // center of its eventual full screen frame.
    NSRect l_centerWindowFrame = m_windowFrame;
    l_centerWindowFrame.origin.x = 
     window.frame.size.width / 2 - 
     m_windowFrame.size.width / 2;
    
    l_centerWindowFrame.origin.y = 
     window.frame.size.height / 2 - 
     m_windowFrame.size.height / 2;
    
    // Our animation will be broken into two stages.
    [NSAnimationContext 
     runAnimationGroup:^(NSAnimationContext *context)
     {
         // First, we'll restore the window to its original size 
         // while centering it 
         [context setDuration:duration / D_BTS_ANIMATION_STEPS];
         [[window animator] 
          setFrame:l_centerWindowFrame display:YES];
         
     } 
        completionHandler:^
        {
            [NSAnimationContext 
             runAnimationGroup:^(NSAnimationContext *context)
             {
             // And then we'll move it back to its initial
             // position.
             [context setDuration:duration / D_BTS_ANIMATION_STEPS];
             [[window animator] 
              setFrame:m_windowFrame display:YES];
             
             } 
                completionHandler:^
                {             
                }
          ];
         
        }
     ];
}

- (void)windowDidFailToExitFullScreen:(NSWindow *)window
{
    // If we had any cleanup to perform in the event of failure to exit Full Screen,
    // this would be the place to do it.
    // ...
}

/*
#pragma mark -
#pragma mark Full Screen Support: Persisting and Restoring Window's Non-FullScreen Frame

+ (NSArray *)restorableStateKeyPaths
{
    return [[super restorableStateKeyPaths] arrayByAddingObject:@"frameForNonFullScreenMode"];
}
*/
@end
