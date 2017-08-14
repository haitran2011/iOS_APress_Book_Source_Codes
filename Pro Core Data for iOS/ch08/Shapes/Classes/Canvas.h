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

#import <CoreData/CoreData.h>

@class Transform;

@interface Canvas :  NSManagedObject  
{
}

@property (nonatomic, retain) NSSet* shapes;
@property (nonatomic, retain) Transform * transform;

+ (Canvas *)initWithTransform:(Transform *)transform inContext:(NSManagedObjectContext *)context;

@end


@interface Canvas (CoreDataGeneratedAccessors)
- (void)addShapesObject:(NSManagedObject *)value;
- (void)removeShapesObject:(NSManagedObject *)value;
- (void)addShapes:(NSSet *)value;
- (void)removeShapes:(NSSet *)value;

@end

