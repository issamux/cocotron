/* Copyright (c) 2006-2007 Christopher J. W. Lloyd

Permission is hereby granted, free of charge, to any person obtaining a copy of this software and associated documentation files (the "Software"), to deal in the Software without restriction, including without limitation the rights to use, copy, modify, merge, publish, distribute, sublicense, and/or sell copies of the Software, and to permit persons to whom the Software is furnished to do so, subject to the following conditions:

The above copyright notice and this permission notice shall be included in all copies or substantial portions of the Software.

THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE. */

// Original - Christopher Lloyd <cjwl@objc.net>
#import <AppKit/NSCell.h>
#import <AppKit/NSFont.h>
#import <AppKit/NSImage.h>
#import <AppKit/NSWindow.h>
#import <AppKit/NSEvent.h>
#import <AppKit/NSParagraphStyle.h>
#import <AppKit/NSAttributedString.h>
#import <AppKit/NSColor.h>
#import <AppKit/NSCursor.h>
#import <AppKit/NSControl.h>
#import <AppKit/NSClipView.h>
#import <AppKit/NSNibKeyedUnarchiver.h>

#import <Foundation/NSNumberFormatter.h>

@implementation NSCell

-(void)encodeWithCoder:(NSCoder *)coder {
   [coder encodeInt:_state forKey:@"NSCell state"];
   [coder encodeInt:_cellType forKey:@"NSCell type"];
   [coder encodeInt:_textAlignment forKey:@"NSCell alignment"];
   [coder encodeBool:_wraps forKey:@"NSCell wraps"];
   [coder encodeBool:_isEnabled forKey:@"NSCell enabled"];
   [coder encodeBool:_isEditable forKey:@"NSCell editable"];
   [coder encodeBool:_isSelectable forKey:@"NSCell selectable"];
   [coder encodeBool:_isScrollable forKey:@"NSCell scrollable"];
   [coder encodeBool:_isBordered forKey:@"NSCell bordered"];
   [coder encodeBool:_isBezeled forKey:@"NSCell bezeled"];
   [coder encodeBool:_isHighlighted forKey:@"NSCell highlighted"];
   [coder encodeBool:_isContinuous forKey:@"NSCell continuous"];
   [coder encodeObject:_font forKey:@"NSCell font"];
   [coder encodeObject:_objectValue forKey:@"NSCell objectValue"];
   [coder encodeObject:_image forKey:@"NSCell image"];
}

