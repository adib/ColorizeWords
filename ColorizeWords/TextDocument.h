//
//  TextDocument.h
//  ColorizeWords
//
//  Created by Sasmito Adibowo on 20-08-11.
//  Copyright 2011 Basil Salad Software. All rights reserved.
//  http://cutecoder.org

#import <Cocoa/Cocoa.h>

@class WebView;

@interface TextDocument : NSDocument {
    NSView *textEditingContainerView;
    WebView *renderedTextContainerView;
    NSTextView *inputTextView;
    
    NSView* currentContainerView;
    IBOutlet NSView *rootContainerView;
    
}

@property (assign) IBOutlet NSView *textEditingContainerView;

@property (assign) IBOutlet WebView *renderedTextContainerView;

@property (assign) IBOutlet NSTextView *inputTextView;
- (IBAction)toggleContainerViews:(id)sender;

@end
