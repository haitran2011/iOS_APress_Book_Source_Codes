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

#import "PlayerViewController.h"
#import "MasterViewController.h"

@implementation PlayerViewController

@synthesize firstName, lastName, email, team, player, masterController;

- (id)initWithMasterController:(MasterViewController *)aMasterController team: (NSManagedObject *)aTeam player:(NSManagedObject *)aPlayer {
  if ((self = [super init])) {
    self.masterController = aMasterController;
    self.team = aTeam;
    self.player = aPlayer;
  }
  return self;
}
- (void)didReceiveMemoryWarning
{
    // Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
    
    // Release any cached data, images, etc that aren't in use.
}

- (IBAction)save:(id)sender {
  if (masterController != nil) {
    if (player != nil) {
      [player setValue:firstName.text forKey:@"firstName"];
      [player setValue:lastName.text forKey:@"lastName"];
      [player setValue:email.text forKey:@"email"];
      [masterController saveContext];
    } else {
      [masterController insertPlayerWithTeam:team firstName:firstName.text lastName:lastName.text email:email.text];
    }
  }
  [self dismissModalViewControllerAnimated:YES];
}

- (IBAction)confirmDelete:(id)sender {
  if (player != nil) {
    UIActionSheet *confirm = [[UIActionSheet alloc] initWithTitle:nil delegate:self cancelButtonTitle:@"Cancel" destructiveButtonTitle:@"Delete Player" otherButtonTitles:nil];
    confirm.actionSheetStyle = UIActionSheetStyleBlackTranslucent;
    [confirm showInView:self.view];
  }
}
- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex {
  if (buttonIndex == 0 && masterController != nil) {
    // The Delete button was clicked
    [masterController deletePlayer:player];
    [self dismissModalViewControllerAnimated:YES];
  }
}

- (IBAction)cancel:(id)sender {
  [self dismissModalViewControllerAnimated:YES];
}

#pragma mark - View lifecycle

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
  if (player != nil) {
    firstName.text = [player valueForKey:@"firstName"];
    lastName.text = [player valueForKey:@"lastName"];
    email.text = [player valueForKey:@"email"];
  }
}

- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    // Return YES for supported orientations
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

@end