-initWithCoder:(NSCoder *)coder {
   if([coder isKindOfClass:[NSNibKeyedUnarchiver class]]){
    NSNibKeyedUnarchiver *keyed=(NSNibKeyedUnarchiver *)coder;
    int                flags=[keyed decodeIntForKey:@"NSCellFlags"];
    int                flags2=[keyed decodeIntForKey:@"NSCellFlags2"];
    id                 check;
    
    _state=(flags&0x8000000)?YES:NO;
    _isHighlighted=(flags&0x40000000)?YES:NO;
    _isEnabled=(flags&0x20000000)?NO:YES;
    _isEditable=(flags&0x10000000)?YES:NO;
    _cellType=(flags&0x0C000000)>>26;
    _isBordered=(flags&0x00800000)?YES:NO;
    _isBezeled=(flags&0x00400000)?YES:NO;
    _isSelectable=(flags&0x00200000)?YES:NO;
    _isScrollable=(flags&0x00100000)?YES:NO;
    _wraps=(flags&0x00100000)?NO:YES; // ! scrollable, use lineBreakMode ?
    _allowsMixedState=(flags2&0x1000000)?YES:NO;
    // 0x00080000 = continuous
    // 0x00040000 = action on mouse down
    // 0x00000100 = action on mouse drag
    _isContinuous=(flags&0x00080100)?YES:NO;
    _textAlignment=(flags2&0x1c000000)>>26;
    _objectValue=[[keyed decodeObjectForKey:@"NSContents"] retain];
    check=[keyed decodeObjectForKey:@"NSNormalImage"];
    if([check isKindOfClass:[NSImage class]])
     _image=[check retain];
    else if([check isKindOfClass:[NSFont class]])
     _font=[check retain];
     
    check=[keyed decodeObjectForKey:@"NSSupport"];
    if([check isKindOfClass:[NSFont class]])
     _font=[check retain];

    _controlSize=(flags2&0xE0000)>>17;
    if (_font==nil)
       _font=[[NSFont userFontOfSize:13 - _controlSize*2] retain];
   }
   else {
    _state=[coder decodeIntForKey:@"NSCell state"];
    _cellType=[coder decodeIntForKey:@"NSCell type"];
    _textAlignment=[coder decodeIntForKey:@"NSCell alignment"];
    _wraps=[coder decodeBoolForKey:@"NSCell wraps"];
    _isEnabled=[coder decodeBoolForKey:@"NSCell enabled"];
    _isEditable=[coder decodeBoolForKey:@"NSCell editable"];
    _isSelectable=[coder decodeBoolForKey:@"NSCell selectable"];
    _isScrollable=[coder decodeBoolForKey:@"NSCell scrollable"];
    _isBordered=[coder decodeBoolForKey:@"NSCell bordered"];
    _isBezeled=[coder decodeBoolForKey:@"NSCell bezeled"];
    _isHighlighted=[coder decodeBoolForKey:@"NSCell highlighted"];
    _isContinuous=[coder decodeBoolForKey:@"NSCell continuous"];
    _font=[[coder decodeObjectForKey:@"NSCell font"] retain];
    _objectValue=[[coder decodeObjectForKey:@"NSCell objectValue"] retain];
    _image=[[coder decodeObjectForKey:@"NSCell image"] retain];
   }
   return self;
}

-initTextCell:(NSString *)string {

   _state=NSOffState;
   _font=[[NSFont userFontOfSize:0] retain];
   _objectValue=[string copy];
   _image=nil;
   _cellType=NSTextCellType;
   _isEnabled=YES;
   _isEditable=NO;
   _isSelectable=NO;
   _wraps=NO;
   _isBordered=NO;
   _isBezeled=NO;
   _isHighlighted=NO;
   _refusesFirstResponder=NO;

   return self;
}

-initImageCell:(NSImage *)image {

   _state=NSOffState;
   _font=nil;
   _objectValue=nil;
   _image=[image retain];
   _cellType=NSImageCellType;
   _isEnabled=YES;
   _isEditable=NO;
   _isSelectable=NO;
   _wraps=NO;
   _isBordered=NO;
   _isBezeled=NO;
   _isHighlighted=NO;
   _refusesFirstResponder=NO;

   return self;
}

-init {
   return [self initTextCell:@"Cell"];
}

-(void)dealloc {
   [_font release];
   [_objectValue release];
   [_image release];
   [_formatter release];
   [_title release];
   [_representedObject release];
   [super dealloc];
}

-copyWithZone:(NSZone *)zone {
   NSCell *copy=NSCopyObject(self,0,zone);

   copy->_font=[_font retain];
   copy->_objectValue=[_objectValue copy];
   copy->_image=[_image retain];
   copy->_formatter=[_formatter retain];
   copy->_title=[_title retain];
   copy->_representedObject=[_representedObject retain];

   return copy;
}

-(NSView *)controlView {
   return nil;
}

-(NSCellType)type {
   return _cellType;
}

-(int)state {
   if (_allowsMixedState) {
      if (_state < 0)
         return -1;
      else if (_state > 0)
         return 1;
      else
         return 0;
   }
   else
      return (abs(_state) > 0) ? 1 : 0;
}

-target {
   return nil;
}

-(SEL)action {
   return NULL;
}

-(int)tag {
   return -1;
}

-(int)entryType {
   return _entryType;
}

-(id)formatter {
    return _formatter;
}

-(NSFont *)font {
   return _font;
}

-(NSImage *)image {
   return _image;
}

-(NSTextAlignment)alignment {
   return _textAlignment;
}

