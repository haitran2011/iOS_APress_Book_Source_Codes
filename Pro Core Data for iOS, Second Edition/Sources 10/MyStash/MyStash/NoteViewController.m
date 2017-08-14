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

#import "NoteViewController.h"
#import "NoteListViewController.h"

@implementation NoteViewController

@synthesize titleField, body, parentController, note;

- (id)initWithParentController:(NoteListViewController *)parentController_ note:(NSManagedObject *)note_ 
{
  if ((self = [super init])) 
  {
    self.parentController = parentController_;
    self.note = note_;
  }
  return self;
}

#pragma mark - View lifecycle

- (void)viewDidLoad
{
  [super viewDidLoad];
  if (note != nil) 
  {
    titleField.text = [note valueForKey:@"title"];
    body.text = [note valueForKey:@"body"];
  } 
  else 
  {
    body.text = @"Type text here . . .";
  }
}

- (void)viewDidUnload
{
  self.titleField = nil;
  self.body = nil;
  [super viewDidUnload];
}

- (IBAction)save:(id)sender 
{
  if (parentController != nil) 
  {
    if (note != nil) 
    {
      [note setValue:titleField.text forKey:@"title"];
      [note setValue:body.text forKey:@"body"];
      [parentController saveContext];
    }
    else 
    {
      [parentController insertNoteWithTitle:titleField.text body:body.text];
    }
  }
  [self dismissModalViewControllerAnimated:YES];
}

- (IBAction)cancel:(id)sender 
{
  [self dismissModalViewControllerAnimated:YES];
}

@end
