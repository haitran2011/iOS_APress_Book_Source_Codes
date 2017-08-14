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

#import "PasswordListViewController.h"
#import "PasswordViewController.h"

@interface PasswordListViewController()
- (void)configureCell:(UITableViewCell *)cell atIndexPath:(NSIndexPath *)indexPath;
@end

@implementation PasswordListViewController

@synthesize fetchedResultsController, managedObjectContext;

#pragma mark -
#pragma mark Initialization

- (id)initWithStyle:(UITableViewStyle)style {
  if ((self = [super initWithStyle:style])) {
    self.title = @"Passwords";
    self.tabBarItem.image = [UIImage imageNamed:@"password"];
  }
  return self;
}

#pragma mark -
#pragma mark View lifecycle

- (void)viewDidLoad {
  [super viewDidLoad];
  
  self.navigationItem.leftBarButtonItem = self.editButtonItem;
  
  UIBarButtonItem *addButton = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemAdd target:self action:@selector(showPasswordView)];
  self.navigationItem.rightBarButtonItem = addButton;
  [addButton release];
}

- (void)showPasswordView {
  PasswordViewController *passwordViewController = [[PasswordViewController alloc] initWithParentController:self system:nil];
  [self presentModalViewController:passwordViewController animated:YES];
  [passwordViewController release];
}

- (NSManagedObject *)insertPasswordWithName:(NSString *)name userId:(NSString *)userId password:(NSString *)password {
  NSManagedObjectContext *context = [fetchedResultsController managedObjectContext];
  NSEntityDescription *entity = [[fetchedResultsController fetchRequest] entity];
  NSManagedObject *newPassword = [NSEntityDescription insertNewObjectForEntityForName:[entity name] inManagedObjectContext:context];
  
  [newPassword setValue:name forKey:@"name"];
  [newPassword setValue:userId forKey:@"userId"];
  [newPassword setValue:password forKey:@"password"];
  
  return newPassword;
}

#pragma mark -
#pragma mark Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
  return [[self.fetchedResultsController sections] count];
}


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
  id <NSFetchedResultsSectionInfo> sectionInfo = [[fetchedResultsController sections] objectAtIndex:section];
  return [sectionInfo numberOfObjects];
}


// Customize the appearance of table view cells.
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
  static NSString *CellIdentifier = @"PasswordCell";
  
  UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
  if (cell == nil) {
    cell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier] autorelease];
  }
  [self configureCell:cell atIndexPath:indexPath];
  return cell;
}

- (void)configureCell:(UITableViewCell *)cell atIndexPath:(NSIndexPath *)indexPath {
  NSManagedObject *system = [self.fetchedResultsController objectAtIndexPath:indexPath];
  cell.textLabel.text = [system valueForKey:@"name"];
  
  // Register this object for KVO
  [system addObserver:self forKeyPath:@"name" options:NSKeyValueObservingOptionOld | NSKeyValueObservingOptionNew context:nil];
}

#pragma mark -
#pragma mark KVO Notifications

- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object
                        change:(NSDictionary *)change context:(void *)context {
  NSLog(@"Changed value for %@: %@ -> %@", keyPath,
        [change objectForKey:NSKeyValueChangeOldKey],
        [change objectForKey:NSKeyValueChangeNewKey]);
}

#pragma mark -
#pragma mark Table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
  NSManagedObject *system = [[self fetchedResultsController] objectAtIndexPath:indexPath];
  
  PasswordViewController *passwordViewController = [[PasswordViewController alloc] initWithParentController:self system:system];
  [self presentModalViewController:passwordViewController animated:YES];
  [passwordViewController release];
}

- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
  if (editingStyle == UITableViewCellEditingStyleDelete) {
    // Delete the managed object for the given index path
    NSManagedObjectContext *context = [self.fetchedResultsController managedObjectContext];
    [context deleteObject:[self.fetchedResultsController objectAtIndexPath:indexPath]];
    
    // Save the context.
    [self saveContext];
  }   
}

