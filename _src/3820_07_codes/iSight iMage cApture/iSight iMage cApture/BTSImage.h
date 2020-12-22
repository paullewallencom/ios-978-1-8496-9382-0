//
//  BTSImage.h
//  iSight iMage cApture
//
//  Created by rwiebe on 12-06-04.
//  Copyright (c) 2012 BurningThumb Software. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface BTSImage : NSObject

// A reference to the file URL
@property (strong)  NSURL *m_URL;

// The interface for initializing
// a new BTSImage using a URL that
// points to the image
- (id) initWithURL: (NSURL *) a_URL;

// The IKImageBrowserView dataSource protocol
// methods

// Required methods

// Returns a unique string that identifies 
// the data source item.
- (NSString *) imageUID;

// Returns the representation type of the 
// image to display.
- (NSString *) imageRepresentationType;

// Returns the image to display.
- (id)  imageRepresentation;


// Optional methods

// Returns the display title of the image
- (NSString *) imageTitle;

@end
