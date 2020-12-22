//
//  BTSStrokeView.h
//  Multi-Finger Paint
//
//  Created by rwiebe on 12-05-26.
//  Copyright (c) 2012 BurningThumb Software. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "BTSStroke.h"

@interface BTSStrokeView : NSView

// A reference to the array of Saved Strokes
@property (strong) NSMutableArray *m_Strokes;

/**
 ** - (void) addStroke: (BTSStroke *)a_stroke
 **
 ** Add a stroke to the saved array of
 ** BTSStroke objects
 **
 ** Input: A BTSStroke object
 **
 ** Output: none
 */
- (void) addStroke: (BTSStroke *)a_stroke;

// Reader challenge
- (void) clear;

@end
