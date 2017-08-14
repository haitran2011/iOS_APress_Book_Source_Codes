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

#import "PlayerListViewController.h"
#import "RootViewController.h"
#import "PlayerViewController.h"

@implementation PlayerListViewController

@synthesize rootController, team;

- (id)initWithRootController:(RootViewController *)aRootController team:(NSManagedObject *)aTeam {
  if ((self = [super init])) {
    self.rootController = aRootController;
    self.team = aTeam;
  }
  return self;
}

#pragma mark -
#pragma mark View lifecycle

- (void)viewDidLoad {
  [super viewDidLoad];
  
  self.title = @"Players";
  
  UIBarButtonItem *addButton = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemAdd target:self action:@selector(showPlayerView)];
  self.navigationItem.rightBarButtonItem = addButton;
  [addButton release];
}

- (void)showPlayerView {
  PlayerViewController *playerViewController = [[PlayerViewController alloc] initWithRootController:rootController team:team player:nil];
  [self presentModalViewController:playerViewController animated:YES];
  [playerViewController release];  
}

- (void)viewWillAppear:(BOOL)animated {
  [super viewWillAppear:animated];
  [self.tableView reloadData];
}

#pragma mark -
#pragma mark Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
  return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
  return [(NSSet *)[team valueForKey:@"players"] count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
  static NSString *CellIdentifier = @"PlayerCell";
  
  UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
  if (cell == nil) {
    cell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:CellIdentifier] autorelease];
  }
  
  NSManagedObject *player = [[self sortPlayers] objectAtIndex:indexPath.row];
  cell.textLabel.text = [NSString stringWithFormat:@"%@ %@", [[player valueForKey:@"firstName"] description], [[player valueForKey:@"lastName"] description]];
  cell.detailTextLabel.text = [[player valueForKey:@"email"] description];
  return cell;
}

- (NSArray *)sortPlayers {
  NSSortDescriptor *sortLastNameDescriptor = [[[NSSortDescriptor alloc] initWithKey:@"lastName" ascending:YES] autorelease];
  NSArray *sortDescriptors = [NSArray arrayWithObjects:sortLastNameDescriptor, nil];
  return [[(NSSet *)[team valueForKey:@"players"] allObjects] sortedArrayUsingDescriptors:sortDescriptors];
}

#pragma mark -
#pragma mark Table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
  NSManagedObject *player = [[self sortPlayers] objectAtIndex:indexPath.row];
  PlayerViewController *playerViewController = [[PlayerViewController alloc] initWithRootController:rootController team:team player:player];
  [self presentModalViewController:playerViewController animated:YES];
  [playerViewController release];
}

#pragma mark -
#pragma mark Memory management

- (void)didReceiveMemoryWarning {
    // Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
    
    // Relinquish ownership any cached data, images, etc. that aren't in use.
}

- (void)viewDidUnload {
    // Relinquish ownership of anything that can be recreated in viewDidLoad or on demand.
    // For example: self.myOutlet = nil;
}


- (void)dealloc {
  [rootController release];
  [team release];
  [super dealloc];
}


@end

