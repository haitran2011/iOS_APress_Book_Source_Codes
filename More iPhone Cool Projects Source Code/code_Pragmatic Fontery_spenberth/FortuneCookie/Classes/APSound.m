//
//  APSound.m
//  FortuneCookie
//
//  Created by Scott Penberthy on 2/10/10.
//  Copyright 2010 North Highland Partners, Inc.. All rights reserved.
//

#import "APSound.h"

@implementation APSound

@synthesize soundFileURLRef, sid;

- (void) loadSound: (NSString *) theSound {
	// Get the main bundle for the app
	CFBundleRef mainBundle;
	mainBundle = CFBundleGetMainBundle ();
	NSArray *parts = [theSound componentsSeparatedByString:@"."];
	
	// Get the URL to the sound file to play
	soundFileURLRef  =	CFBundleCopyResourceURL(
												mainBundle,
												(CFStringRef) [parts objectAtIndex: 0],
												CFSTR ("caf"),
												NULL
												);
	
	// Create a system sound object representing the sound file
	AudioServicesCreateSystemSoundID(
									 soundFileURLRef,
									 &sid
									 );
}

- (void) play {
	// Play our sound	
	if (sid) AudioServicesPlaySystemSound (sid);
}	


- (void)dealloc {
	if (sid) {
		AudioServicesDisposeSystemSoundID (sid);
		CFRelease (soundFileURLRef);
	}
    [super dealloc];
}

@end
