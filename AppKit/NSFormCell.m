/* Copyright (c) 2006 Christopher J. W. Lloyd

Permission is hereby granted, free of charge, to any person obtaining a copy of this software and associated documentation files (the "Software"), to deal in the Software without restriction, including without limitation the rights to use, copy, modify, merge, publish, distribute, sublicense, and/or sell copies of the Software, and to permit persons to whom the Software is furnished to do so, subject to the following conditions:

The above copyright notice and this permission notice shall be included in all copies or substantial portions of the Software.

THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE. */

// Original - Christopher Lloyd <cjwl@objc.net>
#import <AppKit/NSFormCell.h>
#import <AppKit/NSAttributedString.h>
#import <AppKit/NSStringDrawing.h>
#import <AppKit/NSGraphics.h>
#import <AppKit/NSColor.h>
#import <AppKit/NSParagraphStyle.h>
#import <AppKit/NSStringDrawer.h>
#import <AppKit/NSNibKeyedUnarchiver.h>

@implementation NSFormCell

-(void)encodeWithCoder:(NSCoder *)coder {
   NSUnimplementedMethod();
}

-initWithCoder:(NSCoder *)coder {
   [super initWithCoder:coder];

   if([coder isKindOfClass:[NSNibKeyedUnarchiver class]]){
    NSNibKeyedUnarchiver *keyed=(NSNibKeyedUnarchiver *)coder;
    
    _titleWidth=[keyed decodeFloatForKey:@"NSTitleWidth"];
    _titleCell=[[keyed decodeObjectForKey:@"NSTitleCell"] retain];
   }
   else {
    [NSException raise:NSInvalidArgumentException format:@"-[%@ %s] is not implemented for coder %@",isa,SELNAME(_cmd),coder];
   }
   return self;
}

-copyWithZone:(NSZone *)zone {
    NSFormCell *copy = [super copyWithZone:zone];

    copy->_titleCell=[_titleCell copy];

    return copy;
}


-(void)dealloc {
   [_titleCell release];
   [super dealloc];
}

-(NSCellType)type {
   return NSTextCellType;
}

-(float)titleWidth {
   return _titleWidth;
}

-(NSString *)title {
   return [_titleCell stringValue];
}

-(NSAttributedString *)attributedTitle {
   return [_titleCell attributedStringValue];
}

-(NSFont *)titleFont {
   return [_titleCell font];
}

-(NSTextAlignment)titleAlignment {
   return [_titleCell alignment];
}

-(void)setTitleWidth:(float)width {
   _titleWidth=width;
}

-(void)setTitle:(NSString *)title {
   [_titleCell setStringValue:title];
}

-(void)setTitleFont:(NSFont *)font {
   [_titleCell setFont:font];
}

-(void)setTitleAlignment:(NSTextAlignment)alignment {
   [_titleCell setAlignment:alignment];
}

-(void)setEnabled:(BOOL)enabled {
   [super setEnabled:enabled];
   [_titleCell setEnabled:enabled];
}

-(NSAttributedString *)attributedStringValue {
   NSMutableDictionary *attributes=[NSMutableDictionary dictionary];
   NSMutableParagraphStyle *paraStyle=[[[NSParagraphStyle defaultParagraphStyle] mutableCopy] autorelease];
   NSFont              *font=[self font];

   if(font!=nil)
    [attributes setObject:font forKey:NSFontAttributeName];

   [attributes setObject:[self isEnabled]?[NSColor controlTextColor]:[NSColor disabledControlTextColor]
                  forKey:NSForegroundColorAttributeName];

   [attributes setObject:[NSColor whiteColor]
                  forKey:NSBackgroundColorAttributeName];

   if(![self wraps])
    [paraStyle setLineBreakMode:NSLineBreakByClipping];
   [paraStyle setAlignment:_textAlignment];
   [attributes setObject:paraStyle forKey:NSParagraphStyleAttributeName];

   return [[[NSAttributedString alloc] initWithString:[self stringValue] attributes:attributes] autorelease];
}

-(void)drawInteriorWithFrame:(NSRect)frame inView:(NSView *)control {
   NSAttributedString *title=[self attributedTitle];
   NSAttributedString *value=[self attributedStringValue];
   NSSize              titleSize=[title size];
   NSRect              titleRect;
   NSRect              valueRect;

   titleRect.origin.x=frame.origin.x;
   titleRect.origin.y=frame.origin.y+floor((frame.size.height-titleSize.height)/2);
   titleRect.size.width=_titleWidth;
   titleRect.size.height=titleSize.height;

   [title _clipAndDrawInRect:titleRect];

   valueRect=frame;
   valueRect.origin.x+=(_titleWidth+1);
   valueRect.size.width-=(_titleWidth+1);

   if([self isBezeled]){
    NSDrawWhiteBezel(valueRect,valueRect);
   }

   valueRect=[self titleRectForBounds:frame];

   [value _clipAndDrawInRect:valueRect];
}

-(void)drawWithFrame:(NSRect)frame inView:(NSView *)control {
   _controlView=control;

   [self drawInteriorWithFrame:frame inView:control];
}

-(NSRect)titleRectForBounds:(NSRect)rect {
   rect.origin.x+=(_titleWidth+1);
   rect.size.width-=(_titleWidth+1);

   if([self isBezeled])
    rect=NSInsetRect(rect,3,3);

   return rect;
}

@end
