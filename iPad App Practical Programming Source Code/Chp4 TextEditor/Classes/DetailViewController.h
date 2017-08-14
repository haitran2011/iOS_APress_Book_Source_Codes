//
//  DetailViewController.h
//  TextEditor
//
//  Created by Chen Li on 8/25/10.
//  Copyright Chen Li 2010. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface DetailViewController : UIViewController <UIPopoverControllerDelegate, UISplitViewControllerDelegate> {
    
    UIPopoverController *popoverController;
    UIToolbar *toolbar;
    
    int detailItem;
    UILabel *detailDescriptionLabel;
	IBOutlet UITextView* textView;
	IBOutlet UIView* keyPadView;
	UIButton *star;
}

@property (nonatomic, retain) IBOutlet UIToolbar *toolbar;

@property int detailItem;
@property (nonatomic, retain) IBOutlet UILabel *detailDescriptionLabel;
@property (nonatomic, retain) IBOutlet UITextView* textView;
@property (nonatomic, retain) IBOutlet UIView* keyPadView;

-(IBAction) didSelectIPhone;
-(IBAction) didSelectIPad;
-(IBAction) didSelectMac;
-(IBAction) didSelectDismiss;

@end
