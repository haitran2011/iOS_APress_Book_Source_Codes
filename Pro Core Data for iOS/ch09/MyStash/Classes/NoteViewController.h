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
#import "Note.h"

@class NoteListViewController;

@interface NoteViewController : UIViewController {
  IBOutlet UITextField *titleField;
  IBOutlet UITextView *body;
  NoteListViewController *parentController;
  Note *note;
}
@property (nonatomic, retain) UITextField *titleField;
@property (nonatomic, retain) UITextView *body;
@property (nonatomic, retain) NoteListViewController *parentController;
@property (nonatomic, retain) Note *note;

- (id)initWithParentController:(NoteListViewController *)aParentController note:(Note*)aNote;
- (IBAction)save:(id)sender;
- (IBAction)cancel:(id)sender;

@end
