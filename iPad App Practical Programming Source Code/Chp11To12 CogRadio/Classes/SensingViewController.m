    //
//  SensingViewController.m
//  CogRadio
//
//  Created by Chen Li on 11/17/10.
//  Copyright 2010 Chen Li. All rights reserved.
//

#import "SensingViewController.h"
#import "RoadView.h"

@implementation SensingViewController

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
	[super createContents];
	
	[self enterIntroPhase];
}

-(void)destroyContents {
	[super destroyContents];
	
}

-(void)enterIntroPhase {
	NSLog(@"enterIntroPhase");
	NSString* string = @"A Cognitive Radio (CR) is able to sense and adjust to the environment, thus promote the usage of the spectrum resources. ";
	string = [string stringByAppendingFormat:@"%@", @"The first task of a CR is to sense the spectrum, "];
	string = [string stringByAppendingFormat:@"%@", @"it means you need to know what's going on in many spectrum bands. "];
	textView.text = string;
	[self.view addSubview:textView];
	
	[button addTarget:self action:@selector(enterDemoPhase) forControlEvents:UIControlEventTouchUpInside];
	[button setTitle:@"Continue" forState:UIControlStateNormal];
	//button.center = CGPointMake(850, 600);
	[self.view addSubview:button];
}

-(void)enterDemoPhase {
	NSLog(@"enterDemoPhase");
	textView.text = @"";
	
	NSString* string = @"A CR needs to sense many bands, like a vehicle needs to know the situation of many lanes in order to drive";
	textHead.text = string;
	
	[roads changeNumOfLane:3];
	[self.view addSubview:roads];
	[roads startPuTxOnLane:1];
	[roads startPuTxOnLane:2];
	[roads startPuTxOnLane:3];
	
	//button.center = CGPointMake(700, 600);
	[button removeTarget:self action:@selector(enterDemoPhase) forControlEvents:UIControlEventTouchUpInside];
	[button addTarget:self action:@selector(sceneFinished) forControlEvents:UIControlEventTouchUpInside];
	[self.view bringSubviewToFront:button];
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation {
    // Overriden to allow any orientation.
    return YES;
}


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
