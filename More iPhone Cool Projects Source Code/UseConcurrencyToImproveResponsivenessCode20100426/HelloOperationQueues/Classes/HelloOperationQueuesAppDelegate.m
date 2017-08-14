//
//  HelloOperationQueuesAppDelegate.m
//  HelloOperationQueues
//
//  Created by Danton Chin on 3/28/10.
//  Copyright  http://iphonedeveloperjournal.com/ 2010. All rights reserved.
//

#import "HelloOperationQueuesAppDelegate.h"
#import "HelloOperationQueuesViewController.h"

@implementation HelloOperationQueuesAppDelegate

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
