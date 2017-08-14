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

@interface PlayerListViewController : UITableViewController {
  NSManagedObject *team;
  RootViewController *rootController;
}
@property (nonatomic, retain) NSManagedObject *team;
@property (nonatomic, retain) RootViewController *rootController;

- (id)initWithRootController:(RootViewController *)aRootController team:(NSManagedObject *)aTeam;
- (void)showPlayerView;
- (NSArray *)sortPlayers;

@end

