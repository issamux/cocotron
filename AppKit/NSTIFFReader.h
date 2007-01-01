/* Copyright (c) 2006-2007 Christopher J. W. Lloyd

Permission is hereby granted, free of charge, to any person obtaining a copy of this software and associated documentation files (the "Software"), to deal in the Software without restriction, including without limitation the rights to use, copy, modify, merge, publish, distribute, sublicense, and/or sell copies of the Software, and to permit persons to whom the Software is furnished to do so, subject to the following conditions:

The above copyright notice and this permission notice shall be included in all copies or substantial portions of the Software.

THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE. */

#import <Foundation/Foundation.h>


enum {
 NSTIFFTypeBYTE=1,
 NSTIFFTypeASCII=2,
 NSTIFFTypeSHORT=3,
 NSTIFFTypeLONG=4,
 NSTIFFTypeRATIONAL=5,
};

enum {
 NSTIFFTagArtist=315,
 NSTIFFTagBitsPerSample=258,
 NSTIFFTagCellLength=265,
 NSTIFFTagCellWidth=264,
 NSTIFFTagColorMap=320,
 NSTIFFTagCompression=259,
 NSTIFFTagCopyright=33432,
 NSTIFFTagDateTime=306,
 NSTIFFTagDocumentName=269,
 NSTIFFTagExtraSamples=338,
 NSTIFFTagFillOrder=266,
 NSTIFFTagFreeByteCounts=289,
 NSTIFFTagFreeOffsets=288,
 NSTIFFTagGrayResponseCurve=291,
 NSTIFFTagGrayResponseUnit=290,
 NSTIFFTagHostComputer=316,
 NSTIFFTagImageDescription=270,
 NSTIFFTagImageLength=257,
 NSTIFFTagImageWidth=256,
 NSTIFFTagMake=271,
 NSTIFFTagMaxSampleValue=281,
 NSTIFFTagMinSampleValue=280,
 NSTIFFTagModel=272,
 NSTIFFTagNewSubfileType=254,
 NSTIFFTagOrientation=274,
 NSTIFFTagPageName=285,
 NSTIFFTagPageNumber=297,
 NSTIFFTagPhotometricInterpretation=262,
 NSTIFFTagPlanarConfiguration=284,
 NSTIFFTagResolutionUnit=296,
 NSTIFFTagRowsPerStrip=278,
 NSTIFFTagSamplesPerPixel=277,
 NSTIFFTagSoftware=305,
 NSTIFFTagStripByteCounts=279,
 NSTIFFTagStripOffsets=273,
 NSTIFFTagSubfileType=255,
 NSTIFFTagThreshholding=263,
 NSTIFFTagXPosition=286,
 NSTIFFTagXResolution=282,
 NSTIFFTagYPosition=287,
 NSTIFFTagYResolution=283,

 NSTIFFTagPhotoshopPrivate1=34377,
 NSTIFFTagPhotoshopPrivate2=37724,
};

enum {
 NSTIFFExtraSamples_unspecified=0,
 NSTIFFExtraSamples_associatedAlpha=1,
 NSTIFFExtraSamples_unassociatedAlpha=2,

 NSTIFFCompression_none=1,
 NSTIFFCompression_CCITTGroup3=2,
 NSTIFFCompression_packBits=32773,

 NSTIFFResolutionUnit_none=1,
 NSTIFFResolutionUnit_inch=2,
 NSTIFFResolutionUnit_centimeter=3,


};

@interface NSTIFFReader : NSObject {
  NSData              *_data;
  const unsigned char *_bytes;
  unsigned             _length,_position;
  BOOL                 _bigEndian;

  NSMutableArray      *_directory;
}

-initWithContentsOfFile:(NSString *)path;

-(BOOL)tracingEnabled;

-(unsigned)currentOffset;
-(void)seekToOffset:(unsigned)offset;

-(unsigned)nextUnsigned16;
-(unsigned)nextUnsigned32;
-(unsigned)expectUnsigned16;
-(unsigned)expectUnsigned32;
-(double)expectRational;
-(NSString *)expectASCII;
-(unsigned)expectUnsigned16OrUnsigned32;
-(void)expectArrayOfUnsigned16:(unsigned **)valuesp count:(unsigned *)countp;
-(void)expectArrayOfUnsigned16OrUnsigned32:(unsigned **)valuesp count:(unsigned *)countp;


-(int)pixelsWide;
-(int)pixelsHigh;

-(BOOL)getRGBAImageBytes:(unsigned char *)bytes width:(int)width height:(int)height;

@end
