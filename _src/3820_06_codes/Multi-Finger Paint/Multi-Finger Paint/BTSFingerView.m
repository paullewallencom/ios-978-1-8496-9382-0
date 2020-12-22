//
//  BTSFingerView.m
//  Multi-Finger Paint
//
//  Created by rwiebe on 12-05-23.
//  Copyright (c) 2012 BurningThumb Software. All rights reserved.
//

#import "BTSFingerView.h"
#import "BTSStroke.h"
#import "BTSStrokeView.h" // -- not in word document

@implementation BTSFingerView


// Reader challenge Pen Down Checkbox
@synthesize m_penDownCheckbox;

// Syntesize the object that will
// store the currently active touches
@synthesize m_activeTouches;

// Syntesize the object that will
// store the color well information
@synthesize m_colorWellView;
@synthesize m_colorWells;

// Syntesize the object that will
// store the currently active stokes
@synthesize m_activeStrokes;

// This method is automatically invoked
// when the view is created 
-(void) awakeFromNib
{
    // Get the color well views
    // into an array
    m_colorWells = [m_colorWellView subviews];
}

- (id)initWithFrame:(NSRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code here.
        
        // Create the mutable dictionary that
        // will hold the list of currently active
        // touch events
        m_activeTouches = [[NSMutableDictionary alloc] init];
        
        // Create the mutable dictionary that
        // will hold the list of currently active
        // strokes
        m_activeStrokes = [[NSMutableDictionary alloc] init];
        
        // Accept trackpad events
        [self setAcceptsTouchEvents: YES];

    }
    
    return self;
}

/**
 ** - (void)viewDidMoveToWindow
 **
 ** Informs the receiver that it has been added to 
 ** a new view hierarchy.
 **
 ** We need to make sure the view window is valid 
 ** and when it is, we can add the tracking rect
 **
 ** Once the tracking rect is added the mouseEntered:
 ** and mouseExited: events will be sent to our view
 **
 */

- (void)viewDidMoveToWindow 
{
    // Is the views window valid
    if ([self window] != nil)
    {
        // Add a tracking rect such that the
        // mouseEntered; and mouseExited: methods
        // will be automatically invoked
        [self addTrackingRect:[self bounds] 
                        owner:self 
                     userData:NULL 
                 assumeInside:NO];
    }
}

// Reader challenge, use a keydown
// event to change the state of the
// Pen Down checkbox
- (void)keyDown:(NSEvent *)a_event 
{    
    NSString *l_characters = [a_event characters];
    
    if ([l_characters length]) 
    {
        if ([l_characters hasPrefix:@" "]) 
        {
            if (NSOnState == m_penDownCheckbox.state)
            {
                [m_penDownCheckbox setState:NSOffState];
            }
            else 
            {
                [m_penDownCheckbox setState:NSOnState];
            }
        }
        else 
        {
            [super keyDown:a_event];
        }
    }
}


/**
 ** - (void)mouseEntered:
 **
 ** Informs the receiver that the mouse cursor
 ** entered a tracking rectangle
 **
 ** Since we only have a single tracking rect
 ** we know the mouse is over our custom view
 **
 */

- (void)mouseEntered:(NSEvent *)theEvent 
{
    // Set the flag so that other metods know
    // the mouse cursor is over our view
    m_mouseIsInFingerView = YES;
    
    // Redraw the view so that the focus ring
    // will appear
    [self setNeedsDisplay:YES];
}

/**
 ** - (void)mouseExited:
 **
 ** Informs the receiver that the mouse cursor
 ** exited a tracking rectangle
 **
 ** Since we only have a single tracking rect
 ** we know the mouse is not over our custom view
 **
 */

- (void)mouseExited:(NSEvent *)theEvent 
{
    // Set the flag so that other metods know
    // the mouse cursor is not over our view
    m_mouseIsInFingerView = NO;
     
    // Redraw the view so that the focus ring
    // will not appear
    [self setNeedsDisplay:YES];
}


/**
 ** (void)rotateWithEvent:(NSEvent *)event
 ** 
 ** Invoked when two fingers make a rotating
 ** gesture on the trackpad
 ** 
 ** Input: event - the gesture event
 **
 ** Output: none
 */

- (void)rotateWithEvent:(NSEvent *)event
{
    // If the pen is not down
    if (NSOffState == m_penDownCheckbox.state)
    {
        // Rotate the super view
        // By the amount of rotation in the
        // event
       [self.superview 
        setFrameCenterRotation:
         [self.superview frameCenterRotation] + [event rotation]];
    }
    
}

