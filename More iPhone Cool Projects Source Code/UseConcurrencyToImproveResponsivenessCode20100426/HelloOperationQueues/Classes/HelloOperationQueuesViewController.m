//
//  HelloOperationQueuesViewController.m
//  HelloOperationQueues
//
//  Created by Danton Chin on 3/28/10.
//  Copyright  http://iphonedeveloperjournal.com/ 2010. All rights reserved.
//

#import "HelloOperationQueuesViewController.h"
#import "JobUnit.h"

@implementation HelloOperationQueuesViewController

@synthesize operationCountOutput, operationOutput;

-(IBAction)buttonPressed:(id)sender
{
	
	switch ([sender tag]) {
		case 0:
			/*
			 * get operation count button pressed
			 */
			{
				NSArray *opArray = [workQueue operations];

				[operationCountOutput setText:[NSString stringWithFormat:@"%d", [opArray count]]];
				
			}
			break;
		case 1:
			/*
			 *	Add JobA button pressed
			 */
			[self addOp:jobA];
			break;
		case 2:
			/*
			 *	Add JobB button pressed
			 */
			[self addOp:jobB];
			break;
		case 3:
			/*
			 *	Add JobC button pressed
			 */
			[self addOp:jobC];	
			break;
		default:
			break;
	}
}

-(void)addOp:(JobUnit *)job
{
	UIAlertView *alert;

	@try {
		[workQueue addOperation:job];
	}
	@catch (NSException * exception) {
		
		alert = [[UIAlertView alloc] initWithTitle:@"NSOperationQueue Error:" 
										   message:[exception reason] 
										  delegate:nil 
								 cancelButtonTitle:@"OK" 
								 otherButtonTitles:nil];
		[alert show];
		[alert release];
	}
	
}
/*
// The designated initializer. Override to perform setup that is required before the view is loaded.
- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil {
    if (self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil]) {
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


- (void)viewDidLoad {
    [super viewDidLoad];
	
	/*
	 *		create the NSOperationQueue
	 */
	
	workQueue = [[NSOperationQueue alloc] init];
	[workQueue setMaxConcurrentOperationCount:1];
	
	/*
	 *		create the NSOperation objects
	 */
	
	jobA = [[JobUnit alloc] initWithMsg:@"Welcome " dependency:nil];
	[jobA addObserver:self forKeyPath:@"isFinished" options:NSKeyValueObservingOptionNew context:nil];
	
	jobB = [[JobUnit alloc] initWithMsg:@"to " dependency:jobA];
	[jobB addObserver:self forKeyPath:@"isFinished" options:NSKeyValueObservingOptionNew context:nil];
	
	jobC = [[JobUnit alloc] initWithMsg:@"NSOperationQueues!" dependency:jobB];
	[jobC addObserver:self forKeyPath:@"isFinished" options:NSKeyValueObservingOptionNew context:nil];
	
	//[workQueue addObserver:self forKeyPath:@"operations" options:(NSKeyValueObservingOptionNew) context:NULL];
	
	[workQueue addObserver:self forKeyPath:@"operations" options:NSKeyValueObservingOptionNew context:nil];
	
	
}

-(void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary *)change context:(void *)context
{
	
	if ([keyPath isEqual:@"isFinished"])
	{
		// operation finished
		[operationOutput setText:[NSString stringWithFormat:@"%@%@",[operationOutput text], [object workMsg]]];
	}
	
	if ([keyPath isEqual:@"operations"]) {
		// number of operations changed
		[operationCountOutput setText:[NSString stringWithFormat:@"%d",[[workQueue operations] count]]];
	}

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
	[jobA	release];
	[jobB	release];
	[jobC	release];
	[workQueue	release];
    [super dealloc];
}

@end
