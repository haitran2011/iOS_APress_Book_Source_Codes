    //
//  AccessViewController.m
//  CogRadio
//
//  Created by Chen Li on 11/17/10.
//  Copyright 2010 Chen Li. All rights reserved.
//

#import "AccessViewController.h"
#import "RoadView.h"

@implementation AccessViewController

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
	NSString* string = @"When CR finds out that a band is not used by PU currently, it adapts itself to make use of that band; ";
	string = [string stringByAppendingFormat:@"%@", @"when the PU begins to use this band, the CR quit this band to avoid interference with PU. "];
	string = [string stringByAppendingFormat:@"%@", @"This way, spectrum usage is promoted, and licensed users are protected. "];
	textView.text = string;
	[self.view addSubview:textView];
	
	[button addTarget:self action:@selector(enterDemoPhase) forControlEvents:UIControlEventTouchUpInside];
	[button setTitle:@"Continue" forState:UIControlStateNormal];
	[self.view addSubview:button];
}

-(void)enterDemoPhase {
	NSLog(@"enterDemoPhase");
	textView.text = @"";
	
	NSString* string = @"Here the laptop is the CR. Notice how CRs make use of the available road resource, ";
	string = [string stringByAppendingFormat:@"while avoiding collision with PUs (TV, antenna, cellphone). "];
	textHead.text = string;
	
	[roads changeNumOfLane:3];
	[self.view addSubview:roads];
	[roads startPuTxOnLane:1];
	[roads startPuTxOnLane:2];
	[roads startPuTxOnLane:3];
	[roads startCrTx:1];
	[roads startCrTx:2];
	[roads startCrTx:3];
	
	[button removeTarget:self action:@selector(enterDemoPhase) forControlEvents:UIControlEventTouchUpInside];
	[button addTarget:self action:@selector(enterSummaryPhase) forControlEvents:UIControlEventTouchUpInside];
	[self.view bringSubviewToFront:button];
}

-(void)enterSummaryPhase {
	NSLog(@"enterSummaryPhase");
	[roads clearRoad];
	[roads removeFromSuperview];
	
	textHead.text = @"";
	
	NSString* string = @"In sum, Cognitive Radio technology makes better use of spectrum resources, ";
	string = [string stringByAppendingFormat:@"without creating harm to licensed spectrum users. "];
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