-(BOOL)wraps {
   return _wraps;
}

-(NSString *)title {
    return _title;
}

-(BOOL)isEnabled {
   return _isEnabled;
}

-(BOOL)isEditable {
   return _isEditable;
}

-(BOOL)isSelectable {
   return _isSelectable;
}

-(BOOL)isScrollable {
   return _isScrollable;
}

-(BOOL)isBordered {
   return _isBordered;
}

-(BOOL)isBezeled {
   return _isBezeled;
}

-(BOOL)isContinuous {
   return _isContinuous;
}

-(BOOL)refusesFirstResponder {
   return _refusesFirstResponder;
}

-(BOOL)isHighlighted {
   return _isHighlighted;
}

-objectValue {
   return _objectValue;
}

-(NSString *)stringValue {
    NSString *formatted;
    
    if (_formatter != nil)
        if (formatted = [_formatter stringForObjectValue:_objectValue])
          return formatted;

    if([_objectValue isKindOfClass:[NSAttributedString class]])
     return [_objectValue string];

    return [_objectValue description];
}

-(int)intValue {
   return [_objectValue intValue];
}

-(float)floatValue {
   return [_objectValue floatValue];
}

-(double)doubleValue {
    return [_objectValue doubleValue];
}

-(NSAttributedString *)attributedStringValue {
   if([_objectValue isKindOfClass:[NSAttributedString class]])
    return _objectValue;
   else {
    NSMutableDictionary *attributes=[NSMutableDictionary dictionary];
    NSMutableParagraphStyle *paraStyle=[[[NSParagraphStyle defaultParagraphStyle] mutableCopy] autorelease];
    NSFont              *font=[self font];

    if(font!=nil)
     [attributes setObject:font forKey:NSFontAttributeName];

    if([self isEnabled]){
     if([self isHighlighted] || [self state])
      [attributes setObject:[NSColor whiteColor]
                     forKey:NSForegroundColorAttributeName];
     else
      [attributes setObject:[NSColor controlTextColor]
                     forKey:NSForegroundColorAttributeName];
    }
    else {
     [attributes setObject:[NSColor disabledControlTextColor]
                     forKey:NSForegroundColorAttributeName];
    }

    if(![self wraps])
     [paraStyle setLineBreakMode:NSLineBreakByClipping];
    [paraStyle setAlignment:_textAlignment];
    [attributes setObject:paraStyle forKey:NSParagraphStyleAttributeName];

    return [[[NSAttributedString alloc] initWithString:[self stringValue] attributes:attributes] autorelease];
   }
}

-(id)representedObject {
    return _representedObject;
}

- (NSControlSize)controlSize {
    return _controlSize;
}

-(void)setType:(NSCellType)type {
   if(_cellType!=type){
    _cellType = type;
    if (type == NSTextCellType) {
// FIX, localization
       [self setTitle:@"Cell"];				// mostly clarified in setEntryType dox
       [self setFont:[NSFont systemFontOfSize:12.0]];
    }
    [[[self controlView] window] invalidateCursorRectsForView:[self controlView]];
   }
}

-(void)setState:(int)value {
   if (_allowsMixedState) {
      if (value < 0)
         _state = -1;
      else if (value > 0)
         _state = 1;
      else
         _state = 0;
   }
   else
      _state = (abs(value) > 0) ? 1 : 0;
}

-(int)nextState {
   if (_allowsMixedState) {
      int value = [self state];
      return value - ((value == -1) ? -2 : 1);
   }
   else
      return 1 - [self state];
}

-(void)setNextState {
   _state = [self nextState];
}

-(BOOL)allowsMixedState; {
   return _allowsMixedState;
}

-(void)setAllowsMixedState:(BOOL)allow {
   _allowsMixedState = allow;
}

-(void)setTarget:target {
   [NSException raise:NSInternalInconsistencyException
               format:@"-[%@ %s] Unimplemented",isa,SELNAME(_cmd)];
}


