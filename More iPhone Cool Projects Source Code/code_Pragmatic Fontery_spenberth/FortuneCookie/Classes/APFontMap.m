//
//  APFontMap.m
//  FortuneCookie
//
//  Created by Scott Penberthy on 2/7/10.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import "APFontMap.h"

#define kMaxTextureSize 1024
#define HACKING YES
#define CONVERT_TO_4444 NO

@implementation APFontMap

// Singleton accessor.  this is how you should ALWAYS get a reference
// to the controller.  Never init your own.

@synthesize glyphLibrary, mapLibrary;

+(APFontMap *) sharedFontMap 
{
	static APFontMap *sharedMap;
	@synchronized(self)
	{
		if (!sharedMap)
			sharedMap = [[APFontMap alloc] init];
		
		return sharedMap;
	}
	return sharedMap;
}

+ (APGlyph *) getGlyph: (NSString *) name
{
	APFontMap *fm = [APFontMap sharedFontMap];
	APGlyph *glyph = [[fm glyphLibrary] objectForKey: name];
	return glyph;
}


-(void)loadMap:(NSString*) mapName
{
	// make sure we have a map and glyph library, and that this is not a duplicate load
	NSAutoreleasePool * apool = [[NSAutoreleasePool alloc] init];	
	if (glyphLibrary == nil) glyphLibrary = [[NSMutableDictionary alloc] init];
	if ([mapLibrary objectForKey:mapName] != nil) return; // load once
	
	// load our map
	CGSize mapSize = [self loadMapImage:[mapName stringByAppendingPathExtension:@"png"] mapKey: mapName];
	if (mapSize.width == 0) {
		NSLog(@"Failed to load font map '%@'",mapName);
	}
	
	// load our glyph data
	NSArray * glyphData = [NSArray arrayWithContentsOfFile:[[NSBundle mainBundle] pathForResource:mapName ofType:@"plist"]];
	for (NSDictionary * record in glyphData) {
		APGlyph * glyph = [self parseGlyph:record withSize:mapSize usingKey:mapName];
		[glyphLibrary setObject:glyph forKey: glyph.glyphName]; 
		NSLog(@"Added %@ to %@", [glyph glyphName], mapName); 
	}
	[self bindMaterial:mapName];
	[apool release];
}


-(APGlyph *)parseGlyph:(NSDictionary*)record 
			withSize:(CGSize)mapSize
			usingKey:(NSString*)key;
{	
	GLfloat x = [[record objectForKey:@"x"] floatValue];
	GLfloat y = [[record objectForKey:@"y"] floatValue];
	GLfloat width = [[record objectForKey:@"width"] floatValue];
	GLfloat height = [[record objectForKey:@"height"] floatValue];
	GLfloat ascent = [[record objectForKey:@"ascent"] floatValue];
	GLfloat descent = [[record objectForKey:@"descent"] floatValue];
	NSString *name = [record objectForKey:@"name"];
	
	APGlyph *glyph = [[APGlyph alloc] init];
	
	// find the normalized texture coordinates
	GLfloat w = mapSize.width*1.0;
	GLfloat h = mapSize.height*1.0;
	GLfloat xMin = x/w;
	GLfloat yMin = y/h;
	GLfloat xMax = (x + width)/w;
	GLfloat yMax = (y + height)/h;
		
	glyph.uv[0] = xMin;
	glyph.uv[1] = yMin;
	
	glyph.uv[2] = xMax;
	glyph.uv[3] = yMin;
	
	glyph.uv[4] = xMax;
	glyph.uv[5] = yMax;
	
	glyph.uv[6] = xMin;
	glyph.uv[7] = yMax;
	
	glyph.mapKey = key;
	glyph.ascent = ascent;
	glyph.descent = descent;
	glyph.glyphName = name;
	glyph.width = width;
	glyph.height = height;
	
	return [glyph autorelease];
}

