//
//  NSButton+TextColor.m
//  iSight Recorder
//
//  Created by rwiebe on 12-06-26.
//  Copyright (c) 2012 BurningThumb Software. All rights reserved.
//

#import "NSButton+TextColor.h"

@implementation NSButton (TextColor)

// This method applies the passed color
// to the attributed title string
- (void)setTextColor:(NSColor *)a_Color
{
    // Create a mutable copy of the title
    NSMutableAttributedString *l_attrTitle =
    [[self attributedTitle] mutableCopy];
    
    // Create a range corresponding to the length
    // of the attributed string
    NSRange l_range = 
     NSMakeRange(0, [l_attrTitle length]);
    
    // Add a foreground color attribute to the 
    // attributed string using the provided color
    [l_attrTitle 
     addAttribute:NSForegroundColorAttributeName 
            value:a_Color 
            range:l_range];
    
    // Set the title
    [self setAttributedTitle:l_attrTitle];
}

// ----- Reader Challenge

// This method returns the color of the first
// character in the string or the default control
// color if the string is empty
- (NSColor *)textColor
{
    // Create a reference for the returned color
    NSColor *textColor;
    
    // Get a reference to attributed string title
    NSAttributedString *l_attrTitle = 
    [self attributedTitle];
    
    // Get the length of the title
    NSInteger l_len = [l_attrTitle length];
    
    // If the string has at least 1 character
    if (l_len)
    {   
        // Get the font attributes of the first character
        NSDictionary *l_attrs = 
        [l_attrTitle fontAttributesInRange:NSMakeRange(0, 1)];
        
        // If there are font attributes
        if (l_attrs) 
        {
            // Get the foreground color
            textColor = 
            [l_attrs objectForKey:
             NSForegroundColorAttributeName];
        }
    }
    
    // If no color was found
    if (nil == textColor)
    {
        // Get a reference to a color object that
        // represents the default control text color
        textColor = [NSColor controlTextColor];
    }
    
    // Return the color
    return textColor;
}

@end
