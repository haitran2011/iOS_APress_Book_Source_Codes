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
  //[self createData];
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
  NSManagedObjectContext *context = [self managedObjectContext];    
  
  NSEntityDescription *orgEntity = [NSEntityDescription entityForName:@"Organization" inManagedObjectContext:context];
  NSEntityDescription *personEntity = [NSEntityDescription entityForName:@"Person" inManagedObjectContext:context];
  
  { // Company A
    NSManagedObject *organization = [NSEntityDescription insertNewObjectForEntityForName:[orgEntity name] inManagedObjectContext:context];    
    
    [organization setValue:@"Company A" forKey:@"name"];
    int orgId = [organization hash];
    [organization setValue:[NSNumber numberWithInt:orgId] forKey:@"id"];
    
    NSManagedObject *john = [NSEntityDescription insertNewObjectForEntityForName:[personEntity name] inManagedObjectContext:context];
    [john setValue:@"John" forKey:@"name"];
    [john setValue:[NSNumber numberWithInt:32] forKey:@"age"];
    
    NSManagedObject *jane = [NSEntityDescription insertNewObjectForEntityForName:[personEntity name] inManagedObjectContext:context];
    [jane setValue:@"Jane" forKey:@"name"];
    [jane setValue:[NSNumber numberWithInt:26] forKey:@"age"];
    
    NSManagedObject *tim = [NSEntityDescription insertNewObjectForEntityForName:[personEntity name] inManagedObjectContext:context];
    [tim setValue:@"Tim" forKey:@"name"];
    [tim setValue:[NSNumber numberWithInt:22] forKey:@"age"];
    
    NSManagedObject *jim = [NSEntityDescription insertNewObjectForEntityForName:[personEntity name] inManagedObjectContext:context];
    [jim setValue:@"Jim" forKey:@"name"];
    [jim setValue:[NSNumber numberWithInt:40] forKey:@"age"];
    
    NSManagedObject *kate = [NSEntityDescription insertNewObjectForEntityForName:[personEntity name] inManagedObjectContext:context];
    [kate setValue:@"Kate" forKey:@"name"];
    [kate setValue:[NSNumber numberWithInt:40] forKey:@"age"];
    
    NSManagedObject *jill = [NSEntityDescription insertNewObjectForEntityForName:[personEntity name] inManagedObjectContext:context];
    [jill setValue:@"Jill" forKey:@"name"];
    [jill setValue:[NSNumber numberWithInt:22] forKey:@"age"];
    
    NSMutableSet *johnsEmployees = [john mutableSetValueForKey:@"employees"];
    [johnsEmployees addObject:jane];
    [johnsEmployees addObject:tim];
    
    NSMutableSet *timsEmployees = [tim mutableSetValueForKey:@"employees"];
    
    [timsEmployees addObject:jim];
    [timsEmployees addObject:kate];
    [timsEmployees addObject:jill];
    
    [organization setValue:john forKey:@"leader"];
  }
  
  { // Company B
    NSManagedObject *organization = [NSEntityDescription insertNewObjectForEntityForName:[orgEntity name] inManagedObjectContext:context];    
    
    [organization setValue:@"Company B" forKey:@"name"];
    int orgId = [organization hash];
    [organization setValue:[NSNumber numberWithInt:orgId] forKey:@"id"];
    
    NSManagedObject *mary = [NSEntityDescription insertNewObjectForEntityForName:[personEntity name] inManagedObjectContext:context];
    [mary setValue:@"Mary" forKey:@"name"];
    [mary setValue:[NSNumber numberWithInt:36] forKey:@"age"];
    
    NSManagedObject *tom = [NSEntityDescription insertNewObjectForEntityForName:[personEntity name] inManagedObjectContext:context];
    [tom setValue:@"Tom" forKey:@"name"];
    [tom setValue:[NSNumber numberWithInt:26] forKey:@"age"];
    
    [[mary mutableSetValueForKey:@"employees"] addObject:tom];
    
    [organization setValue:mary forKey:@"leader"];
  }
  
  [self saveContext];
}

- (void)displayPerson:(NSManagedObject*)person withIndentation:(NSString*)indentation
{
  NSLog(@"%@Name: %@ (%@)", indentation, [person valueForKey:@"name"], [person valueForKey:@"age"]);
  
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
  NSEntityDescription *entity = [NSEntityDescription entityForName:@"Person" inManagedObjectContext:context];
  
  NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] init];
  [fetchRequest setEntity:entity];
  
  NSPredicate *predicate = [NSPredicate predicateWithFormat:@"manager.name CONTAINS[c] %@", @"m"];

  [fetchRequest setPredicate:predicate];
  
  NSSortDescriptor *sortDescriptorByAge = [[NSSortDescriptor alloc] initWithKey:@"age" ascending:YES];
  NSSortDescriptor *sortDescriptorByName = [[NSSortDescriptor alloc] initWithKey:@"name" ascending:NO];

  NSArray *sortDescriptors = [[NSArray alloc] initWithObjects:sortDescriptorByAge, sortDescriptorByName, nil];
  [fetchRequest setSortDescriptors:sortDescriptors];
  
  NSArray *persons = [context executeFetchRequest:fetchRequest error:nil];
  
  for (NSManagedObject *person in persons) 
  {
    NSLog(@"name=%@ age=%@", [person valueForKey:@"name"], [person valueForKey:@"age"]);
  }
}


@end
