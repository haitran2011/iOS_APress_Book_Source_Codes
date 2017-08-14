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

@interface PerformanceTuningViewController : UIViewController <UIPickerViewDataSource, UIPickerViewDelegate> {
  IBOutlet UILabel *startTime;
  IBOutlet UILabel *stopTime;
  IBOutlet UILabel *elapsedTime;
  IBOutlet UITextView *results;
  IBOutlet UIPickerView *testPicker;
  NSArray *tests;
}
@property (nonatomic, retain) UILabel *startTime;
@property (nonatomic, retain) UILabel *stopTime;
@property (nonatomic, retain) UILabel *elapsedTime;
@property (nonatomic, retain) UITextView *results;
@property (nonatomic, retain) UIPickerView *testPicker;
@property (nonatomic, retain) NSArray *tests;

- (IBAction)runTest:(id)sender;

@end

