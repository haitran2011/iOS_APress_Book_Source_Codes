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

#import "PasswordListViewController.h"
#import "PasswordViewController.h"

@interface PasswordListViewController(private)
- (void)configureCell:(UITableViewCell *)cell atIndexPath:(NSIndexPath *)indexPath;
@end

@implementation PasswordListViewController

@synthesize fetchedResultsController;
@synthesize managedObjectContext;

- (id)initWithStyle:(UITableViewStyle)style
{
  self = [super initWithStyle:style];
  if (self) {
    self.title = @"Passwords";
    self.tabBarItem.image = [UIImage imageNamed:@"password"];
  }
  return self;
}

- (void)didReceiveMemoryWarning
{
  // Releases the view if it doesn't have a superview.
  [super didReceiveMemoryWarning];
  
  // Release any cached data, images, etc that aren't in use.
}

#pragma mark - View lifecycle

- (void)viewDidLoad
{
  [super viewDidLoad];
  
  self.navigationItem.leftBarButtonItem = self.editButtonItem;
  
  UIBarButtonItem *addButton = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemAdd target:self action:@selector(showPasswordView)];
  self.navigationItem.rightBarButtonItem = addButton;
}

- (void)viewDidUnload
{
  [super viewDidUnload];
  // Release any retained subviews of the main view.
  // e.g. self.myOutlet = nil;
}

- (void)viewWillAppear:(BOOL)animated
{
  [super viewWillAppear:animated];
}

- (void)viewDidAppear:(BOOL)animated
{
  [super viewDidAppear:animated];
}

- (void)viewWillDisappear:(BOOL)animated
{
  [super viewWillDisappear:animated];
}

- (void)viewDidDisappear:(BOOL)animated
{
  [super viewDidDisappear:animated];
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
  // Return YES for supported orientations
  return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
  return [[self.fetchedResultsController sections] count];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
  id <NSFetchedResultsSectionInfo> sectionInfo = [[fetchedResultsController sections] objectAtIndex:section];
  return [sectionInfo numberOfObjects];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
  static NSString *CellIdentifier = @"PasswordCell";
  
  UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
  if (cell == nil) 
  {
    cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
  }
  [self configureCell:cell atIndexPath:indexPath];
  return cell;
}

- (void)controller:(NSFetchedResultsController *)controller didChangeObject:(id)anObject atIndexPath:(NSIndexPath *)indexPath forChangeType:(NSFetchedResultsChangeType)type newIndexPath:(NSIndexPath *)newIndexPath 
{  
  switch(type) 
  {
    case NSFetchedResultsChangeInsert:
      [self.tableView insertRowsAtIndexPaths:[NSArray arrayWithObject:newIndexPath] withRowAnimation:UITableViewRowAnimationFade];
      break;
    case NSFetchedResultsChangeDelete:
      [self.tableView deleteRowsAtIndexPaths:[NSArray arrayWithObject:indexPath] withRowAnimation:UITableViewRowAnimationFade];
      break;
    case NSFetchedResultsChangeUpdate:
      [self configureCell:[self.tableView cellForRowAtIndexPath:indexPath] atIndexPath:indexPath];
      break;
    case NSFetchedResultsChangeMove:
      [self.tableView deleteRowsAtIndexPaths:[NSArray arrayWithObject:indexPath] withRowAnimation:UITableViewRowAnimationFade];
      [self.tableView insertRowsAtIndexPaths:[NSArray arrayWithObject:newIndexPath] withRowAnimation:UITableViewRowAnimationFade];
      break;
  }
}

- (void)configureCell:(UITableViewCell *)cell atIndexPath:(NSIndexPath *)indexPath 
{
  NSManagedObject *system = [self.fetchedResultsController objectAtIndexPath:indexPath];
  cell.textLabel.text = [system valueForKey:@"name"];
  
  // Register this object for KVO
  [system addObserver:self forKeyPath:@"name" options:NSKeyValueObservingOptionOld | NSKeyValueObservingOptionNew context:nil];
}

- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
  if (editingStyle == UITableViewCellEditingStyleDelete) 
  {
    [[self.fetchedResultsController managedObjectContext] deleteObject:[self.fetchedResultsController objectAtIndexPath:indexPath]];
    [self saveContext];
  }   
}

- (NSString *)saveContext {
  NSString *errorText = nil;
  NSError *error = nil;
  if(![[self.fetchedResultsController managedObjectContext] save:&error]) 
  {
    errorText = [self validationErrorText:error];
  }
  return errorText;
}

/*
 // Override to support conditional editing of the table view.
 - (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath
 {
 // Return NO if you do not want the specified item to be editable.
 return YES;
 }
 */

/*
 // Override to support editing the table view.
 - (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
 {
 if (editingStyle == UITableViewCellEditingStyleDelete) {
 // Delete the row from the data source
 [tableView deleteRowsAtIndexPaths:[NSArray arrayWithObject:indexPath] withRowAnimation:UITableViewRowAnimationFade];
 }   
 else if (editingStyle == UITableViewCellEditingStyleInsert) {
 // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
 }   
 }
 */

/*
 // Override to support rearranging the table view.
 - (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)fromIndexPath toIndexPath:(NSIndexPath *)toIndexPath
 {
 }
 */

/*
 // Override to support conditional rearranging of the table view.
 - (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath
 {
 // Return NO if you do not want the item to be re-orderable.
 return YES;
 }
 */

