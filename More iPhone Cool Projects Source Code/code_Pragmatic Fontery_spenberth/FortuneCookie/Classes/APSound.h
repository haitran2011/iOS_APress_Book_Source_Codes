//
//  APSound.h
//  FortuneCookie
//
//  Created by Scott Penberthy on 2/10/10.
//  Copyright 2010 North Highland Partners, Inc.. All rights reserved.
//

#import <Foundation/Foundation.h>
#include <AudioToolbox/AudioToolbox.h>

//
// This little class is my abstraction for playing
// a single sound.  We do a "crunch" sound on startup.
//
// OK, ok, lame, but this is about fonts.  :-)
//


@interface APSound : NSObject {
	CFURLRef soundFileURLRef;
	SystemSoundID sid; 
}

@property (readwrite) CFURLRef soundFileURLRef;
@property (readonly) SystemSoundID sid;

- (void) loadSound: (NSString *) theSound;
- (void) play;

@end
