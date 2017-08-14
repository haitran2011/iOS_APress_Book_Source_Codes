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


@interface Transform :  NSManagedObject  
{
}

@property (nonatomic, retain) NSNumber * scalarValue;
@property (nonatomic, retain) NSManagedObject * canvas;

+ (Transform *)initWithScale:(float)scale inContext:(NSManagedObjectContext *)context;

@end



