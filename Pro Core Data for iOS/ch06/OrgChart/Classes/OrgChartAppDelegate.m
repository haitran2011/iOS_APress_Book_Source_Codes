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

#import "OrgChartAppDelegate.h"
#import "OrgChartViewController.h"

@implementation OrgChartAppDelegate

@synthesize window;
@synthesize viewController;


#pragma mark -
#pragma mark Application lifecycle

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {    
//  [self createData];
  [self readData];
  
  [self.window addSubview:viewController.view];
  [self.window makeKeyAndVisible];
  return YES;
}


- (void)applicationWillResignActive:(UIApplication *)application {
    /*
     Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
     Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
     */
}


- (void)applicationDidEnterBackground:(UIApplication *)application {
    /*
     Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later. 
     If your application supports background execution, called instead of applicationWillTerminate: when the user quits.
     */
}


- (void)applicationWillEnterForeground:(UIApplication *)application {
    /*
     Called as part of  transition from the background to the inactive state: here you can undo many of the changes made on entering the background.
     */
}


- (void)applicationDidBecomeActive:(UIApplication *)application {
    /*
     Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
     */
}


- (void)applicationWillTerminate:(UIApplication *)application {
    /*
     Called when the application is about to terminate.
     See also applicationDidEnterBackground:.
     */
}


#pragma mark -
#pragma mark Memory management

- (void)applicationDidReceiveMemoryWarning:(UIApplication *)application {
    /*
     Free up as much memory as possible by purging cached data objects that can be recreated (or reloaded from disk) later.
     */
}


- (void)dealloc {
    [viewController release];
    [window release];
    [super dealloc];
}

#pragma mark -
#pragma mark Core Data stack

/**
 Returns the managed object model for the application.
 If the model doesn't already exist, it is created from the application's model.
 */
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
  
  NSString* dir = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) lastObject];
  NSURL *storeURL = [NSURL fileURLWithPath:[dir stringByAppendingPathComponent:@"OrgChart.sqlite"]];
  
  NSError *error = nil;
  persistentStoreCoordinator_ = [[NSPersistentStoreCoordinator alloc] initWithManagedObjectModel:[self managedObjectModel]];
  if (![persistentStoreCoordinator_ addPersistentStoreWithType:NSSQLiteStoreType configuration:nil URL:storeURL options:nil error:&error]) {
    NSLog(@"Unresolved error %@, %@", error, [error userInfo]);
    abort();
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

-(void)createData {
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
  
  NSError *error = nil;
  if (![context save:&error]) {
    NSLog(@"Unresolved error %@, %@", error, [error userInfo]);
    abort();
  }
}

-(void)displayPerson:(NSManagedObject*)person withIndentation:(NSString*)indentation {
  NSLog(@"%@Name: %@ (%@)", indentation, [person valueForKey:@"name"], [person valueForKey:@"age"]);
  
  // Increase the indentation for sub-levels
  indentation = [NSString stringWithFormat:@"%@  ", indentation];
  
  NSSet *employees = [person valueForKey:@"employees"];
  id employee;
  NSEnumerator *it = [employees objectEnumerator];
  while((employee = [it nextObject]) != nil) {        
    [self displayPerson:employee withIndentation:indentation];
  }
}

-(void)readData {
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
  [sortDescriptorByAge release];
  [sortDescriptorByName release];
  
  NSArray *persons = [context executeFetchRequest:fetchRequest error:nil];
  
  for(NSManagedObject *person in persons) {
    NSLog(@"name=%@ age=%@", [person valueForKey:@"name"], [person valueForKey:@"age"]);
  }
  [sortDescriptors release];
  [fetchRequest release];
}


@end
