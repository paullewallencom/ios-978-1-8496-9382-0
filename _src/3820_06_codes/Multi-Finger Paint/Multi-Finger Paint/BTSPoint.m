//
//  BTSPoint.m
//  Multi-Finger Paint
//
//  Created by rwiebe on 12-05-24.
//  Copyright (c) 2012 BurningThumb Software. All rights reserved.
//

#import "BTSPoint.h"

/**
 ** BTSPoint
 **
 ** This is a simple class that wraps an NSPoint/CGPoint
 ** in an object so that it can be added to other
 ** objects, like NSArrays
 **
 ** It allows us initialize a point, retrieve the point,
 ** and retrieve the x or y value of the point.
 **
 ** It implements the <NSCoding> protocal so that points
 ** can be archived using the NSKeyedArchiver class
 **
 */

@implementation BTSPoint

/**
 ** initWithNSPoint:
 **
 ** This method initializes the wrapped point
 ** instance variable with the x,y values of
 ** the original point
 **
 ** Input: The original point
 ** Output: The wrapped point object
 **
 */

- (id) initWithNSPoint:(NSPoint)a_point;
{
	if ((self = [super init]) == nil) 
    {
		return self;
	}
    
    // Set the initial value of the instance
    // variable to match the passed in 
    // point values
	m_point.x	= a_point.x;
	m_point.y	= a_point.y;
	
    return self;
    
}

/**
 ** point
 **
 ** This method "unwraps" and returns
 ** the original point value
 **
 ** Input: none
 ** Output: The wrapped point value
 **
 */

- (NSPoint) point;
{
    // return the instance variable
	return m_point;
}

/**
 ** x
 **
 ** This method "unwraps" and returns
 ** the x component of the original point value
 **
 ** Input: none
 ** Output: The unwrapped x value
 **
 */
- (CGFloat)x;
{
    // Return the x component of the instance
    // variable
	return m_point.x;
}

/**
 ** y
 **
 ** This method "unwraps" and returns
 ** the y component of the original point value
 **
 ** Input: none
 ** Output: The unwrapped y value
 **
 */

- (CGFloat)y;
{
    // Return the y component of the instance
    // variable
	return m_point.y;
}

/** In order that BTSPoint objects can be written to
 ** and read from archives, the NSCoder protocol methods
 ** must be implememted
 */

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
    // method for encodePoint:forKey:, so just use it
    [coder encodePoint:m_point forKey:@"m_point"];
    
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
        // method for decodePointForKey:, so just use it
        m_point = [coder decodePointForKey:@"m_point"];
    } 
    
    return self; 
} 

@end
