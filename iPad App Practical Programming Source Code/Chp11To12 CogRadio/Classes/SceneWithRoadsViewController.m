//
//  SceneWithRoadsViewController.m
//  CogRadio
//
//  Created by Chen Li on 11/18/10.
//  Copyright 2010 Chen Li. All rights reserved.
//

#import "SceneWithRoadsViewController.h"
#import "RoadView.h"

@implementation SceneWithRoadsViewController

/*
 // The designated initializer.  Override if you create the controller programmatically and want to perform customization that is not appropriate for viewDidLoad.
- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil {
    if ((self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil])) {
        // Custom initialization
    }
    return self;
}
*/

/*
// Implement viewDidLoad to do additional setup after loading the view, typically from a nib.
- (void)viewDidLoad {
    [super viewDidLoad];
}
*/

-(void)createContents {
	contentsCreated = YES;
	[super createContents];
	
	[self.view addSubview:bkColorView];
	
	roads = [[RoadView alloc] initWithNumOfLane:1];
	roads.center = CGPointMake(SceneWidth/2, SceneHeight/2);
	//[self.view addSubview:roads];
}

-(void)destroyContents {
	contentsCreated = NO;
	[super destroyContents];
	
	[roads removeFromSuperview];
	[roads release];
}

/*
// Override to allow orientations other than the default portrait orientation.
- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation {
    // Return YES for supported orientations
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}
*/

- (void)didReceiveMemoryWarning {
    // Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
    
    // Release any cached data, images, etc that aren't in use.
}

- (void)viewDidUnload {
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}


- (void)dealloc {
    [super dealloc];
}


@end
