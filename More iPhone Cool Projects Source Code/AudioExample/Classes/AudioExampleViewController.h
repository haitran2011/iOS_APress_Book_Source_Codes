//
//  AudioExampleViewController.h
//  AudioExample
//

#import <UIKit/UIKit.h>
#import <AVFoundation/AVFoundation.h>
#import <AudioToolbox/AudioToolbox.h>

@interface AudioExampleViewController : UIViewController {

	IBOutlet UIButton* playPauseButton;
	
	IBOutlet UILabel* timeRemaining;
	IBOutlet UILabel* timeElapsed;
	
	AVAudioPlayer* player;
}

-(IBAction)playPauseButtonClicked;
-(IBAction)forwardButtonClicked;
-(IBAction)backButtonClicked;

@end

