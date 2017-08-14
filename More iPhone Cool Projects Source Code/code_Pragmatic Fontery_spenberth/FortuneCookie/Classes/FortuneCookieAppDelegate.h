//
//  FortuneCookieAppDelegate.h
//  FortuneCookie
//
//  Created by Scott Penberthy on 2/7/10.
//  Copyright North Highland Partners 2010. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "APSound.h"

@class EAGLView;

@interface FortuneCookieAppDelegate : NSObject <UIApplicationDelegate> {
    UIWindow *window;
    EAGLView *glView;
	APSound *startup;
}

@property (nonatomic, retain) IBOutlet UIWindow *window;
@property (nonatomic, retain) IBOutlet EAGLView *glView;

@end