// grabs the openGL texture ID from the library and calls the openGL bind texture method
-(void)bindMaterial:(NSString*)mapKey
{
	NSNumber * numberObj = [mapLibrary objectForKey:mapKey];
	if (numberObj == nil) {
		NSLog(@"Missing %@ font, no texture used.",mapKey);
		return;
	}
	//NSLog(@"Switching to texture %@", numberObj);
	GLuint textureID = [numberObj unsignedIntValue];
	
	glEnable(GL_TEXTURE_2D);
	glBindTexture(GL_TEXTURE_2D, textureID);
	//FIXME
	if (glGetError()) printf("OpenGL error using texture %u\n", textureID);
}

// grabs the texture ID from the library and deletes it from the framebuffer
-(void)purgeMaterial:(NSString*)mapKey
{
	NSLog(@"Dumping map '%@'",mapKey);
	NSNumber * numberObj = [mapLibrary objectForKey:mapKey];
	[glyphLibrary removeObjectForKey: mapKey];
	if (numberObj == nil) {
		if (HACKING) NSLog(@"...map missing");
		return;
	}
	GLuint textureID = [numberObj unsignedIntValue];
	glDeleteTextures(1, &textureID);
	
	NSArray * itemData = [NSArray arrayWithContentsOfFile:[[NSBundle mainBundle] pathForResource:mapKey ofType:@"plist"]];
	
	if (itemData) {
		for (NSDictionary * record in itemData) {
			NSString *glyphName = [record objectForKey:@"name"];
			if (HACKING) NSLog(@"...dumping quad %@", glyphName);
			[glyphLibrary removeObjectForKey: glyphName];
		}
	}
}

-(void)purgeAllMaterials
{
	// TODO we might need a mutex here
	
	for (NSString * mapKey in [mapLibrary allKeys]) {
		[self purgeMaterial:mapKey];
	}
	[mapLibrary release];
	mapLibrary = nil;
	[glyphLibrary release];
	glyphLibrary = nil;
}


// does the heavy lifting for getting a named image into a texture
// that is loaded into openGL

-(CGSize)loadMapImage:(NSString*)imageName mapKey:(NSString*)mapKey
{
	if ([mapLibrary objectForKey:mapKey] != nil) return CGSizeZero; // we already loaded it
	
	// grab the image off the file system, jam it into a CGImageRef
	
	UIImage *uiImage = [[UIImage alloc] initWithContentsOfFile:[[NSBundle mainBundle] pathForResource:imageName ofType:nil]];
	CGSize result = [self saveImage: uiImage withKey: mapKey];
	[uiImage release];
	return result;
}

+ (CGSize) textureSizeForSize: (CGSize) s 
{
	size_t width,height;
	BOOL sizeToFit = NO;
	int i;
	
	// choose a width x height that is a power of 2
	width = round(s.width);
	if((width != 1) && (width & (width - 1))) {
		i = 1;
		while((sizeToFit ? 2 * i : i) < width)
			i *= 2;
		width = i;
	}
	
	height = round(s.height);
	if((height != 1) && (height & (height - 1))) {
		i = 1;
		while((sizeToFit ? 2 * i : i) < height)
			i *= 2;
		height = i;
	}
	
	return CGSizeMake(width,height);
}	


