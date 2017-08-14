//
//  APGlyph.m
//  FortuneCookie
//
//  Created by Scott Penberthy on 2/7/10.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//


//
// The APGlyph class represents the smallest element of Gutenberg's press.  Each
// glyph is the image of single character from a font.  We need to record its (u,v)
// coordinates on the font texture atlas, the name of the character (glyphName),
// the name of the atlas from whence it was derived (mapKey), the pixel dimensions
// of the character on the atlas (width, height), and the size of the ascent and descent
// parameters for lining up Glyphs on our virtual vise.
//

#import "APGlyph.h"

@implementation APGlyph

@synthesize uv, ascent, descent, mapKey, glyphName, width, height;

- (id) init
{
	self = [super init];
	if (self != nil) {
		// 4 vertexes
		ascent = descent = 0;
		uv = (CGFloat *) malloc(8 * sizeof(CGFloat));
		bzero(uv, 8*sizeof(CGFloat));
	}
	return self;
}

- (void) dealloc
{
	free(uv);
	[super dealloc];
}

@end