-(void)setAction:(SEL)action {
   [NSException raise:NSInternalInconsistencyException
               format:@"-[%@ %s] Unimplemented",isa,SELNAME(_cmd)];
}

-(void)setTag:(int)tag {
   [NSException raise:NSInternalInconsistencyException
               format:@"-[%@ %s] Unimplemented",isa,SELNAME(_cmd)];
}

-(void)setEntryType:(int)type {
   _entryType=type;
   [self setType:NSTextCellType];
}

-(void)setFormatter:(NSFormatter *)formatter {
    formatter=[formatter retain];
    [_formatter release];
    _formatter=formatter;
}

-(void)setFont:(NSFont *)font {
   font=[font retain];
   [_font release];
   _font=font;
}

-(void)setImage:(NSImage *)image {
   [self setType:NSImageCellType];
   image=[image retain];
   [_image release];
   _image=image;
   [(NSControl *)[self controlView] updateCell:self];
}

-(void)setAlignment:(NSTextAlignment)alignment {
   _textAlignment=alignment;
}

-(void)setWraps:(BOOL)wraps {
   _wraps=wraps;
}

-(void)setTitle:(NSString *)title {
    title = [title retain];
    [_title release];
    _title = title;
}

-(void)setEnabled:(BOOL)flag {
   if(_isEnabled!=flag){
    _isEnabled=flag;
    [(NSControl *)[self controlView] updateCell:self];
    [[[self controlView] window] invalidateCursorRectsForView:[self controlView]];
   }
}

-(void)setEditable:(BOOL)flag {
   if(_isEditable!=flag){
    _isEditable=flag;
    [[[self controlView] window] invalidateCursorRectsForView:[self controlView]];
   }
}

-(void)setSelectable:(BOOL)flag {
   if(_isSelectable!=flag){
    _isSelectable=flag;
    [[[self controlView] window] invalidateCursorRectsForView:[self controlView]];
   }
}

-(void)setScrollable:(BOOL)flag {
   _isScrollable=flag;
}

-(void)setBordered:(BOOL)flag {
   _isBordered=flag;
}

-(void)setBezeled:(BOOL)flag {
   _isBezeled=flag;
}

-(void)setContinuous:(BOOL)flag {
   _isContinuous=flag;
}

-(void)setRefusesFirstResponder:(BOOL)flag {
   _refusesFirstResponder=flag;
}

-(void)setHighlighted:(BOOL)flag {
   _isHighlighted = flag;
}

// the problem with this method is that the dox specify that if autorange is YES, then the field
// becomes one big floating-point entry, but NSNumberFormatter doesn't work that way. - dwy
-(void)setFloatingPointFormat:(BOOL)fpp left:(unsigned)left right:(unsigned)right {
    NSMutableString *format = [NSMutableString string];
    
    [self setFormatter:[[[NSNumberFormatter alloc] init] autorelease]];
    if (fpp == YES) { // autorange
        unsigned fieldWidth = left + right;
        while(fieldWidth--)
            [format appendString:@"#"];
    }
    else {
        while(left--)
            [format appendString:@"#"];
        [format appendString:@"."];
        while(right--)
            [format appendString:@"0"];
    }
    [(NSNumberFormatter *)_formatter setFormat:format];
}

-(void)setObjectValue:(id <NSCopying>)value {
   value=[value copyWithZone:NULL];
   [_objectValue release];
   _objectValue=value;
   [(NSControl *)[self controlView] updateCell:self];
}

-(void)setStringValue:(NSString *)value {
   if(value==nil){
    [NSException raise:NSInvalidArgumentException format:@"-[%@ %s] value==nil",isa,SELNAME(_cmd)];
    return;
   }

   [self setType:NSTextCellType];

   if (_formatter != nil) {
       id formattedValue;

       if ([_formatter getObjectValue:&formattedValue forString:value errorDescription:NULL])
           value=formattedValue;
   }

   [self setObjectValue:value];
}

-(void)setIntValue:(int)value {
   [self setObjectValue:[NSNumber numberWithInt:value]];
}

