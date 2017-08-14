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

@class NoteListViewController;

@interface NoteViewController : UIViewController
{
  UITextField *titleField;
  UITextView *body;
  NoteListViewController *parentController;
  NSManagedObject *note;
}
@property (strong, nonatomic) IBOutlet UITextField *titleField;
@property (strong, nonatomic) IBOutlet UITextView *body;
@property (strong, nonatomic) NoteListViewController *parentController;
@property (strong, nonatomic) NSManagedObject *note;

- (id)initWithParentController:(NoteListViewController *)parentController note:(NSManagedObject *)note;
- (IBAction)save:(id)sender;
- (IBAction)cancel:(id)sender;

@end
