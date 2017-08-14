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

#import "PasswordViewController.h"
#import "PasswordListViewController.h"

@implementation PasswordViewController

@synthesize name, userId, password, parentController, system;

- (id)initWithParentController:(PasswordListViewController *)parentController_ system:(NSManagedObject *)system_ 
{
  if ((self = [super init])) 
  {
    self.parentController = parentController_;
    self.system = system_;
  }
  return self;
}

- (void)viewDidLoad 
{
  [super viewDidLoad];
  if (system != nil) 
  {
    name.text = [system valueForKey:@"name"];
    userId.text = [system valueForKey:@"userId"];
    password.text = [system valueForKey:@"password"];
  }
}

- (void)viewDidUnload
{
  self.name = nil;
  self.userId = nil;
  self.password = nil;
  [super viewDidUnload];
}

- (IBAction)save:(id)sender 
{
  NSString *errorText = nil;
  
  // Create variables to store pre-change state, so we can back out if 
  // validation errors occur
  NSManagedObject *tempSystem = nil;
  NSString *tempName = nil;
  NSString *tempUserId = nil;
  NSString *tempPassword = nil;
  
  if (parentController != nil) 
  {
    if (system != nil) 
    {
      // User is editing an existing system. Store its current values
      tempName = [NSString stringWithString:(NSString *)[system valueForKey:@"name"]];
      tempUserId = [NSString stringWithString:(NSString *)[system valueForKey:@"userId"]];
      tempPassword = [NSString stringWithString:(NSString *)[system valueForKey:@"password"]];
      
      // Update with the new values
      [system setValue:name.text forKey:@"name"];
      [system setValue:userId.text forKey:@"userId"];
      [system setValue:password.text forKey:@"password"];
      [parentController saveContext];
    } 
    else 
    {
      // User is adding a new system. Create the new managed object but keep 
      // a pointer to it
      tempSystem = [parentController insertPasswordWithName:name.text userId:userId.text password:password.text];
    }
    // Save the context and gather any validation errors
    errorText = [parentController saveContext];
  }
  if (errorText != nil) 
  {
    // Validation error occurred. Show an alert.
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Error!" message:errorText delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
    [alert show];
    
    // Because we had errors and the context didn't save, undo any changes 
    // this method made
    if (tempSystem != nil) 
    {
      // We added an object, so delete it
      [[parentController.fetchedResultsController managedObjectContext] deleteObject:tempSystem];
    } 
    else 
    {
      // We edited an object, so restore it to how it was
      [system setValue:tempName forKey:@"name"];
      [system setValue:tempUserId forKey:@"userId"];
      [system setValue:tempPassword forKey:@"password"];
    }
  } 
  else 
  {
    // Successful save! Dismiss the modal only on success
    [self dismissModalViewControllerAnimated:YES];
  }
}

- (IBAction)cancel:(id)sender 
{
  [self dismissModalViewControllerAnimated:YES];
}

@end
