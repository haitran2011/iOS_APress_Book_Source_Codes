//
//  APText.m
//  FortuneCookie
//
//  Created by Scott Penberthy on 2/7/10.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//
//
// A basic texture mapped font.  We draw an entire text string with
// one call to OpenGL.
//

#import "APText.h"
#import "APFontMap.h"

@implementation APText

@synthesize alignment,fontName,spacing,lineHeight,lineWidth,charCount,string,vertexCount,okToRender,alpha,r,g,b;

+ (BOOL) string: (NSString *) s1 contains: (NSString *) s2
{
	NSRange r1 = [s1 rangeOfString: s2];
	NSUInteger i1 = r1.length;
	return i1  > 0;
}

+(NSMutableDictionary *)stringMap
{
	//
	// Map from character codes to NSString values, once.
	//
	static NSMutableDictionary *sharedStringMap;
	@synchronized(self)
	{
		if (!sharedStringMap) {
			NSString *glyphs = @" ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789.!?,!\"#$%&\'()*+-:;<=>[\\]^_{|}~";
			int len = [glyphs length];
			sharedStringMap = [[NSMutableDictionary alloc] initWithCapacity: len];			
			for (int index=0; index<len; index++) {
				int c =  [glyphs characterAtIndex: index];
				NSString *str = [NSString stringWithFormat:@"%c", [glyphs characterAtIndex:index]];
				[sharedStringMap setObject: [str retain]
									forKey: [NSNumber 
											 numberWithInt: c]];
			}
			return sharedStringMap;
		}
	}
	return sharedStringMap;
}

+(NSString *) stringFromChar: (uint) c 
{
	NSMutableDictionary *dict = [APText stringMap];
	return (NSString *) [dict objectForKey: [NSNumber numberWithInt: (int) c]];
}

- (id) init
{
	self = [super init];
	if (self != nil) {
		[self preload];
		needsLayout = YES;
		alignment = UITextAlignmentLeft;
		okToRender = NO;
		charCount = 0;
		alpha = 1.0;
		lineWidth = lineHeight = 0;
		r = g = b = 0;
	}
	return self;
}

-(void) setString: (NSString *) s {
	if ([string isEqualToString: s]) {
		if (!needsLayout) return;
	}
	needsLayout = YES;
	string = s;

	[self updateText];
	[self layoutText];
	[self prepareMesh];
}

-(void)preload
{
	if (chars == nil) chars = [[NSMutableArray alloc] initWithCapacity: kMaxChars];
	unusedChars = [[NSMutableArray alloc] initWithCapacity:kMaxChars];
	NSInteger count = 0;
	for (count = 0; count < kMaxChars; count++) {
		APChar *c = [[APChar alloc] init];
		[chars addObject:c];
		[c release];
	}
	
	// remember 6 vertexes per character
	vertices = (GLfloat *) malloc(2 * 6 * kMaxChars * sizeof(GLfloat));
	uv = (GLfloat *) malloc(2 * 6 * kMaxChars * sizeof(GLfloat));
}


//
// Our mesh does all the final rendering...  we'll be specifying
// materials named by individual characters within a larger font
// atlas.  
//
// For example, we could have a font called "red."  This is our
// font map.  The vertex/uv pairs point to individual characters
// within this atlas.  We manage those in this calls, but have our 
// mesh point to these.  When the RenderController
// asks the mesh to render itself, it will make a single call into OpenGL
// that will render each character in sequence, as stored in the 
// vertexes and uv arrays.
//
// useFont points our mesh at the correct map, vertices, uv.
//
-(void)useFont: (NSString*)mapName
{
	if (fontName) [fontName release];
	fontName = [mapName retain];
	[[APFontMap sharedFontMap] loadMap: fontName];
	NSLog(@"Using font %@", fontName);
	
}

//
// Whenever we update a text block, we iterate through a string of 
// characters.  Each character starts as a quad, pointing to (u,v)
// coordinates in our font, as well as (x,y) locations on the screen.
// We add these to the end of the vertexes and uv coordinates array,
// spacing out the characters from left to right, increasing width
// along the way.
//
// Once the characters have been laid out, we tell the mesh how many
// vertexes it has to render.  The rendering loop will later render
// our handywork in a single graphics call.
//
-(void) updateText {
	int index=0, width=0.0;
	charCount = 0;
	int len = [string length];
	if (len > kMaxChars) len = kMaxChars;
	
	while (index < len) {
		uint c = (uint) [string characterAtIndex: index];
		NSString *name = [APText stringFromChar: c];
		APChar *chr = [chars objectAtIndex: index];
		APGlyph *glyph  = [APFontMap getGlyph: name];		
		CGFloat u,v,minU,minV,maxU,maxV;
			
		// need to calculate the min and max UV for our character in the fontmap
		NSInteger i2;
		minU = minV = 1.0;
		maxU = maxV = 0.0;
		CGFloat *uvs = [glyph uv];
		for (i2 = 0; i2 < 4; i2++) {
			u = uvs[i2 * 2];
			v = uvs[(i2 * 2) + 1];
			if (u < minU) minU = u;
			if (v < minV) minV = v;
			if (u > maxU) maxU = u;
			if (v > maxV) maxV = v;
		}
			
		// Update our character
		chr.x = chr.y = 0;
		chr.width = [glyph width];
		//printf("w=%f ",chr.width);
		chr.height = [glyph height];
		chr.minU = minU;
		chr.maxU = maxU;
		chr.minV = minV;
		chr.maxV = maxV;
		chr.baseline = [glyph height] + [glyph descent];
		
		width += [glyph width]; 
		index++;
	}
	charCount = index;
}

