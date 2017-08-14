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

#import "NoteViewController.h"
#import "NoteListViewController.h"

@implementation NoteViewController

@synthesize titleField, body, parentController, note;

- (id)initWithParentController:(NoteListViewController *)aParentController note:(Note *)aNote {
  if ((self = [super init])) {
    self.parentController = aParentController;
    self.note = aNote;
  }
  return self;
}

- (void)viewDidLoad {
  [super viewDidLoad];
  if (note != nil) {
    titleField.text = note.title;
    body.text = note.text;
  } else {
    body.text = @"Type text here . . .";
  }
}

- (IBAction)save:(id)sender {
  if (parentController != nil) {
    if (note != nil) {
      note.title = titleField.text;
      note.text = body.text;
      [parentController saveContext];
    }
    else {
      [parentController insertNoteWithTitle:titleField.text body:body.text];
    }
  }
  [self dismissModalViewControllerAnimated:YES];
}

- (IBAction)cancel:(id)sender {
  [self dismissModalViewControllerAnimated:YES];
}

- (void)dealloc {
  [parentController release];
  [note release];
  [super dealloc];
}

@end
