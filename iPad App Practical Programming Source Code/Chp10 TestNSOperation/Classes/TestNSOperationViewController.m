//
//  TestNSOperationViewController.m
//  TestNSOperation
//
//  Created by Chen Li on 10/7/10.
//  Copyright 2010 Chen Li. All rights reserved.
//

#import "TestNSOperationViewController.h"
#import "Sub.h"

@implementation TestNSOperationViewController



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


// Open up console, see the output. The 4 tasks are not executed sequentially; instead, they're executed concurrently. 
- (void)viewDidLoad {
    [super viewDidLoad];
	
	NSOperationQueue* queue = [[[NSOperationQueue alloc] init] autorelease];
	[queue setMaxConcurrentOperationCount:4];
	
	Sub* job1 = [[[Sub alloc] init] autorelease];
	job1.numberToPrint = 1;
	Sub* job2 = [[[Sub alloc] init] autorelease];
	job2.numberToPrint = 2;
	Sub* job3 = [[[Sub alloc] init] autorelease];
	job3.numberToPrint = 3;
	Sub* job4 = [[[Sub alloc] init] autorelease];
	job4.numberToPrint = 4;
	
	[queue addOperation:job1];
	[queue addOperation:job2];
	[queue addOperation:job3];
	[queue addOperation:job4];
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
	// Release any retained subviews of the main view.
	// e.g. self.myOutlet = nil;
}


- (void)dealloc {
    [super dealloc];
}

@end
