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

#import "AppDelegate.h"
#import "NoteListViewController.h"
#import "PasswordListViewController.h"

@implementation AppDelegate

@synthesize window = _window;
@synthesize tabBarController = _tabBarController;
@synthesize managedObjectContext = __managedObjectContext;
@synthesize managedObjectModel = __managedObjectModel;
@synthesize persistentStoreCoordinator = __persistentStoreCoordinator;

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
  [self loadData];
  
  self.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
  self.window.backgroundColor = [UIColor whiteColor];

  self.tabBarController = [[UITabBarController alloc] init];
  [self.window addSubview:self.tabBarController.view];

  // Add the note list tab
  NoteListViewController *noteListViewController = [[NoteListViewController alloc] initWithStyle:UITableViewStylePlain];
  UINavigationController *navNoteList = [[UINavigationController alloc] initWithRootViewController:noteListViewController];
  noteListViewController.managedObjectContext = self.managedObjectContext;
  
  // Add the password list tab
  PasswordListViewController *passwordListViewController = [[PasswordListViewController alloc] initWithStyle:UITableViewStylePlain];
  UINavigationController *navPasswordList = [[UINavigationController alloc] initWithRootViewController:passwordListViewController];
  passwordListViewController.managedObjectContext = self.managedObjectContext;
  
  [self.tabBarController setViewControllers:[NSArray arrayWithObjects:navNoteList, navPasswordList, nil]];
  
  [self.window makeKeyAndVisible];
  return YES;
}

- (void)applicationWillResignActive:(UIApplication *)application
{
  /*
   Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
   Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
   */
}

- (void)applicationDidEnterBackground:(UIApplication *)application
{
  /*
   Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later. 
   If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
   */
}

- (void)applicationWillEnterForeground:(UIApplication *)application
{
  /*
   Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
   */
}

- (void)applicationDidBecomeActive:(UIApplication *)application
{
  /*
   Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
   */
}

- (void)applicationWillTerminate:(UIApplication *)application
{
  // Saves changes in the application's managed object context before the application terminates.
  [self saveContext];
}

- (void)saveContext
{
  NSError *error = nil;
  NSManagedObjectContext *managedObjectContext = self.managedObjectContext;
  if (managedObjectContext != nil)
  {
    if ([managedObjectContext hasChanges] && ![managedObjectContext save:&error])
    {
      /*
       Replace this implementation with code to handle the error appropriately.
       
       abort() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development. If it is not possible to recover from the error, display an alert panel that instructs the user to quit the application by pressing the Home button.
       */
      NSLog(@"Unresolved error %@, %@", error, [error userInfo]);
      abort();
    } 
  }
}

#pragma mark - Core Data stack

/**
 Returns the managed object context for the application.
 If the context doesn't already exist, it is created and bound to the persistent store coordinator for the application.
 */
- (NSManagedObjectContext *)managedObjectContext
{
  if (__managedObjectContext != nil)
  {
    return __managedObjectContext;
  }
  
  NSPersistentStoreCoordinator *coordinator = [self persistentStoreCoordinator];
  if (coordinator != nil)
  {
    __managedObjectContext = [[NSManagedObjectContext alloc] init];
    [__managedObjectContext setPersistentStoreCoordinator:coordinator];
  }
  return __managedObjectContext;
}

/**
 Returns the managed object model for the application.
 If the model doesn't already exist, it is created from the application's model.
 */
- (NSManagedObjectModel *)managedObjectModel
{
  if (__managedObjectModel != nil)
  {
    return __managedObjectModel;
  }
  NSURL *modelURL = [[NSBundle mainBundle] URLForResource:@"MyStash" withExtension:@"momd"];
  __managedObjectModel = [[NSManagedObjectModel alloc] initWithContentsOfURL:modelURL];    
  return __managedObjectModel;
}

/**
 Returns the persistent store coordinator for the application.
 If the coordinator doesn't already exist, it is created and the application's store added to it.
 */
