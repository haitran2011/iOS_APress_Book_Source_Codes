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

#import <UIKit/UIKit.h>

@class MasterViewController;

@interface TeamViewController : UIViewController {
  IBOutlet UITextField *name;
  IBOutlet UITextField *uniformColor;
  NSManagedObject *team;
  MasterViewController *rootController;
}
@property (nonatomic, retain) UITextField *name;
@property (nonatomic, retain) UITextField *uniformColor;
@property (nonatomic, retain) NSManagedObject *team;
@property (nonatomic, retain) MasterViewController *masterController;

- (IBAction)save:(id)sender;
- (IBAction)cancel:(id)sender;
- (id)initWithMasterController:(MasterViewController *)aMasterController team:(NSManagedObject *)aTeam;

@end
