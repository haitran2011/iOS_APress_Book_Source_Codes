//
//  DetailViewController.m
//  TextEditor
//
//  Created by Chen Li on 8/25/10.
//  Copyright Chen Li 2010. All rights reserved.
//

#import "DetailViewController.h"
#import "RootViewController.h"


@interface DetailViewController ()
@property (nonatomic, retain) UIPopoverController *popoverController;
- (void)configureView;
@end



@implementation DetailViewController

@synthesize toolbar, popoverController, detailItem, detailDescriptionLabel;
@synthesize textView, keyPadView;

#pragma mark -
#pragma mark Managing the detail item

/*
 When setting the detail item, update the view and dismiss the popover controller if it's showing.
 */
- (void)setDetailItem:(int)newDetailItem {
    if (detailItem != newDetailItem) {
        detailItem = newDetailItem;
        
		// dismiss the keypad first
		[textView resignFirstResponder];
        // Update the view.
        [self configureView];
    }

    if (popoverController != nil) {
        [popoverController dismissPopoverAnimated:YES];
    }        
}

// the keyboard has already been dismissed
- (void)configureView {
	if (detailItem==0) {
		self.textView.inputView = nil;
		self.textView.inputAccessoryView = nil;
		[[NSNotificationCenter defaultCenter] removeObserver:self];
	}
    else if (detailItem==1) {
		self.textView.inputView = self.keyPadView;
		self.textView.inputAccessoryView = nil;
		[[NSNotificationCenter defaultCenter] removeObserver:self];
	}  
	else if (detailItem==2) {
		self.textView.inputView = nil;
		self.textView.inputAccessoryView = self.keyPadView;
		[[NSNotificationCenter defaultCenter] removeObserver:self];
	}
	else {
		self.textView.inputView = nil;
		self.textView.inputAccessoryView = nil;
		[[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardDidShow:) name:UIKeyboardDidShowNotification object:nil];
		[[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillHide:) name:UIKeyboardWillHideNotification object:nil];
	}
}

// Note in the configureView method, we add self as observer only if detailItem == 4. 
- (void) keyboardDidShow:(NSNotification*)note {
	NSLog(@"keyboardDidShow");
	NSLog(@"%@",note);
	
	UIWindow* tempWindow;
	
	// UIView for the keyboard
	UIView* keyboard;
	
	NSLog(@"number of windows, %d",[[[UIApplication sharedApplication] windows] count]);
	// Check each window in our application
	for(int windowIndex = 0; windowIndex < [[[UIApplication sharedApplication] windows] count]; windowIndex ++)
	{
		// Get a reference of the current window
		tempWindow = [[[UIApplication sharedApplication] windows] objectAtIndex:windowIndex];
		
		NSLog(@"window # %d, %d subviews",windowIndex,[tempWindow.subviews count]);
		
		// Loop through all views in the current window
		for(int i = 0; i < [tempWindow.subviews count]; i++)
		{
			// current view
			keyboard = [tempWindow.subviews objectAtIndex:i];
			NSLog(@"window:%d, %@",windowIndex,[keyboard description]);
			
			// When I wrote this example, keyboard view starts with "<UIPeripheralHostView";
			// Note this may change. 
			// When the app has launched, make sure you rotate it to landscape mode;
			// In simulator, press command and left button can do the rotate. 
			if([[keyboard description] hasPrefix:@"<UIPeripheralHostView"] == YES)
			{
				// Set the Button Type.
				star = [UIButton buttonWithType:UIButtonTypeCustom];
				
				// Position the button - you need many tries to find a point. 
				// Also, the position may need changes as iOS version changes. 
				star.frame = CGRectMake(731, 268, 106, 53);
				
				// Add images to buttons.
				[star setImage:[UIImage imageNamed:@"starNormal.png"] forState:UIControlStateNormal];
				[star setImage:[UIImage imageNamed:@"starHighlighted.png"] forState:UIControlStateHighlighted];
				
				//Add the button to the keyboard
				[keyboard addSubview:star];
				
				// When the button is pressed, call the didSelectStar method
				[star addTarget:self action:@selector(didSelectStar)  forControlEvents:UIControlEventTouchUpInside];
				
				return;				
			}
		}
	}
}

- (void) keyboardWillHide:(NSNotification*)note {
	NSLog(@"keyboardWillHide");
	
	// remove the button
	[star removeFromSuperview];
}

-(void) didSelectStar {
	self.textView.text = [NSString stringWithFormat:@"%@%@ ", self.textView.text, @"*"];
}

-(IBAction) didSelectIPhone {
	self.textView.text = [NSString stringWithFormat:@"%@ %@ ", self.textView.text, @"iPhone"];
}

-(IBAction) didSelectIPad {
	self.textView.text = [NSString stringWithFormat:@"%@ %@ ", self.textView.text, @"iPad"];
}

-(IBAction) didSelectMac {
	self.textView.text = [NSString stringWithFormat:@"%@ %@ ", self.textView.text, @"Mac"];
}

-(IBAction) didSelectDismiss {
	[self.textView resignFirstResponder];
}

#pragma mark -
#pragma mark Split view support

- (void)splitViewController: (UISplitViewController*)svc willHideViewController:(UIViewController *)aViewController withBarButtonItem:(UIBarButtonItem*)barButtonItem forPopoverController: (UIPopoverController*)pc {
    
    barButtonItem.title = @"Root List";
    NSMutableArray *items = [[toolbar items] mutableCopy];
    [items insertObject:barButtonItem atIndex:0];
    [toolbar setItems:items animated:YES];
    [items release];
    self.popoverController = pc;
}


// Called when the view is shown again in the split view, invalidating the button and popover controller.
- (void)splitViewController: (UISplitViewController*)svc willShowViewController:(UIViewController *)aViewController invalidatingBarButtonItem:(UIBarButtonItem *)barButtonItem {
    
    NSMutableArray *items = [[toolbar items] mutableCopy];
    [items removeObjectAtIndex:0];
    [toolbar setItems:items animated:YES];
    [items release];
    self.popoverController = nil;
}


#pragma mark -
#pragma mark Rotation support

// Ensure that the view controller supports rotation and that the split view can therefore show in both portrait and landscape.
- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation {
    return YES;
}


#pragma mark -
#pragma mark View lifecycle

// Implement viewDidLoad to do additional setup after loading the view, typically from a nib.
- (void)viewDidLoad {
    [super viewDidLoad];
	
	[[NSBundle mainBundle] loadNibNamed:@"KeyPadView" owner:self options:nil];
}

/*
- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
}
*/
/*
- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
}
*/
/*
- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
}
*/
/*
- (void)viewDidDisappear:(BOOL)animated {
    [super viewDidDisappear:animated];
}
*/

- (void)viewDidUnload {
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
    self.popoverController = nil;
}


#pragma mark -
#pragma mark Memory management

/*
- (void)didReceiveMemoryWarning {
    // Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
    
    // Release any cached data, images, etc that aren't in use.
}
*/

- (void)dealloc {
    [popoverController release];
    [toolbar release];
    
    [detailDescriptionLabel release];
	[textView release];
	[keyPadView release];
    [super dealloc];
}

@end
