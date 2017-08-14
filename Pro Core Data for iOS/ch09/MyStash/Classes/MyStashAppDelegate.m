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

#import "MyStashAppDelegate.h"
#import "NoteListViewController.h"
#import "PasswordListViewController.h"

@implementation MyStashAppDelegate

@synthesize window, tabBarController;

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
  [self loadData];
  
  NoteListViewController *noteListViewController = [[NoteListViewController alloc] initWithStyle:UITableViewStylePlain];
  noteListViewController.managedObjectContext = self.managedObjectContext;
  UINavigationController *navNoteController = [[[UINavigationController alloc] initWithRootViewController:noteListViewController] autorelease];
  [noteListViewController release];
  
  PasswordListViewController *passwordListViewController = [[PasswordListViewController alloc] initWithStyle:UITableViewStylePlain];
  passwordListViewController.managedObjectContext = self.managedObjectContext;
  UINavigationController *navPasswordController = [[[UINavigationController alloc] initWithRootViewController:passwordListViewController] autorelease];
  [passwordListViewController release];
  
  [tabBarController setViewControllers:[NSArray arrayWithObjects:navNoteController, navPasswordController, nil]];
  [window addSubview:tabBarController.view];
  [window makeKeyAndVisible];
  return YES;
}

- (void)dealloc {
  [tabBarController release];
  [window release];
  [super dealloc];
}

#pragma mark -
#pragma mark Core Data stack

- (NSManagedObjectModel *)managedObjectModel {    
  if (managedObjectModel_ != nil) {
    return managedObjectModel_;
  }
  managedObjectModel_ = [[NSManagedObjectModel mergedModelFromBundles:nil] retain];   
  return managedObjectModel_;
}

- (NSPersistentStoreCoordinator *)persistentStoreCoordinator {
  
  if (persistentStoreCoordinator_ != nil) {
    return persistentStoreCoordinator_;
  }
  
  persistentStoreCoordinator_ = [[NSPersistentStoreCoordinator alloc] initWithManagedObjectModel:[self managedObjectModel]];
  
  {
    NSURL *passwordStoreURL = [NSURL fileURLWithPath: [[self applicationDocumentsDirectory] stringByAppendingPathComponent: @"Passwords.sqlite"]];
    
    NSError *error = nil;
    if (![persistentStoreCoordinator_ addPersistentStoreWithType:NSSQLiteStoreType configuration:@"Passwords" URL:passwordStoreURL options:nil error:&error]) {
      [self showCoreDataError];
    }
    
    NSDictionary *fileAttributes = [NSDictionary dictionaryWithObject:NSFileProtectionComplete forKey:NSFileProtectionKey];
    if(![[NSFileManager defaultManager] setAttributes:fileAttributes ofItemAtPath:[passwordStoreURL path] error: &error]) {
      [self showCoreDataError];
    }
  }
  
  {
    NSURL *notesStoreURL = [NSURL fileURLWithPath: [[self applicationDocumentsDirectory] stringByAppendingPathComponent: @"Notes.sqlite"]];
    
    NSError *error = nil;
    if (![persistentStoreCoordinator_ addPersistentStoreWithType:NSSQLiteStoreType configuration:@"Notes" URL:notesStoreURL options:nil error:&error]) {
      [self showCoreDataError];
    }    
  }
  
  return persistentStoreCoordinator_;
}

- (NSManagedObjectContext *)managedObjectContext {    
  if (managedObjectContext_ != nil) {
    return managedObjectContext_;
  }
  
  NSPersistentStoreCoordinator *coordinator = [self persistentStoreCoordinator];
  if (coordinator != nil) {
    managedObjectContext_ = [[NSManagedObjectContext alloc] init];
    [managedObjectContext_ setPersistentStoreCoordinator:coordinator];
  }
  return managedObjectContext_;
}

#pragma mark -
#pragma mark Application's Documents directory

/**
 Returns the path to the application's Documents directory.
 */
- (NSString *)applicationDocumentsDirectory {
  return [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) lastObject];
}

#pragma mark -
#pragma mark Seed Data

- (void)loadData {
  // Get the version object for "category"
  NSManagedObjectContext *context = [self managedObjectContext];
  NSFetchRequest *request = [[NSFetchRequest alloc] init];
  [request setEntity:[NSEntityDescription entityForName:@"List" inManagedObjectContext:context]];
  [request setPredicate:[NSPredicate predicateWithFormat:@"name = 'category'"]];
  NSArray *results = [context executeFetchRequest:request error:nil];
  [request release];
  
  // Get the version number. If it doesn't exist, create it and set version to 0
  NSManagedObject *categoryVersion = nil;
  NSInteger version = 0;
  if ([results count] > 0) {
    categoryVersion = (NSManagedObject *)[results objectAtIndex:0];
    version = [(NSNumber *)[categoryVersion valueForKey:@"version"] intValue];
  } else {
    categoryVersion = [NSEntityDescription insertNewObjectForEntityForName:@"List" inManagedObjectContext:context];
    [categoryVersion setValue:@"category" forKey:@"name"];
    [categoryVersion setValue:[NSNumber numberWithInt:0] forKey:@"version"];
  }
  
  // Create the categories to get to the latest version
  if (version < 1) {
    [self addCategoryWithName:@"Web Site"];
    [self addCategoryWithName:@"Desktop Software"];
  }
  if (version < 2) {
    [self addCategoryWithName:@"Credit Card PIN"];
  }
  
  // Update the version number and save the context
  [categoryVersion setValue:[NSNumber numberWithInt:2] forKey:@"version"];
  [self saveContext];
}

- (NSManagedObject *)addCategoryWithName:(NSString *)name {
  NSManagedObject *category = [NSEntityDescription insertNewObjectForEntityForName:@"Category" inManagedObjectContext:[self managedObjectContext]];
  [category setValue:name forKey:@"name"];
  return category;
}

- (void)saveContext {
  NSManagedObjectContext *context = [self managedObjectContext];
  NSError *error = nil;
  if (![context save:&error]) {
    NSLog(@"Unresolved error %@, %@", error, [error userInfo]);
    abort();
  }
}

- (void)showCoreDataError {
  UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Error!" message:@"MyStash can't continue.\nPress the Home button to close MyStash." delegate:nil cancelButtonTitle:nil otherButtonTitles:@"OK", nil];
  [alert show];
  [alert release];
}

@end