-(void)setFloatValue:(float)value {
   [self setObjectValue:[NSNumber numberWithFloat:value]];
}

-(void)setDoubleValue:(double)value {
   [self setObjectValue:[NSNumber numberWithDouble:value]];
}


-(void)setAttributedStringValue:(NSAttributedString *)value {
   value=[value copy];
   [_objectValue release];
   _objectValue=value;
}

-(void)setRepresentedObject:(id)object {
    object = [object retain];
    [_representedObject release];
    _representedObject = object;
}

- (void)setControlSize:(NSControlSize)size {
   _controlSize = size;
   [_font release];
   _font = [[NSFont userFontOfSize:13 - _controlSize*2] retain];
   [(NSControl *)[self controlView] updateCell:self];
}

-(void)takeObjectValueFrom:sender {
   [self setObjectValue:[sender objectValue]];
}

-(void)takeStringValueFrom:sender {
   [self setStringValue:[sender stringValue]];
}

-(void)takeIntValueFrom:sender {
   [self setIntValue:[sender intValue]];
}

-(void)takeFloatValueFrom:sender {
   [self setFloatValue:[sender floatValue]];
}

-(NSSize)cellSize {
   NSUnimplementedMethod();
   return NSMakeSize(0,0);
}

-(NSRect)imageRectForBounds:(NSRect)rect {
   return rect;
}

-(NSRect)titleRectForBounds:(NSRect)rect {
   return rect;
}

-(NSRect)drawingRectForBounds:(NSRect)rect {
   return rect;
}

-(void)drawInteriorWithFrame:(NSRect)frame inView:(NSView *)view {
}

-(void)drawWithFrame:(NSRect)frame inView:(NSView *)view {

   if([self type]==NSTextCellType){
    if([self isBezeled])
     NSDrawWhiteBezel(frame,frame);
   }

   [self drawInteriorWithFrame:[self drawingRectForBounds:frame] inView:view];
}

-(void)highlight:(BOOL)highlight withFrame:(NSRect)frame inView:(NSView *)view {
   if(_isHighlighted!=highlight){
    _isHighlighted=highlight;
    [self drawWithFrame:frame inView:view];
   }
}

-(BOOL)startTrackingAt:(NSPoint)startPoint inView:(NSView *)view {
   return YES;
}

-(BOOL)continueTracking:(NSPoint)lastPoint at:(NSPoint)currentPoint inView:(NSView *)view {
   return YES;
}

-(void)stopTracking:(NSPoint)lastPoint at:(NSPoint)stopPoint inView:(NSView *)view mouseIsUp:(BOOL)flag {
}

-(BOOL)trackMouse:(NSEvent *)event inRect:(NSRect)frame ofView:(NSView *)view untilMouseUp:(BOOL)untilMouseUp {
   NSPoint lastPoint;
   BOOL    result=NO;

   if(![self startTrackingAt:[event locationInWindow] inView:view])
    return NO;

   [self drawWithFrame:frame inView:view];

   do{
    NSPoint currentPoint;
    BOOL isWithinCellFrame;

    lastPoint=[event locationInWindow];
    currentPoint=[view convertPoint:[event locationInWindow] fromView:nil];
    isWithinCellFrame=NSMouseInRect(currentPoint,frame,[view isFlipped]);

    //NSLog(@"%@ in %@", NSStringFromPoint(currentPoint), NSStringFromRect(frame));
    if(untilMouseUp){
     if([event type]==NSLeftMouseUp){
      [self stopTracking:lastPoint at:[event locationInWindow] inView:view mouseIsUp:YES];
      result=YES;
      break;
     }
    }
    else if(isWithinCellFrame){
     if([event type]==NSLeftMouseUp){
      [self stopTracking:lastPoint at:[event locationInWindow] inView:view mouseIsUp:YES];
      result=YES;
      break;
     }
    }
    else {
     [self stopTracking:lastPoint at:[event locationInWindow] inView:view mouseIsUp:NO];
     result=NO;
     break;
    }

    if(isWithinCellFrame) {
     if(![self continueTracking:lastPoint at:[event locationInWindow] inView:view])
      break;

     if([self isContinuous])
      [(NSControl *)view sendAction:[(NSControl *)view action] to:[(NSControl *)view target]];
    }

    [[view window] flushWindow];

    event=[[view window] nextEventMatchingMask:NSLeftMouseUpMask|
                          NSLeftMouseDraggedMask];

   }while(YES);

   [self drawWithFrame:frame inView:view];

   return result;
}

