//
//  GroupViewController.h
//  CogRadio
//
//  Created by Chen Li on 11/17/10.
//  Copyright 2010 Chen Li. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SceneViewController.h"

@interface GroupViewController : SceneViewController {
	UIWebView* webView;
	UIButton* buttonToList;
}

-(void)toList;

@end
