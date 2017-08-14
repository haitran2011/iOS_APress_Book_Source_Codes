//
// From the book Pro Core Data for iOS
// Michael Privat and Rob Warner
// Published by Apress, 2011
// Source released under the Eclipse Public License
// http://www.eclipse.org/legal/epl-v10.html
// 
// Contact information:
// Michael: @michaelprivat -- http://michaelprivat.com -- mprivat@mac.com
// Rob: @hoop33 -- http://grailbox.com -- rwarner@grailbox.com
//

#import "PerformanceTuningViewController.h"
#import "PerformanceTuningAppDelegate.h"
#import "PerformanceTest.h"
#import "FetchAllMoviesActorsAndStudiosTest.h"
#import "DidTurnIntoFaultTest.h"
#import "SinglyFiringFaultTest.h"
#import "PreFetchFaultingTest.h"
#import "CacheTest.h"
#import "UniquingTest.h"
#import "PredicatePerformanceTest.h"
#import "SubqueryTest.h"

@implementation PerformanceTuningViewController

@synthesize startTime, stopTime, elapsedTime, results, testPicker, tests;

- (void)viewDidLoad {
  [super viewDidLoad];
  
  startTime.text = @"";
  stopTime.text = @"";
  elapsedTime.text = @"";
  results.text = @"";
  
  FetchAllMoviesActorsAndStudiosTest *famaasTest = [[FetchAllMoviesActorsAndStudiosTest alloc] init];
  DidTurnIntoFaultTest *dtifTest = [[DidTurnIntoFaultTest alloc] init];
  SinglyFiringFaultTest *sffTest = [[SinglyFiringFaultTest alloc] init];
  PreFetchFaultingTest *pffTest = [[PreFetchFaultingTest alloc] init];
  CacheTest *cTest = [[CacheTest alloc] init];
  UniquingTest *uTest = [[UniquingTest alloc] init];
  PredicatePerformanceTest *ppTest = [[PredicatePerformanceTest alloc] init];
  SubqueryTest *sTest = [[SubqueryTest alloc] init];
  self.tests = [[NSArray alloc] initWithObjects:famaasTest, dtifTest, sffTest, pffTest, cTest, uTest, ppTest, sTest, nil];
  [famaasTest release];
  [dtifTest release];
  [sffTest release];
  [pffTest release];
  [cTest release];
  [uTest release];
  [ppTest release];
  [sTest release];
}

#pragma mark -
#pragma mark UIPickerViewDataSource methods

- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView {
  return 1;
}

- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component {
  return [self.tests count];
}

#pragma mark -
#pragma mark UIPickerViewDelegate methods

- (NSString *)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component {
  id <PerformanceTest> test = [self.tests objectAtIndex:row];
  return [test name];
}

#pragma mark -
#pragma mark Run the test
- (IBAction)runTest:(id)sender {
  PerformanceTuningAppDelegate *delegate = (PerformanceTuningAppDelegate *)[[UIApplication sharedApplication] delegate];
  NSManagedObjectContext *context = [delegate managedObjectContext];
  id <PerformanceTest> test = [self.tests objectAtIndex:[testPicker selectedRowInComponent:0]];
  
  NSDate *start = [NSDate date];
  results.text = [test runWithContext:context];
  NSDate *stop  = [NSDate date];
  
  startTime.text = [start description];
  stopTime.text = [stop description];
  elapsedTime.text = [NSString stringWithFormat:@"%.03f seconds", [stop timeIntervalSinceDate:start]];
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
  [tests release];
  [super dealloc];
}

@end
