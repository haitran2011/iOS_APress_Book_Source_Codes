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

#import "TeamViewController.h"
#import "RootViewController.h"

@implementation TeamViewController

@synthesize name, uniformColor, team, rootController;

- (id)initWithRootController:(RootViewController *)aRootController team:(NSManagedObject *)aTeam {
  if ((self = [super init])) {
    self.rootController = aRootController;
    self.team = aTeam;
  }
  return self;
}

- (void)viewDidLoad {
  [super viewDidLoad];
  if (team != nil) {
    name.text = [team valueForKey:@"name"];
    uniformColor.text = [team valueForKey:@"uniformColor"];
  }
}

- (IBAction)save:(id)sender {
  if (rootController != nil) {
    if (team != nil) {
      [team setValue:name.text forKey:@"name"];
      [team setValue:uniformColor.text forKey:@"uniformColor"];
      [rootController saveContext];
    } else {
      [rootController insertTeamWithName:name.text uniformColor:uniformColor.text];
    }
  }
  [self dismissModalViewControllerAnimated:YES];
}

- (IBAction)cancel:(id)sender {
  [self dismissModalViewControllerAnimated:YES];
}

- (void)didReceiveMemoryWarning {
    // Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
    
    // Release any cached data, images, etc. that aren't in use.
}

- (void)viewDidUnload {
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}


- (void)dealloc {
  [team release];
  [rootController release];
  [super dealloc];
}


@end
