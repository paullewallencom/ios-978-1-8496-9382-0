//
//  BTSWindowController+Importer.h
//  iSight iMage cApture
//
//  Created by rwiebe on 12-06-06.
//  Copyright (c) 2012 BurningThumb Software. All rights reserved.
//

#import "BTSWindowController.h"

@interface BTSWindowController (Importer)

#define D_FILENAME_TEMPLATE @"IMG%u%02u%02u%02u%02u%02u.jpg"
#define D_MAX_WIDTH 640
#define D_MAX_HEIGHT 480

// The action method to capture an image
- (IBAction) takePicture:(id) sender;

@end
