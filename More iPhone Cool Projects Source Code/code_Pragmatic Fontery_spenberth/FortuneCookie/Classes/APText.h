//
//  APText.h
//  FortuneCookie
//
//  Created by Scott Penberthy on 2/7/10.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import "APChar.h"

//
// An APText class represents an entire vise grip of letters, which we press to the display
// using APRenderController.  We keep a pool of APChar instances that we reuse as the string
// of characters changes over time.  The simple layout algorithms here are useful for titles,
// head up displays, labels, and so forth.  More elaborate algorithms are needed for complete
// text layout, scrolling, etc.
//
// See the Pragmatic Fonts chapter for a description of each instance variable.
//
// uv - uv coordinates, sent to OpenGL, packed tightly together
// xy - xy screen coordinates, sent to OpenGL
// r,g,b,alpha - color and transparency of current text string
// fontName - the font from which we draw
// vertexIndex, vertexCount, needsLayout, okToRender - internal state variables
// lineWidth, lineHeight - current line dimensions for retrieval and simple alignment (left, center, right)
//

#define kMaxChars 256

@interface APText : NSObject {
	NSMutableArray * chars;
	NSMutableArray * unusedChars;
	
	GLfloat * uv;
	GLfloat * vertices;
	GLfloat r, g, b;
	CGFloat alpha;
	
	NSInteger vertexIndex;
	NSInteger vertexCount;
	NSInteger alignment;
	NSInteger spacing;
	NSInteger charCount;
	NSString *string;
	
	CGFloat	lineWidth;
	CGFloat lineHeight;
	
	NSString *fontName;
	BOOL needsLayout;
	BOOL okToRender;
}

@property (assign) GLfloat r;
@property (assign) GLfloat g;
@property (assign) GLfloat b;
@property (assign) CGFloat alpha;
@property (assign) NSInteger alignment;
@property (assign) NSInteger spacing;
@property (assign) NSInteger charCount;
@property (assign) NSInteger vertexCount;
@property (assign) CGFloat lineWidth;
@property (assign) CGFloat lineHeight;
@property (retain) NSString *string;
@property (retain) NSString *fontName;
@property (assign) BOOL okToRender;

- (void) prepareMesh;
- (id) init;
- (void)setText;
- (void) updateText;
- (void) layoutText;
- (void) alignText;
- (void) useFont: (NSString*) fontName;
+ (NSString *) stringFromChar: (uint) c;
-(void)preload;

@end
