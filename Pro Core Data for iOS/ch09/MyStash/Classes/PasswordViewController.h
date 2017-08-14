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

@class PasswordListViewController;

@interface PasswordViewController : UIViewController {
  IBOutlet UITextField *name;
  IBOutlet UITextField *userId;
  IBOutlet UITextField *password;
  PasswordListViewController *parentController;
  NSManagedObject *system;
}
@property (nonatomic, retain) UITextField *name;
@property (nonatomic, retain) UITextField *userId;
@property (nonatomic, retain) UITextField *password;
@property (nonatomic, retain) PasswordListViewController *parentController;
@property (nonatomic, retain) NSManagedObject *system;

- (id)initWithParentController:(PasswordListViewController *)aParentController system:(NSManagedObject *)aSystem;
- (IBAction)save:(id)sender;
- (IBAction)cancel:(id)sender;

@end
