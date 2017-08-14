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

#import "CircleToEllipseMigrationPolicy.h"

@implementation CircleToEllipseMigrationPolicy

- (BOOL)createDestinationInstancesForSourceInstance:(NSManagedObject *)sInstance entityMapping:(NSEntityMapping *)mapping manager:(NSMigrationManager *)manager error:(NSError **)error {
  // Create the ellipse managed object
  NSManagedObject *ellipse = [NSEntityDescription insertNewObjectForEntityForName:[mapping destinationEntityName] inManagedObjectContext:[manager destinationContext]];
  
  // Copy the x, y, and color values from the Circle to the Ellipse
  [ellipse setValue:[sInstance valueForKey:@"x"] forKey:@"x"];
  [ellipse setValue:[sInstance valueForKey:@"y"] forKey:@"y"];
  [ellipse setValue:[sInstance valueForKey:@"color"] forKey:@"color"];
  
  // Copy the radius value from the Circle to the width and height of the Ellipse
  [ellipse setValue:[sInstance valueForKey:@"radius"] forKey:@"width"];
  [ellipse setValue:[sInstance valueForKey:@"radius"] forKey:@"height"];
  
  // Set up the association between the Circle and the Ellipse for the migration manager
  [manager associateSourceInstance:sInstance withDestinationInstance:ellipse forEntityMapping:mapping];
  
  return YES;
}

@end
