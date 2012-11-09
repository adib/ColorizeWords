//
//  TextDocument.m
//  ColorizeWords
//
//  Created by Sasmito Adibowo on 20-08-11.
//  Copyright 2011 Basil Salad Software. All rights reserved.
//  http://cutecoder.org


#import "TextDocument.h"
#import <WebKit/WebKit.h>
#import <QuartzCore/QuartzCore.h>
#import "SolarizedColors.h"

@implementation TextDocument
@synthesize textEditingContainerView;
@synthesize renderedTextContainerView;
@synthesize inputTextView;

- (id)init
{
    self = [super init];
    if (self) {
        // Add your subclass-specific initialization here.
        // If an error occurs here, send a [self release] message and return nil.
    }
    return self;
}

- (NSString *)windowNibName
{
    // Override returning the nib file name of the document
    // If you need to use a subclass of NSWindowController or if your document supports multiple NSWindowControllers, you should remove this method and override -makeWindowControllers instead.
    return @"TextDocument";
}

- (void)windowControllerDidLoadNib:(NSWindowController *)aController
{
    [super windowControllerDidLoadNib:aController];
    // Add any code here that needs to be executed once the windowController has loaded the document's window.
    
    NSRect containerBounds = rootContainerView.bounds;
    [textEditingContainerView setFrame:containerBounds];
    [rootContainerView addSubview:textEditingContainerView];
    
    NSString* resourceFile = [[NSBundle mainBundle] pathForResource:@"dream-speech" ofType:@"txt"];
    NSString* resourceString = [NSString stringWithContentsOfFile:resourceFile usedEncoding:nil error:nil];
    [inputTextView setString:resourceString];
    
    currentContainerView = textEditingContainerView;
}

- (NSData *)dataOfType:(NSString *)typeName error:(NSError **)outError
{
    /*
     Insert code here to write your document to data of the specified type. If outError != NULL, ensure that you create and set an appropriate error when returning nil.
    You can also choose to override -fileWrapperOfType:error:, -writeToURL:ofType:error:, or -writeToURL:ofType:forSaveOperation:originalContentsURL:error: instead.
    */
    if (outError) {
        *outError = [NSError errorWithDomain:NSOSStatusErrorDomain code:unimpErr userInfo:NULL];
    }
    return nil;
}

- (BOOL)readFromData:(NSData *)data ofType:(NSString *)typeName error:(NSError **)outError
{
    /*
    Insert code here to read your document from the given data of the specified type. If outError != NULL, ensure that you create and set an appropriate error when returning NO.
    You can also choose to override -readFromFileWrapper:ofType:error: or -readFromURL:ofType:error: instead.
    If you override either of these, you should also override -isEntireFileLoaded to return NO if the contents are lazily loaded.
    */
    if (outError) {
        *outError = [NSError errorWithDomain:NSOSStatusErrorDomain code:unimpErr userInfo:NULL];
    }
    return YES;
}

+ (BOOL)autosavesInPlace
{
    return NO;
}

#pragma mark -

-(void) animateInRenderedTextContainerView {
    NSRect containerBounds = [rootContainerView bounds];

    NSRect renderedTextViewFrame = containerBounds;
    renderedTextViewFrame.origin.x = renderedTextViewFrame.size.width;
    [renderedTextContainerView setFrame:renderedTextViewFrame];
    if (![renderedTextContainerView superview]) {
        [rootContainerView addSubview:renderedTextContainerView];
    }
    
    [NSAnimationContext beginGrouping];
    [[NSAnimationContext currentContext] setDuration:1];
    [[NSAnimationContext currentContext] setTimingFunction:[CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut]];

    NSRect textEditingViewFrame = textEditingContainerView.frame;
    textEditingViewFrame.origin.x -= textEditingViewFrame.size.width;
    [[textEditingContainerView  animator] setFrame:textEditingViewFrame];
    
    renderedTextViewFrame.origin.x = 0;
    [[renderedTextContainerView animator] setFrame:renderedTextViewFrame];

        
    [[NSAnimationContext currentContext] setCompletionHandler:^(void) {
        currentContainerView = renderedTextContainerView; 
    }];
    [NSAnimationContext endGrouping];

}


