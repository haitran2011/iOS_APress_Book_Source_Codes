//
//  AudioExampleAppDelegate.h
//  AudioExample
//
//  Created by David Smith on 12/15/09.
//  Copyright __MyCompanyName__ 2009. All rights reserved.
//

#import <UIKit/UIKit.h>

@class AudioExampleViewController;

@interface AudioExampleAppDelegate : NSObject <UIApplicationDelegate> {
    UIWindow *window;
    AudioExampleViewController *viewController;
}

@property (nonatomic, retain) IBOutlet UIWindow *window;
@property (nonatomic, retain) IBOutlet AudioExampleViewController *viewController;

@end

