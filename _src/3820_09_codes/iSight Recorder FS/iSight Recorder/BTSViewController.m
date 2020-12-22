//
//  BTSViewController.m
//  iSight Recorder
//
//  Created by rwiebe on 12-06-27.
//  Copyright (c) 2012 BurningThumb Software. All rights reserved.
//

#import "BTSViewController.h"

@implementation BTSViewController

- (id)initWithFrame:(NSRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code here.
    }
    
    return self;
}


- (void)drawRect:(NSRect)dirtyRect
{
    // Drawing code here.
}

// The view MUST return YES if it wants
// mouseMoved events
- (BOOL)acceptsFirstResponder
{  
    return YES;
}

// This method is invoke automatically whenever the 
// mouse moves
- (void)mouseMoved: (NSEvent*)a_event
{
    // Just forward the event to the App Delegate
    // It knows what to do when the mouse moves
    [[NSApp delegate] mouseMoved:a_event];
}

@end
