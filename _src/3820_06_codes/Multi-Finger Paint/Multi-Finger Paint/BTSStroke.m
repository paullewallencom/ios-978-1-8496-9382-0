//
//  BTSStroke.m
//  Multi-Finger Paint
//
//  Created by rwiebe on 12-05-24.
//  Copyright (c) 2012 BurningThumb Software. All rights reserved.
//

#import "BTSStroke.h"

/**
 ** BTSStroke
 **
 ** This is a simple class that wraps an Array of
 ** BTSPoint objects along with a color and width
 ** to represent a stroke
 ** 
 ** It allows us initialize a stroke with a width and
 ** color, add a point to a stroke, retrive the color
 ** componets of the stroke, and retrieve the  
 ** width of the stroke
 **
 ** It conforms to the <NSCoding> protocal so that points
 ** can be archived using the NSKeyedArchiver class
 */

@implementation BTSStroke

@synthesize m_points;

/**
 ** initWithWidth:red:green:blue:alpha:
 **
 ** This method initializes the stroke
 ** instance variable with an empty array
 ** of points, a width, and RGBA color
 ** values
 **
 ** Input: Width: The width to draw
 **        red: The float value for the red color
 **        green: The float value for the green color
 **        blue: The float value for the blue color
 **        alpha: The float value for the opacity
 **
 ** Output: The stroke object
 **
 */

- (id) initWithWidth:(float)a_width 
                 red:(float)a_red 
               green:(float)a_green 
                blue:(float)a_blue 
               alpha:(float)a_alpha
{
	if ((self = [super init]) == nil) {
		return self;
	} // end if
    
    m_points = [[NSMutableArray alloc] init];
    m_red = a_red;
    m_green = a_green;
    m_blue = a_blue;
    m_alpha = a_alpha;
    m_width = a_width;
	
    return self;
    
}

/**
 ** addPoint:
 **
 ** This method adds a BTSPoint to the stroke.  It
 ** looks at the distance of this point from
 ** the last point added and ignores it if it is
 ** "too close"
 **
 ** Input: Point: The point to add
 **
 ** Output: none
 **
 */

- (void) addPoint:(BTSPoint *)a_point
{
    // Get the last point added to the stroke
    BTSPoint *l_lastPoint = [m_points lastObject];
    
    // Calculate the distance between the 
    // last point and this point
    float l_distance = 
     sqrtf(powf(l_lastPoint.x - a_point.x, 2) + 
           powf(l_lastPoint.y - a_point.y, 2));
    
    // Ignore the point if it is too close
    if (l_distance < D_TOO_CLOSE)
    {
        return;
    }
    
    // Add the new point to the stroke
    [m_points addObject:a_point];
}

/**
 ** points
 **
 ** Retrieve the array of points
 **
 ** Input: none
 **
 ** Output: The array of points
 **
 */

- (NSMutableArray *) points;
{
	return m_points;
}

/**
 ** red
 **
 ** Retrieve the red color value of the
 ** stroke
 **
 ** Input: none
 **
 ** Output: The red color value
 **
 */

- (float)red
{
	return m_red;
}

/**
 ** green
 **
 ** Retrieve the green color value of the
 ** stroke
 **
 ** Input: none
 **
 ** Output: The green color value
 **
 */

- (float)green
{
	return m_green;
}

/**
 ** blue
 **
 ** Retrieve the blue color value of the
 ** stroke
 **
 ** Input: none
 **
 ** Output: The blue color value
 **
 */

- (float)blue
{
	return m_blue;
}

/**
 ** alpha
 **
 ** Retrieve the opacity value of the
 ** stroke
 **
 ** Input: none
 **
 ** Output: The opacity value
 **
 */

- (float)alpha
{
	return m_alpha;
}

/**
 ** width
 **
 ** Retrieve the width value of the
 ** stroke
 **
 ** Input: none
 **
 ** Output: The width value
 **
 */
- (float)width
{
	return m_width;
}

/**
 ** encodeWithCoder:
 **
 ** This method uses key value encoding to
 ** archive the object
 **
 ** Input: The coder
 ** Output: none
 **
 */

- (void) encodeWithCoder: (NSCoder *)coder 
{
    // The archiver provides a convenience
    // method for encodeFloat:forKey:, so just use it
    // for RGBA and Widh
    [coder encodeFloat:m_red forKey:kBTS_RED_COLOR];
    [coder encodeFloat:m_green forKey:kBTS_GREEN_COLOR];
    [coder encodeFloat:m_blue forKey:kBTS_BLUE_COLOR];
    [coder encodeFloat:m_alpha forKey:kBTS_ALPHA_COLOR];
    [coder encodeFloat:m_width forKey:kBTS_WIDTH_COLOR];
    
    // Encode the NSArray object
    [coder encodeObject:m_points forKey:kBTS_POINTS_COLOR];
    
}

/**
 ** initWithCoder:
 **
 ** This method uses key value encoding to
 ** unarchive the object
 **
 ** Input: The coder
 ** Output: The Object
 **
 */

 - (id) initWithCoder: (NSCoder *)coder 
{ 
    if (self = [super init]) 
    { 
        // The unarchiver provides a convenience
        // method for decodeFloatForKey:, so just use it
        // for RGBA and Widh
        m_red = [coder decodeFloatForKey:kBTS_RED_COLOR];
        m_green = [coder decodeFloatForKey:kBTS_GREEN_COLOR];
        m_blue = [coder decodeFloatForKey:kBTS_BLUE_COLOR];
        m_alpha = [coder decodeFloatForKey:kBTS_ALPHA_COLOR];
        m_width = [coder decodeFloatForKey:kBTS_WIDTH_COLOR];
        
        // Decode the NSArray object
        m_points = [coder decodeObjectForKey:kBTS_POINTS_COLOR];
        
    } 
    
    return self; 
} 

@end