- (NSPersistentStoreCoordinator *)persistentStoreCoordinator
{
  if (__persistentStoreCoordinator != nil)
  {
    return __persistentStoreCoordinator;
  }
  __persistentStoreCoordinator = [[NSPersistentStoreCoordinator alloc] initWithManagedObjectModel:[self managedObjectModel]];
  {
    // Create the Notes persistent store
    NSURL *noteStoreURL = [[self applicationDocumentsDirectory] URLByAppendingPathComponent:@"Notes.sqlite"];
    NSError *error = nil;
    if (![__persistentStoreCoordinator addPersistentStoreWithType:NSSQLiteStoreType configuration:@"Notes" URL:noteStoreURL options:nil error:&error])
    {
      [self showCoreDataError];
    }
  }

  {
    // Create the Passwords persistent store
    NSURL *passwordStoreURL = [[self applicationDocumentsDirectory] URLByAppendingPathComponent:@"Passwords.sqlite"];
    NSError *error = nil;
    if (![__persistentStoreCoordinator addPersistentStoreWithType:NSSQLiteStoreType configuration:@"Passwords" URL:passwordStoreURL options:nil error:&error])
    {
      [self showCoreDataError];
    }
    
    // Encrypt the password database
    NSDictionary *fileAttributes = [NSDictionary dictionaryWithObject:NSFileProtectionComplete forKey:NSFileProtectionKey];
    if (![[NSFileManager defaultManager] setAttributes:fileAttributes ofItemAtPath:[passwordStoreURL path] error:&error]) 
    {
      [self showCoreDataError];
    }
  }
  
  return __persistentStoreCoordinator;
}

- (void)showCoreDataError 
{
  UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Error!" message:@"MyStash can't continue.\nPress the Home button to close MyStash." delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
  [alert show];
}

#pragma mark - Application's Documents directory

/**
 Returns the URL to the application's Documents directory.
 */
- (NSURL *)applicationDocumentsDirectory
{
  return [[[NSFileManager defaultManager] URLsForDirectory:NSDocumentDirectory inDomains:NSUserDomainMask] lastObject];
}

#pragma mark - Seed Data

- (void)loadData 
{
  // Get the version object for "category"
  NSManagedObjectContext *context = [self managedObjectContext];
  NSFetchRequest *request = [[NSFetchRequest alloc] init];
  [request setEntity:[NSEntityDescription entityForName:@"List" inManagedObjectContext:context]];
  [request setPredicate:[NSPredicate predicateWithFormat:@"name = 'category'"]];
  NSArray *results = [context executeFetchRequest:request error:nil];
  
  // Get the version number. If it doesn't exist, create it and set version to 0
  NSManagedObject *categoryVersion = nil;
  NSInteger version = 0;
  if ([results count] > 0) 
  {
    categoryVersion = (NSManagedObject *)[results objectAtIndex:0];
    version = [(NSNumber *)[categoryVersion valueForKey:@"version"] intValue];
  } 
  else 
  {
    categoryVersion = [NSEntityDescription insertNewObjectForEntityForName:@"List" inManagedObjectContext:context];
    [categoryVersion setValue:@"category" forKey:@"name"];
    [categoryVersion setValue:[NSNumber numberWithInt:0] forKey:@"version"];
  }
  
  // Create the categories to get to the latest version
  if (version < 1) 
  {
    [self addCategoryWithName:@"Web Site"];
    [self addCategoryWithName:@"Desktop Software"];
  }
  if (version < 2)
  {
    [self addCategoryWithName:@"Credit Card PIN"];
  }
  
  // Update the version number and save the context
  [categoryVersion setValue:[NSNumber numberWithInt:2] forKey:@"version"];
  [self saveContext];
}

- (NSManagedObject *)addCategoryWithName:(NSString *)name 
{
  NSManagedObject *category = [NSEntityDescription insertNewObjectForEntityForName:@"Category" inManagedObjectContext:[self managedObjectContext]];
  [category setValue:name forKey:@"name"];
  return category;
}

@end
