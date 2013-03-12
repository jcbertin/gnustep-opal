/*
   NSFont.h

   The font class

   Copyright (C) 1996 Free Software Foundation, Inc.

   Author:  Scott Christley <scottc@net-community.com>
   Author:  Ovidiu Predescu <ovidiu@net-community.com>
   Date: 1996, 1997

   This file is part of the GNUstep GUI Library.

   This library is free software; you can redistribute it and/or
   modify it under the terms of the GNU Lesser General Public
   License as published by the Free Software Foundation; either
   version 2 of the License, or (at your option) any later version.

   This library is distributed in the hope that it will be useful,
   but WITHOUT ANY WARRANTY; without even the implied warranty of
   MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.	 See the GNU
   Lesser General Public License for more details.

   You should have received a copy of the GNU Lesser General Public
   License along with this library; see the file COPYING.LIB.
   If not, see <http://www.gnu.org/licenses/> or write to the
   Free Software Foundation, 51 Franklin Street, Fifth Floor,
   Boston, MA 02110-1301, USA.
*/

#ifndef _GNUstep_H_Opal_NSFont
#define _GNUstep_H_Opal_NSFont

#import <AppKit/NSFont.h>
#include <CoreText/CTFont.h>
#import <AppKit/NSFontDescriptor.h>
@interface NSFont(OpalText)

- (CGFloat) leading;
//
// CTFont private
//
+ (NSFont*) fontWithDescriptor: (NSFontDescriptor*)descriptor
                       options: (CTFontOptions)options;
+ (NSFont*) UIFontWithType: (CTFontUIFontType)type
                      size: (CGFloat)size
               forLanguage: (NSString*)languageCode;
+ (NSFont*) fontWithGraphicsFont: (CGFontRef)graphics
            additionalDescriptor: (NSFontDescriptor*)descriptor;
- (CGFloat) unitsPerEm;
- (NSString*) nameForKey: (NSString*)nameKey;
- (NSString*) localizedNameForKey: (NSString*)nameKey
                         language: (NSString**)languageOut;
- (bool) getGraphicsGlyphsForCharacters: (const unichar *)characters
                         graphicsGlyphs: (const CGGlyph *)glyphs
                                  count: (CFIndex)count;
- (double) getAdvancesForGraphicsGlyphs: (const CGGlyph *)glyphs
                               advances: (CGSize*)advances
                            orientation: (CTFontOrientation)orientation
                                  count: (CFIndex)count;
- (CGRect) getBoundingRectsForGraphicsGlyphs: (const CGGlyph *)glyphs
                                       rects: (CGRect*)rects
                                 orientation: (CTFontOrientation)orientation
                                       count: (CFIndex)count;
- (void) getVerticalTranslationForGraphicsGlyphs: (const CGGlyph*)glyphs
                                     translation: (CGSize*)translation
                                           count: (CFIndex)count;
- (CGPathRef) graphicsPathForGlyph: (CGGlyph)glyph
                         transform: (const CGAffineTransform *)xform;
- (NSArray*) variationAxes;
- (NSDictionary*) variation;
- (CGFontRef) graphicsFontWithDescriptor: (NSFontDescriptor**)descriptorOut;
- (NSArray*) availableTablesWithOptions: (CTFontTableOptions)options;
- (NSData*) tableForTag: (CTFontTableTag)tag
            withOptions: (CTFontTableOptions)options;
//
// CGFont private
//
- (NSString*) nameForGlyph: (CGGlyph)graphicsGlyph;
+ (CTFontRef) fontWithData: (NSData*)fontData
                      size: (CGFloat)size
       		          matrix: (const CGFloat*)fontMatrix
      additionalDescriptor: (NSFontDescriptor*)descriptor;

- (id)_initWithDescriptor: (NSFontDescriptor*)descriptor
                  options: (CTFontOptions)options;

@end

#endif
