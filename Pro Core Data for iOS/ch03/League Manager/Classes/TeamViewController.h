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

@class RootViewController;

@interface TeamViewController : UIViewController {
  IBOutlet UITextField *name;
  IBOutlet UITextField *uniformColor;
  NSManagedObject *team;
  RootViewController *rootController;
}
@property (nonatomic, retain) UITextField *name;
@property (nonatomic, retain) UITextField *uniformColor;
@property (nonatomic, retain) NSManagedObject *team;
@property (nonatomic, retain) RootViewController *rootController;

- (IBAction)save:(id)sender;
- (IBAction)cancel:(id)sender;
- (id)initWithRootController:(RootViewController *)aRootController team:(NSManagedObject *)aTeam;

@end