// Reader challenge
- (void)swipeWithEvent:(NSEvent *)event
{
    
    if (NSOffState == m_penDownCheckbox.state)
    {
        BTSStrokeView *l_strokeView = (BTSStrokeView *)self.superview;
        
        [m_activeTouches removeAllObjects];
        [m_activeStrokes removeAllObjects];
        
        CGAssociateMouseAndMouseCursorPosition(true);
        [NSCursor unhide];
        m_cursorIsHidden = NO;
        
        [l_strokeView clear];
    }
}

/**
 ** - (void)touchesBeganWithEvent:(NSEvent *)event
 ** 
 ** Invoked when a finger touches the trackpad
 ** 
 ** Input: event - the touch event
 **
 ** Output: none
 */

- (void)touchesBeganWithEvent:(NSEvent *)event
{
    // Ignore touches for which there is no color
    if ([m_activeTouches count] > ([m_colorWells count] - 1))
    {
        return;
    }

    // If the mouse cursor is not already hidden, 
    if (NO == m_cursorIsHidden)
    {
        // Detach the mouse cursor from the mouse 
        // hardware so that moving the mouse (or a 
        // single finger) will not move the cursor
        CGAssociateMouseAndMouseCursorPosition(false);
        
        // Hide the mouse cursor
        [NSCursor hide];
        
        // Remember that we detached and hid the
        // mouse cursor
        m_cursorIsHidden = YES;
    }

    // Get the set of began touches
    NSSet *l_touches = 
     [event touchesMatchingPhase:NSTouchPhaseBegan 
                          inView:self];
    
    // For each began touch, add the touch
    // to the active touches dictionary
    // using its identity as the key
    for (NSTouch *l_touch in l_touches)
    {
        [m_activeTouches setObject:l_touch forKey:l_touch.identity];
        
        // Reader challange, add a line only
        // it the pen is down
        if (NSOnState == m_penDownCheckbox.state)
        {
            // Get the color for the stroke
            NSColor *l_color = 
               [[m_colorWells objectAtIndex:
                 [m_activeTouches count] - 1] color];
            
            // Create a new stroke object with
            // the color
            BTSStroke *l_stoke = 
             [[BTSStroke alloc]
              initWithWidth:2.0 /* BAD MAGIC NUMBER */
              red:[l_color redComponent]
              green:[l_color greenComponent]
              blue:[l_color blueComponent]
              alpha:1];
            
            // Add the stroke to the array of active strokes
            [m_activeStrokes setObject:l_stoke 
                                forKey:l_touch.identity];
            
            // Create a new point at the location of the
            // finger touch.  This is done by getting the 
            // normalized position (between 0 and 10 and
            // calculating the position in the view bounds
            NSPoint l_touchNP = 
             [l_touch normalizedPosition];
            l_touchNP.x = 
             l_touchNP.x * self.bounds.size.width;
            l_touchNP.y = 
             l_touchNP.y * self.bounds.size.height;
            BTSPoint * l_point = 
             [[BTSPoint alloc] initWithNSPoint:l_touchNP];
            
            // Add the point to the stroke
            [l_stoke addPoint:l_point];
        }
        
    }

    
    
    // Redisplay the view
	[self setNeedsDisplay:YES];
}

/**
 ** - (void)touchesMovedWithEvent:(NSEvent *)event
 ** 
 ** Invoked when a finger moves on the trackpad
 ** 
 ** Input: event - the touch event
 **
 ** Output: none
 */

- (void)touchesMovedWithEvent:(NSEvent *)event
{
    // Get the set of move touches
    NSSet *l_touches = 
     [event touchesMatchingPhase:NSTouchPhaseMoved 
                          inView:self];
    
    // For each move touch, update the touch
    // in the active touches dictionary
    // using its identity as the key
    for (NSTouch *l_touch in l_touches)
    {
        // Update the touch only if it is found
        // in the active touches dictionary
        if ([m_activeTouches objectForKey:l_touch.identity])
        {
            [m_activeTouches setObject:l_touch 
                                forKey:l_touch.identity];

            // Reader challenge, add points to the line
            // only if the pen is down
            if (NSOnState == m_penDownCheckbox.state)
            {
                // Retrieve the stroke for this touch
                BTSStroke *l_Line = 
                 [m_activeStrokes objectForKey:
                  l_touch.identity];
                
                // Create a new point at the location of the
                // finger touch.  This is done by getting the 
                // normalized position (between 0 and 10 and
                // calculating the position in the view 
                // bounds
                NSPoint l_touchNP = 
                 [l_touch normalizedPosition];
                l_touchNP.x = 
                 l_touchNP.x * self.bounds.size.width;
                l_touchNP.y = 
                 l_touchNP.y * self.bounds.size.height;
                BTSPoint * l_point = 
                 [[BTSPoint alloc]initWithNSPoint:l_touchNP];
                
                // Add the point to the stroke
               [l_Line addPoint:l_point];
            }
        }
    }

    // Redisplay the view
	[self setNeedsDisplay:YES];
}

