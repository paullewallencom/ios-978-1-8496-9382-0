//
//  BTSStrokeView.m
//  Multi-Finger Paint
//
//  Created by rwiebe on 12-05-26.
//  Copyright (c) 2012 BurningThumb Software. All rights reserved.
//

#import "BTSStrokeView.h"
#import "BTSStroke.h"

@implementation BTSStrokeView

// Syntesize the object that will
// store the saved stokes
@synthesize m_Strokes;

- (id)initWithFrame:(NSRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code here.
        
        
        // Initialize and allocate the array
        self.m_Strokes = [[NSMutableArray alloc] init];
    }
    
    return self;
}

// Reader challenge
- (void) clear
{
    [m_Strokes removeAllObjects];
    [self setNeedsDisplay:YES];
}

/**
 ** - (void) addLine: (BTSStroke *)a_line
 **
 ** Add a stroke to the saved array of
 ** BTSStroke objects
 **
 ** Input: A BTSStroke object
 **
 ** Output: none
 */
- (void) addStroke: (BTSStroke *)a_stroke
{

    // Add the stroke to the array
    [m_Strokes addObject: a_stroke];
}

- (void)drawRect:(NSRect)dirtyRect
{
    // Drawing code here.
    
    // colour the background transparent
    [[NSColor whiteColor] set];
    
    // Fill the view with fully transparent
    // color so that we can see through it
    // to whatever is below
    [[NSBezierPath bezierPathWithRect:dirtyRect] fill];
    
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
    for (BTSStroke *l_stroke in m_Strokes )
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

}

@end