#pragma mark - Table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
  NSManagedObject *system = [[self fetchedResultsController] objectAtIndexPath:indexPath];
  
  PasswordViewController *passwordViewController = [[PasswordViewController alloc] initWithParentController:self system:system];
  [self presentModalViewController:passwordViewController animated:YES];
}

#pragma mark -
#pragma mark Fetched results controller

- (NSFetchedResultsController *)fetchedResultsController 
{
  if (fetchedResultsController != nil) 
  {
    return fetchedResultsController;
  }
  
  // Create the fetch request for the entity.
  NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] init];
  NSEntityDescription *entity = [NSEntityDescription entityForName:@"System" inManagedObjectContext:self.managedObjectContext];
  [fetchRequest setEntity:entity];
  
  // Set the batch size
  [fetchRequest setFetchBatchSize:20];
  
  // Sort by note title, ascending
  NSSortDescriptor *sortDescriptor = [[NSSortDescriptor alloc] initWithKey:@"name" ascending:YES];
  NSArray *sortDescriptors = [[NSArray alloc] initWithObjects:sortDescriptor, nil];
  [fetchRequest setSortDescriptors:sortDescriptors];
  
  // Create the fetched results controller using the
  // fetch request we just created, and with the managed
  // object context member, and set this controller to
  // be the delegate
  NSFetchedResultsController *aFetchedResultsController = [[NSFetchedResultsController alloc] initWithFetchRequest:fetchRequest managedObjectContext:managedObjectContext sectionNameKeyPath:nil cacheName:@"System"];
  aFetchedResultsController.delegate = self;
  self.fetchedResultsController = aFetchedResultsController;
  
  // Fetch the results into the fetched results controller
	NSError *error = nil;
	if (![[self fetchedResultsController] performFetch:&error]) 
  {
    NSLog(@"Unresolved error %@, %@", error, [error userInfo]);
    abort();
	}
  return fetchedResultsController;
}

#pragma mark -
#pragma mark Fetched results controller delegate

- (void)controllerWillChangeContent:(NSFetchedResultsController *)controller 
{
  [self.tableView beginUpdates];
}

- (void)controllerDidChangeContent:(NSFetchedResultsController *)controller 
{
  [self.tableView endUpdates];
}

- (void)controller:(NSFetchedResultsController *)controller didChangeSection:(id <NSFetchedResultsSectionInfo>)sectionInfo atIndex:(NSUInteger)sectionIndex forChangeType:(NSFetchedResultsChangeType)type 
{
  switch(type) 
  {
    case NSFetchedResultsChangeInsert:
      [self.tableView insertSections:[NSIndexSet indexSetWithIndex:sectionIndex] withRowAnimation:UITableViewRowAnimationFade];
      break;
    case NSFetchedResultsChangeDelete:
      [self.tableView deleteSections:[NSIndexSet indexSetWithIndex:sectionIndex] withRowAnimation:UITableViewRowAnimationFade];
      break;
  }
}

- (void)showPasswordView 
{
  PasswordViewController *passwordViewController = [[PasswordViewController alloc] initWithParentController:self system:nil];
  [self presentModalViewController:passwordViewController animated:YES];
}

- (NSManagedObject *)insertPasswordWithName:(NSString *)name userId:(NSString *)userId password:(NSString *)password 
{
  NSManagedObjectContext *context = [fetchedResultsController managedObjectContext];
  NSEntityDescription *entity = [[fetchedResultsController fetchRequest] entity];
  NSManagedObject *newPassword = [NSEntityDescription insertNewObjectForEntityForName:[entity name] inManagedObjectContext:context];
  
  [newPassword setValue:name forKey:@"name"];
  [newPassword setValue:userId forKey:@"userId"];
  [newPassword setValue:password forKey:@"password"];
  
  return newPassword;
}

- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object
                        change:(NSDictionary *)change context:(void *)context {
  NSLog(@"Changed value for %@: %@ -> %@", keyPath,
        [change objectForKey:NSKeyValueChangeOldKey],
        [change objectForKey:NSKeyValueChangeNewKey]);
}

#pragma mark - Validation Error Handling

- (NSString *)validationErrorText:(NSError *)error 
{
  // Create a string to hold all the error messages
  NSMutableString *errorText = [NSMutableString stringWithCapacity:100];
  
  // Determine whether we're dealing with a single error or multiples, and put them all
  // in an array
  NSArray *errors = [error code] == NSValidationMultipleErrorsError ? [[error userInfo] objectForKey:NSDetailedErrorsKey] : [NSArray arrayWithObject:error];
  
  // Iterate through the errors
  for (NSError *err in errors) 
  {
    // Get the property that had a validation error
    NSString *propName = [[err userInfo] objectForKey:@"NSValidationErrorKey"];
    NSString *message;
    // Form an appropriate error message
    switch ([err code]) 
    {
      case NSValidationMissingMandatoryPropertyError:
        message = [NSString stringWithFormat:@"%@ required", propName];
        break;
      case NSValidationStringTooShortError:
        message = [NSString stringWithFormat:@"%@ must be at least %d characters", propName, 3];
        break;
      case NSValidationStringTooLongError:
        message = [NSString stringWithFormat:@"%@ can't be longer than %d characters", propName, 10];
        break;
      case NSValidationStringPatternMatchingError:
        message = [NSString stringWithFormat:@"%@ can contain only letters and numbers", propName];
        break;
      default:
        message = @"Unknown error. Press Home button to halt.";
        break;
    }
    // Separate the error messages with line feeds
    if ([errorText length] > 0) 
    {
      [errorText appendString:@"\n"];
    }
    [errorText appendString:message];
  }
  return errorText;
}

@end
