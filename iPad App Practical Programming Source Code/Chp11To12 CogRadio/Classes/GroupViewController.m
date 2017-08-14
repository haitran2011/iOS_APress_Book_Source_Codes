    //
//  GroupViewController.m
//  CogRadio
//
//  Created by Chen Li on 11/17/10.
//  Copyright 2010 Chen Li. All rights reserved.
//

#import "GroupViewController.h"


@implementation GroupViewController

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
	
	// webView
	// @"<font size=\"4\" face=\"Verdana\" color=\"#CC0000\"> This is a paragraph. </font>"
	webView = [[UIWebView alloc] initWithFrame:CGRectMake(0, 80, SceneWidth, 700)];
	[self.view addSubview:webView];
	[self toList];
	
	// buttonBack
	button.center = CGPointMake(50, 30);
	[button setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
	[button addTarget:webView action:@selector(goBack) forControlEvents:UIControlEventTouchUpInside];
	[button setTitle:@"Back" forState:UIControlStateNormal];
	[self.view addSubview:button];
	
	// buttonToList
	
	buttonToList = [UIButton buttonWithType:UIButtonTypeCustom];
	buttonToList.frame = CGRectMake(SceneWidth-110, 70, 150, 30);
	[buttonToList retain];
	[buttonToList setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
	buttonToList.center = CGPointMake(200, 30);
	[buttonToList addTarget:self action:@selector(toList) forControlEvents:UIControlEventTouchUpInside];
	[buttonToList setTitle:@"List of Groups" forState:UIControlStateNormal];
	[self.view addSubview:buttonToList];
}

-(void)destroyContents {
	[super destroyContents];
	
	[buttonToList removeFromSuperview];
	[buttonToList release];
}

-(void)toList {
	NSString* string = @"<font size=\"5\" face=\"Verdana\" color=\"#CC0000\"><p style=\"margin:0px 0px 0px 50px\"><a href=\"http://bwrc.eecs.berkeley.edu/Research/Cognitive/default.htm\">University of California, Berkeley </a></p>";
	string = [string stringByAppendingFormat:@"<p style=\"margin:0px 0px 0px 50px\"><a href=\"http://www.ece.gatech.edu/research/labs/bwn/CR/\">Georgia Institute of Technology</a></p>"];
	string = [string stringByAppendingFormat:@"<p style=\"margin:0px 0px 0px 50px\"><a href=\"http://soma.mcmaster.ca/\">McMaster University</a></p>"];
	string = [string stringByAppendingFormat:@"<p style=\"margin:0px 0px 0px 50px\"><a href=\"http://www.ece.mtu.edu/faculty/ztian/\">Chen Li</a></p>"];
	string = [string stringByAppendingFormat:@"<p style=\"margin:0px 0px 0px 50px\"><a href=\"http://research.nokia.com/cognitive_radio\">Nokia Research Center</a></p></font>"];
	[webView loadHTMLString:string baseURL:nil];
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
	[webView release];
    [super dealloc];
}


@end
