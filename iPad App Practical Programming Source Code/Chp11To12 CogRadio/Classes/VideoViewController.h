//
//  VideoViewController.h
//  CogRadio
//
//  Created by Chen Li on 11/17/10.
//  Copyright 2010 Chen Li. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SceneViewController.h"
#import <MediaPlayer/MediaPlayer.h>

@interface VideoViewController : SceneViewController {
	UIWebView* webView;
	MPMoviePlayerController* moviePlayer;
}

@end