-(NSText *)setUpFieldEditorAttributes:(NSText *)editor {
   [editor setEditable:[self isEditable]];
   [editor setSelectable:[self isSelectable]];
   [editor setString:[self stringValue]];
   [editor setFont:[self font]];
   [editor setAlignment:[self alignment]];
   if([self respondsToSelector:@selector(drawsBackground)])
    [editor setDrawsBackground:(BOOL)(int)[self performSelector:@selector(drawsBackground)]];
   if([self respondsToSelector:@selector(backgroundColor)])
    [editor setBackgroundColor:[self performSelector:@selector(backgroundColor)]];

   return editor;
}

-(void)_setupFieldEditorWithFrame:(NSRect)frame controlView:(NSView *)view editor:(NSText *)editor delegate:delegate {
/* There is some funkiness here where the editor is already in the control and it is moving to
   a different cell or the same cell is being edited after a makeFirstResponder
   This needs to be straightened out
 */
   if([self isScrollable]){
    NSClipView *clipView;

    if([[editor superview] isKindOfClass:[NSClipView class]]){
     clipView=[editor superview];
     [clipView setFrame:[self titleRectForBounds:frame]];
    }
    else {
     clipView=[[[NSClipView alloc] initWithFrame:[self titleRectForBounds:frame]] autorelease];
     [clipView setDocumentView:editor];
     [view addSubview:clipView];
    }

    [clipView setAutoresizingMask:NSViewWidthSizable|NSViewHeightSizable];
    [editor setAutoresizingMask:0];
    [editor setHorizontallyResizable:YES];
    [editor setVerticallyResizable:YES];
    [editor sizeToFit];
    [editor setNeedsDisplay:YES];
   }
   else {
    [editor setFrame:[self titleRectForBounds:frame]];
    [view addSubview:editor];
   }
   [[view window] makeFirstResponder:editor];
   [editor setDelegate:delegate];
}

-(void)editWithFrame:(NSRect)frame inView:(NSView *)view editor:(NSText *)editor delegate:(id)delegate event:(NSEvent *)event {
   if(![self isEditable] && ![self isSelectable])
    return;

   if(view == nil || editor == nil || [self font] == nil || _cellType != NSTextCellType)
    return;

   [self _setupFieldEditorWithFrame:frame controlView:view editor:editor delegate:delegate];
   [editor mouseDown:event];
}

-(void)selectWithFrame:(NSRect)frame inView:(NSView *)view editor:(NSText *)editor delegate:(id)delegate start:(int)location length:(int)length {
   if(![self isEditable] && ![self isSelectable])
    return;

   if(view == nil || editor == nil || [self font] == nil || _cellType != NSTextCellType)
    return;

   [self _setupFieldEditorWithFrame:frame controlView:view editor:editor delegate:delegate];
   [editor setSelectedRange:NSMakeRange(location,length)];
}

-(void)endEditing:(NSText *)editor {
   [self setStringValue:[editor string]];
}

-(void)resetCursorRect:(NSRect)rect inView:(NSView *)view {
   if(([self type]==NSTextCellType) && [self isEnabled]){
    if([self isEditable] || [self isSelectable]){
     NSRect titleRect=[self titleRectForBounds:rect];

     titleRect=NSIntersectionRect(titleRect,[view visibleRect]);

     if(!NSIsEmptyRect(titleRect))
      [view addCursorRect:titleRect cursor:[NSCursor IBeamCursor]];
    }
   }
}

@end