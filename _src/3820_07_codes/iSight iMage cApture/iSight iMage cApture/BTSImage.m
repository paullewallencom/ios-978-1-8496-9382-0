//
//  BTSImage.m
//  iSight iMage cApture
//
//  Created by rwiebe on 12-06-04.
//  Copyright (c) 2012 BurningThumb Software. All rights reserved.
//

#import <Quartz/Quartz.h>
#import "BTSImage.h"

@implementation BTSImage

// Create the accessor methods for 
// the image URL
@synthesize m_URL;

// Assign an NSURL to the BTSImage
// and return the BTSImage object
- (id)initWithURL:(NSURL *)a_URL
{
    self = [super init];
    if (self) 
    {
        // Initialization code here.
        m_URL = a_URL;
    }
    
    return self;
}

#pragma mark -
#pragma mark item data source protocol

// Return the constant that indicates
// the image is represented by an 
// NSURL
- (NSString *)  imageRepresentationType
{
    return IKImageBrowserNSURLRepresentationType;
}

// Return the NSURL for the image
- (id)  imageRepresentation
{
	return m_URL;
}

// Return the full path to the image
// as its unique id
- (NSString *) imageUID
{
    return [m_URL path];
}

// Return just the file name component
// of the path as the image title
- (NSString *) imageTitle
{
	return [m_URL lastPathComponent];
}

@end
