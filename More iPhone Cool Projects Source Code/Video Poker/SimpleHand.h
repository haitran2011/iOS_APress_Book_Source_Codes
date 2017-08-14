//
//  SimpleHandRank.h
//  HU Poker
//
//  Created by Chuck Smith on 5/5/09.
//  Copyright 2009 Chuck Smith. All rights reserved.
//

#import <Foundation/Foundation.h>

@class Card;

@interface SimpleHand : NSObject <NSCopying>
{
	NSMutableArray *cards;
	NSUInteger handRank;
}

@property (nonatomic, retain) NSMutableArray *cards;

-(id)initWithHand:(NSMutableArray *)myHand;
-(id)initWithHand:(NSMutableArray *)myHand without:(NSUInteger)removal1 andWithout:(NSUInteger)removal2;
- (NSString *)handRankString;
-(void)addCard:(Card *)anotherCard;

-(NSComparisonResult)compareTo:(SimpleHand *)myHand;
-(NSUInteger)cardRankAtIndex:(NSUInteger)index;

-(void)calculate;
-(void) sort;

- (Card *)getCard:(NSUInteger)index;
-(void)replaceCardIndex:(NSUInteger)cardIndex withCard:(Card *)newCard;

-(NSUInteger)handRank;

-(NSString *)handRankString;

-(BOOL)isRoyalFlush;
-(BOOL)isStraightFlush;
-(BOOL)isFourOfAKind;
-(BOOL)isFullHouse;
-(BOOL)isFlush;
-(BOOL)isStraight;
-(BOOL)isThreeOfAKind;
-(BOOL)isTwoPair;
-(BOOL)isOnePair;
-(BOOL)isJacksOrBetter;

@end