-(void) alignText {
	// Align everything left, right or center
	CGFloat nudge = (alignment == UITextAlignmentRight) ? lineWidth : ceil(lineWidth*0.5);
	if (alignment != UITextAlignmentLeft) {
		for (APChar* kid in chars) {
			CGFloat kx = kid.x;  
			kx -= nudge;
			kid.x = kx;
		//	printf("%f ",kx);
		}
	}
	//printf("\n");
}

- (void) layoutText {
	//
	// Simple linear layout for now
	//
	if (!needsLayout) return;
	needsLayout = NO;
	int eol=charCount, cursor=0;
	lineWidth = lineHeight = 0;
	for (APChar* c in chars) {
		if (eol > 0) {
			c.x = cursor;
			c.y = 0;
			cursor += c.width;
			eol--;
			if (c.height > lineHeight) lineHeight = c.height;
		}
	}
	lineWidth = cursor;
	if (lineWidth < 0) lineWidth = 0;
	[self alignText];
}

-(void)addVertex:(CGFloat)x y:(CGFloat)y u:(CGFloat)u v:(CGFloat)v
{
	NSInteger pos = vertexIndex * 2.0;
	vertices[pos] = x;
	vertices[pos + 1] = y;
	uv[pos] = u;
	uv[pos + 1] = v;
	vertexIndex++;
}


- (void) prepareMesh {
	vertexIndex = 0;
	int index=0;

	while (index < charCount) {
		APChar * chr = [chars objectAtIndex:index];
		
		CGFloat minU=chr.minU;
		CGFloat minV=chr.minV;
		CGFloat maxU=chr.maxU;
		CGFloat maxV=chr.maxV;
		
		CGFloat w = chr.width;
		CGFloat h = chr.height;
		CGFloat x0 = chr.x;
		CGFloat y0 = chr.y + h*0.5;

		// for each character, need 2 triangles, so 6 verts
		// Need to load them in clockwise
		// order since our models are in that order
		 
		// first triangle
		[self addVertex:x0		y:y0		u:minU v:minV];  // 1
		[self addVertex:(x0+w)	y:y0		u:maxU v:minV];  // 2
		[self addVertex:x0		y:(y0-h)	u:minU v:maxV];  // 3
		
		// second triangle
		[self addVertex:x0		y:(y0-h)	u:minU v:maxV]; // 3
		[self addVertex:(x0+w)	y:y0		u:maxU v:minV]; // 2
		[self addVertex:(x0+w)	y:(y0-h)	u:maxU v:maxV]; // 4
		
		index++;
		
	}
	vertexCount = vertexIndex;	
	okToRender = YES;
	NSLog(@"Total vertices: %d with %d chars", vertexIndex, charCount);
}

-(void)setText
{	
	[self layoutText];
	[self prepareMesh];
}

// called once every frame
-(void)render
{
	// Choose font atlas and uv mapping
	if (fontName != nil) {
		[[APFontMap sharedFontMap] bindMaterial: fontName];
		glEnableClientState(GL_TEXTURE_COORD_ARRAY); 
		glTexCoordPointer(2, GL_FLOAT, 0, uv);
		if (glGetError()) printf("Error setting texture uv\n");
	} 
	
	// Load (x,y) mapping
	glEnableClientState( GL_VERTEX_ARRAY);
	glVertexPointer(2, GL_FLOAT, 0, vertices);
	if (glGetError()) printf("Error setting vertices xy \n");

	// Set paint color
	GLfloat red = (r < 0) ? 0 : ((r > 1) ? 1 : r);
	GLfloat green = (g < 0) ? 0 : ((g > 1) ? 1 : g);
	GLfloat blue = (b < 0) ? 0 : ((b > 1) ? 1 : b);
	glColor4f(red, green, blue, alpha);
	
	// Apply triangles to screen
	glDrawArrays(GL_TRIANGLES, 0, vertexCount);
	if (glGetError()) printf("Error drawing vertices\n");
	
	// Clean up our work area
	glColor4ub( 255, 255, 255, 255);
	glDisable( GL_TEXTURE_2D);
	glDisableClientState(GL_VERTEX_ARRAY );
	glDisableClientState( GL_TEXTURE_COORD_ARRAY );
}


- (void) dealloc 
{
	[unusedChars release];
	[chars release];
	[fontName release];
	free(vertices);
	free(uv);
	[super dealloc];
}

@end

