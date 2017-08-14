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
#import <CoreData/CoreData.h>
#import "BasicCanvasUIView.h"

@interface ShapesViewController : UIViewController {
  NSManagedObjectContext *managedObjectContext;
  IBOutlet BasicCanvasUIView *topView;
  IBOutlet BasicCanvasUIView *bottomView;
  IBOutlet UIButton *undoButton;
  IBOutlet UIButton *redoButton;
}

@property (nonatomic, retain) NSManagedObjectContext *managedObjectContext;
@property (nonatomic, retain) BasicCanvasUIView *topView;
@property (nonatomic, retain) BasicCanvasUIView *bottomView;
@property (nonatomic, retain) UIButton *undoButton;
@property (nonatomic, retain) UIButton *redoButton;

- (IBAction)undo:(id)sender;
- (IBAction)redo:(id)sender;
- (void)updateUndoAndRedoButtons:(NSNotification *)notification;

@end
