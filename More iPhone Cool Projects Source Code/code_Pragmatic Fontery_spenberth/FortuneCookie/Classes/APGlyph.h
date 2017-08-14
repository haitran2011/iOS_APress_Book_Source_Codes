//
//  APGlyph.h
//  FortuneCookie
//
//  Created by Scott Penberthy on 2/7/10.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <OpenGLES/EAGL.h>
#import <OpenGLES/ES1/gl.h>
#import <OpenGLES/ES1/glext.h>
#import <QuartzCore/QuartzCore.h>

@interface APGlyph : NSObject {
	CGFloat *uv;
	CGFloat width;
	CGFloat height;
	CGFloat ascent;
	CGFloat descent;
	NSString *mapKey;
	NSString *glyphName;
}
	
@property (assign) CGFloat *uv;
@property (retain) NSString *mapKey;
@property (retain) NSString *glyphName;
@property (assign) CGFloat ascent;
@property (assign) CGFloat descent;
@property (assign) CGFloat width;
@property (assign) CGFloat height;
- (void) dealloc;

@end
