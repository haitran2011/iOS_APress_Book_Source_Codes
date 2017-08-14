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

@class Canvas;

@interface Shape :  NSManagedObject  
{
}

@property (nonatomic, retain) UIColor * color;
@property (nonatomic, retain) NSSet* canvases;

@end


@interface Shape (CoreDataGeneratedAccessors)
- (void)addCanvasesObject:(Canvas *)value;
- (void)removeCanvasesObject:(Canvas *)value;
- (void)addCanvases:(NSSet *)value;
- (void)removeCanvases:(NSSet *)value;

@end

