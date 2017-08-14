//
//  CogRadioAppDelegate.h
//  CogRadio
//
//  Created by Chen Li on 11/16/10.
//  Copyright 2010 Chen Li. All rights reserved.
//

#import <UIKit/UIKit.h>

@class CogRadioViewController;

@interface CogRadioAppDelegate : NSObject <UIApplicationDelegate> {
    UIWindow *window;
    CogRadioViewController *viewController;
}

@property (nonatomic, retain) IBOutlet UIWindow *window;
@property (nonatomic, retain) IBOutlet CogRadioViewController *viewController;

@end

