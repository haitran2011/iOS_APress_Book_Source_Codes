//
// From the book Pro Core Data for iOS, 2nd Edition
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
#import "MasterViewController.h"

@implementation TeamViewController

@synthesize name;
@synthesize uniformColor;
@synthesize team;
@synthesize masterController;

- (id)initWithMasterController:(MasterViewController *)aMasterController team: (NSManagedObject *)aTeam {
  if ((self = [super init])) {
    self.masterController = aMasterController;
    self.team = aTeam;
  }
  return self;
}


- (void)didReceiveMemoryWarning {
  [super didReceiveMemoryWarning];
}

#pragma mark - View lifecycle

- (void)viewDidLoad {
  [super viewDidLoad];
  if (team != nil) {
    name.text = [team valueForKey:@"name"];
    uniformColor.text = [team valueForKey:@"uniformColor"];
  }
}

- (void)viewDidUnload {
  [super viewDidUnload];
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation {
  return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

#pragma mark - Button handlers

- (IBAction)save:(id)sender {
  if (masterController != nil) {
    if (team != nil) {
      [team setValue:name.text forKey:@"name"];
      [team setValue:uniformColor.text forKey:@"uniformColor"];
      [masterController saveContext];
    } else {
      [masterController insertTeamWithName:name.text uniformColor:uniformColor.text];
    }
  }
  [self dismissModalViewControllerAnimated:YES];
}

- (IBAction)cancel:(id)sender {
  [self dismissModalViewControllerAnimated:YES];
}

@end