-(void) animateInTextEditingContainerView {
    NSRect containerBounds = [rootContainerView bounds];
    
    NSRect textEditingViewFrame = containerBounds;
    textEditingViewFrame.origin.x = -textEditingViewFrame.size.width;
    [textEditingContainerView setFrame:textEditingViewFrame];
    if (![textEditingContainerView superview]) {
        [rootContainerView addSubview:textEditingContainerView];
    }
    
    [NSAnimationContext beginGrouping];
    [[NSAnimationContext currentContext] setDuration:1];
    [[NSAnimationContext currentContext] setTimingFunction:[CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut]];
    
    NSRect renderedTextViewFrame = renderedTextContainerView.frame;
    renderedTextViewFrame.origin.x += renderedTextViewFrame.size.width;
    
    [[renderedTextContainerView animator] setFrame:renderedTextViewFrame];
    
    textEditingViewFrame.origin.x = 0;
    [[textEditingContainerView animator] setFrame:textEditingViewFrame];
    
    
    [[NSAnimationContext currentContext] setCompletionHandler:^(void) {
        currentContainerView = textEditingContainerView; 
    }];
    [NSAnimationContext endGrouping];
    
}


-(void) renderText {
    NSString* sourceString = [inputTextView string];
                              
    NSMutableString* outputString = [NSMutableString stringWithCapacity:[sourceString length] * 2];
    
    NSLinguisticTagger* tagger = [[[NSLinguisticTagger alloc] initWithTagSchemes:[NSArray arrayWithObjects:NSLinguisticTagSchemeNameTypeOrLexicalClass,nil]  options:NSLinguisticTaggerJoinNames] autorelease];
    
    
    [tagger setString:sourceString];
    
    const BOOL solarizedLight = NO;
    [tagger enumerateTagsInRange:NSMakeRange(0, [sourceString length]) scheme:NSLinguisticTagSchemeNameTypeOrLexicalClass options:NSLinguisticTaggerJoinNames usingBlock:^(NSString *tag, NSRange tokenRange, NSRange sentenceRange, BOOL *stop) {
        uint32 colorValue = 0;
        BOOL colorize = YES;
        NSString* tokenText = [sourceString substringWithRange:tokenRange];
/*
        if ([NSLinguisticTagNoun isEqualToString:tag]) { 
            colorValue = BSSolarizedRGBRed;
        } else if([NSLinguisticTagVerb isEqualToString:tag]) {
            colorValue = BSSolarizedRGBRed;
        } else if([NSLinguisticTagAdjective isEqualToString:tag]) {
            colorValue = BSSolarizedRGBOrange;
        } else if([NSLinguisticTagAdverb isEqualToString:tag]) {
            colorValue = BSSolarizedRGBMagenta;
        } else if([NSLinguisticTagPersonalName isEqualToString:tag]) {
            colorValue = BSSolarizedRGBBlue;
        } else if([NSLinguisticTagOrganizationName isEqualToString:tag]) {
            colorValue = BSSolarizedRGBCyan;
        } else {
            colorize = NO;
        } */
        
        if ([NSLinguisticTagNoun isEqualToString:tag]) { 
            colorValue = BSSolarizedRGBCyan;
        } else if([NSLinguisticTagPersonalName isEqualToString:tag]) {
            colorValue = BSSolarizedRGBRed;
        } else if([NSLinguisticTagOrganizationName isEqualToString:tag]) {
            colorValue = BSSolarizedRGBOrange;
        } else {
            colorize = NO;
        }
        
        NSString* tokenOutput = nil;
        if (colorize) {
            tokenOutput = [NSString stringWithFormat:@"<font color=\"#%06x\">%@</font>",colorValue,tokenText];
        } else {
            if ([@"\n" isEqualToString:tokenText]) {
                tokenOutput = @"<br />";
            } else {
                tokenOutput = tokenText;
            }
        }
        [outputString appendString:tokenOutput];
    }];
    
    
    NSString* htmlString = [NSString stringWithFormat:@"<html><body bgcolor=\"#%06x\" text=\"#%06x\" style=\"font-family: Monaco,monospace; font-size: 13pt; line-height: 200%%;\">%@</body></html>",BSSolarizedBaseColor(BSSolarizedBaseColorTypeBackground, solarizedLight),BSSolarizedBaseColor(BSSolarizedBaseColorTypePrimaryContent, solarizedLight),outputString];
    [[renderedTextContainerView mainFrame] loadHTMLString:htmlString baseURL:nil];
}

- (IBAction)toggleContainerViews:(id)sender {
    if (currentContainerView == textEditingContainerView) {
        [self renderText];
        [self animateInRenderedTextContainerView];
    } else if (currentContainerView == renderedTextContainerView) {
        [self animateInTextEditingContainerView];
    }
}

@end
