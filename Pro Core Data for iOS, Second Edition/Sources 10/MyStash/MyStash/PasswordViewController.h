//
// From the book Pro Core Data for iOS, 2nd Edition
// Michael Privat and Rob Warner
// Published by Apress, 2011
// Source released under the Eclipse Public License
// http://www.eclipse.org/legal/epl-v10.html
// 
// Contact information:
// Michael: @michaelprivat -- http://michaelprivat.com -- mprivat@mac.com
// Rob: @hoop33 -- http://grailbox.com -- rwarner@grailbox.com
//

@class PasswordListViewController;

@interface PasswordViewController : UIViewController
{
  UITextField *name;
  UITextField *userId;
  UITextField *password;
  PasswordListViewController *parentController;
  NSManagedObject *system;
}
@property (strong, nonatomic) IBOutlet UITextField *name;
@property (strong, nonatomic) IBOutlet UITextField *userId;
@property (strong, nonatomic) IBOutlet UITextField *password;
@property (strong, nonatomic) PasswordListViewController *parentController;
@property (strong, nonatomic) NSManagedObject *system;

- (id)initWithParentController:(PasswordListViewController *)parentController system:(NSManagedObject *)system;
- (IBAction)save:(id)sender;
- (IBAction)cancel:(id)sender;

@end
