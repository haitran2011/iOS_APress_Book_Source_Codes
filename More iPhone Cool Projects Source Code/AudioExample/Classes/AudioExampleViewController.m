//
//  AudioExampleViewController.m
//  AudioExample
//
//  Created by David Smith on 12/15/09.
//  Copyright __MyCompanyName__ 2009. All rights reserved.
//

#import "AudioExampleViewController.h"

@implementation AudioExampleViewController

-(IBAction)playPauseButtonClicked {
	if(player == nil) {
		NSBundle* bundle =[NSBundle mainBundle]; 
		NSString* path = [bundle pathForResource:@"example" ofType:@"mp3"];
		NSURL *url = [NSURL fileURLWithPath:path];
		player = [[AVAudioPlayer alloc] initWithContentsOfURL:url error:nil];
		[NSTimer scheduledTimerWithTimeInterval:1.0 target:self selector:@selector(onTimer) userInfo:nil repeats:YES];
		
		UInt32 category = kAudioSessionCategory_MediaPlayback;
		AudioSessionInitialize(NULL,NULL,NULL,NULL);
		AudioSessionSetProperty (kAudioSessionProperty_AudioCategory, sizeof (category), &category);
		AudioSessionSetActive (true);
		
	} 
	if([player isPlaying]) {
		[playPauseButton setTitle:@"Play" forState:UIControlStateNormal];
		[player pause];
	} else {
		[playPauseButton setTitle:@"Pause" forState:UIControlStateNormal];
		[player play];
		
	}
}

-(void)onTimer {
	
	if(player != nil && [player isPlaying]) {

		float remainingTime = player.duration - player.currentTime;
		
		timeElapsed.text = [NSString stringWithFormat:@"%0.1f",player.currentTime];
		timeRemaining.text = [NSString stringWithFormat:@"-%0.1f",remainingTime];
	
	} else {
		timeElapsed.text = @"";
		timeRemaining.text = @"";
	}
	
}

-(IBAction)forwardButtonClicked {
	if(player != nil && [player isPlaying]) {
		player.currentTime += 30;
	}
}

-(IBAction)backButtonClicked {
	if(player != nil && [player isPlaying]) {
			player.currentTime -= 30;
	}
}


@end
