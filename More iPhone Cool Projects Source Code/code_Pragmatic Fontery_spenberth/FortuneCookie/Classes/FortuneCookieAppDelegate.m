//
//  FortuneCookieAppDelegate.m
//  FortuneCookie
//
//  Created by Scott Penberthy on 2/7/10.
//  Copyright North Highland Partners 2010. All rights reserved.
//

#import "FortuneCookieAppDelegate.h"
#import "EAGLView.h"
#import "APSound.h"

@implementation FortuneCookieAppDelegate

@synthesize window;
@synthesize glView;

- (void) applicationDidFinishLaunching:(UIApplication *)application
{
	startup = [[APSound alloc] init];
	[startup loadSound: @"crunch"];
	[glView startAnimation];
	[startup play];
}

- (void) applicationWillResignActive:(UIApplication *)application
{
	[glView stopAnimation];
}

- (void) applicationDidBecomeActive:(UIApplication *)application
{
	[glView startAnimation];
}

- (void)applicationWillTerminate:(UIApplication *)application
{
	[glView stopAnimation];
}

- (void) dealloc
{
	[window release];
	[glView release];
	[startup release];
	
	[super dealloc];
}

@end
