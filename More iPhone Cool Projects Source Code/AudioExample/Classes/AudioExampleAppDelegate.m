//
//  AudioExampleAppDelegate.m
//  AudioExample
//
//  Created by David Smith on 12/15/09.
//  Copyright __MyCompanyName__ 2009. All rights reserved.
//

#import "AudioExampleAppDelegate.h"
#import "AudioExampleViewController.h"

@implementation AudioExampleAppDelegate

@synthesize window;
@synthesize viewController;


- (void)applicationDidFinishLaunching:(UIApplication *)application {    
    
    // Override point for customization after app launch    
    [window addSubview:viewController.view];
    [window makeKeyAndVisible];
}

- (void)dealloc {
    [viewController release];
    [window release];
    [super dealloc];
}


@end
