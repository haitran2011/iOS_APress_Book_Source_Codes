    //
//  TradViewController.m
//  CogRadio
//
//  Created by Chen Li on 11/17/10.
//  Copyright 2010 Chen Li. All rights reserved.
//

#import "TradViewController.h"
#import "RoadView.h"

@implementation TradViewController

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
	NSString* string = @"Traditionally, frequency bands are statically allocated to authorized users, also know as Primary Users (PUs). ";
	string = [string stringByAppendingFormat:@"%@", @"The frequency bands are like the lanes in a road: "];
	string = [string stringByAppendingFormat:@"%@", @"the bands are used to carry radio signals, while the roads are used to carry vehicles. "];
	textView.text = string;
	[self.view addSubview:textView];
	
	[button addTarget:self action:@selector(enterDemoPhase) forControlEvents:UIControlEventTouchUpInside];
	[button setTitle:@"Continue" forState:UIControlStateNormal];
	[self.view addSubview:button];
}

-(void)enterDemoPhase {
	NSLog(@"enterDemoPhase");
	textView.text = @"";
	
	NSString* string = @"The traditional policy is: one lane is dedicated to a specific kind of vehicle; ";
	string = [string stringByAppendingFormat:@"just like one band can only be used by the PU, even if the PU is not transmitting any signal. "];
	textHead.text = string;
	
	[roads changeNumOfLane:1];
	[self.view addSubview:roads];
	[roads startPuTxOnLane:1];
	
	[button removeTarget:self action:@selector(enterDemoPhase) forControlEvents:UIControlEventTouchUpInside];
	[button addTarget:self action:@selector(enterSummaryPhase) forControlEvents:UIControlEventTouchUpInside];
	[self.view bringSubviewToFront:button];
}

-(void)enterSummaryPhase {
	NSLog(@"enterSummaryPhase");
	[roads clearRoad];
	[roads removeFromSuperview];
	
	textHead.text = @"";
	
	NSString* string = @"In summary, the traditional policy is simple and guarantees the need of the PU. ";
	string = [string stringByAppendingFormat:@"However, it results in wasted spectrum resources; "];
	string = [string stringByAppendingFormat:@"this disadvantage becomes obvious when more and more un-authorized users try to access the network. "];
	textView.text = string;
	
	[button removeTarget:self action:@selector(enterSummaryPhase) forControlEvents:UIControlEventTouchUpInside];
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
