/* Copyright (c) 2006-2007 Christopher J. W. Lloyd

Permission is hereby granted, free of charge, to any person obtaining a copy of this software and associated documentation files (the "Software"), to deal in the Software without restriction, including without limitation the rights to use, copy, modify, merge, publish, distribute, sublicense, and/or sell copies of the Software, and to permit persons to whom the Software is furnished to do so, subject to the following conditions:

The above copyright notice and this permission notice shall be included in all copies or substantial portions of the Software.

THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE. */
#import <AppKit/NSUserDefaultsController.h>
#import <Foundation/NSUserDefaults.h>
#import <Foundation/NSDictionary.h>

@implementation NSUserDefaultsController

+sharedUserDefaultsController {
   static NSUserDefaultsController *shared=nil;
   
   if(shared==nil){
    shared=[[NSUserDefaultsController alloc] initWithDefaults:nil initialValues:nil];
   }
   
   return shared;
}

-initWithDefaults:(NSUserDefaults *)defaults initialValues:(NSDictionary *)values {
   if(defaults==nil)
    defaults=[NSUserDefaults standardUserDefaults];
   
   _defaults=[defaults retain];
   _initialValues=[values copy];
   _appliesImmediately=YES;
   
   return self;
}

-(void)dealloc {
   [_defaults release];
   [_initialValues release];
   [super dealloc];
}

-(NSUserDefaults *)defaults {
   return _defaults;
}

-(NSDictionary *)initialValues {
   return _initialValues;
}

-(BOOL)appliesImmediately {
   return _appliesImmediately;
}

-(void)setInitialValues:(NSDictionary *)values {
   values=[values copy];
   [_initialValues release];
   _initialValues=values;
}

-(void)setAppliesImmediately:(BOOL)flag {
   _appliesImmediately=flag;
}

@end