/**
 ** - (void)touchesEndedWithEvent:(NSEvent *)event
 ** 
 ** Invoked when a finger lifts off the trackpad
 ** 
 ** Input: event - the touch event
 **
 ** Output: none
 */

- (void)touchesEndedWithEvent:(NSEvent *)event
{
    
    // Get the set of ended touches
    NSSet *l_touches = 
     [event touchesMatchingPhase:NSTouchPhaseEnded 
                          inView:self];
    
    
    // For each ended touch, remove the touch
    // from the active touches dictionary
    // using its identity as the key
    // Also remove the active stroke for
    // the touch
    
    // Get a reference to the
    // stroke view object
    BTSStrokeView *l_strokeView = 
     (BTSStrokeView *)[self superview];

    for (NSTouch *l_touch in l_touches)
    {
        // If there is an active touch
        if ([m_activeTouches objectForKey:l_touch.identity])
        {
            // Get the active stroke for the touch
            BTSStroke *l_stroke =         
            [m_activeStrokes 
             objectForKey:l_touch.identity];
            
            // If the stroke has at least 2 points
            // in it add it to the stroke view
            // object
            if (l_stroke.m_points.count > D_MIN_POINTS)
            {
                [l_strokeView addStroke: l_stroke];
                [l_strokeView setNeedsDisplay:YES];
            }
        
            // Remove the active touch
            [m_activeTouches removeObjectForKey:l_touch.identity];
            
            // Remove the active stroke
            [m_activeStrokes removeObjectForKey:l_touch.identity];
        }
    }
    
    // If there are no remaining active touches
    if (0 == [m_activeTouches count])
    {
        // Attach the mouse cursor to the mouse 
        // hardware so that moving the mouse (or a 
        // single finger) will  move the cursor
        CGAssociateMouseAndMouseCursorPosition(true);
        
        // Show the mouse cursor
        [NSCursor unhide];
        
        // Remember that we attached and unhid the
        // mouse cursor so that the next touch that
        // begins will detach and hide it
        m_cursorIsHidden = NO;
    }

    // Redisplay the view
	[self setNeedsDisplay:YES];
}

/**
 ** - (void)touchesCancelledWithEvent:(NSEvent *)event
 ** 
 ** Invoked when a touch is cancelled
 ** 
 ** Input: event - the touch event
 **
 ** Output: none
 */

- (void)touchesCancelledWithEvent:(NSEvent *)event
{
    
    // Get the set of cancelled touches
    NSSet *l_touches = 
     [event touchesMatchingPhase:NSTouchPhaseCancelled 
                          inView:self];
    
    
    // For each ended touch, remove the touch
    // from the active touches dictionary
    // using its identity as the key
    // Also remove the active stroke for
    // the touch
    for (NSTouch *l_touch in l_touches)
    {
        [m_activeTouches removeObjectForKey:l_touch.identity];
        [m_activeStrokes removeObjectForKey:l_touch.identity];
    }
    
    // If there are no remaining active touches
    if (0 == [m_activeTouches count])
    {
        // Attach the mouse cursor to the mouse 
        // hardware so that moving the mouse (or a 
        // single finger) will  move the cursor
        CGAssociateMouseAndMouseCursorPosition(true);
        
        // Show the mouse cursor
        [NSCursor unhide];
        
        // Remember that we attached and unhid the
        // mouse cursor so that the next touch that
        // begins will detach and hide it
        m_cursorIsHidden = NO;
    }

    // Redisplay the view
	[self setNeedsDisplay:YES];
}

/**
 ** - (BOOL) acceptsFirstResponder
 **
 ** Make sure the view will receive
 ** events. 
 **
 ** Input: none
 **
 ** Output: YES to accept, NO to reject
 */

- (BOOL) acceptsFirstResponder
{
    return YES;
}

/**
 ** - (void)drawRect:(NSRect)dirtyRect
 ** 
 ** Draw the view content
 ** 
 ** Input: dirtyRect - the rectangle to draw
 **
 ** Output: none
 */

