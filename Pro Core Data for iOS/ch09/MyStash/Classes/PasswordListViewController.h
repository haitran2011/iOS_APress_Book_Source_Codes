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

#import <UIKit/UIKit.h>
#import <CoreData/CoreData.h>

@interface PasswordListViewController : UITableViewController <NSFetchedResultsControllerDelegate> {
  NSFetchedResultsController *fetchedResultsController;
  NSManagedObjectContext *managedObjectContext;
}
@property (nonatomic, retain) NSFetchedResultsController *fetchedResultsController;
@property (nonatomic, retain) NSManagedObjectContext *managedObjectContext;

- (NSString *)saveContext;
- (void)showPasswordView;
- (NSManagedObject *)insertPasswordWithName:(NSString *)name userId:(NSString *)userId password:(NSString *)password;
- (NSString *)validationErrorText:(NSError *)error;

@end

