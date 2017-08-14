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

#import "PlayerViewController.h"
#import "RootViewController.h"

@implementation PlayerViewController

@synthesize firstName, lastName, email, team, player, rootController;

- (id)initWithRootController:(RootViewController *)aRootController team:(NSManagedObject *)aTeam player:(NSManagedObject *)aPlayer {
  if ((self = [super init])) {
    self.rootController = aRootController;
    self.team = aTeam;
    self.player = aPlayer;
  }
  return self;
}

- (void)viewDidLoad {
  [super viewDidLoad];
  if (player != nil) {
    firstName.text = [player valueForKey:@"firstName"];
    lastName.text = [player valueForKey:@"lastName"];
    email.text = [player valueForKey:@"email"];
  }
}

- (IBAction)save:(id)sender {
  if (rootController != nil) {
    if (player != nil) {
      [player setValue:firstName.text forKey:@"firstName"];
      [player setValue:lastName.text forKey:@"lastName"];
      [player setValue:email.text forKey:@"email"];
      [rootController saveContext];
    } else {
      [rootController insertPlayerWithTeam:team firstName:firstName.text lastName:lastName.text email:email.text];
    }
  }
  [self dismissModalViewControllerAnimated:YES];
}

- (IBAction)cancel:(id)sender {
  [self dismissModalViewControllerAnimated:YES];
}

- (IBAction)confirmDelete:(id)sender {
  if (player != nil) {
    UIActionSheet *confirm = [[UIActionSheet alloc] initWithTitle:nil delegate:self cancelButtonTitle:@"Cancel" destructiveButtonTitle:@"Delete Player" otherButtonTitles:nil];
    confirm.actionSheetStyle = UIActionSheetStyleBlackTranslucent;
    [confirm showInView:self.view];
    [confirm release];
  }
}

- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex {
  if (buttonIndex == 0 && rootController != nil) {
    // The Delete button was clicked
    [rootController deletePlayer:player];
    [self dismissModalViewControllerAnimated:YES];
  }
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
  [player release];
  [rootController release];
  [super dealloc];
}


@end
