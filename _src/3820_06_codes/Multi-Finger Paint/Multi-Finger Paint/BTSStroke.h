//
//  BTSStroke.h
//  Multi-Finger Paint
//
//  Created by rwiebe on 12-05-24.
//  Copyright (c) 2012 BurningThumb Software. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "BTSPoint.h"

/**
 ** BTSStroke
 **
 ** This is a simple class that wraps an Array of
 ** BTSPoint objects along with a color and width
 ** to represent a stroke
 ** 
 ** It allows us initialize a stroke with a width and
 ** color, add a point to a stroke, retrieve the array
 ** of points, retrive the color componets of the 
 ** stroke, and retrieve the width of the stroke
 **
 ** It conforms to the <NSCoding> protocal so that points
 ** can be archived using the NSKeyedArchiver class
 */

// How close is too close for
// points be be considered unique
#define D_TOO_CLOSE 5

// Keys to access the archived values
#define kBTS_RED_COLOR @"m_red"
#define kBTS_GREEN_COLOR @"m_green"
#define kBTS_BLUE_COLOR @"m_blue"
#define kBTS_ALPHA_COLOR @"m_alpha"
#define kBTS_WIDTH_COLOR @"m_width"
#define kBTS_POINTS_COLOR @"m_points"

@interface BTSStroke : NSObject <NSCoding> // Adopts NSCoding protocol
{
    float m_red;
    float m_green;
    float m_blue;
    float m_alpha;
    float m_width;
}

@property (strong) NSMutableArray *m_points;


- (id) initWithWidth:(float)a_width 
                 red:(float)a_red 
               green:(float)a_green 
                blue:(float)a_blue 
               alpha:(float)a_alpha;
- (void) addPoint:(BTSPoint *)a_point;
- (NSMutableArray *) points;
- (float)red;
- (float)green;
- (float)blue;
- (float)alpha;
- (float)width;

@end
