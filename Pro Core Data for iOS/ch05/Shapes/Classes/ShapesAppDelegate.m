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

#import "ShapesAppDelegate.h"
#import "ShapesViewController.h"
#import "UIColorTransformer.h"

@implementation ShapesAppDelegate

@synthesize window;
@synthesize viewController;


#pragma mark -
#pragma mark Application lifecycle

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {    
  UIColorTransformer* transformer = [[[UIColorTransformer alloc] init] autorelease];
  [UIColorTransformer setValueTransformer:transformer forName:(NSString *)@"UIColorTransformerName"];
  viewController.managedObjectContext = self.managedObjectContext;
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


- (void)applicationDidBecomeActive:(UIApplication *)application {
    /*
     Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
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
  NSString *dir = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) lastObject];
  NSURL *storeURL = [NSURL fileURLWithPath:[dir stringByAppendingPathComponent:@"Shapes.sqlite"]];
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
    
    NSUndoManager *undoManager = [[NSUndoManager alloc] init];
    [undoManager setLevelsOfUndo:10];
    [managedObjectContext_ setUndoManager:undoManager];
    [undoManager release];
  }
  return managedObjectContext_;
}

@end
