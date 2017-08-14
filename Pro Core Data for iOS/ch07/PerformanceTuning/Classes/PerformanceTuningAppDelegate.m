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

#import "PerformanceTuningAppDelegate.h"
#import "PerformanceTuningViewController.h"

@implementation PerformanceTuningAppDelegate

@synthesize window;
@synthesize viewController;

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
  [self loadData];
  [window addSubview:viewController.view];
  [window makeKeyAndVisible];
  return YES;
}

- (void)applicationWillTerminate:(UIApplication *)application {
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
  
  NSString* dir = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) lastObject];
  NSURL *storeURL = [NSURL fileURLWithPath: [dir stringByAppendingPathComponent: @"PerformanceTuning.sqlite"]];
  
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

- (void)dealloc {
  [window release];
  [viewController release];
  [super dealloc];
}

#pragma mark -
#pragma mark Data Insertion

- (NSManagedObject *)insertObjectForName:(NSString *)entityName withName:(NSString *)name {
  NSManagedObjectContext *context = [self managedObjectContext];
  NSManagedObject *object = [NSEntityDescription insertNewObjectForEntityForName:entityName inManagedObjectContext:context];
  [object setValue:name forKey:@"name"];
  [object setValue:[NSNumber numberWithInteger:((arc4random() % 10) + 1)] forKey:@"rating"];
  return object;
}

- (void)loadData {
  // Pull the movies. If we have 200, assume our db is set up.
  NSManagedObjectContext *context = [self managedObjectContext];
  NSFetchRequest *request = [[NSFetchRequest alloc] init];
  [request setEntity:[NSEntityDescription entityForName:@"Movie" inManagedObjectContext:context]];
  NSArray *results = [context executeFetchRequest:request error:nil];
  if ([results count] != 200) {
    // Add 200 actors, movies, and studios
    for (int i = 1; i <= 200; i++) {
      [self insertObjectForName:@"Actor" withName:[NSString stringWithFormat:
                                                   @"Actor %d", i]];
      [self insertObjectForName:@"Movie" withName:[NSString stringWithFormat:
                                                   @"Movie %d", i]];
      [self insertObjectForName:@"Studio" withName:[NSString stringWithFormat:
                                                    @"Studio %d", i]];
    }
    
    // Relate all the actors and all the studios to all the movies
    NSManagedObjectContext *context = [self managedObjectContext];
    NSFetchRequest *request = [[NSFetchRequest alloc] init];
    [request setEntity:[NSEntityDescription entityForName:@"Movie" inManagedObjectContext:context]];
    NSArray *results = [context executeFetchRequest:request error:nil];
    for (NSManagedObject *movie in results) {
      [request setEntity:[NSEntityDescription entityForName:@"Actor" inManagedObjectContext:context]];
      NSArray *actors = [context executeFetchRequest:request error:nil];
      NSMutableSet *set = [movie mutableSetValueForKey:@"actors"];
      [set addObjectsFromArray:actors];
      
      [request setEntity:[NSEntityDescription entityForName:@"Studio" inManagedObjectContext:context]];
      NSArray *studios = [context executeFetchRequest:request error:nil];
      set = [movie mutableSetValueForKey:@"studios"];
      [set addObjectsFromArray:studios];
    }
  }
  [request release];
  
  NSError *error = nil;
  if (![context save:&error]) {
    NSLog(@"Unresolved error %@, %@", error, [error userInfo]);
    abort();
  }
}

@end
