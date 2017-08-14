//
//  APFontMap.h
//  FortuneCookie
//
//  Created by Scott Penberthy on 2/7/10.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import "APGlyph.h"

//
// The APFontMap class represents a complete collection of Glyphs, all stored on a single
// texture atlas.  Think of this as Gutenberg's table full of drawers, where each drawer
// held a collection of glyphs for a particular character.
//
// The methods are as follows:
//
// loadMapImage:  loads a local resource and associates it with a name, called mapKey
//
// parseGlyph:withSize:usingKey - this loads a glyph from a texture map named mapKey,
//                                with map dimensions in the withSize:; attribute,
//                                and the name of the glyph in the usingKey: attribute
//
// Admittedly, the signature could be better in a production application!
//
// bindMaterial: - this routine will prepare a font map for printing onto our screen,
//                 "binding" the current texture atlas for lower level OpenGL calls
//                 that refer to a texture atlas
//
// saveImage:withKey - this is an internal method used by the class to save a
//                     texture atlas in memory for use throughtout the application.
//
// getGlyph: - returns a Glyph object representing a given character named "name"
//
// loadMap:  - loads an APFontMap into memory if needed.  We keep all fontmaps
//             in a static shared variable.
//

@interface APFontMap : NSObject {
	NSMutableDictionary *glyphLibrary;
	NSMutableDictionary *mapLibrary;
}

@property (retain, nonatomic) NSMutableDictionary *glyphLibrary;
@property (retain, nonatomic) NSMutableDictionary *mapLibrary;

-(CGSize)loadMapImage:(NSString*)imageName mapKey:(NSString*)mapKey;
-(APGlyph *)parseGlyph:(NSDictionary*)record 
			  withSize:(CGSize)mapSize
			  usingKey:(NSString*)key;
-(void)bindMaterial:(NSString*)mapKey;
- (CGSize) saveImage: (UIImage *) uiImage withKey: (NSString *) mapKey;
+ (APFontMap *) sharedFontMap;
+ (APGlyph *) getGlyph: (NSString *) name;
- (void) loadMap:(NSString*) mapName;


@end
