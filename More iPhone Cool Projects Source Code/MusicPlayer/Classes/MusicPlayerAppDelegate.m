//
//  MusicPlayerAppDelegate.m
//  MusicPlayer
//
//  Created by Saul Mora on 4/22/10.
//  Copyright Magical Panda Software, LLC 2010. All rights reserved.
//

#import "MusicPlayerAppDelegate.h"
#import "MusicPlayerViewController.h"

@implementation MusicPlayerAppDelegate

@synthesize window;
@synthesize viewController;


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {    
    
    // Override point for customization after app launch    
    [window addSubview:viewController.view];
    [window makeKeyAndVisible];
	
	return YES;
}


- (void)dealloc {
    [viewController release];
    [window release];
    [super dealloc];
}


@end
