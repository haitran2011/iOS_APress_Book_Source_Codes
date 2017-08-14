//
//  APChar.h
//  FortuneCookie
//
//  Created by Scott Penberthy on 2/7/10.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//
//
// A single character for display within a Text object
//

#import "APGlyph.h"

//
// An APChar class represents the dynamic placement of a Glpyh on the virtual
// vise grip of Gutenberg.  We cache all the Glyph dimensions we need, as well
// as the appropriate placement on the screen (x,y), as well as the (u,v) square
// we need to extract from the font map.  We do this for speed.
//

@interface APChar : NSObject {
	CGFloat x;
	CGFloat y;
	CGFloat width;
	CGFloat height;
	CGFloat baseline;
	CGFloat r;
	CGFloat g;
	CGFloat b;
	CGFloat a;
	
	// The following are taken from the glyph map, 
	// then cached here.
	CGFloat minU;
	CGFloat maxU;
	CGFloat minV;
	CGFloat maxV;
}

@property (assign) CGFloat x;
@property (assign) CGFloat y;
@property (assign) CGFloat r;
@property (assign) CGFloat g;
@property (assign) CGFloat b;
@property (assign) CGFloat a;
@property (assign) CGFloat minU;
@property (assign) CGFloat maxU;
@property (assign) CGFloat minV;
@property (assign) CGFloat maxV;
@property (assign) CGFloat width;
@property (assign) CGFloat height;
@property (assign) CGFloat baseline;

@end