- (NSString *)saveContext {
  NSString *errorText = nil;
  NSManagedObjectContext *context = [fetchedResultsController managedObjectContext];
  NSError *error = nil;
  if (![context save:&error]) {
    errorText = [self validationErrorText:error];
  }
  return errorText;
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
  [fetchedResultsController release];
  [managedObjectContext release];
  [super dealloc];
}

#pragma mark -
#pragma mark Fetched results controller

- (NSFetchedResultsController *)fetchedResultsController {
  if (fetchedResultsController != nil) {
    return fetchedResultsController;
  }
  
  // Create the fetch request for the entity.
  NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] init];
  NSEntityDescription *entity = [NSEntityDescription entityForName:@"System" inManagedObjectContext:self.managedObjectContext];
  [fetchRequest setEntity:entity];
  
  // Set the batch size
  [fetchRequest setFetchBatchSize:10];
  
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
  
  // Clean up
  [aFetchedResultsController release];
  [fetchRequest release];
  [sortDescriptor release];
  [sortDescriptors release];
  
  // Fetch the results into the fetched results controller
	NSError *error = nil;
	if (![[self fetchedResultsController] performFetch:&error]) {
    NSLog(@"Unresolved error %@, %@", error, [error userInfo]);
    abort();
	}
  return fetchedResultsController;
}    

#pragma mark -
#pragma mark Fetched results controller delegate

- (void)controllerWillChangeContent:(NSFetchedResultsController *)controller {
  [self.tableView beginUpdates];
}

- (void)controllerDidChangeContent:(NSFetchedResultsController *)controller {
  [self.tableView endUpdates];
}

- (void)controller:(NSFetchedResultsController *)controller didChangeObject:(id)anObject
       atIndexPath:(NSIndexPath *)indexPath forChangeType:(NSFetchedResultsChangeType)type
      newIndexPath:(NSIndexPath *)newIndexPath {
  UITableView *tableView = self.tableView;
  switch(type) {
      // An object has been added (inserted)
    case NSFetchedResultsChangeInsert:
      [tableView insertRowsAtIndexPaths:[NSArray arrayWithObject:newIndexPath] withRowAnimation:UITableViewRowAnimationFade];
      break;
      // An object has been deleted
    case NSFetchedResultsChangeDelete:
      [tableView deleteRowsAtIndexPaths:[NSArray arrayWithObject:indexPath] withRowAnimation:UITableViewRowAnimationFade];
      break;
      // An object has been updated (edited)
    case NSFetchedResultsChangeUpdate:
      [self configureCell:[tableView cellForRowAtIndexPath:indexPath] atIndexPath:indexPath];
      break;
      // An object has been moved
    case NSFetchedResultsChangeMove:
      [tableView deleteRowsAtIndexPaths:[NSArray arrayWithObject:indexPath] withRowAnimation:UITableViewRowAnimationFade];
      [tableView insertRowsAtIndexPaths:[NSArray arrayWithObject:newIndexPath]withRowAnimation:UITableViewRowAnimationFade];
      break;
  }
}

#pragma mark -
#pragma mark Validation Error Handling

- (NSString *)validationErrorText:(NSError *)error {
  // Create a string to hold all the error messages
  NSMutableString *errorText = [NSMutableString stringWithCapacity:100];
  
  // Determine whether we're dealing with a single error or multiples, and put them all in an array
  NSArray *errors = [error code] == NSValidationMultipleErrorsError ? [[error userInfo] objectForKey:NSDetailedErrorsKey] : [NSArray arrayWithObject:error];
  
  // Iterate through the errors
  for (NSError *err in errors) {
    // Get the property that had a validation error
    NSString *propName = [[err userInfo] objectForKey:@"NSValidationErrorKey"];
    NSString *message;
    // Form an appropriate error message
    switch ([err code]) {
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
    if ([errorText length] > 0) {
      [errorText appendString:@"\n"];
    }
    [errorText appendString:message];
  }
  return errorText;
}

@end
