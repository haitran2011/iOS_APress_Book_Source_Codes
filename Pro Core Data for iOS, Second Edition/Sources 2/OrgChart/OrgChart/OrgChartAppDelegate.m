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

#import "OrgChartAppDelegate.h"

#import "OrgChartViewController.h"

@implementation OrgChartAppDelegate

@synthesize window = _window;
@synthesize viewController = _viewController;
@synthesize managedObjectContext = __managedObjectContext;
@synthesize managedObjectModel = __managedObjectModel;
@synthesize persistentStoreCoordinator = __persistentStoreCoordinator;

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
  [self createData];
  [self readData];
  self.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
  // Override point for customization after application launch.
  self.viewController = [[OrgChartViewController alloc] initWithNibName:@"OrgChartViewController" bundle:nil]; 
  self.window.rootViewController = self.viewController;
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
  /*
   Called when the application is about to terminate.
   Save data if appropriate.
   See also applicationDidEnterBackground:.
   */
}

- (void)saveContext
{
  NSError *error = nil;
  NSManagedObjectContext *managedObjectContext = self.managedObjectContext;
  if (managedObjectContext != nil)
  {
    if ([managedObjectContext hasChanges] && ![managedObjectContext save:&error])
    {
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
  NSURL *modelURL = [[NSBundle mainBundle] URLForResource:@"OrgChart" withExtension:@"momd"];
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
  
  NSURL *storeURL = [[self applicationDocumentsDirectory] URLByAppendingPathComponent:@"OrgChart.sqlite"];
  
  NSError *error = nil;
  __persistentStoreCoordinator = [[NSPersistentStoreCoordinator alloc] initWithManagedObjectModel:[self managedObjectModel]];
  if (![__persistentStoreCoordinator addPersistentStoreWithType:NSSQLiteStoreType configuration:nil URL:storeURL options:nil error:&error])
  {
    NSLog(@"Unresolved error %@, %@", error, [error userInfo]);
    abort();
  }    
  
  return __persistentStoreCoordinator;
}

#pragma mark - Application's Documents directory

/**
 Returns the URL to the application's Documents directory.
 */
- (NSURL *)applicationDocumentsDirectory
{
  return [[[NSFileManager defaultManager] URLsForDirectory:NSDocumentDirectory inDomains:NSUserDomainMask] lastObject];
}

- (void)createData
{
  // Create the organization
  NSManagedObject *organization = [NSEntityDescription insertNewObjectForEntityForName:@"Organization" inManagedObjectContext:self.managedObjectContext];
  [organization setValue:@"MyCompany, Inc." forKey:@"name"];
  [organization setValue:[NSNumber numberWithInt:[@"MyCompany, Inc." hash]] forKey:@"id"];
  
  // Create the people
  NSManagedObject *john = [NSEntityDescription insertNewObjectForEntityForName:@"Person" inManagedObjectContext:self.managedObjectContext];
  [john setValue:@"John" forKey:@"name"];
  [john setValue:[NSNumber numberWithInt:[@"John" hash]] forKey:@"id"];
  
  NSManagedObject *jane = [NSEntityDescription insertNewObjectForEntityForName:@"Person" inManagedObjectContext:self.managedObjectContext];
  [jane setValue:@"Jane" forKey:@"name"];
  [jane setValue:[NSNumber numberWithInt:[@"Jane" hash]] forKey:@"id"];
  
  NSManagedObject *bill = [NSEntityDescription insertNewObjectForEntityForName:@"Person" inManagedObjectContext:self.managedObjectContext];
  [bill setValue:@"Bill" forKey:@"name"];
  [bill setValue:[NSNumber numberWithInt:[@"Bill" hash]] forKey:@"id"];

  // Set the leader of the organization
  [organization setValue:john forKey:@"leader"];
  
  // Set the employees
  NSMutableSet *johnsEmployees = [john mutableSetValueForKey:@"employees"];
  [johnsEmployees addObject:jane];
  [johnsEmployees addObject:bill];
  
  // Add Jack
  NSManagedObject *jack = [NSEntityDescription insertNewObjectForEntityForName:@"Person" inManagedObjectContext:self.managedObjectContext];
  [jack setValue:@"Jack" forKey:@"name"];
  [jack setValue:[NSNumber numberWithInt:[@"Jack" hash]] forKey:@"id"];
  NSMutableSet *janesEmployees = [jane mutableSetValueForKey:@"employees"];
  [janesEmployees addObject:jack];
  
  // Save changes
  [self saveContext];
}

- (void)displayPerson:(NSManagedObject*)person withIndentation:(NSString*)indentation
{
  NSLog(@"%@Name: %@", indentation, [person valueForKey:@"name"]);
  
  // Increase the indentation for sub-levels
  indentation = [NSString stringWithFormat:@"%@  ", indentation];
  
  NSSet *employees = [person valueForKey:@"employees"];
  id employee;
  NSEnumerator *it = [employees objectEnumerator];
  while ((employee = [it nextObject]) != nil)
  {
    [self displayPerson:employee withIndentation:indentation];
  }
}

- (void)readData 
{
  NSManagedObjectContext *context = [self managedObjectContext];    
  NSEntityDescription *orgEntity = [NSEntityDescription entityForName:@"Organization" inManagedObjectContext:context];
  
  NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] init];  
  [fetchRequest setEntity:orgEntity];
  
  NSArray *organizations = [context executeFetchRequest:fetchRequest error:nil];
  
  id organization;
  NSEnumerator *it = [organizations objectEnumerator];
  while ((organization = [it nextObject]) != nil) 
  {        
    NSLog(@"Organization: %@", [organization valueForKey:@"name"]);
    
    NSManagedObject *leader = [organization valueForKey:@"leader"];
    [self displayPerson:leader withIndentation:@"  "];
  }
}
@end
