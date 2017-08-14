    //
//  VideoViewController.m
//  CogRadio
//
//  Created by Chen Li on 11/17/10.
//  Copyright 2010 Chen Li. All rights reserved.
//

#import "VideoViewController.h"


@implementation VideoViewController

/*
 // The designated initializer.  Override if you create the controller programmatically and want to perform customization that is not appropriate for viewDidLoad.
- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil {
    if ((self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil])) {
        // Custom initialization
    }
    return self;
}
*/

/*
// Implement viewDidLoad to do additional setup after loading the view, typically from a nib.
- (void)viewDidLoad {
    [super viewDidLoad];
}
 */

-(void)createContents {
	[super createContents];
	
	// webView, used to play Youtube video
	webView = [[UIWebView alloc] initWithFrame:CGRectMake(50, 50, 240, 160)];
	NSString* youtubeHTML = @"<object width=\"240\" height=\"160\"><param name=\"movie\"\
	value=\"http://www.youtube.com/v/YE7VzlLtp-4?fs=1&amp;hl=en_US\"></param><param name=\"allowFullScreen\"\
	value=\"true\"></param><param name=\"allowscriptaccess\" value=\"always\"></param>\
	<embed src=\"http://www.youtube.com/v/YE7VzlLtp-4?fs=1&amp;hl=en_US\" type=\"application/x-shockwave-flash\"\
	allowscriptaccess=\"always\" allowfullscreen=\"true\" width=\"240\" height=\"160\"></embed></object>";
	[webView loadHTMLString:youtubeHTML baseURL:nil];
	[self.view addSubview:webView];
	
	// movie player
	NSString* strURL = @"http://lichen1985.com/Video/BigBuckBunny320by180.mp4";
	moviePlayer = [[MPMoviePlayerController alloc] initWithContentURL:[NSURL URLWithString:strURL]];
	[[moviePlayer view] setFrame:CGRectMake(400, 50, 500, 400)];
	[moviePlayer backgroundView].backgroundColor = [UIColor blueColor];
	[self.view addSubview:[moviePlayer view]];
	if (moviePlayer) {
		// Register for the preload/finished notification
		[[NSNotificationCenter defaultCenter] addObserver:self 
												 selector:@selector(movieLoadStateChanged) 
													 name:MPMoviePlayerLoadStateDidChangeNotification 
												   object:nil]; 
		// Register for the playback finished notification.  d 
		[[NSNotificationCenter defaultCenter] addObserver:self 
												 selector:@selector(movieFinished) 
													 name:MPMoviePlayerPlaybackDidFinishNotification 
												   object:nil]; 
	}
}

-(void)movieLoadStateChanged {
	if (moviePlayer.loadState) {
		[moviePlayer play];
	}
}

-(void)movieFinished {
	[[NSNotificationCenter defaultCenter] removeObserver:self name:MPMoviePlayerLoadStateDidChangeNotification object:nil];
	[[NSNotificationCenter defaultCenter] removeObserver:self name:MPMoviePlayerPlaybackDidFinishNotification object:nil];
	[moviePlayer stop];
}

-(void)destroyContents {
	[super destroyContents];
	
	[webView removeFromSuperview];
	[webView release];
	[moviePlayer release];
}


- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation {
    // Overriden to allow any orientation.
    return YES;
}


- (void)didReceiveMemoryWarning {
    // Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
    
    // Release any cached data, images, etc that aren't in use.
}


- (void)viewDidUnload {
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}

- (void)dealloc {
    [super dealloc];
}


@end
