/* Copyright (c) 2006 Christopher J. W. Lloyd

Permission is hereby granted, free of charge, to any person obtaining a copy of this software and associated documentation files (the "Software"), to deal in the Software without restriction, including without limitation the rights to use, copy, modify, merge, publish, distribute, sublicense, and/or sell copies of the Software, and to permit persons to whom the Software is furnished to do so, subject to the following conditions:

The above copyright notice and this permission notice shall be included in all copies or substantial portions of the Software.

THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE. */


#import <Foundation/NSObject.h>
#import <Foundation/NSException.h>

#ifdef WIN32
#import <winsock.h>
typedef SOCKET NSSocketDescriptor;
#define NSInvalidSocket INVALID_SOCKET
#endif

#ifdef __MACH__
#import <libc.h>
typedef int NSSocketDescriptor;
#define NSInvalidSocket (-1)
#endif

#ifdef __svr4__ // Solaris
#import <unistd.h>
#import <sys/filio.h>
#import <sys/socket.h>
#import <sys/types.h>
#import <netinet/in.h>
#import <arpa/inet.h>
typedef int NSSocketDescriptor;
#define NSInvalidSocket (-1)
#endif

#ifdef hpux
#import <unistd.h>
#import <sys/socket.h>
typedef int NSSocketDescriptor;
#define NSInvalidSocket (-1)
#endif

#ifdef LINUX
#import <unistd.h>
#import <sys/socket.h>
#import <sys/select.h>
#import <sys/ioctl.h>
#define NSInvalidSocket (-1)
typedef int NSSocketDescriptor;
#endif 

BOOL _NSSocketAssert(int r,int line,const char *file);
NSException *_NSSocketException(int r,int line,const char *file);

#define NSSocketAssert(call)    _NSSocketAssert(call,__LINE__,__FILE__)
#define NSSocketException(call) _NSSocketException(call,__LINE__,__FILE__)

int NSSocketSetBlocking(NSSocketDescriptor socket,BOOL blocks);
BOOL NSSocketOperationWouldBlock();
