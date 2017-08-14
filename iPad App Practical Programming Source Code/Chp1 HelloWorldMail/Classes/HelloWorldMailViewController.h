//
//  HelloWorldMailViewController.h
//  HelloWorldMail
//
//  Created by Chen Li on 8/1/10.
//  Copyright 2010 Chen Li. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <MessageUI/MessageUI.h>

@interface HelloWorldMailViewController : UIViewController <MFMailComposeViewControllerDelegate> {

}

-(IBAction) didClickButton;

@end

