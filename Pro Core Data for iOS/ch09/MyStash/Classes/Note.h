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

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@interface Note : NSManagedObject {
  NSString* text;
  NSString* password;
}

@property (nonatomic, retain) NSString *title;
@property (nonatomic, retain) NSData *body;
@property (nonatomic, retain) NSString *text;
@property (nonatomic, retain) NSString *password;

@end




