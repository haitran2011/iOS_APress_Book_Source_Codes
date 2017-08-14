//
//  CogRadioViewController.m
//  CogRadio
//
//  Created by Chen Li on 11/16/10.
//  Copyright 2010 Chen Li. All rights reserved.
//

#import "CogRadioViewController.h"
#import "TradViewController.h"
#import "SensingViewController.h"
#import "AccessViewController.h"
#import "GroupViewController.h"
#import "VideoViewController.h"
#import "AboutViewController.h"
#import "Definitions.h"

@implementation CogRadioViewController

@synthesize btnTrad;
@synthesize btnSensing;
@synthesize btnAccess;
@synthesize btnVideo;
@synthesize btnGroups;
@synthesize btnAbout;
@synthesize scrollView;

/*
// The designated initializer. Override to perform setup that is required before the view is loaded.
- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil {
    if ((self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil])) {
        // Custom initialization
    }
    return self;
}
*/

/*
// Implement loadView to create a view hierarchy programmatically, without using a nib.
- (void)loadView {
}
*/


// Implement viewDidLoad to do additional setup after loading the view, typically from a nib.
- (void)viewDidLoad {
    [super viewDidLoad];
	
	// buttons
	arrayButtons = [[NSArray alloc] initWithObjects:btnTrad,btnSensing,btnAccess,btnVideo,btnGroups,btnAbout,nil];
	
	// viewcontrollers
	tradVC = [[TradViewController alloc] init];
	sensingVC = [[SensingViewController alloc] init];
	accessVC = [[AccessViewController alloc] init];
	videoVC = [[VideoViewController alloc] init];
	groupVC = [[GroupViewController alloc] init];
	aboutVC = [[AboutViewController alloc] init];
	arrayVCs = [[NSArray alloc] initWithObjects:tradVC,sensingVC,accessVC,videoVC,groupVC,aboutVC,nil];
	
	// scrollView
	scrollView.contentSize = CGSizeMake(SceneWidth*NumScene, SceneHeight);
	NSLog(@"contentSize: %@",NSStringFromCGSize(scrollView.contentSize));
	scrollView.delegate = self;
	scrollView.scrollEnabled = NO;
	scrollView.contentInset = UIEdgeInsetsZero;
	//scrollView.delaysContentTouches = NO;
	scrollView.clipsToBounds = YES;
	//scrollView.canCancelContentTouches = YES;
	scrollView.showsVerticalScrollIndicator = NO;
	scrollView.showsHorizontalScrollIndicator = NO;
	for (int i=0; i<NumScene; i++) {
		SceneViewController* sceneVC = [arrayVCs objectAtIndex:i];
		sceneVC.delegate = self;
		sceneVC.view.center = CGPointMake((i+0.5)*SceneWidth, 0.5*SceneHeight);
		[scrollView addSubview:sceneVC.view];
	}
	
	// scroll to the 0-th view
	[self createContentsInViewAtIndex:0];
}

// called when one of the button is clicked
-(IBAction) clicked:(UIButton*)sender {
	for (int i=0; i<[arrayButtons count]; i++) {
		if (sender==[arrayButtons objectAtIndex:i]) {
			[self scrollToViewAtIndex:i];
		}
	}
}

// create contents in related view (by calling -createContentInViewAtIndex:), and scroll to the view
-(void) scrollToViewAtIndex:(int)index {
	NSLog(@"scrollToViewAtIndex:%d",index);
	iVC = index;
	
	[self createContentsInViewAtIndex:index];
	[scrollView scrollRectToVisible:CGRectMake(index*SceneWidth, 0, SceneWidth, SceneHeight) animated:YES];
}

// create contents in related view
-(void) createContentsInViewAtIndex:(int)index {
	// if there's no view in the given index, do nothing
	if (index<0)
		return;
	if (index>=[arrayVCs count])
		return;
	
	// create contents if it's not done yet
	SceneViewController* sceneVC = [arrayVCs objectAtIndex:index];		// get the viewcontroller
	if (!sceneVC.contentsCreated) {
		[sceneVC createContents];
	}
}

// destroy contents in related view, used when received memory warning
-(void) destroyContentsInViewAtIndex:(int)index {
	
}

// SceneDelegate method, called when finished with one scene
-(void)finishedScene:(id)scene {
	int finishedSceneIndex;
	for (int i=0; i<[arrayVCs count]; i++) {
		if (scene==[arrayVCs objectAtIndex:i]) {
			finishedSceneIndex = i;
		}
	}
	NSLog(@"The finishedSceneIndex:%d",finishedSceneIndex);
	
	int index = (finishedSceneIndex+1)%NumScene;		// the index to load
	[self createContentsInViewAtIndex:index];
	[scrollView scrollRectToVisible:CGRectMake(index*SceneWidth, 0, SceneWidth, SceneHeight) animated:YES];
}

// Override to allow orientations other than the default portrait orientation.
- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation {
    return (interfaceOrientation==UIInterfaceOrientationLandscapeLeft) || (interfaceOrientation==UIInterfaceOrientationLandscapeRight);
}

- (void)didReceiveMemoryWarning {
	// Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
	
	// Release any cached data, images, etc that aren't in use.
}

- (void)viewDidUnload {
	// Release any retained subviews of the main view.
	// e.g. self.myOutlet = nil;
}


- (void)dealloc {
	[btnTrad release];
	[btnSensing release];
	[btnAccess release];
	[btnVideo release];
	[btnGroups release];
	[btnAbout release];
	[arrayButtons release];
	
	[tradVC release];
	[sensingVC release];
	[accessVC release];
	[videoVC release];
	[groupVC release];
	[aboutVC release];
	[arrayVCs release];
	
	[scrollView release];
	
    [super dealloc];
}

@end
