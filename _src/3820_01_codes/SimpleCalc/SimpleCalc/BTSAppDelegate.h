//
//  BTSAppDelegate.h
//  SimpleCalc
//
//  Created by rwiebe on 12-04-10.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <Cocoa/Cocoa.h>

@interface BTSAppDelegate : NSObject <NSApplicationDelegate>

@property (assign) IBOutlet NSWindow *window;

/*
    Create the user interface elements
 */

// Buttons
@property (assign) IBOutlet NSButton *mAdd;
@property (assign) IBOutlet NSButton *mSubtract;
@property (assign) IBOutlet NSButton *mMutliply;
@property (assign) IBOutlet NSButton *mDivide;

// Text Fields
@property (assign) IBOutlet NSTextField *mValue1;
@property (assign) IBOutlet NSTextField *mValue2;
@property (assign) IBOutlet NSTextField *mResult;

/*
 Create the App interface for the buttons
 */

- (IBAction)myButtonAction:(id)sender;

@end