- (void)drawRect:(NSRect)dirtyRect
{
    // Drawing code here.
        
    // Preserve the graphics content
    // so that other things we draw
    // don't get focus rings
    [NSGraphicsContext saveGraphicsState];

    // colour the background transparent
    [[NSColor clearColor] set];

    // If this view has accepted first responder
    // it should draw the focus ring but only if
    // the mouse cursor is over this view
    if (
        ([[self window] firstResponder] == self) && 
        (YES == m_mouseIsInFingerView)
        )
    {
        NSSetFocusRingStyle(NSFocusRingAbove);
    }

    // Fill the view with fully transparent
    // color so that we can see through it
    // to whatever is below
    [[NSBezierPath bezierPathWithRect:[self bounds]] fill];
    
    // Restore the graphics content
    // so that other things we draw
    // don't get focus rings
    [NSGraphicsContext restoreGraphicsState];

    // Get the current graphics context
    NSGraphicsContext *	l_GraphicsContext = 
     [NSGraphicsContext currentContext];
    
    // Get the low level Core Graphics context
    // from the high level NSGraphicsContext
    // so that we can use Core Graphics to 
    // draw
	CGContextRef l_CGContextRef	= 
     (CGContextRef) [l_GraphicsContext graphicsPort];
    
    // We will need to reference the array of
    // points in each store
    NSMutableArray *l_points;
    
    // We will need a reference to individual
    // points
    BTSPoint *l_point;
    
    // We will need to know how many points
    // are in each stroke
    NSUInteger l_pointCount;
    
    // We will need a reference to the
    // first point in each stroke
    BTSPoint * l_firsttPoint;
    
    // For all of the active strokes
    for (BTSStroke *l_stroke in m_activeStrokes.allValues )
    {
        // Set the stroke width for line
        // drawing
        CGContextSetLineWidth(l_CGContextRef, 
                              [l_stroke width]);
        
        // Set the color for line drawing
		CGContextSetRGBStrokeColor(l_CGContextRef,
                                   [l_stroke red],
                                   [l_stroke green],
                                   [l_stroke blue],
                                   [l_stroke alpha]);
        // Get the array of points
		l_points = [l_stroke points];
        
		// Get the number of points
		l_pointCount = [l_points count];
        
        // Get the first point
		l_firsttPoint = [l_points objectAtIndex:0];
        
        // Create a new path
		CGContextBeginPath(l_CGContextRef);
        
        // Move to the first point of the stroke
		CGContextMoveToPoint(l_CGContextRef,
                             [l_firsttPoint x],
                             [l_firsttPoint y]);
                
        // For the remaining points
		for (NSUInteger i = 1; i < l_pointCount; i++) 
        {  
            // note the index starts at 1
            // Get the SECOND point
			l_point = [l_points objectAtIndex:i];
            
            // Add a line segment to the stroke
			CGContextAddLineToPoint(l_CGContextRef,
                                    [l_point x],
                                    [l_point y]);	
		} 
		
        // Draw the path
		CGContextDrawPath(l_CGContextRef,kCGPathStroke);
		
	} 
    
    // For each active touch
    for (NSTouch *l_touch in m_activeTouches.allValues)
    {   
        // Create a rectangle reference to hold the 
        // location of the cursor
        NSRect l_cursor;
        
        // Determine where the touch point
        NSPoint l_touchNP = [l_touch normalizedPosition];
        
        // Calculate the pixel position of the touch point
        l_touchNP.x = l_touchNP.x * [self bounds].size.width;
        l_touchNP.y = l_touchNP.y * [self bounds].size.height;
        
        // Calculate the rectangle around the cursor
        l_cursor.origin.x = l_touchNP.x - (D_FINGER_CURSOR_SIZE / 2);
        l_cursor.origin.y = l_touchNP.y - (D_FINGER_CURSOR_SIZE / 2);
        l_cursor.size.width = D_FINGER_CURSOR_SIZE;
        l_cursor.size.height = D_FINGER_CURSOR_SIZE;
        
        // Set the color of the cursor
        [[NSColor colorWithDeviceRed: D_FINGER_CURSOR_RED 
                               green: D_FINGER_CURSOR_GREEN 
                                blue: D_FINGER_CURSOR_BLUE 
                               alpha: D_FINGER_CURSOR_ALPHA] set];
        
        // Draw the cursor as a circle
        [[NSBezierPath bezierPathWithOvalInRect: l_cursor] fill];
    }


}

@end
