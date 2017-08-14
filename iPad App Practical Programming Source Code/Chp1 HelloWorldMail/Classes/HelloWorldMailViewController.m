//
//  HelloWorldMailViewController.m
//  HelloWorldMail
//
//  Created by Chen Li on 8/1/10.
//  Copyright 2010 Chen Li. All rights reserved.
//

// View controller is the "C" in the "MVC" design pattern.
// It is of great importance to an iOS app. It tells the view how to display and what to display. 
// It also talks to the model to fetch data, and serve these data to the views. 

#import "HelloWorldMailViewController.h"

@implementation HelloWorldMailViewController


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


/*
// Implement viewDidLoad to do additional setup after loading the view, typically from a nib.
- (void)viewDidLoad {
    [super viewDidLoad];
}
*/

// IBAction means this method is triggered by a user action; and you can find it out in the HelloWorldMailViewController.xib file. 
-(IBAction) didClickButton {
	// Before sending email, try to make sure the device is able to do it
	if ([MFMailComposeViewController canSendMail]) {
		// MFMailComposeViewController is another view controller, manages another view. 
		MFMailComposeViewController *picker = [[MFMailComposeViewController alloc] init];
		picker.mailComposeDelegate = self;
		
		[picker setSubject:@"Hello World from my iPad app!"];
		
		NSString *emailBody = @"Hey, <br /> <br /> \
		this is from my first iPad app!";
		[picker setMessageBody:emailBody isHTML:YES];
		
		[self presentModalViewController:picker animated:YES];
		[picker release];
		
		// add a button
		UIButton* button = [UIButton buttonWithType:UIButtonTypeInfoLight];
		button.center = CGPointMake(50, 20);
		[self.view addSubview:button];
	}
}

- (void)mailComposeController:(MFMailComposeViewController*)controller didFinishWithResult:(MFMailComposeResult)result error:(NSError*)error {
	[self dismissModalViewControllerAnimated:YES];
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
    [super dealloc];
}

@end
