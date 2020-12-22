//
//  BTSFingerView.h
//  Multi-Finger Paint
//
//  Created by rwiebe on 12-05-23.
//  Copyright (c) 2012 BurningThumb Software. All rights reserved.
//

#import <Cocoa/Cocoa.h>

// Define the size of the cursor that
// will be drawn in the view for each
// finger on the trackpad
#define D_FINGER_CURSOR_SIZE 20

// Define the color values that will 
// be used for the finger cursor
#define D_FINGER_CURSOR_RED 1.0
#define D_FINGER_CURSOR_GREEN 0.0
#define D_FINGER_CURSOR_BLUE 0.0
#define D_FINGER_CURSOR_ALPHA 0.5

// Define the minimum number of
// points that can be in a stroke
#define D_MIN_POINTS 2

@interface BTSFingerView : NSView
{

    // Define a flag so that view methods can behave
    // differently depending on the position of the
    // mouse cursor
    BOOL m_mouseIsInFingerView;
    
    // Define a flag so that touch methods can behave
    // differently depending on the visibility of
    // the mouse cursor
    BOOL m_cursorIsHidden;
}    

// Reader challenge Pen Down button
@property (strong) IBOutlet NSButton *m_penDownCheckbox;

// A reference to the object that will
// store the currently active touches
@property (strong) NSMutableDictionary *m_activeTouches;

// A reference to the custom view object that will
// contain the NSColorWell subviews
@property (strong) IBOutlet NSView *m_colorWellView;

// A reference to the array of NSColorWell objects
@property (strong) NSArray *m_colorWells;

// A reference to the array of Active Strokes
@property (strong) NSMutableDictionary *m_activeStrokes;



@end