- (CGSize) saveImage: (UIImage *) uiImage withKey: (NSString *) mapKey
{
	if ([mapLibrary objectForKey:mapKey] != nil) return CGSizeZero;
	
	CGContextRef			spriteContext;
	GLubyte					*spriteData;
	size_t					width, height;
	CGAffineTransform		transform;
	CGSize					imageSize;
	GLuint					textureID;
	CGColorSpaceRef			colorSpace;
	
	CGImageRef spriteImage = [uiImage CGImage];
	// Get the width and height of the image
	imageSize = CGSizeMake(CGImageGetWidth(spriteImage),CGImageGetHeight(spriteImage));
	transform = CGAffineTransformIdentity;
	
	CGSize ts = [APFontMap textureSizeForSize: imageSize];
	width = ts.width;
	height = ts.height;
	
	NSAssert2( (width <= kMaxTextureSize) && (height <= kMaxTextureSize), 
			  @"Image is bigger than the supported %d x %d", 
			  kMaxTextureSize, kMaxTextureSize);
	
	//CGSize imageSizeFinal = CGSizeMake(width, height);
	// Texture dimensions must be a power of 2. If you write an application that allows users to supply an image,
	// you'll want to add code that checks the dimensions and takes appropriate action if they are not a power of 2.
	
	if(spriteImage) {
		// Allocated memory needed for the bitmap context
		spriteData = (GLubyte *) malloc(width * height * 4);
		memset(spriteData, 0, width*height*4);
		
		// Grab the device color space
		colorSpace = CGColorSpaceCreateDeviceRGB();
		
		// Uses the bitmap creation function provided by the Core Graphics framework. 
		spriteContext = CGBitmapContextCreate(spriteData, width, height, 8, width * 4, colorSpace, 
											  kCGImageAlphaPremultipliedLast | kCGBitmapByteOrder32Big);
		
		// After you create the context, you can draw the sprite image to the context.
		CGContextClearRect(spriteContext, CGRectMake(0, 0, width, height));
		CGContextTranslateCTM(spriteContext, 0, height - imageSize.height);
		
		if (HACKING) {
			printf("Drawing %fx%f image into %dx%d space\n",
				   imageSize.width, 
				   imageSize.height,
				   (int) width,
				   (int) height);
		}
		CGContextDrawImage(spriteContext, CGRectMake(0.0, 0.0, 
													 imageSize.width, 
													 imageSize.height), spriteImage);
		
		// You don't need the context or colorspace at this point, so you need to release it to avoid memory leaks.
		CGContextRelease(spriteContext);
		CGColorSpaceRelease(colorSpace);
		
		// Use OpenGL ES to generate a name for the texture.
		glGenTextures(1, &textureID);
		
		// Bind the texture name. 
		glBindTexture(GL_TEXTURE_2D, textureID);
		
		// Specify a 2D texture image, providing a pointer to the image data in memory
		
		//Convert "RRRRRRRRGGGGGGGGAPAPAPAPAAAAAAAA" to "RRRRGGGGAPAPAAAA"
		if (CONVERT_TO_4444) {
			void*					tempData;
			unsigned int*			inPixel32;
			unsigned short*			outPixel16;
			
			tempData = malloc(height * width * 2);
			
			inPixel32 = (unsigned int*)spriteData;
			outPixel16 = (unsigned short*)tempData;
			NSUInteger i;
			for(i = 0; i < width * height; ++i, ++inPixel32)
				*outPixel16++ = 
				((((*inPixel32 >> 0) & 0xFF) >> 4) << 12) | 
				((((*inPixel32 >> 8) & 0xFF) >> 4) << 8) | 
				((((*inPixel32 >> 16) & 0xFF) >> 4) << 4) | 
				((((*inPixel32 >> 24) & 0xFF) >> 4) << 0);
			
			glTexImage2D(GL_TEXTURE_2D, 0, GL_RGBA, width, height, 0, GL_RGBA, GL_UNSIGNED_SHORT_4_4_4_4, tempData);
			free(tempData);
		} else {
			glTexImage2D(GL_TEXTURE_2D, 0, GL_RGBA, width, height, 0, GL_RGBA, GL_UNSIGNED_BYTE, spriteData);			
		}
		
		free(spriteData);
		// Release the image data
		// Set the texture parameters to use a minifying filter and a linear filer (weighted average)
		glTexParameteri(GL_TEXTURE_2D, GL_TEXTURE_MIN_FILTER, GL_LINEAR);
		glTexParameteri(GL_TEXTURE_2D, GL_TEXTURE_MAG_FILTER, GL_NEAREST);
		
		// Enable use of the texture
		glEnable(GL_TEXTURE_2D);
		
		// Set a blending function to use
		glBlendFunc(GL_ONE, GL_ONE_MINUS_SRC_ALPHA);
		// Enable blending
		glEnable(GL_BLEND);
	} else {
		NSLog(@"no texture for %@",mapKey);
		return CGSizeZero;
	}
	if (mapLibrary == nil) mapLibrary = [[NSMutableDictionary alloc] init];
	
	// now put the texture ID into the library
	printf("Created texture id %u\n",textureID);
	[mapLibrary setObject:[NSNumber numberWithUnsignedInt:textureID] forKey:mapKey];
	
	return imageSize;
}

- (void) dealloc
{
	[mapLibrary release];
	[glyphLibrary release];
	[super dealloc];
}

@end
