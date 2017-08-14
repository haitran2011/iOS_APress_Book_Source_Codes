//
//  PokerGameScene.m
//  Video Poker
//
//  Created by Chuck Smith on 1/28/10.
//  Copyright 2010 Chuck Smith. All rights reserved.
//

#import "PokerGameScene.h"
#import "Deck.h"
#import "SimpleHand.h"
#import "Card.h"

// Import sound library
#import "SimpleAudioEngine.h"

@implementation PokerGame

#define DEAL_BUTTON 0
#define HAND_LABEL 1

@synthesize cardImages;
@synthesize myDeck;
@synthesize myHand;
@synthesize handLabel;

// on "dealloc" you need to release all your retained objects
- (void) dealloc
{
	// in case you have something to dealloc, do it in this method
	// in this particular example nothing needs to be released.
	// cocos2d will automatically release all the children (Label)
	
	[cardImages release];
	[myDeck release];
	[myHand release];
	[handLabel release];
	
	// don't forget to call "super dealloc"
	[super dealloc];
}

+(id) scene
{
	// 'scene' is an autorelease object.
	CCScene *scene = [CCScene node];
	
	// 'layer' is an autorelease object.
	PokerGame *layer = [PokerGame node];
	
	// add layer as a child to scene
	[scene addChild: layer];
	
	// return the scene
	return scene;
}

// on "init" you need to initialize your instance
-(id) init
{
	if( (self=[super init] )) {
		myDeck = [Deck new];
		myHand = [SimpleHand new];

		for ( int a = 0; a < 5; a++ )
		{
			[myHand addCard:[myDeck nextCard]];
		}
		
		[myHand calculate];
		
		// ask director the window size
		CGSize size = [[CCDirector sharedDirector] winSize];
		
		dealButton = [CCSprite spriteWithFile:@"Deal.png"];
		dealButton.position = ccp ( size.width / 2, size.height - 30.0 );
		

#if __IPHONE_OS_VERSION_MAX_ALLOWED >= 30200
		// Increase font size if user is on an iPad
		if ( UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad )
		{
			// The device is an iPad running iPhone 3.2 or later.
			[dealButton runAction:[CCScaleBy actionWithDuration:0.1f scale:2.0f]];
		}
#endif
		
		
		[self addChild:dealButton z:-1 tag:0];
		
		cardImages = [NSMutableArray new];
		
		for ( int a = 0; a < 5; a++ )
		{
			CCSprite *newCardImage = [CCSprite new];
			
			// Load image of card
			newCardImage = [CCSprite spriteWithFile:[NSString stringWithFormat:@"%@.png", [myHand getCard:a]]]; 
			
			// Place card off screen centered on the top.
			newCardImage.position = ccp( size.width / 2, size.height + 50.0 );
			
			// Add card image to Z-Axis:0
			[self addChild:newCardImage z:0 tag:a+100];
			[cardImages addObject:newCardImage];
			[newCardImage release];
			
			// Animate card to screen
			[self dealCard:a];
		}
		
		[[SimpleAudioEngine sharedEngine] playEffect:@"shuffle-cards.wav"];
	}
	
	// Enable touch detection
	self.isTouchEnabled = YES;
	
	firstDraw = true;
	
	// create and initialize a Label
#if __IPHONE_OS_VERSION_MAX_ALLOWED >= 30200
	// Increase font size if user is on an iPad
	if ( UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad )
	{
		// The device is an iPad running iPhone 3.2 or later.
		handLabel = [CCLabel labelWithString:@"" fontName:@"Marker Felt" fontSize:64];
	}
	else
	{
		// The device is an iPhone or iPod touch.
		handLabel = [CCLabel labelWithString:@"" fontName:@"Marker Felt" fontSize:32];
	}
#else
	// The device is an iPhone or iPod touch earlier than v3.2
	handLabel = [CCLabel labelWithString:@"" fontName:@"Marker Felt" fontSize:32];
#endif
	
	
	// ask director the the window size
	CGSize size = [[CCDirector sharedDirector] winSize];
	
	// position the label on the center of the screen
	// 'ccp' is a helper macro that creates a point. It means: 'CoCos Point'
	handLabel.position =  ccp( size.width / 2 , size.height / 2 + 25.0 );
	
	// add the label as a child to this Layer
	[self addChild: handLabel z:1 tag:HAND_LABEL];
	
	[[SimpleAudioEngine sharedEngine] playBackgroundMusic:@"poker-music.mp3"];
	
	return self;
}


