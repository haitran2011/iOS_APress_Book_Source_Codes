#import "OpenglAppDelegate.h"
#import "EAGLView.h"
#import "EAGLViewController.h"

@implementation OpenglAppDelegate

@synthesize window;
@synthesize mainViewController;

- (void) applicationDidFinishLaunching:(UIApplication *)application
{
  EAGLViewController *aController = [[EAGLViewController alloc] initWithNibName:@"EAGLView" bundle:nil];
	self.mainViewController = aController;
	[aController release];
	
  mainViewController.view.frame = [UIScreen mainScreen].applicationFrame;
	[window addSubview:[mainViewController view]];
  [window makeKeyAndVisible];
}

- (void) dealloc
{
	[window release];
	[super dealloc];
}

@end
