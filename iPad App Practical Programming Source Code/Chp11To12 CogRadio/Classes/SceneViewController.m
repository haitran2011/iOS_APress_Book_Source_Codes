//
//  SceneViewController.m
//  CogRadio
//
//  Created by Chen Li on 11/17/10.
//  Copyright 2010 Chen Li. All rights reserved.
//

#import "SceneViewController.h"

@implementation SceneViewController

@synthesize contentsCreated,delegate;

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
	
	// background color
	bkColorView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, SceneWidth, SceneHeight)];
	bkColorView.backgroundColor = [UIColor blackColor];
	
	// textHead
	textHead = [[UITextView alloc] initWithFrame:CGRectMake(0, 0, SceneWidth-300, 110)];
	textHead.center = CGPointMake(SceneWidth/2-50, 70);
	textHead.textAlignment = UITextAlignmentCenter;
	textHead.textColor = [UIColor whiteColor];
	textHead.font = [UIFont fontWithName:@"Arial" size:24];
	textHead.backgroundColor = [UIColor clearColor];
	textHead.userInteractionEnabled = NO;
	[self.view addSubview:textHead];
	
	// textView
	textView = [[UITextView alloc] initWithFrame:CGRectMake(0, 0, SceneWidth*0.7, SceneHeight*0.5)];
	textView.center = CGPointMake(SceneWidth/2, SceneHeight/2);
	//textView.text = @"textView";
	textView.textColor = [UIColor whiteColor];
	textView.font = [UIFont fontWithName:@"Arial" size:24];
	textView.backgroundColor = [UIColor clearColor];
	textView.userInteractionEnabled = NO;
	[self.view addSubview:textView];
	
	// button
	button = [UIButton buttonWithType:UIButtonTypeCustom];
	button.frame = CGRectMake(SceneWidth-110, 70, 100, 30);
	[button retain];
	[button setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
}

-(void)destroyContents {
	contentsCreated = NO;
	
	[bkColorView removeFromSuperview];
	[bkColorView release];
	
	[textHead removeFromSuperview];
	[textHead release];
	
	[button removeFromSuperview];
	[button release];
}

-(void)sceneFinished {
	[delegate finishedScene:self];
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
	[self destroyContents];
    [super dealloc];
}


@end
