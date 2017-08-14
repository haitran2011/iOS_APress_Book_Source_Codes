//
// cocos2d Hello World example
// http://www.cocos2d-iphone.org
//

// Import the interfaces
#import "MainMenuScene.h"
#import "PokerGameScene.h"
#import "HowToPlayScene.h"
#import "OptionsScene.h"

// HelloWorld implementation
@implementation MainMenu

// on "dealloc" you need to release all your retained objects
- (void) dealloc
{
	// in case you have something to dealloc, do it in this method
	// in this particular example nothing needs to be released.
	// cocos2d will automatically release all the children (Label)
	
	// don't forget to call "super dealloc"
	[super dealloc];
}


+(id) scene
{
	// 'scene' is an autorelease object.
	CCScene *scene = [CCScene node];
	
	// 'layer' is an autorelease object.
	MainMenu *layer = [MainMenu node];
	
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
		// New menu
		
#if __IPHONE_OS_VERSION_MAX_ALLOWED >= 30200
		// Increase font size if user is on an iPad
		if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad)
		{
			// The device is an iPad running iPhone 3.2 or later.
			[CCMenuItemFont setFontSize:64];
		}
#endif		
		
		CCMenuItem *playGame = 
		[CCMenuItemFont itemFromString:@"Start Game" 
							  target:self selector:@selector(playGame:)];
		CCMenuItem *howToPlay = 
		[CCMenuItemFont itemFromString:@"How to Play"
							  target:self selector:@selector(howToPlay:)];
		CCMenuItem *options = 
		[CCMenuItemFont itemFromString:@"Options"
							  target:self selector:@selector(options:)];
		
		CCMenu *menu = [CCMenu menuWithItems: playGame, howToPlay, options, nil];
		[menu alignItemsVertically];
		
		[self addChild:menu];
	}
	return self;
}

-(void)playGame:(id)sender {
	[[CCDirector sharedDirector] replaceScene:[PokerGame node]];
}

-(void)howToPlay:(id)sender {
	[[CCDirector sharedDirector] replaceScene:[HowToPlay node]];	
}

-(void)options:(id)sender {
	[[CCDirector sharedDirector] replaceScene:[Options node]];
}

@end
