//
//  BTSAppDelegate+WindowDelegate.h
//  iSight Recorder
//
//  Created by rwiebe on 12-06-22.
//  Copyright (c) 2012 BurningThumb Software. All rights reserved.
//

#import "BTSAppDelegate.h"

// Define the size of the border around the window
#define D_BTS_WINDOW_BORDER 100

// Define the minimum acceptable size
#define BTS_MIN_WIDTH 320
#define BTS_MIN_HEIGHT 240

// Define the number of cutom animation steps
#define D_BTS_DURATION_ADJUSTMENT 0.1
#define D_BTS_ANIMATION_STEPS 2

@interface BTSAppDelegate (WindowDelegate)

- (void) handleFadeEvent;


@end
