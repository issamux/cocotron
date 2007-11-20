#import <Foundation/NSObject.h>
#import <AppKit/CGFont.h>

@class KGPDFObject,KGPDFContext,KGMutablePath;

enum {
   CGNullGlyph=0x0
};

typedef struct CGFontMetrics {
   float  emsquare;
   float  scale;
   NSRect boundingRect;
   float  ascender;
   float  descender;
   float  leading;
   float  italicAngle;
   float  capHeight;
   float  xHeight;
   float  stemV;
   float  stemH;
   float  underlineThickness;
   float  underlinePosition;
   BOOL   isFixedPitch;
} CGFontMetrics;

typedef struct CGGlyphRange {
   CGGlyph glyphs[256];
} CGGlyphRange;

typedef struct CGGlyphRangeTable {
   unsigned                 numberOfGlyphs;
   struct CGGlyphRange     *ranges[256];
   unichar                 *characters;
} CGGlyphRangeTable;

typedef struct {
   CGGlyph previous;
   float   xoffset;
} CGKerningOffset;

typedef struct CGGlyphMetrics {
   BOOL             hasAdvancement;
   float            advanceA;
   float            advanceB;
   float            advanceC;
   unsigned         numberOfKerningOffsets;
   CGKerningOffset *kerningOffsets;
} CGGlyphMetrics;

typedef struct CGGlyphMetricsSet {
   unsigned        numberOfGlyphs;
   CGGlyphMetrics *info;
} CGGlyphMetricsSet;

@interface KGFont : NSObject {
   NSString                 *_name;
   float                     _size;
   CGFontMetrics             _metrics;
   BOOL                      _glyphRangeTableLoaded;
   struct CGGlyphRangeTable *_glyphRangeTable;
   struct CGGlyphMetricsSet *_glyphInfoSet;
}

-initWithName:(NSString *)name size:(float)size;

-(NSString *)name;
-(float)pointSize;
-(float)nominalSize;

-(NSRect)boundingRect;
-(float)ascender;
-(float)descender;
-(float)leading;
-(float)underlineThickness;
-(float)underlinePosition;
-(BOOL)isFixedPitch;
-(float)italicAngle;
-(float)leading;
-(float)xHeight;
-(float)capHeight;

-(unsigned)numberOfGlyphs;
-(BOOL)glyphIsEncoded:(CGGlyph)glyph;
-(NSSize)advancementForGlyph:(CGGlyph)glyph;
-(NSSize)maximumAdvancement;

-(NSPoint)positionOfGlyph:(CGGlyph)current precededByGlyph:(CGGlyph)previous isNominal:(BOOL *)isNominalp;

-(void)getGlyphs:(CGGlyph *)glyphs forCharacters:(const unichar *)characters length:(unsigned)length;
-(void)getCharacters:(unichar *)characters forGlyphs:(const CGGlyph *)glyphs length:(unsigned)length;
-(void)getBytes:(unsigned char *)bytes forGlyphs:(const CGGlyph *)glyphs length:(unsigned)length;
-(void)getGlyphs:(CGGlyph *)glyphs forBytes:(const unsigned char *)bytes length:(unsigned)length;

-(void)getAdvancements:(NSSize *)advancements forGlyphs:(const CGGlyph *)glyphs count:(unsigned)count;

-(NSSize)advancementForNominalGlyphs:(const CGGlyph *)glyphs count:(unsigned)count;

-(KGPDFObject *)encodeReferenceWithContext:(KGPDFContext *)context;

// implement in subclass
-(void)fetchMetrics;
-(void)loadGlyphRangeTable;
-(void)fetchGlyphKerning;
-(void)fetchAdvancementsForGlyph:(CGGlyph)glyph;
-(void)appendCubicOutlinesToPath:(KGMutablePath *)path glyphs:(CGGlyph *)glyphs length:(unsigned)length;
@end