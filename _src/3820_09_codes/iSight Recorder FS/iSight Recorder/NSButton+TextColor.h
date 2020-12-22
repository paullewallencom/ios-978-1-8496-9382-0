//
//  NSButton+TextColor.h
//  iSight Recorder
//
//  Created by rwiebe on 12-06-26.
//  Copyright (c) 2012 BurningThumb Software. All rights reserved.
//

#import <Cocoa/Cocoa.h>

@interface NSButton (TextColor)

// The method to set the text color
- (void)setTextColor:(NSColor *)textColor;

// ----- Reader challenge
// The method to get the text color 
- (NSColor *)textColor;


@end
