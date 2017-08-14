//
//  MenuLayer.m
//  MagicApprentice
//
//  Created by Chen Li on 12/6/10.
//  Copyright 2010 Chen Li. All rights reserved.
//

#import "MenuLayer.h"
#import "GameLayer.h"

@implementation MenuLayer

+(id) scene
{
	// 'scene' is an autorelease object.
	CCScene *scene = [CCScene node];
	
	// 'layer' is an autorelease object.
	// This method will call the init method below
	MenuLayer* layer = [MenuLayer node];
	
	// add layer as a child to scene
	[scene addChild: layer];
	
	// return the scene
	return scene;
}

// on "init" you need to initialize your instance
-(id) init
{
	// always call "super" init
	// Apple recommends to re-assign "self" with the "super" return value
	if( (self=[super init] )) {
		
		[CCMenuItemFont setFontSize:40];
		CCMenuItemFont *gameButton = [CCMenuItemFont itemFromString:@"Enter Game" target:self selector:@selector(toGameLayer)];
		gameButton.position = ccp(400,500);
		CCMenu* menu = [CCMenu menuWithItems:gameButton,nil];
		menu.position = CGPointZero;
		[self addChild:menu];
		
		// init sprite
		CCSprite* spriteStar = [CCSprite spriteWithFile:@"stars2.png"];
		spriteStar.position = ccp(200,100);
		
		// action
		CCMoveTo* moveAction1 = [CCMoveTo actionWithDuration:4.0 position:ccp(800,650)];
		CCScaleTo* scaleAction1 = [CCScaleTo actionWithDuration:4.0 scale:0.5];
		CCRotateBy* rotateAction1 = [CCRotateBy actionWithDuration:4.0 angle:1080];
		CCSpawn* action1 = [CCSpawn actions:moveAction1,scaleAction1,rotateAction1,nil];
		CCMoveTo* moveAction2 = [CCMoveTo actionWithDuration:4.0 position:ccp(200,100)];
		CCScaleTo* scaleAction2 = [CCScaleTo actionWithDuration:4.0 scale:1.0];
		CCRotateBy* rotateAction2 = [CCRotateBy actionWithDuration:4.0 angle:-1080];
		CCSpawn* action2 = [CCSpawn actions:moveAction2,scaleAction2,rotateAction2,nil];
		CCSequence* actionOnce = [CCSequence actionOne:action1 two:action2];
		CCRepeatForever* actionForever = [CCRepeatForever actionWithAction:actionOnce];
		
		// add sprite and its action
		[self addChild:spriteStar];
		[spriteStar runAction:actionForever];
	}
	return self;
}

-(void) toGameLayer {
	[[CCDirector sharedDirector] replaceScene:[GameLayer scene]];
}

@end
