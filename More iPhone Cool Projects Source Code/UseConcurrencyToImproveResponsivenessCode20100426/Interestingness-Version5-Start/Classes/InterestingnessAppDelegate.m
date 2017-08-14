//
//  InterestingnessAppDelegate.m
//  Interestingness - Version 5
//
//  Created by Danton Chin on 3/24/10.
//  Copyright  http://iphonedeveloperjournal.com/ 2010. All rights reserved.
//

#import "InterestingnessAppDelegate.h"
#import "InterestingnessTableViewController.h"

@implementation InterestingnessAppDelegate

@synthesize window;


- (void)applicationDidFinishLaunching:(UIApplication *)application {    

    tableViewController = [[InterestingnessTableViewController alloc] initWithStyle:UITableViewStylePlain];
	
	[[tableViewController view] setFrame:[[UIScreen mainScreen] applicationFrame]];
	
	[window addSubview:[tableViewController view]];
	
    [window makeKeyAndVisible];
}


- (void)dealloc {
	[tableViewController release];
    [window release];
    [super dealloc];
}


@end
