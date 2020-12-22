//
//  BTSWindowController+Browser.h
//  iSight iMage cApture
//
//  Created by rwiebe on 12-06-06.
//  Copyright (c) 2012 BurningThumb Software. All rights reserved.
//

#import "BTSWindowController.h"

@interface BTSWindowController (Browser)

// The method to setup the IKBrowserView
- (void) setupBrowser;

// ----- needs to be added to the word file
- (void) addImageWithURL:(NSURL *) a_fileURL;

@end
