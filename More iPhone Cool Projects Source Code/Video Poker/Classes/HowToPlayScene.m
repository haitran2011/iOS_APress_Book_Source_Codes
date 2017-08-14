//
//  HowToPlayScene.m
//  Video Poker
//
//  Created by Chuck Smith on 1/29/10.
//  Copyright 2010 Chuck Smith. All rights reserved.
//

#import "HowToPlayScene.h"


@implementation HowToPlay

+(id) scene
{
	// 'scene' is an autorelease object.
	CCScene *scene = [CCScene node];
	
	// 'layer' is an autorelease object.
	HowToPlay *layer = [HowToPlay node];
	
	// add layer as a child to scene
	[scene addChild: layer];
	
	// return the scene
	return scene;
}

-(id) init
{
	// always call "super" init
	// Apple recommends to re-assign "self" with the "super" return value
	if( (self=[super init] )) {
		// Put code to initialize cocos2d scene here 
	}
	return self;
}

@end