// Calculate home point of card given its index
- (CGPoint)cardHomePoint:(NSUInteger)cardIndex locked:(BOOL)lockedVal {

	// ask director the window size
	CGSize size = [[CCDirector sharedDirector] winSize];

	NSUInteger multiplier = 1;
	
	// Move sprite lower for locked cards.
	if ( lockedVal ) { multiplier = 2; }
	
	// For each iPhone card, position it 80 pixels over
	CGPoint homePoint = ccp( (cardIndex + 1) * 80,
							size.height / 2 - 50.0f * multiplier );
	
#if __IPHONE_OS_VERSION_MAX_ALLOWED >= 30200
	// Increase font size if user is on an iPad
	if ( UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad )
	{
		// The device is an iPad running iPhone 3.2 or later.
		homePoint = ccp( (cardIndex + 1) * 170.66667f,
						size.height / 2 - 100.f * multiplier );
	}
#endif

	return homePoint;
							
}


- (void) dealCard:(NSUInteger)curCard
{
	id deal = [CCMoveTo actionWithDuration:0.75 
								  position:[self cardHomePoint:curCard locked:NO]];
		
	float degrees = 360.0f;
	
	id rotate = [CCRotateBy actionWithDuration:0.75 angle:degrees];
	id spawn = [CCSpawn actions:deal, rotate, nil];
	
	[[cardImages objectAtIndex:curCard] runAction:spawn];
}

- (void) dealCards
{	
	// If second draw, shuffle the deck to get ready for fresh cards.
	if ( !firstDraw ) {
		[myDeck shuffle];
		
		// Empty hand value display
		[handLabel setString:@""];
		
		// Unpause background music
		[[SimpleAudioEngine sharedEngine] resumeBackgroundMusic];
	} else {
		// Pause background music
		[[SimpleAudioEngine sharedEngine] pauseBackgroundMusic];
	}
	
	// Temporarily state that all cards are locked to check later if still true.
	BOOL allLocked = true;
	
	for ( NSUInteger a = 0; a < 5; a++ )
	{
		if ( [[myHand getCard:a] locked] )
		{
			// Card is locked, unlock it for later.
			[[myHand getCard:a] unlock];
		}
		else
		{
			// Something is unlocked, so change all locked state to false.
			allLocked = false;
			[self animateCard:a];
		}
	}
	
	firstDraw = !firstDraw;

	// All cards are locked, so new cards will not need to be dealt.
	if ( allLocked ) {
		NSLog( @"ALL LOCKED" );
		[self calculateHand];
	} else {
		NSLog( @"NOT ALL LOCKED" );
		[[SimpleAudioEngine sharedEngine] playEffect:@"shuffle-cards.wav"];
	}
}


- (void)animateCard:(NSUInteger)cardIndex {	
	// Card is not locked, swap it out.
	CGSize size = [[CCDirector sharedDirector] winSize];
	
	// Prepare CCMoveTo action to send card off screen
	id dealAway = [CCMoveTo actionWithDuration:0.75 
									  position:ccp( size.width / 2, size.height - 25.0 )];
	id rotate = [CCRotateBy actionWithDuration:0.75 
										 angle:360.0];
	
	id dealBack;	// Initialize dealBack action
	
	// Prepare to move card back on screen in unlocked position.
	dealBack = [CCMoveTo actionWithDuration:0.75 
								   position:[self cardHomePoint:cardIndex locked:firstDraw]];
	
	// Create spawns to send cards away and back on screen.
	id spawnAway = [CCSpawn actions:dealAway, rotate, nil];
	id spawnBack = [CCSpawn actions:dealBack, rotate, nil];
	
	// Switch sprite to new card from new deal
	id changeCard = [CCCallFuncN actionWithTarget:self selector:@selector(changeCard:)];
	
	// Display hand rank (like one pair or three of a kind)
	id showHandRank = [CCCallFunc actionWithTarget:self selector:@selector(calculateHand)];
	
	// Set up sequence to send cards away, change the card, bring it back and show hand rank.
	id sequence = [CCSequence actions:spawnAway, changeCard,
				   spawnBack, showHandRank, nil];
	
	// Finally, run the above sequence for this card.
	[[cardImages objectAtIndex:cardIndex] runAction:sequence];
}


