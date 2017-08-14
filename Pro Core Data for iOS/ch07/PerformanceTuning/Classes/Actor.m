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

#import "Actor.h"


@implementation Actor 

@dynamic name;
@dynamic rating;
@dynamic movies;

- (void)willTurnIntoFault {
  NSLog(@"Actor named %@ will turn into fault", self.name);
}

- (void)didTurnIntoFault {
  NSLog(@"Actor named %@ did turn into fault", self.name);
}

@end
