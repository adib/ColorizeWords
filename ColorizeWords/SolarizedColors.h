//
//  SolarizedColors.h
//  ColorizeWords
//
//  Created by Sasmito Adibowo on 20-08-11.
//  Copyright 2011 Basil Salad Software. All rights reserved.
//  http://cutecoder.org

#import <AppKit/AppKit.h>

@interface NSColor (SolarizedColors)

@end

/*
 Solarized color values
 http://ethanschoonover.com/solarized
*/


extern const uint32 BSSolarizedRGBBase03   ;

extern const uint32 BSSolarizedRGBBase02   ;

extern const uint32 BSSolarizedRGBBase01   ;

extern const uint32 BSSolarizedRGBBase00   ;

extern const uint32 BSSolarizedRGBBase0    ;

extern const uint32 BSSolarizedRGBBase1    ;

extern const uint32 BSSolarizedRGBBase2    ;

extern const uint32 BSSolarizedRGBBase3    ;

extern const uint32 BSSolarizedRGBYellow   ;

extern const uint32 BSSolarizedRGBOrange   ;

extern const uint32 BSSolarizedRGBRed      ;

extern const uint32 BSSolarizedRGBMagenta  ;

extern const uint32 BSSolarizedRGBViolet   ;

extern const uint32 BSSolarizedRGBBlue     ;

extern const uint32 BSSolarizedRGBCyan     ;

extern const uint32 BSSolarizedRGBGreen    ;


typedef enum {
    BSSolarizedBaseColorTypeNeutral,
    BSSolarizedBaseColorTypePrimaryContent,
    BSSolarizedBaseColorTypeSecondaryContent,
    BSSolarizedBaseColorTypeEmphasizedContent,
    BSSolarizedBaseColorTypeBackground,
    BSSolarizedBaseColorTypeBackgroundHighlight
} BSSolarizedBaseColorType;

inline static uint32 BSSolarizedBaseColor(BSSolarizedBaseColorType type,BOOL light)
{
    switch (type) {
        case BSSolarizedBaseColorTypePrimaryContent: // body text, default, 
            return light ? BSSolarizedRGBBase00 : BSSolarizedRGBBase0;
        case BSSolarizedBaseColorTypeSecondaryContent:
            return light ? BSSolarizedRGBBase1 : BSSolarizedRGBBase01;
        case BSSolarizedBaseColorTypeEmphasizedContent:
            return light ? BSSolarizedRGBBase01 : BSSolarizedRGBBase1;
        case BSSolarizedBaseColorTypeBackground:
            return light ? BSSolarizedRGBBase3 : BSSolarizedRGBBase03;
        case BSSolarizedBaseColorTypeBackgroundHighlight:
            return light ? BSSolarizedRGBBase2 : BSSolarizedRGBBase02;            
        default: // return neutral color by default
            return light ? BSSolarizedRGBBase0 : BSSolarizedRGBBase00;
    }
}