- (void) calculateHand {
	[myHand calculate];
	NSLog( @"Your hand is %@", [myHand description] );
	if ( !firstDraw ) {
		CGSize size = [[CCDirector sharedDirector] winSize];
		handLabel.position = ccp( size.width / 2, size.height + 50.0 );
		[handLabel runAction:[CCMoveTo actionWithDuration:0.5 position:ccp( size.width / 2 , size.height/2 + 25.0 )]];
		[handLabel setString:[myHand handRankString]];
	}
}
					   
					   
- (void) changeCard:(id)node {
	// Subtract 100, since we set card sprite tags to 100-104. 
	int cardNum = [node tag] - 100;
	
	// Replace card at index with the next card in the deck.
	[myHand replaceCardIndex:cardNum withCard:[myDeck nextCard]];
	
	// Swap out images in the card sprite for the new card.
	[[cardImages objectAtIndex:cardNum] 
	 setTexture:[[CCTextureCache sharedTextureCache]
				 addImage:[NSString stringWithFormat:@"%@.png",
						   [myHand getCard:cardNum]]]];
}


- (BOOL)tappedSprite:(CCSprite *)curButton withPoint:(CGPoint)touchPoint
{
	CGSize sprSize = [curButton contentSize];
	CGPoint sprPos = [curButton position];

	// Make rectangle from size and position data.
	CGRect result = CGRectOffset(CGRectMake(0, 0, 
											sprSize.width,
											sprSize.height),
								 sprPos.x-sprSize.width/2,
								 sprPos.y-sprSize.height/2);
	
	// See if touch is within rectangle.
	if ( touchPoint.x > result.origin.x &&
		touchPoint.y > result.origin.y &&
		touchPoint.x < result.origin.x + result.size.width &&
		touchPoint.y < result.origin.y + result.size.height )
	{
		NSLog( @"Tapped sprite" );
		return true;
	}
	else {
		NSLog( @"DID NOT tap sprite" );
		return false;
	}
}


- (void)ccTouchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
	// Get UITouch object
	UITouch *touch = [touches anyObject];
	NSUInteger numTaps = [[touches anyObject] tapCount];
	
	// Only process if single tap.
	if ( numTaps == 1 )
	{
		// Find point of touch
		CGPoint location = [touch locationInView: [touch view]];
		// Convert point to landscape mode
		CGPoint touchPoint = [[CCDirector sharedDirector] convertToGL:location];

		NSLog( @"You touched (%0.f, %0.f)", touchPoint.x, touchPoint.y );

		// See if deal button was tapped.
		if ( [self tappedSprite:dealButton withPoint:touchPoint] ) {
			[self dealCards];
		}
		
		// Check each card to see if it was tapped.
		for ( NSUInteger a = 0; a < 5; a++ ) {
			if ( [self tappedSprite:[cardImages objectAtIndex:a] withPoint:touchPoint] )
			{
				if ( firstDraw ) {
					// Only lock and unlock cards if it's the first draw.
					[self toggleCard:a];
				}
			}
		}
	}
}


- (void) toggleCard:(NSUInteger)cardIndex {
	[[SimpleAudioEngine sharedEngine] playEffect:@"card-slide.wav"];

	CGPoint cardHome = [self cardHomePoint:cardIndex locked:![[myHand getCard:cardIndex] locked]];
	
	id moveHome = [CCMoveTo actionWithDuration:0.25 position:cardHome];
	[[cardImages objectAtIndex:cardIndex] runAction:moveHome];
	
	[[myHand getCard:cardIndex] toggleLock];
}


@end
