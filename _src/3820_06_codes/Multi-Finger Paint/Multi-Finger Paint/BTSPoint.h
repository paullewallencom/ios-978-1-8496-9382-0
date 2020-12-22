//
//  BTSPoint.h
//  Multi-Finger Paint
//
//  Created by rwiebe on 12-05-24.
//  Copyright (c) 2012 BurningThumb Software. All rights reserved.
//

#import <Foundation/Foundation.h>

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
 ** It conforms to the <NSCoding> protocal so that points
 ** can be archived using the NSKeyedArchiver class
 */

@interface BTSPoint : NSObject <NSCoding>
{
	NSPoint m_point;
}

- (id) initWithNSPoint:(NSPoint)a_point;
- (NSPoint) point;
- (CGFloat)x;
- (CGFloat)y;

@end
