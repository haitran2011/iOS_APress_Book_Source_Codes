// When you import this file, you import all the cocos2d classes
#import "cocos2d.h"

@class Deck;
@class SimpleHand;

// PokerGame Layer
@interface PokerGame : CCLayer
{
	Deck *myDeck;
	SimpleHand *myHand;
	NSMutableArray *cardImages;
	CCSprite *dealButton;
	BOOL firstDraw;
	CCLabel *handLabel;
}

@property (nonatomic, retain) NSMutableArray *cardImages;
@property (nonatomic, retain) Deck *myDeck;
@property (nonatomic, retain) SimpleHand *myHand;
@property (nonatomic, retain) CCLabel *handLabel;

// returns a Scene that contains the HelloWorld as the only child
+(id) scene;

- (CGPoint)cardHomePoint:(NSUInteger)cardIndex locked:(BOOL)lockedVal;
- (void) dealCard:(NSUInteger)curCard;
- (void) animateCard:(NSUInteger)cardIndex;
- (void) toggleCard:(NSUInteger)cardIndex;
- (void) calculateHand;

@end