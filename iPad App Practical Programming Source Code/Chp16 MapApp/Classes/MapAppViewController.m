//
//  MapAppViewController.m
//  MapApp
//
//  Created by Chen Li on 1/2/11.
//  Copyright 2011 Chen Li. All rights reserved.
//

#import "MapAppViewController.h"

@implementation MapAppViewController


/*
// The designated initializer. Override to perform setup that is required before the view is loaded.
- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil {
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
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
	
	// initialize mapView
	mapView = [[MKMapView alloc] initWithFrame:CGRectMake(100, 100, 550, 700)];
	mapView.showsUserLocation=TRUE;
	mapView.mapType=MKMapTypeStandard;
	mapView.delegate=self;
	
	// set the coordinate
	CLLocationCoordinate2D coordinate;
	coordinate.latitude = 37.31;
	coordinate.longitude = -122.03;
	mapView.region = MKCoordinateRegionMakeWithDistance(coordinate, 4000, 6000);
	[self.view insertSubview:mapView atIndex:0];
	
	// drop a pin
	Pin* aPin = [[[Pin alloc] init] autorelease];
	aPin.latitude = 37.3105;
	aPin.longitude = -122.0305;
	[mapView addAnnotation:aPin];
}


// Override to allow orientations other than the default portrait orientation.
- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation {
    return YES;
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
	[mapView release];
    [super dealloc];
}

@end
